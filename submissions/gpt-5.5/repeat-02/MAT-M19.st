PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;
    (* Add internal variables here. *)
    startTrig : R_TRIG;
    accepted : BOOL;
    acceptedThisScan : BOOL;
    done : BOOL;
    recipeValid : BOOL;
    state : INT;
    reqValue : INT;
    w1 : INT;
    w2 : INT;
    w3 : INT;
    w4 : INT;
    expectedNext : INT;
    activeLeft : BOOL;
    selectedLeft : BOOL;
    p1Left : BOOL;
    p2Left : BOOL;
    p3Left : BOOL;
    p4Left : BOOL;
    leftStarted : INT;
    rightStarted : INT;
    plannedLeft : DINT;
    plannedRight : DINT;
    oneD : DINT := 1;
END_VAR

(* Implement the control logic here. *)
startTrig(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
acceptedThisScan := FALSE;

IF startTrig.Q AND NOT accepted AND NOT done THEN
    accepted := TRUE;
    acceptedThisScan := TRUE;
    reqValue := D10;
    w1 := D20;
    w2 := D21;
    w3 := D22;
    w4 := D23;
    recipeValid := FALSE;
    p1Left := FALSE;
    p2Left := FALSE;
    p3Left := FALSE;
    p4Left := FALSE;
    plannedLeft := 0;
    plannedRight := 0;
    expectedNext := 1;
    leftStarted := 0;
    rightStarted := 0;
    state := 90;

    IF reqValue = 4 THEN
        IF ABS((DINT(w1) + DINT(w2)) - (DINT(w3) + DINT(w4))) <= oneD THEN
            p1Left := TRUE;
            p2Left := TRUE;
            p3Left := FALSE;
            p4Left := FALSE;
            plannedLeft := DINT(w1) + DINT(w2);
            plannedRight := DINT(w3) + DINT(w4);
            recipeValid := TRUE;
        ELSIF ABS((DINT(w1) + DINT(w3)) - (DINT(w2) + DINT(w4))) <= oneD THEN
            p1Left := TRUE;
            p2Left := FALSE;
            p3Left := TRUE;
            p4Left := FALSE;
            plannedLeft := DINT(w1) + DINT(w3);
            plannedRight := DINT(w2) + DINT(w4);
            recipeValid := TRUE;
        ELSIF ABS((DINT(w1) + DINT(w4)) - (DINT(w2) + DINT(w3))) <= oneD THEN
            p1Left := TRUE;
            p2Left := FALSE;
            p3Left := FALSE;
            p4Left := TRUE;
            plannedLeft := DINT(w1) + DINT(w4);
            plannedRight := DINT(w2) + DINT(w3);
            recipeValid := TRUE;
        END_IF;

        IF recipeValid THEN
            state := 10;
        END_IF;
    END_IF;
END_IF;

IF NOT done AND accepted AND NOT acceptedThisScan THEN
    CASE state OF
        10:
            IF expectedNext > 4 THEN
                state := 40;
            ELSIF (D26 = (expectedNext - 1)) AND X20 AND NOT X21 THEN
                selectedLeft := FALSE;
                CASE expectedNext OF
                    1:
                        selectedLeft := p1Left;
                    2:
                        selectedLeft := p2Left;
                    3:
                        selectedLeft := p3Left;
                    4:
                        selectedLeft := p4Left;
                ELSE
                    selectedLeft := FALSE;
                END_CASE;

                IF selectedLeft THEN
                    IF leftStarted < 2 THEN
                        leftStarted := leftStarted + 1;
                        activeLeft := TRUE;
                        state := 20;
                    ELSE
                        state := 90;
                    END_IF;
                ELSE
                    IF rightStarted < 2 THEN
                        rightStarted := rightStarted + 1;
                        activeLeft := FALSE;
                        state := 20;
                    ELSE
                        state := 90;
                    END_IF;
                END_IF;
            END_IF;

        20:
            IF X21 OR (D26 >= expectedNext) THEN
                state := 30;
            ELSE
                IF activeLeft THEN
                    Y20 := TRUE;
                ELSE
                    Y21 := TRUE;
                END_IF;
            END_IF;

        30:
            IF X20 AND (D26 >= expectedNext) THEN
                expectedNext := expectedNext + 1;
                IF expectedNext > 4 THEN
                    state := 40;
                ELSE
                    state := 10;
                END_IF;
            END_IF;

        40:
            IF recipeValid AND (D26 = 4) AND X20 AND (leftStarted = 2) AND (rightStarted = 2) AND (ABS(plannedLeft - plannedRight) <= oneD) AND (ABS(DINT(D24) - DINT(D25)) <= oneD) THEN
                state := 50;
            END_IF;

        50:
            IF X23 THEN
                IF recipeValid AND (D26 = 4) AND X20 AND (leftStarted = 2) AND (rightStarted = 2) AND (ABS(plannedLeft - plannedRight) <= oneD) AND (ABS(DINT(D24) - DINT(D25)) <= oneD) THEN
                    done := TRUE;
                    state := 60;
                ELSE
                    state := 40;
                END_IF;
            ELSE
                Y22 := TRUE;
            END_IF;

        60:
            done := TRUE;

        90:
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
    END_CASE;
END_IF;

IF done THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM