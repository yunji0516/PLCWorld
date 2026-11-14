PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;

    (* internal *)
    state : INT := 0;
    match_flag : BOOL := FALSE;
    key_captured : INT := 0;
    startEdge : R_TRIG;
    advTmr : TON;
    retTmr : TON;
END_VAR

startEdge(CLK := X10);

CASE state OF

0: (* IDLE: wait for home + rising start edge *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF startEdge.Q AND X20 THEN
        key_captured := D20;
        match_flag := (key_captured = D10);
        IF match_flag THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
        state := 1;
    END_IF;

1: (* ADVANCING: hold selected output for 0.5s to reach full extension *)
    advTmr(IN := TRUE, PT := T#500ms);
    IF advTmr.Q THEN
        Y20 := FALSE;
        Y21 := FALSE;
        advTmr(IN := FALSE, PT := T#500ms); (* reset timer *)
        state := 2;
    END_IF;

2: (* RETURNING: both outputs off for 0.5s to return home *)
    Y20 := FALSE;
    Y21 := FALSE;
    retTmr(IN := TRUE, PT := T#500ms);
    IF retTmr.Q AND X20 THEN
        retTmr(IN := FALSE, PT := T#500ms); (* reset timer *)
        state := 3;
    END_IF;

3: (* DONE: outputs stay off; evaluate and latch completion result *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF NOT Y2 THEN
        IF X20 AND NOT Y20 AND NOT Y21 THEN
            IF (match_flag AND X21) OR ((NOT match_flag) AND (NOT X21)) THEN
                Y2 := TRUE;
            END_IF;
        END_IF;
    END_IF;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;

END_CASE;

END_PROGRAM