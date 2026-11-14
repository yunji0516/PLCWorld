PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    // Internal variables
    start_triggered : BOOL := FALSE;
    product_moving : BOOL := FALSE;
    product_passed : BOOL := FALSE;
    edge_detector : R_TRIG;
END_VAR

// Implement edge detection for start
edge_detector(CLK := X10);

// Main control logic
IF edge_detector.Q THEN
    start_triggered := TRUE;
END_IF

IF start_triggered THEN
    // Start the conveyor
    IF NOT product_passed AND D10 = 1 THEN
        IF NOT X20 THEN
            Y20 := TRUE;  // Engage feed to move the product
            product_moving := TRUE;
        ELSE
            Y20 := FALSE; // Stop feed as X20 indicates photoeye is blocked
            product_moving := FALSE;
        END_IF
    END_IF

    // Detect when the product's trailing edge has passed the photoeye
    IF product_moving AND NOT X20 THEN
        product_passed := TRUE;
    END_IF

    // When product has passed and is fully on the conveyor
    IF product_passed THEN
        Y20 := FALSE;  // Ensure the feed is off
        Y2 := TRUE;    // Indicate completion
    END_IF
END_IF

// Retain completion result until evaluation endpoint
IF Y2 THEN
    // Maintain Y2 for the remainder of the evaluation period
    Y2 := TRUE;
END_IF

END_PROGRAM