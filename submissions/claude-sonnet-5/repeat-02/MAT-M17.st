PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    step        : INT := 0;
    startEdge   : R_TRIG;
    requestID   : INT := 0;
    accepted    : BOOL := FALSE;
END_VAR

(* Detect the single accepted start request *)
startEdge(CLK := X10);

IF (NOT accepted) AND startEdge.Q THEN
    requestID := D10;
    accepted  := TRUE;
    step := 1;
END_IF;

CASE step OF

    0: (* IDLE - no actuator operation before Start accepted *)
        Y20 := FALSE;
        Y21 := FALSE;

    1: (* FLUSH: route to waste, pump ON, until outlet identity becomes current (ID2) *)
        Y20 := TRUE;
        Y21 := FALSE;
        IF D20 = 2 THEN
            Y20 := FALSE; (* stop pump before touching branch *)
            step := 2;
        END_IF;

    2: (* PUMP_OFF_CONFIRM: hold pump off for a full scan, branch stays waste *)
        Y20 := FALSE;
        Y21 := FALSE;
        step := 3;

    3: (* MOVE_TO_TARGET: pump remains off while branch moves *)
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            step := 4;
        END_IF;

    4: (* PUMP_TO_TARGET: fully target-positioned, pump ON until source truly empty *)
        Y20 := TRUE;
        Y21 := TRUE;
        IF X22 THEN
            Y20 := FALSE;
            step := 5;
        END_IF;

    5: (* CHECK_DONE: verify completion conditions *)
        Y20 := FALSE;
        Y21 := TRUE; (* branch may remain at target *)
        IF X22 AND X23 AND (D20 = 2) THEN
            Y2 := TRUE;
            step := 6;
        END_IF;

    6: (* DONE: maintain claim and terminal physical state *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y2  := TRUE;

    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        step := 0;
END_CASE;

END_PROGRAM