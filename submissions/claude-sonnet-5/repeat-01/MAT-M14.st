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

    (* internal *)
    start_edge : R_TRIG;
    started    : BOOL := FALSE;
    completed  : BOOL := FALSE;
    state      : INT := 0;
    predicted  : INT;
END_VAR

start_edge(CLK := X10);

CASE state OF

0: (* IDLE - wait for start request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF start_edge.Q AND (D10 = 1) THEN
        started := TRUE;
        state := 1;
    END_IF;

1: (* Advance supply finger only if pusher is home *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X20 THEN
        Y22 := TRUE;
    ELSE
        Y22 := FALSE;
    END_IF;
    IF X23 THEN (* loaded : product fully placed *)
        Y22 := FALSE;
        state := 2;
    END_IF;

2: (* Withdraw supply finger, wait for it to be home *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF X24 THEN (* feeder_home *)
        state := 3;
    END_IF;

3: (* Wait for correct timing window to fire *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    predicted := D20 - D21;
    IF X20 AND X23 AND X24 AND (predicted >= 0) AND (predicted <= 30) THEN
        Y20 := TRUE;
        Y21 := FALSE;
        state := 4;
    END_IF;

4: (* Firing : pusher extends over 1.0 s *)
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF X21 THEN (* end reached *)
        Y20 := FALSE;
        state := 5;
    END_IF;

5: (* Retracting the pusher home *)
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := FALSE;
    IF X20 THEN (* home reached *)
        Y21 := FALSE;
        state := 6;
    END_IF;

6: (* Completion check and hold *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF (NOT completed) AND X20 AND X24 AND X23 AND X22 THEN
        completed := TRUE;
    END_IF;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_CASE;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM