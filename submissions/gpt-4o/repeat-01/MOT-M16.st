```pascal
PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    requestInitiated : BOOL := FALSE;
    moduleCompleted : BOOL := FALSE;
    startEdge : R_TRIG;
    moduleBusyPrev : BOOL := FALSE;
    completionTimer : TON;
    confirmationTimer : TON;
    maintenanceTimer : TON;
    targetAchieved : BOOL := FALSE;
END_VAR

startEdge(CLK := X0);
completionTimer(IN := moduleCompleted AND NOT X35, PT := T#15000ms);
confirmationTimer(IN := X35, PT := T#100ms);
maintenanceTimer(IN := confirmationTimer.Q, PT := T#15100ms);

IF startEdge.Q THEN
    Y20 := TRUE;
    Y21 := TRUE;
    D20 := D101;
    D21 := 1000; // 100% rate
    D24 := D102;
    D25 := 1000; // 100% rate
    requestInitiated := TRUE;
    moduleBusyPrev := X34;
END_IF

IF requestInitiated AND NOT X34 AND NOT moduleBusyPrev THEN
    IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 AND ABS(D12 - D102) <= 20 AND ABS(D13) <= 100 THEN
        targetAchieved := TRUE;
        Y30 := TRUE;
    END_IF
END_IF

IF X34 THEN
    Y30 := FALSE;
END_IF

IF X35 THEN
    moduleCompleted := TRUE;
    Y21 := FALSE;
    D24 := 0;
    targetAchieved := FALSE;
    moduleCompleted := FALSE;
END_IF

IF confirmationTimer.Q THEN
    Y2 := TRUE;
END_IF

IF maintenanceTimer.Q THEN
    Y2 := FALSE;
    Y20 := FALSE;
    requestInitiated := FALSE;
    moduleCompleted := FALSE;
END_IF

moduleBusyPrev := X34;

END_PROGRAM
```