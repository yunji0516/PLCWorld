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
    D22 : INT;
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    started : BOOL;
    completed : BOOL;
    choiceMade : BOOL;
    targetSide : INT;
    latchedMass : DINT;
    latchedLeft : DINT;
    latchedRight : DINT;
    diffIfLeft : DINT;
    diffIfRight : DINT;
END_VAR

(* Implement the control logic here. *)

startEdge(CLK := X10);

IF startEdge.Q AND (NOT started) AND (D10 = 1) THEN
    started := TRUE;
    choiceMade := TRUE;
    latchedMass := DINT(D20);
    latchedLeft := DINT(D21);
    latchedRight := DINT(D22);

    diffIfLeft := ABS((DINT(D21) + DINT(D20)) - DINT(D22));
    diffIfRight := ABS(DINT(D21) - (DINT(D22) + DINT(D20)));

    IF X22 AND X23 THEN
        IF diffIfLeft <= diffIfRight THEN
            targetSide := -1;
        ELSE
            targetSide := 1;
        END_IF;
    ELSIF X22 THEN
        targetSide := -1;
    ELSIF X23 THEN
        targetSide := 1;
    ELSE
        targetSide := 0;
    END_IF;
END_IF;

Y20 := FALSE;
Y21 := FALSE;

IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;

    IF started AND choiceMade THEN
        IF targetSide = -1 THEN
            IF X20 THEN
                completed := TRUE;
                Y2 := TRUE;
            ELSE
                Y20 := TRUE;
            END_IF;
        ELSIF targetSide = 1 THEN
            IF X21 THEN
                completed := TRUE;
                Y2 := TRUE;
            ELSE
                Y21 := TRUE;
            END_IF;
        END_IF;
    END_IF;
END_IF;

IF Y20 AND Y21 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

END_PROGRAM