PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    step : INT := 0;
    start_edge : R_TRIG;
    req_first : DINT;
    req_second : DINT;
    req_depth : DINT;
    req_reach : DINT;
    arr_a : BOOL;
    arr_b : BOOL;
    arr_c : BOOL;
END_VAR

start_edge(CLK := X0);

arr_a := (ABS(D10 - D20) <= 20) AND (ABS(D11) <= 100);
arr_b := (ABS(D12 - D24) <= 20) AND (ABS(D13) <= 100);
arr_c := (ABS(D14 - D28) <= 20) AND (ABS(D15) <= 100);

CASE step OF
    0:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;
        D20 := 0; D24 := 0; D28 := 0;
        D21 := 0; D25 := 0; D29 := 0;
        IF start_edge.Q THEN
            req_first := D101;
            req_second := D102;
            req_depth := D103;
            req_reach := D104;
            step := 1;
        END_IF;
        
    1:
        D24 := 10000; D25 := 1000; Y21 := TRUE;
        Y20 := FALSE; Y22 := FALSE;
        IF arr_b THEN step := 2; END_IF;
        
    2:
        D20 := req_first; D28 := 0;
        D21 := 1000; D29 := 1000;
        Y20 := TRUE; Y22 := TRUE;
        IF arr_a AND arr_c THEN step := 3; END_IF;
        
    3:
        D24 := 0; D25 := 1000; Y21 := TRUE;
        IF arr_b THEN step := 4; END_IF;
        
    4:
        step := 5;
        
    5:
        D24 := 10000; D25 := 1000; Y21 := TRUE;
        IF arr_b THEN step := 6; END_IF;
        
    6:
        D20 := req_second; D28 := req_reach;
        D21 := 1000; D29 := 1000;
        Y20 := TRUE; Y22 := TRUE;
        IF arr_a AND arr_c THEN step := 7; END_IF;
        
    7:
        D24 := req_depth; D25 := 1000; Y21 := TRUE;
        IF arr_b THEN step := 8; END_IF;
        
    8:
        step := 9;
        
    9:
        D24 := 10000; D25 := 1000; Y21 := TRUE;
        IF arr_b THEN step := 10; END_IF;
        
    10:
        D20 := 0; D28 := 0;
        D21 := 1000; D29 := 1000;
        Y20 := TRUE; Y22 := TRUE;
        IF arr_a AND arr_c THEN step := 11; END_IF;
        
    11:
        D24 := 0; D25 := 1000; Y21 := TRUE;
        IF arr_b THEN step := 12; END_IF;
        
    12:
        Y2 := TRUE;
        step := 13;
        
    13:
        Y2 := TRUE;
END_CASE;

END_PROGRAM