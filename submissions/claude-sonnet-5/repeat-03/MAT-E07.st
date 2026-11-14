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
    D20 : INT;

    (* Internal state *)
    stage : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE stage OF
    0: (* IDLE: wait for start request with correct payload *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2  := FALSE;
        IF start_edge.Q AND (D10 = 1) THEN
            stage := 1;
        END_IF;

    1: (* PUSH: drive plate toward receiver until fully received *)
        Y20 := TRUE;
        Y21 := FALSE;
        IF X22 THEN
            stage := 2;
        END_IF;

    2: (* RETRACT: return pusher to home, plate stays via bridge support *)
        Y20 := FALSE;
        Y21 := TRUE;
        IF X20 THEN
            stage := 3;
        END_IF;

    3: (* DONE: outputs off, hold completion claim through remaining budget *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2  := TRUE;

    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y2  := FALSE;
        stage := 0;
END_CASE;

END_PROGRAM