```iec
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
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    running : BOOL := FALSE;
    a_accepted_latch : BOOL := FALSE;
    b_accepted_latch : BOOL := FALSE;

    pallet_a_done : BOOL := FALSE;
    pallet_b_done : BOOL := FALSE;
    bundle_a_done : BOOL := FALSE;
    bundle_b_done : BOOL := FALSE;

    a_count_internal : INT := 0;
    b_count_internal : INT := 0;

    fork_step : INT := 0;
    pallet_target : INT := 0;
    bundle_target : INT := 0;

    head_step : INT := 0;
    head_target_station : INT := 0;
    head_target_kind : INT := 0;
    head_picked_busy : BOOL := FALSE;
    head_placed_busy : BOOL := FALSE;

    a_pattern : ARRAY[0..2] OF INT := [1, 2, 1];
    b_pattern : ARRAY[0..3] OF INT := [2, 1, 2, 1];

    req_kind_a : INT := 0;
    req_kind_b : INT := 0;
    a_can_receive : BOOL := FALSE;
    b_can_receive : BOOL := FALSE;

    completion_active : BOOL := FALSE;
END_VAR

IF X0 THEN
    running := TRUE;
END_IF;

IF NOT running THEN
    D203 := 850;
    D204 := 850;
    RETURN;
END_IF;

// Default level commands for reusable station supports
Y14 := TRUE;
Y15 := TRUE;

// Reset one-scan command pulses
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

// Order acceptance
IF X1B AND (NOT X1D) AND (NOT a_accepted_latch) THEN
    Y10 := TRUE;
    a_accepted_latch := TRUE;
END_IF;
IF X1D THEN
    a_accepted_latch := TRUE;
END_IF;

IF X1C AND (NOT X1E) AND (NOT b_accepted_latch) THEN
    Y11 := TRUE;
    b_accepted_latch := TRUE;
END_IF;
IF X1E THEN
    b_accepted_latch := TRUE;
END_IF;

// Shared Fork State Machine
CASE fork_step OF
    0: // Idle
        IF (NOT X14) AND X18 AND (NOT X12) AND (head_step = 0) THEN
            IF (NOT pallet_a_done) AND (NOT X28) AND X27 THEN
                pallet_target := 1;
                Y1C := TRUE;
                fork_step := 11;
            ELSIF (NOT pallet_b_done) AND (NOT X29) AND X27 THEN
                pallet_target := 2;
                Y1C := TRUE