PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;
    state : INT := 0;
    ratioCmd : DINT := 0;
    syncU : DINT := 0;
    minTarget : DINT := 0;
    parkTarget : DINT := 0;
    idx : INT := 0;
    resultOk : BOOL := FALSE;
    completionDelay : TON;
END_VAR

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y2 := FALSE;
D20 := 0;
D21 := parkTarget;

CASE state OF
    0:
        parkTarget := 0;
        D21 := 0;
        IF X10 THEN
            ratioCmd := D15;
            IF ratioCmd < 500 THEN
                ratioCmd := 500;
            ELSIF ratioCmd > 2500 THEN
                ratioCmd := 2500;
            END_IF;
            D20 := ratioCmd;
            Y20 := TRUE;
            state := 10;
        END_IF;

    10:
        D20 := ratioCmd;
        Y20 := TRUE;
        IF X11 AND X12 THEN
            syncU := D10;
            state := 20;
        END_IF;

    20:
        D20 := ratioCmd;
        Y20 := TRUE;
        IF X11 AND X12 AND ((D10 - syncU) >= D14) THEN
            Y21 := TRUE;
            state := 30;
        END_IF;

    30:
        IF X12 THEN
            D20 := ratioCmd;
        ELSE
            minTarget := D11 + 7000;
            parkTarget := D13;
            FOR idx := 0 TO 20 DO
                IF parkTarget < minTarget THEN
                    parkTarget := parkTarget + 36000;
                END_IF;
            END_FOR;
            D21 := parkTarget;
            Y22 := TRUE;
            state := 40;
        END_IF;

    40:
        D21 := parkTarget;
        IF NOT X12 THEN
            Y22 := TRUE;
        END_IF;

    50:
        D21 := parkTarget;
        IF NOT X12 THEN
            Y22 := TRUE;
        END_IF;
        Y2 := TRUE;

ELSE
    state := 0;
END_CASE;

resultOk := FALSE;
IF (state = 40) OR (state = 50) THEN
    IF (NOT X12) AND Y22 AND (ABS(D11 - parkTarget) <= 20) AND (ABS(D12) <= 100) THEN
        resultOk := TRUE;
    END_IF;
END_IF;

completionDelay(IN := resultOk, PT := T#30ms);

IF (state = 40) AND completionDelay.Q THEN
    state := 50;
    Y2 := TRUE;
END_IF;

END_PROGRAM