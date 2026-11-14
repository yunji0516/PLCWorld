PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    // Internal variables
    stage : INT := 0;
    timer : TON;
    completionTimer : TON;
    headPositionClear : BOOL := FALSE;
    bothAxesReturned : BOOL := FALSE;
    requestHandled : BOOL := FALSE;
    
END_VAR

// Head approach and feeder retreat control logic
IF X0 AND NOT requestHandled THEN
    CASE stage OF
        0:  // Initialize
            D20 := 0;
            D21 := 1000; // Full speed retreat for A
            Y20 := TRUE; // Enable A
            D24 := 9000; // B target 90 degrees
            D25 := 1000; // Full speed
            Y21 := TRUE; // Enable B
            D28 := D101; // C target position specified in request_target
            D29 := 1000; // Full speed
            Y22 := TRUE; // Enable C
            D32 := 0;
            D33 := 1000; // Full speed
            Y23 := TRUE; // Enable D
            stage := 1;
        
        1:  // Monitor destination approach
            IF D10 = 0 AND ABS(D11) <= 100 AND 
               D12 = 9000 AND ABS(D13) <= 100 AND
               D14 = D101 AND ABS(D15) <= 100 AND
               D16 = 0 AND ABS(D17) <= 100 THEN
                headPositionClear := TRUE;
            END_IF
            
            IF headPositionClear THEN
                // Initiate return sequence
                D24 := 0;    // B zero degrees
                D28 := 0;    // C retract
                Y22 := TRUE;
                Y21 := TRUE;
                D32 := 10000; // D position to 100
                Y23 := TRUE;
                stage := 2;
            END_IF
        
        2:  // Monitor return sequence
            IF D12 = 0 AND ABS(D13) <= 100 AND
               D14 = 0 AND ABS(D15) <= 100 AND
               D16 = 10000 AND ABS(D17) <= 100 THEN
                    bothAxesReturned := TRUE;
            END_IF
        
            IF bothAxesReturned THEN
                D20 := 28000; // Feeder A to 280mm
                Y20 := TRUE;
                
                timer(IN := TRUE, PT := T#100ms);
                IF timer.Q THEN
                    Y2 := TRUE;
                    completionTimer(IN := TRUE, PT := T#100ms);
                    IF completionTimer.Q THEN
                        Y2 := FALSE;
                        requestHandled := TRUE;
                        stage := 0; // Reset for future starts
                    END_IF
                END_IF
            END_IF
    END_CASE
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    stage := 0;
    requestHandled := FALSE;
    timer(IN := FALSE);
    completionTimer(IN := FALSE);
END_IF

END_PROGRAM