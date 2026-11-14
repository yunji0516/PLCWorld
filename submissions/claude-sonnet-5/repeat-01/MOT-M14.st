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

    (* Internal variables *)
    req_edge      : R_TRIG;
    state         : INT := 0;      (* 0=IDLE,1=RETRACTING,2=ROTATING,3=APPROACHING,4=DONE *)
    captured_A    : DINT := 0;     (* latched requested table angle *)
    captured_B    : DINT := 0;     (* latched requested slide entry *)
    retract_target: DINT := 0;     (* full retraction target, 0mm *)
    slide_arrived : BOOL := FALSE;
    combined_ok   : BOOL := FALSE;
    combined_timer: TON;
END_VAR

req_edge(CLK := X10);

CASE state OF

0: (* IDLE - before request, no commanded movement *)
    Y20 := FALSE;
    Y21 := FALSE;
    D20 := D10;
    D21 := D12;
    Y2  := FALSE;

    IF req_edge.Q THEN
        captured_A := D14;
        captured_B := D15;
        state := 1;
    END_IF;

1: (* RETRACTING - pull slide to safe retraction before rotation *)
    D20 := D10;              (* hold table at current angle *)
    Y20 := TRUE;
    D21 := retract_target;   (* command full retraction *)
    Y21 := TRUE;
    Y2  := FALSE;

    IF X11 THEN
        state := 2;
    END_IF;

2: (* ROTATING - keep slide retracted, command table rotation *)
    D21 := retract_target;
    Y21 := TRUE;
    D20 := captured_A;
    Y20 := TRUE;
    Y2  := FALSE;

    IF X12 THEN
        state := 3;
    END_IF;

3: (* APPROACHING - table settled, re-approach the slide *)
    D20 := captured_A;
    Y20 := TRUE;
    D21 := captured_B;
    Y21 := TRUE;

    slide_arrived := (ABS(D12 - captured_B) <= 20) AND (ABS(D13) <= 100);
    combined_ok := X12 AND slide_arrived;

    combined_timer(IN := combined_ok, PT := T#30ms);

    IF combined_timer.Q THEN
        Y2 := TRUE;
        state := 4;
    ELSE
        Y2 := FALSE;
    END_IF;

4: (* DONE - maintain terminal state and Y2 *)
    D20 := captured_A;
    Y20 := TRUE;
    D21 := captured_B;
    Y21 := TRUE;
    Y2  := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM