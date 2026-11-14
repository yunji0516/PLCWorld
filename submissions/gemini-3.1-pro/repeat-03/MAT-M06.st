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
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    req_vol : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* Wait for Start *)
        IF start_edge.Q THEN
            req_vol := D10;
            state := 1;
        END_IF

    1: (* Move Down *)
        Y20 := TRUE;
        Y21 := FALSE;
        IF X21 THEN
            Y20 := FALSE;
            state := 2;
        END_IF

    2: (* Open Valve and Pump Liquid *)
        Y22 := TRUE;
        Y23 := TRUE;
        IF D20 >= req_vol THEN
            Y22 := FALSE;
            Y23 := FALSE;
            state := 3;
        END_IF

    3: (* Wait for Valve Closed *)
        Y22 := FALSE;
        Y23 := FALSE;
        IF X23 THEN
            state := 4;
        END_IF

    4: (* Move Up *)
        Y21 := TRUE;
        Y20 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            state := 5;
        END_IF

    5: (* Done / Claim Completion *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
END_CASE

END_PROGRAM