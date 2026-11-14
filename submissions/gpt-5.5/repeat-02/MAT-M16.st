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
    D20 : INT;
    D21 : INT;
    D22 : INT;
    (* Add internal variables here. *)
    prevStart : BOOL;
    startPulse : BOOL;
    active : BOOL;
    done : BOOL;
    targetLength : INT;
    lengthOk : BOOL;
    edgeOk : BOOL;
END_VAR

(* Implement the control logic here. *)

startPulse := X10 AND NOT prevStart;
prevStart := X10;

Y2 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

IF done THEN
    Y2 := TRUE;
    Y23 := TRUE;
ELSE
    IF startPulse AND NOT active THEN
        active := TRUE;
        targetLength := D10;
    END_IF;

    IF active THEN
        IF D21 < targetLength THEN
            Y22 := TRUE;
            Y23 := FALSE;

            IF D20 > 0 THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 < 0 THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF;
        ELSE
            Y22 := FALSE;
            Y20 := FALSE;
            Y21 := FALSE;
            Y23 := TRUE;

            lengthOk := (D21 >= (targetLength - 3)) AND (D21 <= (targetLength + 3));
            edgeOk := (D20 >= -11) AND (D20 <= 11);

            IF X20 AND lengthOk AND edgeOk THEN
                done := TRUE;
                active := FALSE;
                Y2 := TRUE;
                Y20 := FALSE;
                Y21 := FALSE;
                Y22 := FALSE;
                Y23 := TRUE;
            END_IF;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM