PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;
    
    reqEdge : R_TRIG;
    
    state : INT := 0;
    targetA : DINT;
    targetB : DINT;
    targetC : DINT;
    
    Kp : DINT := 100;
    Kd : DINT := 20;
    Ksway : DINT := 200;
    KswaySpd : DINT := 100;
    
    settleCount : INT := 0;
    holdCount : INT := 0;
END_VAR

reqEdge(CLK := X10);

CASE state OF
    0:
        D20 := 140000;
        D21 := 0;
        Y20 := FALSE;
        Y2 := FALSE;
        
        IF reqEdge.Q THEN
            state := 1;
            targetA := D10;
            targetB := D17;
            targetC := D18;
        END_IF;
        
    1:
        D20 := targetA;
        D21 := 0;
        Y20 := TRUE;
        Y2 := FALSE;
        
        state := 2;
        
    2:
        D20 := targetA;
        Y20 := TRUE;
        Y2 := FALSE;
        
        D21 := (targetB - D13) * Kp + (0 - D14) * Kd + (-D15) * Ksway + (-D16) * KswaySpd;
        
        IF D21 > 400000 THEN D21 := 400000;
        ELSIF D21 < -400000 THEN D21 := -400000;
        END_IF;
        
        IF ABS(D13 - targetB) < 200 AND ABS(D14) < 200 AND ABS(D15) < 40 AND ABS(D11 - targetA) < 300 AND ABS(D12) < 300 THEN
            state := 3;
            settleCount := 0;
            holdCount := 0;
        END_IF;
        
    3:
        D20 := targetA;
        Y20 := TRUE;
        
        D21 := (targetB - D13) * Kp + (0 - D14) * Kd + (-D15) * Ksway + (-D16) * KswaySpd;
        
        IF D21 > 400000 THEN D21 := 400000;
        ELSIF D21 < -400000 THEN D21 := -400000;
        END_IF;
        
        IF ABS(D11 - targetA) <= 100 AND ABS(D13 - targetB) <= 100 AND ABS(D15 - targetC) <= 20 AND ABS(D12) <= 100 AND ABS(D14) <= 100 AND ABS(D16) <= 100 THEN
            settleCount := settleCount + 1;
        ELSE
            settleCount := 0;
        END_IF;
        
        IF settleCount >= 3 THEN
            Y2 := TRUE;
            holdCount := holdCount + 1;
        ELSE
            Y2 := FALSE;
            holdCount := 0;
        END_IF;
        
        IF holdCount >= 10 THEN
            state := 4;
        END_IF;
        
    4:
        D20 := targetA;
        D21 := 0;
        Y20 := TRUE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM