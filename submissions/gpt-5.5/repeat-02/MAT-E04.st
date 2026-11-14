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
    (* Add internal variables here. *)
    state : INT := 0;
    accepted : BOOL := FALSE;
    startEdge : R_TRIG;
    rearmTimer : TON;
END_VAR

startEdge(CLK := X10);

IF state = 0 THEN
    IF startEdge.Q AND (D10 = 1) THEN
        state := 10;
        accepted := FALSE;
    END_IF;
END_IF;

rearmTimer(IN := (state = 10), PT := T#200ms);

CASE state OF
    10:
        IF rearmTimer.Q AND (NOT X21) THEN
            state := 20;
        END_IF;

    20:
        IF X22 THEN
            state := 30;
        END_IF;

    30:
        IF X21 THEN
            accepted := TRUE;
            state := 40;
        END_IF;

    40:
        IF accepted AND X20 AND X23 AND (NOT X21) THEN
            state := 100;
        END_IF;

    100:
        accepted := TRUE;

ELSE
    IF state <> 0 THEN
        state := 0;
        accepted := FALSE;
    END_IF;
END_CASE;

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;

    10:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;

    20:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;

    30:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;

    40:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;

    100:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
END_CASE;

END_PROGRAM