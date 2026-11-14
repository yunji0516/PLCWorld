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
    startEdge : R_TRIG;
    state : INT;
    chosenSide : INT;
    leftLoad0 : DINT;
    rightLoad0 : DINT;
    mass0 : DINT;
    diffLeft : DINT;
    diffRight : DINT;
    leftFree0 : BOOL;
    rightFree0 : BOOL;
END_VAR

startEdge(CLK := X10);

IF state = 0 THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;

    IF startEdge.Q AND (D10 = 1) THEN
        leftLoad0 := DINT(D21);
        rightLoad0 := DINT(D22);
        mass0 := DINT(D20);
        leftFree0 := X22;
        rightFree0 := X23;
        chosenSide := 0;

        IF leftFree0 AND rightFree0 THEN
            diffLeft := ABS((leftLoad0 + mass0) - rightLoad0);
            diffRight := ABS(leftLoad0 - (rightLoad0 + mass0));

            IF diffLeft <= diffRight THEN
                chosenSide := 1;
            ELSE
                chosenSide := 2;
            END_IF;
        ELSIF leftFree0 THEN
            chosenSide := 1;
        ELSIF rightFree0 THEN
            chosenSide := 2;
        ELSE
            chosenSide := 0;
        END_IF;

        IF chosenSide = 1 THEN
            state := 1;
        ELSIF chosenSide = 2 THEN
            state := 2;
        END_IF;
    END_IF;

ELSIF state = 1 THEN
    Y2 := FALSE;
    Y21 := FALSE;

    IF X20 THEN
        Y20 := FALSE;
        Y2 := TRUE;
        state := 3;
    ELSE
        Y20 := TRUE;
    END_IF;

ELSIF state = 2 THEN
    Y2 := FALSE;
    Y20 := FALSE;

    IF X21 THEN
        Y21 := FALSE;
        Y2 := TRUE;
        state := 3;
    ELSE
        Y21 := TRUE;
    END_IF;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM