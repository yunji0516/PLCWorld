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
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    step : INT := 0;
    reqEdge : R_TRIG;
    combinedTimer : TON;
    Y2HoldTimer : TON;
END_VAR

reqEdge(CLK := X10);

CASE step OF
    0: // IDLE - wait for X10 request, no movement
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        D20 := D10;
        D21 := D12;
        combinedTimer(IN := FALSE);
        Y2HoldTimer(IN := FALSE);
        
        IF reqEdge.Q THEN
            step := 1;
        END_IF;
        
    1: // Retract slide to 0 mm (full retraction, safely below 500 mm limit)
        Y20 := FALSE;
        D20 := D10;
        Y21 := TRUE;
        D21 := 0;
        
        IF X11 THEN
            step := 2;
        END_IF;
        
    2: // Rotate table to requested angle D14, keep slide retracted
        Y20 := TRUE;
        D20 := D14;
        Y21 := TRUE;
        D21 := 0;
        
        IF X12 THEN
            step := 3;
        END_IF;
        
    3: // Re-approach slide to D15, table held at D14
        Y20 := TRUE;
        D20 := D14;
        Y21 := TRUE;
        D21 := D15;
        combinedTimer(IN := FALSE);
        Y2HoldTimer(IN := FALSE);
        
        IF ABS(D12 - D15) <= 20 AND ABS(D13) <= 100 THEN
            step := 4;
        END_IF;
        
    4: // Wait for combined terminal condition (table settled + slide at target) for 30 ms
        Y20 := TRUE;
        D20 := D14;
        Y21 := TRUE;
        D21 := D15;
        
        combinedTimer(IN := X12 AND ABS(D12 - D15) <= 20 AND ABS(D13) <= 100, PT := T#30ms);
        
        IF combinedTimer.Q THEN
            step := 5;
        END_IF;
        
    5: // Activate Y2 and maintain combined condition for 100 ms
        Y2 := TRUE;
        Y20 := TRUE;
        D20 := D14;
        Y21 := TRUE;
        D21 := D15;
        
        Y2HoldTimer(IN := X12 AND ABS(D12 - D15) <= 20 AND ABS(D13) <= 100, PT := T#100ms);
        
        IF Y2HoldTimer.Q THEN
            step := 6;
        END_IF;
        
    6: // COMPLETE - maintain Y2 and targets
        Y2 := TRUE;
        Y20 := TRUE;
        D20 := D14;
        Y21 := TRUE;
        D21 := D15;
END_CASE;

END_PROGRAM