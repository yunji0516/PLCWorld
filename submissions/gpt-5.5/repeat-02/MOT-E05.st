PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    x11Edge : R_TRIG;
    resultHold : TON;
    state : INT;
    resultRecorded : BOOL;
END_VAR

x11Edge(CLK := X11);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        resultRecorded := FALSE;
        IF X10 THEN
            Y20 := TRUE;
            state := 10;
        END_IF;

    10:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        state := 20;

    20:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF x11Edge.Q THEN
            D20 := D14;
            resultRecorded := TRUE;
            state := 30;
        END_IF;

    30:
        Y20 := TRUE;

    40:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;

ELSE
    state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    resultRecorded := FALSE;
END_CASE;

resultHold(IN := resultRecorded, PT := T#30ms);

IF resultRecorded THEN
    Y20 := TRUE;
    Y21 := TRUE;
    IF resultHold.Q THEN
        Y2 := TRUE;
        state := 40;
    END_IF;
END_IF;

IF D20 > 200000 THEN
    D20 := 200000;
END_IF;

IF D20 < -200000 THEN
    D20 := -200000;
END_IF;

END_PROGRAM