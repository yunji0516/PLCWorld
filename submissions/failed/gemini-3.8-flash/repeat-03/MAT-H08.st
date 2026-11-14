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

    pitch_state : INT := 0;
    pitch_count : INT := 0;
    feed_target_mm : INT := 0;
    transfer_busy_seen : BOOL := FALSE;

    roll_state : INT := 0;
    roll_done_count : INT := 0;
    roll_exchange_active : BOOL := FALSE;

    batch_count : INT := 0;
    accept_rec_pulse : BOOL := FALSE;
    rec_active_latched : BOOL := FALSE;

    complete_latched : BOOL := FALSE;
    completion_timer : TON;
    finish_wait_timer : TON;
END_VAR

// -----------------------------------------------------------------------------
// 1. PRODUCT EXIT HANDSHAKE (Immediate 4-way handshake)
// -----------------------------------------------------------------------------
IF X1A THEN
    Y1A := TRUE;
ELSE
    Y1A := FALSE;
END_IF;

// -----------------------------------------------------------------------------
// 2. RECOVERY BATCH HANDSHAKE & MOTION
// -----------------------------------------------------------------------------
// Batch acceptance rising edge
IF X1B AND (NOT rec_active_latched) AND (NOT X1D) AND (batch_count < 4) THEN
    accept_rec_pulse := TRUE;
ELSE
    accept_rec_pulse := FALSE;
END_IF;
Y17 := accept_rec_pulse;

IF X1C THEN
    rec_active_latched := TRUE;
END_IF;

// Batch acknowledgement
IF X1D THEN
    Y19 := TRUE;
    IF rec_active_latched THEN
        batch_count := batch_count + 1;
        rec_active_latched := FALSE;
    END_IF;
ELSE
    Y19 := FALSE;
END_IF;

// Roll exchange active status
roll_exchange_active := (roll_state <> 0);

// Recovery motion drive (Y18)
IF (rec_active_latched OR X1C) AND (NOT roll_exchange_active) AND (NOT X21) AND (batch_count < 4) THEN
    IF X1E THEN
        // Pass path drain allowed to the actual end
        Y18 := TRUE;
    ELSIF D3 > 0 THEN
        // Advance within storage capacity
        Y18 := TRUE;
    ELSE
        Y18 := FALSE;
    END_IF;
ELSE
    Y18 := FALSE;
END_IF;

// -----------------------------------------------------------------------------
// 3. WASTE REEL EXCHANGE (Triggered by waste_full X21)
// -----------------------------------------------------------------------------
CASE roll_state OF
    0: // IDLE
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF X21 AND (roll_done_count = 0) THEN
            roll_state := 1;
        END_IF;

    1: // Clamp residue side bands
        Y1C := TRUE; // edge_hold level
        IF X22 THEN  // edges_held response
            roll_state := 2;
        END_IF;

    2: // Cut both residue connections
        Y1C := TRUE;
        Y1D := TRUE; // cut_left rising edge
        Y1E := TRUE; // cut_right rising edge
        IF X23 THEN  // edges_cut confirmed
            Y1D := FALSE;
            Y1E := FALSE;
            roll_state := 3;
        END_IF;

    3: // Unload full reel
        Y1C := TRUE;
        Y1F := TRUE; // unload_reel rising