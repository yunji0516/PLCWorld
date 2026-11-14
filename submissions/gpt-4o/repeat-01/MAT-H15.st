PROGRAM Main
VAR
    X0 : BOOL; // start
    X10 : BOOL; // r_ready
    X11 : BOOL; // b_ready
    X12 : BOOL; // head_busy
    X13 : BOOL; // head_held
    X14 : BOOL; // fork_busy
    X15 : BOOL; // fork_inserted
    X16 : BOOL; // fork_supporting
    X17 : BOOL; // fork_at_exit
    X18 : BOOL; // fork_home
    X19 : BOOL; // exit_received
    X20 : BOOL; // b_full
    X21 : BOOL; // a_support_home
    X22 : BOOL; // b_support_home
    X23 : BOOL; // a_support_low
    X24 : BOOL; // b_support_low
    X25 : BOOL; // a_place_clear
    X26 : BOOL; // b_place_clear
    X27 : BOOL; // pallet_available
    X28 : BOOL; // a_pallet
    X29 : BOOL; // b_pallet
    Y10 : BOOL; // accept_a
    Y11 : BOOL; // accept_b
    Y12 : BOOL; // pick
    Y13 : BOOL; // place
    Y14 : BOOL; // support_a
    Y15 : BOOL; // support_b
    Y16 : BOOL; // fork_insert
    Y17 : BOOL; // fork_lift
    Y18 : BOOL; // fork_transfer
    Y19 : BOOL; // fork_release
    D0 : INT; // r_id
    D1 : INT; // b_id
    D2 : INT; // r_thickness
    D3 : INT; // b_thickness
    D4 : INT; // held_id
    D5 : INT; // held_kind
    D6 : INT; // held_thickness
    D7 : INT; // a_next
    D8 : INT; // b_next
    D9 : INT; // a_top
    D10 : INT; // b_top
    D11 : INT; // a_count
    D12 : INT; // b_count
    D13 : INT; // fork_side
    D14 : INT; // received
    D15 : INT; // pallet_received
    D200 : INT; // kind
    D201 : INT; // side
    D202 : INT; // place_mm
    D203 : INT; // support_a_mm
    D204 : INT; // support_b_mm
    X1A : BOOL; // all_done
    X1B : BOOL; // a_available
    X1C : BOOL; // b_available
    X1D : BOOL; // a_active
    X1E : BOOL; // b_active
    X1F : BOOL; // a_full
    X2A : BOOL; // empty_inserted
    X2B : BOOL; // empty_supported
    X2C : BOOL; // empty_at_station
    Y1A : BOOL; // ack_exit
    Y1B : BOOL; // complete
    Y1C : BOOL; // pallet_pick
    Y1D : BOOL; // pallet_lift
    Y1E : BOOL; // pallet_transfer
    Y1F : BOOL; // pallet_release
    aOrderComplete : BOOL := FALSE;
    bOrderComplete : BOOL := FALSE;
    executingTransfer : BOOL := FALSE;
    rTrig_AcceptA : R_TRIG;
    rTrig_AcceptB : R_TRIG;
    ton_CompleteMaintain : TON;
END_VAR

// Initialize R_TRIG instances
rTrig_AcceptA(CLK := X1B AND NOT aOrderComplete);
rTrig_AcceptB(CLK := X1C AND NOT bOrderComplete);

// Handle order acceptance
IF rTrig_AcceptA.Q THEN
    Y10 := TRUE;
    D200 := 1; // Set R kind
    aOrderComplete := TRUE;
END_IF
IF rTrig_AcceptB.Q THEN
    Y11 := TRUE;
    D200 := 2; // Set B kind
    bOrderComplete := TRUE;
END_IF

// Manage pallet supply and reception
IF X27 AND NOT Y1C THEN
    Y1C := TRUE; // pallet_pick
ELSIF Y1C AND X2A THEN
    Y1D := TRUE; // pallet_lift
    Y1C := FALSE;
ELSIF Y1D AND X2B THEN
    Y1E := TRUE; // pallet_transfer
    Y1D := FALSE;
ELSIF Y1E AND X2C THEN
    Y1F := TRUE; // pallet_release
    Y1E := FALSE;
ELSIF Y1F AND NOT fork_busy THEN
    Y1F := FALSE;
    executingTransfer := FALSE;
END_IF

// Handle support and fork operations
IF X21 AND NOT Y14 THEN
    Y14 := TRUE;
    D203 := 830; // Lower support a
ELSIF X23 AND Y14 THEN
    Y14 := FALSE; // Support level reached
END_IF

IF X22 AND NOT Y15 THEN
    Y15 := TRUE;
    D204 := 830; // Lower support b
ELSIF X24 AND Y15 THEN
    Y15 := FALSE; // Support level reached
END_IF

// Fork operations
IF X15 AND NOT executingTransfer THEN
    Y16 := TRUE; // fork_insert
    executingTransfer := TRUE;
ELSIF Y16 AND X16 THEN
    Y17 := TRUE; // fork_lift to 870 mm
    Y16 := FALSE;
END_IF

// Transfer completion
IF X17 AND X19 THEN
    Y1A := TRUE; // Acknowledge exit
    Y19 := TRUE; // fork_release
    Y17 := FALSE;
END_IF

// Completion determination
IF aOrderComplete AND bOrderComplete AND NOT Y18 THEN
    Y18 := TRUE;
    // Start maintaining complete
    ton_CompleteMaintain(IN := TRUE, PT := T#500ms);
ELSIF ton_CompleteMaintain.Q THEN
    Y1B := TRUE; // complete
    IF X12 THEN // Ensure head is idle
        aOrderComplete := FALSE;
        bOrderComplete := FALSE;
        Y1B := FALSE;
    END_IF
END_IF

END_PROGRAM