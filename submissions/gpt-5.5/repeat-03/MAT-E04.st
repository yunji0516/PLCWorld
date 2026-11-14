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
    startTrig : R_TRIG;
    rearmTimer : TON;
    offerTimer : TON;
    stage : INT;
    accepted : BOOL;
END_VAR

startTrig(CLK := X10);

IF (stage = 0) AND startTrig.Q AND (D10 = 1) THEN
    stage := 1;
END_IF;

rearmTimer(IN := (stage = 1), PT := T#1600ms);
offerTimer(IN := (stage = 3) AND X22, PT := T#250ms);

IF stage = 1 THEN
    IF rearmTimer.Q AND (NOT X21) THEN
        stage := 2;
    END_IF;
ELSIF stage = 2 THEN
    IF X22 THEN
        stage := 3;
    END_IF;
ELSIF stage = 3 THEN
    IF offerTimer.Q AND X22 AND X21 THEN
        accepted := TRUE;
        stage := 4;
    END_IF;
ELSIF stage = 4 THEN
    IF accepted AND X20 AND X23 AND (NOT X21) THEN
        stage := 5;
    END_IF;
END_IF;

CASE stage OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
    1:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
    3:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;
    4:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
    5:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := TRUE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
END_CASE;

END_PROGRAM