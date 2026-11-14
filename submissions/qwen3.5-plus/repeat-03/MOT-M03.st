PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    req : BOOL;
    sync : BOOL;
    forkOk : BOOL;
    compTimer : TON;
    y2Claimed : BOOL;
    
    POS_TOL : DINT := 20;
    SPD_TOL : DINT := 100;
END_VAR

IF X10 THEN
    req := TRUE;
END_IF;

IF req THEN
    Y20 := TRUE;
    
    D20 := D13;
    D21 := D14;
    
    IF ABS(D13 - D11) <= POS_TOL AND ABS(D14 - D12) <= SPD_TOL THEN
        sync := TRUE;
    ELSE
        sync := FALSE;
    END_IF;
    
    IF sync THEN
        Y21 := TRUE;
    END_IF;
    
    IF X11 THEN
        forkOk := TRUE;
    END_IF;
    
    IF sync AND forkOk THEN
        compTimer(IN := TRUE, PT := T#100ms);
        IF compTimer.Q THEN
            y2Claimed := TRUE;
        END_IF;
    ELSE
        compTimer(IN := FALSE);
    END_IF;
    
    Y2 := y2Claimed;
END_IF;

END_PROGRAM