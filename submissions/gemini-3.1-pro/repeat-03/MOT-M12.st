PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y24 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y25 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    c_arrived_0 : BOOL;
    c_arrived_50 : BOOL;
    d_arrived_0 : BOOL;
    d_arrived_100 : BOOL;
END_VAR

c_arrived_0 := (ABS(D10) <= 20) AND (ABS(D11) <= 100);
c_arrived_50 := (ABS(D10 - 5000) <= 20) AND (ABS(D11) <= 100);
d_arrived_0 := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
d_arrived_100 := (ABS(D12 - 10000) <= 20) AND (ABS(D13) <= 100);

D21 := 200;
D25 := 200;

CASE state OF
    0:
        Y20 := FALSE; Y21 := TRUE;
        Y22 := FALSE; Y23 := TRUE;
        Y24 := TRUE; D20 := 0;
        Y25 := TRUE; D24 := 0;
        IF X0 THEN
            state := 1;
        END_IF;
    
    1:
        Y20 := TRUE; Y21 := FALSE;
        Y22 := TRUE; Y23 := FALSE;
        Y24 := TRUE; D20 := 0;
        Y25 := TRUE; D24 := 0;
        
        IF X2 AND X4 AND c_arrived_0 AND d_arrived_0 THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE; Y21 := FALSE;
        Y22 := FALSE; Y23 := TRUE;
        Y24 := TRUE; D20 := 0;
        Y25 := TRUE; D24 := 10000;
        
        IF X2 AND X3 AND X5 AND d_arrived_100 AND c_arrived_0 THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE; Y21 := FALSE;
        Y22 := FALSE; Y23 := TRUE;
        Y24 := TRUE; D20 := 5000;
        Y25 := TRUE; D24 := 10000;
        
        IF X2 AND X3 AND X5 AND d_arrived_100 AND c_arrived_50 THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE; Y21 := FALSE;
        Y22 := FALSE; Y23 := TRUE;
        Y24 := TRUE; D20 := 0;
        Y25 := TRUE; D24 := 10000;
        
        IF c_arrived_0 THEN
            state := 5;
        END_IF;
        
    5:
        Y20 := FALSE; Y21 := TRUE;
        Y22 := FALSE; Y23 := TRUE;
        Y24 := TRUE; D20 := 0;
        Y25 := TRUE; D24 := 0;
        
        IF X1 AND X3 AND c_arrived_0 AND d_arrived_0 THEN
            state := 6;
        END_IF;
        
    6:
        Y20 := FALSE; Y21 := TRUE;
        Y22 := FALSE; Y23 := TRUE;
        Y24 := TRUE; D20 := 0;
        Y25 := TRUE; D24 := 0;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM