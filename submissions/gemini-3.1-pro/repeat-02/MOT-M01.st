PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    init_D11 : DINT;
    init_D14 : DINT;
    req_D10 : DINT;
    req_D13 : DINT;
    
    settle_up : TON;
    settle_cross : TON;
    settle_down : TON;
    
    cond_up : BOOL;
    cond_cross : BOOL;
    cond_down : BOOL;
END_VAR

IF X10 AND state = 0 THEN
    init_D11 := D11;
    init_D14 := D14;
    req_D10 := D10;
    req_D13 := D13;
    state := 1;
END_IF;

cond_up := (state = 1) AND (ABS(D16 - 40000) <= 20) AND (ABS(D17) <= 100);
cond_cross := (state = 2) AND (ABS(D11 - req_D10) <= 20) AND (ABS(D12) <= 100) AND 
              (ABS(D14 - req_D13) <= 20) AND (ABS(D15) <= 100);
cond_down := (state = 3) AND (ABS(D16) <= 20) AND (ABS(D17) <= 100) AND
             (ABS(D11 - req_D10) <= 20) AND (ABS(D12) <= 100) AND 
             (ABS(D14 - req_D13) <= 20) AND (ABS(D15) <= 100);

settle_up(IN := cond_up, PT := T#30ms);
settle_cross(IN := cond_cross, PT := T#30ms);
settle_down(IN := cond_down, PT := T#30ms);

IF state = 1 AND settle_up.Q THEN
    state := 2;
ELSIF state = 2 AND settle_cross.Q THEN
    state := 3;
ELSIF state = 3 AND settle_down.Q THEN
    state := 4;
END_IF;

IF state = 0 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y2 := FALSE;
ELSIF state = 1 THEN
    D20 := init_D11; Y20 := TRUE;
    D21 := init_D14; Y21 := TRUE;
    D22 := 40000;    Y22 := TRUE;
    Y2 := FALSE;
ELSIF state = 2 THEN
    D20 := req_D10; Y20 := TRUE;
    D21 := req_D13; Y21 := TRUE;
    D22 := 40000;   Y22 := TRUE;
    Y2 := FALSE;
ELSIF state = 3 THEN
    D20 := req_D10; Y20 := TRUE;
    D21 := req_D13; Y21 := TRUE;
    D22 := 0;       Y22 := TRUE;
    Y2 := FALSE;
ELSIF state = 4 THEN
    D20 := req_D10; Y20 := TRUE;
    D21 := req_D13; Y21 := TRUE;
    D22 := 0;       Y22 := TRUE;
    Y2 := TRUE;
END_IF;

END_PROGRAM