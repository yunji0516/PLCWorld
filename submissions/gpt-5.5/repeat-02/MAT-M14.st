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
    X24 : BOOL;
    D20 : INT;
    D21 : INT;
    startEdge : R_TRIG;
    startPulse : BOOL;
    state : INT;
    dist : DINT;
    spd : DINT;
    timingError : DINT;
    fireWindow : BOOL;
END_VAR

startEdge(CLK := X10);
startPulse := startEdge.Q;

dist := DINT(D20);
spd := DINT(D21);
timingError := dist - spd;
fireWindow := (spd >= 200) AND (spd <= 300) AND (timingError >= 5) AND (timingError <= 20);

Y2 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;

IF (state = 0) AND startPulse AND (D10 = 1) THEN
    state := 10;
END_IF;

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;

    10:
        IF X23 THEN
            Y22 := FALSE;
            state := 20;
        ELSE
            IF X20 THEN
                Y22 := TRUE;
            ELSE
                Y22 := FALSE;
            END_IF;
        END_IF;

    20:
        Y22 := FALSE;
        IF X23 AND X24 THEN
            state := 30;
        END_IF;

    30:
        IF X23 AND X24 AND X20 AND fireWindow THEN
            Y20 := TRUE;
            state := 40;
        END_IF;

    40:
        Y20 := TRUE;
        IF X21 THEN
            Y20 := FALSE;
            IF X22 THEN
                Y21 := TRUE;
                state := 60;
            ELSE
                state := 50;
            END_IF;
        END_IF;

    50:
        IF X22 THEN
            Y21 := TRUE;
            state := 60;
        END_IF;

    60:
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            Y20 := FALSE;
            Y22 := FALSE;
            Y2 := TRUE;
            state := 70;
        END_IF;

    70:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;

ELSE
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_CASE;

END_PROGRAM