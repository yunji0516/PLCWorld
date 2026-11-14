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
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    // Internal variables
    total_occupied : INT;
    batch_a_pending : BOOL := FALSE;
    batch_b_pending : BOOL := FALSE;
    a_tray_ready : BOOL := FALSE;
    b_tray_ready : BOOL := FALSE;
    time_bin_ready : TIME := T#0s;
    edge_start_a : R_TRIG;
    edge_start_b : R_TRIG;
    edge_eject_a : R_TRIG;
    edge_eject_b : R_TRIG;
    edge_swap : R_TRIG;
    edge_take_bin : R_TRIG;
    complete_maintained : INT := 0;
END_VAR

// Calculate total occupancy
total_occupied := D0 + D1;

// Rising edge detection
edge_start_a(CLK := X0 AND (X16 OR NOT batch_a_pending));
edge_start_b(CLK := X0 AND (X1C OR NOT batch_b_pending));
edge_eject_a(CLK := a_tray_ready AND X1B);
edge_eject_b(CLK := b_tray_ready AND X21);
edge_swap(CLK := NOT X11 AND X10 AND spare_ready AND (D1 = 0) AND bin_ready);
edge_take_bin(CLK := X10 AND NOT X14 AND return_ready AND bin_ready);

// Process A batch
IF edge_start_a.Q THEN
    IF NOT X17 AND NOT X19 AND (total_occupied + 3 <= 6) THEN
        Y13 := TRUE; // Feed A
    ELSE
        Y13 := FALSE;
    END_IF
    IF X18 AND NOT X19 AND bin_ready THEN
        Y14 := TRUE; // Start A
        batch_a_pending := TRUE;
    ELSE
        Y14 := FALSE;
    END_IF
END_IF

// Process B batch
IF edge_start_b.Q THEN
    IF NOT X1D AND NOT X1F AND (total_occupied + 2 <= 6) THEN
        Y16 := TRUE; // Feed B
    ELSE
        Y16 := FALSE;
    END_IF
    IF X1E AND NOT X1F AND bin_ready THEN
        Y17 := TRUE; // Start B
        batch_b_pending := TRUE;
    ELSE
        Y17 := FALSE;
    END_IF
END_IF

// Ejection of trays
IF edge_eject_a.Q THEN
    Y15 := TRUE;
    batch_a_pending := FALSE;
ELSE
    Y15 := FALSE;
END_IF

IF edge_eject_b.Q THEN
    Y18 := TRUE;
    batch_b_pending := FALSE;
ELSE
    Y18 := FALSE;
END_IF

// Bin swap logic
IF edge_swap.Q THEN
    Y10 := TRUE;
    time_bin_ready := TIME(); // Begin bin ready timer
ELSE
    IF (TIME() - time_bin_ready < T#3s) THEN
        Y10 := TRUE;
    ELSE
        Y10 := FALSE;
    END_IF
END_IF

// Bin take logic
IF edge_take_bin.Q THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF

// Maintain completion
IF (D4 = 8) AND (D1 = 0) AND (bin_ready OR NOT X10) THEN
    complete_maintained := complete_maintained + 1;
    IF complete_maintained >= 50 THEN // Maintain for 500 ms (0.5 s at 10 ms scan period)
        Y12 := TRUE; // Set complete
    END_IF
ELSE
    complete_maintained := 0;
    Y12 := FALSE;
END_IF

END_PROGRAM