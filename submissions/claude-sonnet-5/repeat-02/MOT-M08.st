PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    state : INT := 0;
    started : BOOL := FALSE;
    x34_trig : R_TRIG;
    x35_trig : R_TRIG;
    capture_target : DINT := 0;
    origin_raw : DINT := 0;
    a_target_raw : DINT := 0;
    b_reach_raw : DINT := 0;
    search_target_raw : DINT := 9500;   (* 95.00 mm, above sensor plane, within [0,350] *)
    low_rate : DINT := 50;              (* slow search / capture rate = 5% *)
    move_rate : DINT := 500;            (* normal move rate = 50% *)
    hold_timer : TON;
END_VAR

x34_trig(CLK := X34);
x35_trig(CLK := X35);

IF X0 THEN
    started := TRUE;
END_IF;

CASE state OF

0: (* IDLE - do not enable before X0 request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y30 := FALSE;
    Y2 := FALSE;
    IF started THEN
        D20 := search_target_raw;
        D21 := low_rate;
        Y20 := TRUE;
        state := 1;
    END_IF;

1: (* SEARCH: drive A up through sensor plane to find a fresh X34 edge *)
    D20 := search_target_raw;
    D21 := low_rate;
    IF x34_trig.Q THEN
        capture_target := D10;   (* freeze target near current position to stop within 10mm of edge *)
        D20 := capture_target;
        state := 2;
    END_IF;

2: (* CAPTURE: wait until stopped near the detected edge *)
    D20 := capture_target;
    D21 := low_rate;
    IF (ABS(D10 - capture_target) <= 20) AND (ABS(D11) <= 100) THEN
        Y30 := TRUE;   (* fresh rising edge issued only after valid stop within capture window *)
        state := 3;
    END_IF;

3: (* REQUEST CONFIG: hold request until device confirms configured *)
    IF x35_trig.Q THEN
        origin_raw := D90;
        Y30 := FALSE;
        a_target_raw := origin_raw + (D102 * D101) / 100;
        D20 := a_target_raw;
        D21 := move_rate;
        state := 5;
    END_IF;

5: (* MOVE A to computed shelf target (fork retracted, B still at 0) *)
    D20 := a_target_raw;
    D21 := move_rate;
    IF (ABS(D10 - a_target_raw) <= 20) AND (ABS(D11) <= 100) THEN
        b_reach_raw := D103;
        D24 := b_reach_raw;
        D25 := move_rate;
        Y21 := TRUE;
        state := 6;
    END_IF;

6: (* EXTEND B to requested reach, only after A is correctly aligned *)
    D24 := b_reach_raw;
    D25 := move_rate;
    IF (ABS(D12 - b_reach_raw) <= 20) AND (ABS(D13) <= 100) THEN
        D24 := 0;
        state := 7;
    END_IF;

7: (* RETRACT B back to 0 *)
    D24 := 0;
    D25 := move_rate;
    IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
        Y2 := TRUE;
        state := 8;
    END_IF;

8: (* HOLD: maintain B at 0 and Y2 asserted, accumulate required stability *)
    D24 := 0;
    D25 := move_rate;
    Y2 := TRUE;
    hold_timer(IN := (ABS(D12) <= 20) AND (ABS(D13) <= 100), PT := T#100ms);
    IF hold_timer.Q THEN
        state := 9;
    END_IF;

9: (* DONE: keep maintaining completion state *)
    D24 := 0;
    D25 := move_rate;
    Y2 := TRUE;
    hold_timer(IN := (ABS(D12) <= 20) AND (ABS(D13) <= 100), PT := T#100ms);

ELSE
    ;
END_CASE;

END_PROGRAM