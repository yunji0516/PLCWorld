PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;
    state : INT;
    reqPos : DINT;
    holdPos : DINT;
    axisCommand : DINT;
    currentBalance : DINT;
    commandBalance : DINT;
    finalBalance : DINT;
    remaining : DINT;
    actualAngleRad : REAL;
    commandAngleRad : REAL;
    requestAngleRad : REAL;
    momentValue : REAL;
    balanceReal : REAL;
    degCountToRad : REAL := 0.000174532925;
    commandStep : DINT := 50;
    posTolA : DINT := 20;
    posTolB : DINT := 20;
    speedTolA : DINT := 100;
    speedTolB : DINT := 100;
    compCondition : BOOL;
    y2Latch : BOOL;
    completionTimer : TON;
END_VAR

actualAngleRad := REAL(D11) * degCountToRad;
momentValue := 88.29 * SIN(actualAngleRad) + 0.001962 * REAL(D13);

balanceReal := -45000.0 * SIN(actualAngleRad);
currentBalance := DINT(ROUND(balanceReal));

requestAngleRad := REAL(reqPos) * degCountToRad;
balanceReal := -45000.0 * SIN(requestAngleRad);
finalBalance := DINT(ROUND(balanceReal));

IF state = 0 THEN
    y2Latch := FALSE;
    IF X10 THEN
        reqPos := D10;
        holdPos := D11;
        axisCommand := D11;
        requestAngleRad := REAL(reqPos) * degCountToRad;
        balanceReal := -45000.0 * SIN(requestAngleRad);
        finalBalance := DINT(ROUND(balanceReal));
        state := 10;
    END_IF;
END_IF;

CASE state OF
0:
    D20 := D11;
    D21 := currentBalance;
    D22 := 0;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;

10:
    D20 := holdPos;
    D21 := currentBalance;
    D22 := 0;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;

    IF (ABS(D13 - currentBalance) <= posTolB) AND
       (ABS(D14) <= speedTolB) AND
       (ABS(D12) <= speedTolA) AND
       (ABS(momentValue) <= 5.0) THEN
        axisCommand := D11;
        state := 20;
    END_IF;

20:
    IF axisCommand < reqPos THEN
        remaining := reqPos - axisCommand;
        IF remaining > commandStep THEN
            axisCommand := axisCommand + commandStep;
        ELSE
            axisCommand := reqPos;
        END_IF;
    ELSIF axisCommand > reqPos THEN
        remaining := axisCommand - reqPos;
        IF remaining > commandStep THEN
            axisCommand := axisCommand - commandStep;
        ELSE
            axisCommand := reqPos;
        END_IF;
    END_IF;

    commandAngleRad := REAL(axisCommand) * degCountToRad;
    balanceReal := -45000.0 * SIN(commandAngleRad);
    commandBalance := DINT(ROUND(balanceReal));

    IF axisCommand = reqPos THEN
        commandBalance := finalBalance;
    END_IF;

    D20 := axisCommand;
    D21 := commandBalance;
    D22 := 0;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;

    IF (axisCommand = reqPos) AND
       (ABS(D11 - reqPos) <= posTolA) AND
       (ABS(D12) <= speedTolA) AND
       (ABS(D13 - finalBalance) <= posTolB) AND
       (ABS(D14) <= speedTolB) AND
       (ABS(momentValue) <= 1.0) THEN
        state := 30;
    END_IF;

30:
    D20 := reqPos;
    D21 := finalBalance;
    D22 := 0;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;

    IF X11 THEN
        state := 40;
    END_IF;

40:
    D20 := reqPos;
    D21 := finalBalance;
    D22 := 0;
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := TRUE;

50:
    D20 := reqPos;
    D21 := finalBalance;
    D22 := 0;
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := TRUE;

ELSE
    state := 0;
    D20 := D11;
    D21 := currentBalance;
    D22 := 0;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
END_CASE;

compCondition := (state >= 40) AND
                 X11 AND
                 (NOT Y20) AND
                 Y22 AND
                 (ABS(D11 - reqPos) <= posTolA) AND
                 (ABS(D12) <= speedTolA) AND
                 (ABS(D13 - finalBalance) <= posTolB) AND
                 (ABS(D14) <= speedTolB) AND
                 (ABS(momentValue) <= 1.0);

completionTimer(IN := compCondition, PT := T#30ms);

IF completionTimer.Q THEN
    y2Latch := TRUE;
    state := 50;
END_IF;

Y2 := y2Latch;

END_PROGRAM