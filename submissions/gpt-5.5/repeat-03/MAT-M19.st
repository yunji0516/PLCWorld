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
    startEdge : R_TRIG;
    state : INT;
    accepted : BOOL;
    completed : BOOL;
    planValid : BOOL;
    requestValue : INT;
    item1Left : BOOL;
    item2Left : BOOL;
    item3Left : BOOL;
    item4Left : BOOL;
    currentLeft : BOOL;
    startCount : INT;
    loadedCountClamped : INT;
    leftLoadedCount : INT;
    rightLoadedCount : INT;
    leftPlannedCount : INT;
    rightPlannedCount : INT;
    nextIndex : INT;
    plannedLeftMass : DINT;
    plannedRightMass : DINT;
    planDiff : DINT;
    measuredDiff : DINT;
    sum12 : DINT;
    sum13 : DINT;
    sum14 : DINT;
    sum23 : DINT;
    sum24 : DINT;
    sum34 : DINT;
    safeLoadedBalanced : BOOL;
END_VAR

startEdge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;

IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

IF (NOT accepted) AND startEdge.Q THEN
    accepted := TRUE;
    requestValue := D10;
    planValid := FALSE;
    item1Left := FALSE;
    item2Left := FALSE;
    item3Left := FALSE;
    item4Left := FALSE;
    leftPlannedCount := 0;
    rightPlannedCount := 0;
    plannedLeftMass := 0;
    plannedRightMass := 0;

    sum12 := DINT(D20) + DINT(D21);
    sum13 := DINT(D20) + DINT(D22);
    sum14 := DINT(D20) + DINT(D23);
    sum23 := DINT(D21) + DINT(D22);
    sum24 := DINT(D21) + DINT(D23);
    sum34 := DINT(D22) + DINT(D23);

    IF requestValue = 4 THEN
        IF ABS(sum12 - sum34) <= 1 THEN
            item1Left := TRUE;
            item2Left := TRUE;
            item3Left := FALSE;
            item4Left := FALSE;
            plannedLeftMass := sum12;
            plannedRightMass := sum34;
            leftPlannedCount := 2;
            rightPlannedCount := 2;
            planValid := TRUE;
        ELSIF ABS(sum13 - sum24) <= 1 THEN
            item1Left := TRUE;
            item2Left := FALSE;
            item3Left := TRUE;
            item4Left := FALSE;
            plannedLeftMass := sum13;
            plannedRightMass := sum24;
            leftPlannedCount := 2;
            rightPlannedCount := 2;
            planValid := TRUE;
        ELSIF ABS(sum14 - sum23) <= 1 THEN
            item1Left := TRUE;
            item2Left := FALSE;
            item3Left := FALSE;
            item4Left := TRUE;
            plannedLeftMass := sum14;
            plannedRightMass := sum23;
            leftPlannedCount := 2;
            rightPlannedCount := 2;
            planValid := TRUE;
        END_IF;
    END_IF;

    IF planValid THEN
        state := 1;
    ELSE
        state := 99;
    END_IF;
END_IF;

loadedCountClamped := D26;
IF loadedCountClamped < 0 THEN
    loadedCountClamped := 0;
ELSIF loadedCountClamped > 4 THEN
    loadedCountClamped := 4;
END_IF;

leftLoadedCount := 0;
IF loadedCountClamped >= 1 THEN
    IF item1Left THEN
        leftLoadedCount := leftLoadedCount + 1;
    END_IF;
END_IF;
IF loadedCountClamped >= 2 THEN
    IF item2Left THEN
        leftLoadedCount := leftLoadedCount + 1;
    END_IF;
END_IF;
IF loadedCountClamped >= 3 THEN
    IF item3Left THEN
        leftLoadedCount := leftLoadedCount + 1;
    END_IF;
END_IF;
IF loadedCountClamped >= 4 THEN
    IF item4Left THEN
        leftLoadedCount := leftLoadedCount + 1;
    END_IF;
END_IF;
rightLoadedCount := loadedCountClamped - leftLoadedCount;

planDiff := ABS(plannedLeftMass - plannedRightMass);
measuredDiff := ABS(DINT(D24) - DINT(D25));
safeLoadedBalanced := accepted AND planValid AND (D26 = 4) AND (leftPlannedCount = 2) AND (rightPlannedCount = 2) AND (planDiff <= 1) AND (measuredDiff <= 1);

CASE state OF
    0:
        ;

    1:
        IF accepted AND planValid THEN
            IF D26 >= 4 THEN
                IF X20 AND safeLoadedBalanced THEN
                    state := 4;
                END_IF;
            ELSE
                IF X20 THEN
                    nextIndex := D26 + 1;
                    currentLeft := FALSE;

                    CASE nextIndex OF
                        1:
                            currentLeft := item1Left;
                        2:
                            currentLeft := item2Left;
                        3:
                            currentLeft := item3Left;
                        4:
                            currentLeft := item4Left;
                    ELSE
                        currentLeft := FALSE;
                    END_CASE;

                    IF currentLeft THEN
                        IF leftLoadedCount < 2 THEN
                            startCount := D26;
                            state := 2;
                        END_IF;
                    ELSE
                        IF rightLoadedCount < 2 THEN
                            startCount := D26;
                            state := 2;
                        END_IF;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

    2:
        IF currentLeft THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;

        IF X21 OR (D26 > startCount) THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 3;
        END_IF;

    3:
        IF X20 AND (D26 > startCount) THEN
            state := 1;
        END_IF;

    4:
        IF safeLoadedBalanced AND X20 THEN
            IF X23 THEN
                Y22 := FALSE;
                completed := TRUE;
                Y2 := TRUE;
                state := 5;
            ELSE
                Y22 := TRUE;
            END_IF;
        ELSE
            Y22 := FALSE;
        END_IF;

    5:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_CASE;

IF completed THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM