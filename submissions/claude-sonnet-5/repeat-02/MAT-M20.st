PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;

    (* Internal variables *)
    startTrig : R_TRIG;
    accepted  : BOOL := FALSE;
    reqVal    : INT  := 0;
    state     : INT  := 0;   (* 0 idle,1 raise,2 push,3 lower,4 retract,5 done *)
    completed : BOOL := FALSE;
END_VAR

(* Edge detect the single start request *)
startTrig(CLK := X10);

IF (NOT accepted) AND startTrig.Q THEN
    accepted := TRUE;
    reqVal   := D10;   (* capture request/recipe value *)
    state    := 1;
END_IF;

CASE state OF

    0: (* IDLE - no actuator operation before Start accepted *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

    1: (* RAISE bridge before crossing the gap *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X20 THEN
            Y20   := FALSE;
            state := 2;
        END_IF;

    2: (* PUSH board across the fully-raised bridge span *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X23 THEN
            Y22   := FALSE;
            state := 3;
        END_IF;

    3: (* LOWER bridge only once board is fully past the gap *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            Y21   := FALSE;
            state := 4;
        END_IF;

    4: (* RETRACT pusher back home *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            Y23   := FALSE;
            state := 5;
        END_IF;

    5: (* DONE - verify terminal condition and hold *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF (NOT completed) AND X25 AND (D20 >= 699) AND X21 AND X22 THEN
            completed := TRUE;
        END_IF;

    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

END_CASE;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM