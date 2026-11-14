```pascal
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
    // Internal state variables
    current_state : INT := 0;
    sensor_edge_detected : BOOL := FALSE;
    initial_sensor_pos : DINT := 0;
    within_stop_limit : BOOL := FALSE;
    edge_position : DINT := 0;
    latch_done : BOOL := FALSE;
    start_time : TIME;
    valid_time : BOOL := FALSE;
    Y2_start_time : TIME := T#0ms;
    Y2_held : BOOL := FALSE;
    Y2_hold_duration : TIME := T#100ms;
END_VAR

// Main program logic
IF X0 THEN

    CASE current_state OF
        0: // Initial state, retract tool and raise
            IF NOT Y20 AND NOT Y21 AND NOT Y22 THEN
                D24 := 0; D25 := 700; Y21 := TRUE; // Retract B position to 0
                D28 := 10000; D29 := 700; Y22 := TRUE; // Raise C position to 100
                current_state := 1;
            END_IF
        
        1: // Wait until retraction and raise are complete
            IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 AND 
               ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
                // Positions reached
                Y21 := FALSE; Y22 := FALSE; // Disable B and C
                current_state := 2;
            END_IF
        
        2: // Detect sensor edge
            if NOT sensor_edge_detected AND X34 THEN
                sensor_edge_detected := TRUE;
                edge_position := D10; 
                current_state := 3;
                Y2_start_time := TIME(); // Record the time
            END_IF

        3: // Check for stop within 10mm
            IF sensor_edge_detected AND (D10 - edge_position) <= 1000 THEN
                within_stop_limit := TRUE;
                // Ensure the motion is stopped or within limit speed
                IF ABS(D11) <= 100 THEN
                    latch_done := TRUE;
                    Y30 := TRUE; // Signal configuration complete
                    current_state := 4;
                END_IF
            END_IF
        
        4: // Latch stopped state coordinates to origin
            IF latch_done THEN
                D90 := edge_position; // Register D90 with latched position
                current_state := 5;
            END_IF

        5: // Move to final park position
            IF X35 THEN
                D20 := D90 + D101; // Set target A to position
                D21 := 700; Y20 := TRUE; // Enable A axis
                current_state := 6;
            END_IF

        6: // Check if move completes, within scan deadline
            IF ABS(D10 - (D90 + D101)) <= 20 AND ABS(D11) <= 100 THEN
                IF NOT valid_time THEN
                    start_time := TIME(); 
                    valid_time := TRUE;
                END_IF

                IF (TIME() - start_time) >= T#14s THEN
                    Y2 := TRUE;  // Completion success signal
                    Y2_start_time := TIME(); // Mark start time
                END_IF
            END_IF           
    END_CASE

    // Handle Y2 hold duration
    IF Y2 THEN
        IF (TIME() - Y2_start_time) >= Y2_hold_duration THEN
            Y2_held := TRUE;
        END_IF
    END_IF

    // Correctly end the cycle
    IF Y2_held THEN
        // Reset outputs after Y2 has been valid for the necessary time
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
    END_IF

ELSE
    // Reset all states if start is not requested
    current_state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y2 := FALSE;
    sensor_edge_detected := FALSE;
    within_stop_limit := FALSE;
    latch_done := FALSE;
    Y2_held := FALSE;
    valid_time := FALSE;
END_IF

END_PROGRAM
```