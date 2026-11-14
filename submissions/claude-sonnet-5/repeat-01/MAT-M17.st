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

    (* internal *)
    state : INT := 0;
    startTrig : R_TRIG;
    accepted : BOOL := FALSE;
    requestedId : INT := 0;
END_VAR

(* detect the single accepted start request *)
startTrig(CLK := X10);
IF startTrig.Q AND NOT accepted THEN
    requestedId := D10;
    accepted := TRUE;
    state := 1;
END_IF;

CASE state OF

    0:
        (* Idle: no actuator commands before Start accepted *)
        Y20 := FALSE;
        Y21 := FALSE;

    1:
        (* Flush previous material (ID1) to waste; branch stays at waste, pump ON *)
        Y21 := FALSE;
        Y20 := TRUE;
        IF D20 = 2 THEN
            (* outlet now current material: stop pump before moving branch *)
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        (* Pump OFF while branch repositions to target *)
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 AND (NOT X20) THEN
            state := 3;
        END_IF;

    3:
        (* Branch confirmed at target: resume pump until source truly empty *)
        Y21 := TRUE;
        Y20 := TRUE;
        IF X22 THEN
            Y20 := FALSE;
            state := 4;
        END_IF;

    4:
        (* Completed: maintain terminal state, pump OFF, branch may stay at target *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := TRUE;

    ELSE
        Y20 := FALSE;
        Y21 := FALSE;

END_CASE;

END_PROGRAM