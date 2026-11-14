PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal variables *)
    start_trig : R_TRIG;
    started    : BOOL := FALSE;
    completed  : BOOL := FALSE;
    violation  : BOOL := FALSE;
    deadband   : INT := 1;
END_VAR

(* Detect start request rising edge *)
start_trig(CLK := X10);
IF start_trig.Q THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    (* Do not initiate operation before Start *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := FALSE;

ELSE

    IF completed THEN
        (* Hold completion, keep steering off *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2  := TRUE;

    ELSE
        (* Active control while feed is progressing *)
        IF NOT X20 THEN
            (* External feed ongoing: bang-bang correction toward zero error *)
            IF D20 > deadband THEN
                Y20 := TRUE;   (* left: reduce edge value *)
                Y21 := FALSE;
            ELSIF D20 < -deadband THEN
                Y20 := FALSE;
                Y21 := TRUE;   (* right: increase edge value *)
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF;

            (* Track any excursion beyond the allowed corridor *)
            IF (D20 > 12) OR (D20 < -12) THEN
                violation := TRUE;
            END_IF;

        ELSE
            (* External feed reported done: stop steering *)
            Y20 := FALSE;
            Y21 := FALSE;

            IF (D20 > 12) OR (D20 < -12) THEN
                violation := TRUE;
            END_IF;
        END_IF;

        (* Completion check *)
        IF X20 AND (NOT Y20) AND (NOT Y21) AND (NOT violation)
           AND (D20 >= -12) AND (D20 <= 12) THEN
            completed := TRUE;
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
    END_IF;

END_IF;

END_PROGRAM