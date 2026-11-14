PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    D20 : INT;
    D22 : INT;

    state : INT := 0;
    layer : INT := 1;
    req_l1 : INT;
    req_l2 : INT;
    req_l3 : INT;
    req_l4 : INT;
    target_source : INT;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q AND D10 = 4 THEN
            req_l1 := D11;
            req_l2 := D12;
            req_l3 := D13;
            req_l4 := D14;
            layer := 1;
            state := 1;
        END_IF

    1:
        IF layer = 1 THEN target_source := req_l1;
        ELSIF layer = 2 THEN target_source := req_l2;
        ELSIF layer = 3 THEN target_source := req_l3;
        ELSIF layer = 4 THEN target_source := req_l4;
        END_IF
        
        Y23 := TRUE; 
        Y24 := FALSE;
        IF X23 THEN
            IF target_source = 0 THEN
                state := 2;
            ELSE
                state := 3;
            END_IF
        END_IF

    2:
        Y23 := TRUE; Y24 := FALSE;
        IF NOT X20 THEN
            Y21 := TRUE; Y22 := FALSE;
        ELSE
            Y21 := FALSE; Y22 := FALSE;
            state := 4;
        END_IF

    3:
        Y23 := TRUE; Y24 := FALSE;
        IF NOT X21 THEN
            Y22 := TRUE; Y21 := FALSE;
        ELSE
            Y21 := FALSE; Y22 := FALSE;
            state := 4;
        END_IF

    4:
        Y21 := FALSE; Y22 := FALSE;
        IF X27 AND X23 THEN
            state := 5;
        END_IF

    5:
        Y23 := FALSE; Y24 := TRUE;
        IF X24 THEN
            state := 6;
        END_IF

    6:
        Y20 := TRUE;
        IF X25 THEN
            state := 7;
        END_IF

    7:
        Y23 := TRUE; Y24 := FALSE;
        IF X23 THEN
            state := 8;
        END_IF

    8:
        Y23 := TRUE; Y24 := FALSE;
        IF NOT X22 THEN
            IF D20 < 0 THEN
                Y22 := TRUE; Y21 := FALSE;
            ELSE
                Y21 := TRUE; Y22 := FALSE;
            END_IF
        ELSE
            Y21 := FALSE; Y22 := FALSE;
            state := 9;
        END_IF

    9:
        IF D22 > 700 THEN
            Y26 := TRUE; Y27 := FALSE;
        ELSIF D22 < 700 THEN
            Y26 := FALSE; Y27 := TRUE;
        ELSE
            Y26 := FALSE; Y27 := FALSE;
            state := 10;
        END_IF

    10:
        Y23 := FALSE; Y24 := TRUE;
        IF X24 THEN
            state := 11;
        END_IF

    11:
        Y20 := FALSE;
        IF X26 AND X28 THEN
            state := 12;
        END_IF

    12:
        Y23 := TRUE; Y24 := FALSE;
        IF X23 THEN
            layer := layer + 1;
            IF layer > 4 THEN
                state := 15;
            ELSE
                state := 1;
            END_IF
        END_IF

    15:
        Y23 := TRUE; Y24 := FALSE;
        IF NOT X20 THEN
            Y21 := TRUE; Y22 := FALSE;
        ELSE
            Y21 := FALSE; Y22 := FALSE;
            state := 16;
        END_IF

    16:
        Y21 := FALSE; Y22 := FALSE;
        Y23 := FALSE; Y24 := FALSE;
        Y26 := FALSE; Y27 := FALSE;
        Y20 := FALSE;
        Y2 := TRUE;

END_CASE

END_PROGRAM