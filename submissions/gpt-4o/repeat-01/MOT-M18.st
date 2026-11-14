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
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    // Internal variables
    edge_detected : BOOL := FALSE;
    position_latched : DINT;
    task_started : BOOL := FALSE;
    tool_retracted : BOOL := FALSE;
    raised_and_detected : BOOL := FALSE;
    within_10mm : BOOL := FALSE;
    step : INT := 0;
    enable_time : TIME := T#0ms;
    completion_time : TIME := T#0ms;
    configured : BOOL := FALSE;
    
    edge_trigger : R_TRIG;
    timer : TON;
END_VAR

// Implement the control logic here.
edge_trigger(CLK := X34);
within_10mm := (ABS(D10 - D90) <= 1000); // Check if within 10mm stop

// State machine
CASE step OF
    0: // Initial State
        IF X0 THEN
            task_started := TRUE;
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            D21 := 0;
            D25 := 0;
            D29 := 0;
            step := 10;
        END_IF
        
    10: // Retract tool and raise C
        IF task_started THEN
            D24 := 0; // Retract B to 0
            D25 := 1000; // Set B max rate
            Y21 := TRUE;
            
            D28 := 10000; // Raise C to 100
            D29 := 1000; // Set C max rate
            Y22 := TRUE;
            
            IF D12 = 0 AND D14 >= 10000 THEN
                tool_retracted := TRUE;
                step := 20;
            END_IF
        END_IF
    
    20: // Detect edge and latch position
        IF tool_retracted THEN
            IF edge_trigger.Q THEN
                edge_detected := TRUE;
                position_latched := D10; // Latch A position
                Y20 := TRUE; // Enable A move
                step := 30;
            END_IF
        END_IF
    
    30: // Stop within 10mm and configure
        IF edge_detected THEN
            D20 := position_latched + DINT(D101*100); // Set new A target
            D21 := 1000; // Set A max rate
            
            IF within_10mm THEN
                IF NOT configured THEN
                    Y30 := TRUE;
                    configured := TRUE;
                    enable_time := TIME();
                END_IF
            END_IF
        END_IF
        
    40: // Completion logic
        IF configured THEN
            timer(IN := TRUE, PT := T#100ms);
            IF timer.Q THEN
                Y2 := TRUE;
                completion_time := TIME();
                step := 50;
            END_IF
        END_IF
    
    50: // Maintain completion signal for 100ms
        IF (TIME() - completion_time) >= T#100ms THEN
            Y2 := FALSE;
            // Reset for next cycle
            step := 0;
            task_started := FALSE;
            tool_retracted := FALSE;
            edge_detected := FALSE;
            configured := FALSE;
        END_IF
END_CASE

END_PROGRAM