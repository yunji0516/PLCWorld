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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
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
    D12 : INT;
    D13 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    run : BOOL := FALSE;
    complete_latched : BOOL := FALSE;

    a_state : INT := 0;
    b_state : INT := 0;

    a_feed_count : INT := 0;
    b_feed_count : INT := 0;
    a_filled_count : INT := 0;
    b_filled_count : INT := 0;

    a_pumping : BOOL := FALSE;
    b_pumping : BOOL := FALSE;

    a_valve_timer : TON;
    b_valve_timer : TON;
    a_drain_timer : TON;
    b_drain_timer : TON;

    refill_active : BOOL := FALSE;
    swap_pulse : BOOL := FALSE;
    swap_in_progress : BOOL := FALSE;

    a_cap_requested : BOOL := FALSE;
    b_cap_requested : BOOL := FALSE;
    cap_a_pulse : BOOL := FALSE;
    cap_b_pulse : BOOL := FALSE;
END_VAR

IF X0 THEN
    run := TRUE;
END_IF;

IF NOT run THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
ELSE
    // --------------------------------------------------------
    // Common Tank Replenishment and Batch Swap Control
    // --------------------------------------------------------
    IF (a_filled_count >= 3 AND b_filled_count >= 3) OR X32 OR (D3 >= 6) THEN
        refill_active := FALSE;
    ELSIF X2F AND (D1 > 0) AND (D0 <= 1450) THEN
        refill_active := TRUE;
    ELSIF (D0 >= 1550) OR (NOT X2F) OR (D1 = 0) THEN
        refill_active := FALSE;
    END_IF;
    Y10 := refill_active;

    swap_pulse := FALSE;
    IF X31 AND (NOT X2F OR D1 = 0) AND (NOT refill_active) AND (NOT X30) AND (NOT swap_in_progress)
       AND NOT (a_filled_count >= 3 AND b_filled_count >= 3) AND NOT X32 AND (D3 < 6) THEN
        swap_pulse := TRUE;
        swap_in_progress := TRUE;
    END_IF;

    IF X30 THEN
        swap_in_progress := TRUE;
    ELSIF NOT X30 AND X2F AND (D1 > 0) THEN
        swap_in_progress := FALSE;
    END_IF;
    Y11 := swap_pulse;

    // ------------------------------------------------