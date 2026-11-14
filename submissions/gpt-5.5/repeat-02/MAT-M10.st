PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;
    startEdge : R_TRIG;
    sourceReleaseTimer : TON;
    targetReleaseTimer : TON;
    state : INT;
    accepted : BOOL;
    requestValue : INT;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
    sourceCustodyOk : BOOL;
    targetCustodyOk : BOOL;
END_VAR

startEdge(CLK := X10);

sourceReleaseTimer(IN := (state = 20), PT := T#150ms);
targetReleaseTimer(IN := (state = 50), PT := T#150ms);

IF startEdge.Q AND (NOT accepted) THEN
    accepted := TRUE;
    requestValue := D10;

    sel1 := (D10 = 1) OR (D10 = 3) OR (D10 = 5);
    sel2 := (D10 = 2) OR (D10 = 3) OR (D10 = 6);
    sel3 := (D10 = 4) OR (D10 = 5) OR (D10 = 6);

    state := 10;
END_IF;

sourceCustodyOk := ((sel1 AND X26) OR ((NOT sel1) AND (NOT X26))) AND
                   ((sel2 AND X27) OR ((NOT sel2) AND (NOT X27))) AND
                   ((sel3 AND X28) OR ((NOT sel3) AND (NOT X28)));

targetCustodyOk := (NOT X26) AND (NOT X27) AND (NOT X28) AND X25;

CASE state OF
    0:
        ;

    10:
        IF X20 AND X23 THEN
            state := 20;
        END_IF;

    20:
        IF sourceReleaseTimer.Q AND sourceCustodyOk THEN
            state := 30;
        END_IF;

    30:
        IF X22 THEN
            state := 40;
        END_IF;

    40:
        IF X21 AND X22 THEN
            state := 45;
        END_IF;

    45:
        IF X21 AND X23 THEN
            state := 50;
        END_IF;

    50:
        IF targetReleaseTimer.Q AND targetCustodyOk THEN
            state := 60;
        END_IF;

    60:
        IF X22 AND X25 THEN
            state := 70;
        END_IF;

    70:
        IF X20 AND X22 AND X25 THEN
            state := 80;
        END_IF;

    80:
        ;
ELSE
    state := 0;
END_CASE;

Y2 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF
    0:
        ;

    10:
        Y23 := TRUE;

    20:
        Y24 := NOT sel1;
        Y25 := NOT sel2;
        Y26 := NOT sel3;

    30:
        Y22 := TRUE;
        Y24 := NOT sel1;
        Y25 := NOT sel2;
        Y26 := NOT sel3;

    40:
        Y20 := TRUE;
        Y24 := NOT sel1;
        Y25 := NOT sel2;
        Y26 := NOT sel3;

    45:
        Y23 := TRUE;
        Y24 := NOT sel1;
        Y25 := NOT sel2;
        Y26 := NOT sel3;

    50:
        Y24 := TRUE;
        Y25 := TRUE;
        Y26 := TRUE;

    60:
        Y22 := TRUE;
        Y24 := TRUE;
        Y25 := TRUE;
        Y26 := TRUE;

    70:
        Y21 := TRUE;
        Y24 := TRUE;
        Y25 := TRUE;
        Y26 := TRUE;

    80:
        Y2 := TRUE;
        Y24 := TRUE;
        Y25 := TRUE;
        Y26 := TRUE;
END_CASE;

END_PROGRAM