PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    retract_cmd : DINT := 40000;
    hold_pos : DINT := 40000;
    table_ok : BOOL := FALSE;
    slide_ok : BOOL := FALSE;
    terminal_ok : BOOL := FALSE;
    timer_terminal : TON;
END_VAR

(* Calculate safe slide retraction target *)
retract_cmd := D16 - 10000;
IF retract_cmd < 0 THEN
    retract_cmd := 0;
END_IF;
IF retract_cmd > 40000 THEN
    retract_cmd := 40000;
END_IF;

(* State transitions *)
CASE state OF
    0:
        IF X10 THEN
            IF X11 THEN
                hold_pos := MIN(D12, retract_cmd);
            ELSE
                hold_pos := retract_cmd;
            END_IF;

            IF X12 THEN
                state := 40;
            ELSIF X11 THEN
                state := 30;
            ELSE
                state := 20;
            END_IF;
        END_IF;

    20:
        (* Retracting slide: wait until clearance is established *)
        IF X11 THEN
            state := 30;
        END_IF;

    30:
        (* Rotating table: wait until table settles at requested angle *)
        IF X12 THEN
            state := 40;
        END_IF;

    40:
        (* Approaching receiver: wait for terminal conditions *)
        IF timer_terminal.Q THEN
            state := 50;
        END_IF;

    50:
        (* Task complete: maintain terminal state *)
        ;
END_CASE;

(* Evaluate terminal condition *)
table_ok := (ABS(D10 - D14) <= 20) AND (ABS(D11) <= 100);
slide_ok := (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100);
terminal_ok := X12 AND table_ok AND slide_ok;

(* Combined terminal condition hold timer (30 ms) *)
timer_terminal(IN := (state = 40) AND terminal_ok, PT := T#30ms);

IF (state = 40) AND timer_terminal.Q THEN
    state := 50;
END_IF;

(* Drive outputs *)
CASE state OF
    0:
        D20 := D10;
        D21 := D12;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;

    20:
        D20 := D10;
        D21 := hold_pos;
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;

    30:
        D20 := D14;
        D21 := hold_pos;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;

    40:
        D20 := D14;
        D21 := D15;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;

    50:
        D20 := D14;
        D21 := D15;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM