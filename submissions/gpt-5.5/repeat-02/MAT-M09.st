PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    initialOffTimer : TON;
    finalOffTimer : TON;
    accepted : BOOL;
    completed : BOOL;
    stage : INT;
END_VAR

startEdge(CLK := X10);

IF startEdge.Q AND NOT accepted AND NOT completed AND (D10 = 1) THEN
    accepted := TRUE;
    stage := 10;
END_IF;

initialOffTimer(IN := accepted AND (stage = 10), PT := T#3600ms);
finalOffTimer(IN := accepted AND ((stage = 30) OR (stage = 40) OR (stage = 50)), PT := T#3600ms);

IF accepted AND NOT completed THEN
    CASE stage OF
        10:
            IF X21 AND X24 AND initialOffTimer.Q AND NOT X23 THEN
                stage := 20;
            END_IF;
        20:
            IF X23 THEN
                stage := 30;
            END_IF;
        30:
            IF X22 AND X25 THEN
                stage := 40;
            END_IF;
        40:
            IF X20 THEN
                stage := 50;
            END_IF;
        50:
            IF X20 AND X22 AND X25 AND NOT X23 AND finalOffTimer.Q THEN
                completed := TRUE;
                stage := 60;
            END_IF;
    ELSE
        stage := 0;
    END_CASE;
END_IF;

Y2 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

IF completed THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
ELSIF accepted THEN
    CASE stage OF
        10:
            Y22 := FALSE;
            Y23 := FALSE;
            Y20 := NOT X21;
            Y21 := FALSE;
        20:
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := TRUE;
        30:
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := TRUE;
            Y23 := FALSE;
        40:
            Y20 := FALSE;
            Y21 := NOT X20;
            Y22 := TRUE;
            Y23 := FALSE;
        50:
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := TRUE;
            Y23 := FALSE;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
    END_CASE;
END_IF;

END_PROGRAM