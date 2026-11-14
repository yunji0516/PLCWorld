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
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    // Internal variables
    accept_edge_a : R_TRIG;
    accept_edge_b : R_TRIG;
    start_piece_edge : R_TRIG;
    feed_rate : INT := 100; // Default feed rate within 80–120 mm/s
    pull_rate : INT := 120; // Default pull rate within 100–160 mm/s
    storage_limit_min : INT := 400; 
    storage_limit_max : INT := 1600;
    batch_counter : INT := 0;
    slice_counter : INT := 0;
    total_waste : INT := 0;
    system_complete : BOOL := FALSE;
    complete_timer : TON;
END_VAR

(* Initialization *)
accept_edge_a(CLK := X13);
accept_edge_b(CLK := X14);
start_piece_edge(CLK := X0);

(* Control logic *)
IF accept_edge_a.Q THEN
    Y12 := TRUE; // Accept batch A
ELSIF accept_edge_b.Q THEN
    Y13 := TRUE; // Accept batch B
END_IF

IF X10 THEN
    Y10 := TRUE; // Set accept_batch if batch_ready
ELSE
    Y10 := FALSE;
END_IF

IF X12 THEN
    Y11 := TRUE; // Acknowledge batch done
    batch_counter := batch_counter + 1;
    IF batch_counter = 5 THEN
        Y1B := TRUE; // Mark complete if all batches processed
        system_complete := TRUE;
    END_IF
ELSE
    Y11 := FALSE;
END_IF

IF start_piece_edge.Q AND X28 THEN
    Y14 := TRUE; // Start a piece if path is clear
    D200 := (slice_counter MOD 2) + 1; // Alternate side
    slice_counter := slice_counter + 1;
END_IF

IF X27 AND NOT system_complete THEN
    // Handle splice needed
    IF NOT X26 THEN
        Y21 := TRUE; // Lower splice press plate
    ELSE
        Y21 := FALSE;
        IF X26 AND X20 AND X21 THEN
            Y22 := TRUE; // Start waste if joined and spare is ready
        END_IF
    END_IF
END_IF

IF X19 AND X1B AND ABS(D8 - D7) <= 2 THEN
    Y18 := TRUE; // Perform cut
END_IF

IF (D1 > D10) THEN
    Y22 := TRUE; // Start waste piece
    total_waste := total_waste + D11;
ELSE
    Y22 := FALSE;
END_IF

IF X1C THEN
    Y1A := TRUE; // Acknowledge exit clear
ELSE
    Y1A := FALSE;
END_IF

complete_timer(IN := system_complete, PT := T#0.5s);

IF complete_timer.Q THEN
    Y1B := TRUE; // Maintain complete signal for at least 0.5s
ELSE
    Y1B := FALSE;
END_IF

END_PROGRAM