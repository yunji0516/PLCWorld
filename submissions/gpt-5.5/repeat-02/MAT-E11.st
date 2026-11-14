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
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    requested : BOOL;
    feeding : BOOL;
    completed : BOOL;
    edgeValid : BOOL;
END_VAR

(* Implement the control logic here. *)
startEdge(CLK := X10);

edgeValid := (D20 >= -12) AND (D20 <= 12);

IF completed THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
ELSE
    IF startEdge.Q AND (D10 = 1) THEN
        requested := TRUE;
        feeding := TRUE;
    END_IF;

    IF requested AND feeding AND (NOT X20) THEN
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
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;

    IF requested AND X20 THEN
        feeding := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;

        IF edgeValid THEN
            completed := TRUE;
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
    ELSE
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM