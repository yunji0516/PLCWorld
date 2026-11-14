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

    (* Internal *)
    start_edge : R_TRIG;
    state : INT := 0; (* 0=idle, 1=pushing, 2=retracting, 3=done *)
END_VAR

start_edge(CLK := X10);

CASE state OF

0: (* idle: wait for start request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    IF start_edge.Q THEN
        state := 1;
        Y20 := TRUE;
        Y21 := FALSE;
    END_IF;

1: (* pushing forward *)
    Y20 := TRUE;
    Y21 := FALSE;
    IF X21 THEN
        (* forward stroke complete, begin return *)
        state := 2;
        Y20 := FALSE;
        Y21 := TRUE;
    END_IF;

2: (* retracting *)
    Y20 := FALSE;
    Y21 := TRUE;
    IF X20 THEN
        (* pusher home *)
        state := 3;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
    END_IF;

3: (* done: hold result *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;

ELSE
    (* safety fallback *)
    Y20 := FALSE;
    Y21 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM