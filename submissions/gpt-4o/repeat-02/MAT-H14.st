```iecst
PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    // Internal variables
    previous_pre_seq : INT;
    previous_post_seq : INT;
    tare_mass : INT;
    finished_mass : INT;
    measuring_pre : BOOL := FALSE;
    measuring_post : BOOL := FALSE;
    dispatch_pending : BOOL := FALSE;
    update_seq_pre : BOOL := FALSE;
    update_seq_post : BOOL := FALSE;
END_VAR

// Initialization on first scan
IF X0 AND NOT X12 THEN
    Y10 := TRUE; // Enable feed when source_ready is true and pre_busy is false
END_IF

// Handle the pre scale measurement
IF X11 AND NOT X12 AND NOT measuring_pre THEN
    // Lift pre scale to take measurement
    Y17 := TRUE;
    IF X1E THEN
        // Start measuring once pre_supported
        Y11 := TRUE;
        update_seq_pre := TRUE;
    END_IF
END_IF

IF Y11 AND NOT X12 THEN
    measuring_pre := TRUE;
END_IF

IF measuring_pre AND (X15 AND (D4 <> previous_pre_seq)) THEN
    previous_pre_seq := D4;
    tare_mass := D2;
    measuring_pre := FALSE;
    Y17 := FALSE; // Lower pre scale back
    Y11 := FALSE; // Stop measure_pre
    Y17 := FALSE; // Lower pre scale back
    IF X1F THEN
        Y17 := FALSE;
    END_IF
END_IF

// Transfer tray to lane
IF X11 AND NOT Y12 AND X17 AND X17 THEN
    Y12 := TRUE;
    D200 := 1; // Assuming lane 1 is free, set in_lane to 1
END_IF

IF Y12 AND D200 = 1 THEN
    Y12 := FALSE;
    D200 := 0;
END_IF

// Handle the post scale measurement
IF Y13 THEN
    // Lift post scale to take measurement
    Y18 := TRUE;
    IF X20 THEN
        // Start measuring once post_supported
        Y14 := TRUE;
        update_seq_post := TRUE;
    END_IF
END_IF

IF (Y14 AND NOT X14 AND X13) THEN
    measuring_post := TRUE;
END_IF

IF measuring_post AND (X16 AND (D5 <> previous_post_seq)) THEN
    previous_post_seq := D5;
    finished_mass := D3;
    measuring_post := FALSE;
    Y13 := FALSE; // Lower post scale back
    Y14 := FALSE; // Stop measure_post
    Y18 := FALSE; 
END_IF

// Determine routing based on mass difference
IF NOT dispatch_pending AND (finished_mass - tare_mass >= 95) AND (finished_mass - tare_mass <= 105) THEN
    D204 := 1; // route=1 acceptance
    Y15 := TRUE;
    dispatch_pending := TRUE;
ELSIF NOT dispatch_pending THEN
    D204 := 2; // route=2 hold
    Y15 := TRUE;
    dispatch_pending := TRUE;
END_IF

// Dispatch trays
IF dispatch_pending AND (X1B OR (D204 = 2 AND X1C)) THEN
    Y15 := FALSE;
    dispatch_pending := FALSE;
END_IF

// Completion condition for the process
IF X1D AND NOT X11 AND NOT X13 THEN
    Y16 := TRUE; // Process is complete
END_IF

END_PROGRAM
```