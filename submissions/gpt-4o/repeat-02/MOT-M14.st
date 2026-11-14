PROGRAM Main
VAR
    X10 : BOOL; // Single position change and re-approach request
    D10 : DINT; // Table actual angle ×0.01 deg
    D11 : DINT; // Table actual speed ×0.01 deg/s
    D12 : DINT; // Slide actual entry amount ×0.01 mm
    D13 : DINT; // Slide actual speed ×0.01 mm/s
    D14 : DINT; // Requested table angle ×0.01 deg
    D15 : DINT; // Requested re-approach entry amount ×0.01 mm
    D16 : DINT; // Maximum allowable entry amount for rotation ×0.01 mm
    X11 : BOOL; // Actual slide retraction confirm signal
    X12 : BOOL; // Table requested angle maintain signal
    D20 : DINT; // Table target angle ×0.01 deg
    D21 : DINT; // Slide target entry amount ×0.01 mm
    Y20 : BOOL; // Table position drive active
    Y21 : BOOL; // Slide position drive active
    Y2 : BOOL; // Maintain work completion

    // Internal variables
    request_processed : BOOL := FALSE;
    slide_retracted : BOOL := FALSE;
    table_positioned : BOOL := FALSE;
    completion_held : BOOL := FALSE;
    rotate_start_time : TIME := T#0s;
    retraction_target : DINT;
    reapproach_target : DINT;
    table_settled : BOOL := FALSE;

    table_settled_for : TIME := T#0s;
    slide_settled_for : TIME := T#0s;

    completion_start_time : TIME := T#0s;
    current_time : TIME;
END_VAR

// Control logic implementation
IF NOT request_processed AND X10 THEN
    // Initial request processing
    request_processed := TRUE;
    retraction_target := MIN(5000, D16); // Ensure the retraction target is within safety limits
    reapproach_target := D15;

    // Set table and slide targets
    D20 := D14;
    D21 := retraction_target;
    Y20 := TRUE;  // Activate table drive
    Y21 := TRUE;  // Activate slide drive
END_IF

// Slide retraction logic
IF request_processed AND NOT slide_retracted THEN
    IF X11 THEN // Slide is fully retracted
        slide_retracted := TRUE;
        Y21 := FALSE;  // Deactivate slide drive
    END_IF
END_IF

// Table positioning logic
IF slide_retracted AND NOT table_positioned THEN
    IF D10 = D14 AND -10 <= D11 AND D11 <= 10 THEN // Table in position
        IF table_settled THEN
            IF current_time - rotate_start_time >= T#30ms THEN
                table_positioned := TRUE;
                Y20 := FALSE;  // Deactivate table drive
            END_IF
        ELSE
            table_settled := TRUE;
            rotate_start_time := current_time;
        END_IF
    ELSE
        table_settled := FALSE;
    END_IF
END_IF

// Re-approach logic
IF table_positioned AND NOT completion_held THEN
    D21 := reapproach_target;
    Y21 := TRUE;  // Activate slide drive for re-approach

    IF X12 AND D12 = D21 AND -10 <= D13 AND D13 <= 10 THEN // Slide in position for re-approach
        IF slide_settled_for >= T#30ms THEN
            completion_held := TRUE;
            Y21 := FALSE;  // Deactivate slide drive
        ELSE
            slide_settled_for := slide_settled_for + T#10ms;
        END_IF
    ELSE
        slide_settled_for := T#0s;
    END_IF
END_IF

// Completion logic
IF completion_held THEN
    IF completion_start_time = T#0s THEN
        completion_start_time := current_time;
    ELSE
        IF current_time - completion_start_time >= T#100ms THEN
            Y2 := TRUE; // Maintain work completion
        END_IF
    END_IF
END_IF

// Update current time
current_time := current_time + T#10ms;

END_PROGRAM