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

    state_a : INT := 0;
    state_b : INT := 0;
    
    a_feed_latched : BOOL := FALSE;
    b_feed_latched : BOOL := FALSE;
    
    a_out_started : BOOL := FALSE;
    b_out_started : BOOL := FALSE;
    
    cap_wait_a : BOOL := FALSE;
    cap_wait_b : BOOL := FALSE;
    cap_cmd_active : BOOL := FALSE;
    
    a_release_active : BOOL := FALSE;
    b_release_active : BOOL := FALSE;
    
    pump_a_allowed : BOOL := FALSE;
    pump_b_allowed : BOOL := FALSE;
    
    swap_started : BOOL := FALSE;
    y10_was_false : BOOL := TRUE;
    
    is_done : BOOL := FALSE;
    all_stopped : BOOL := FALSE;
END_VAR

// 1. Completion Check
is_done := (D3 = 6) OR X32;

// 2. Tank Refill Logic
IF (D0 <= 1200) AND X2F AND (D1 > 0) AND NOT is_done THEN
    Y10 := TRUE;
ELSIF (D0 >= 1550) OR NOT X2F OR (D1 = 0) OR is_done THEN
    Y10 := FALSE;
END_IF

// 3. Tank Swap Logic
IF (D1 = 0) AND NOT X2F AND NOT X30 AND X31 AND NOT is_done AND NOT Y10 AND y10_was_false THEN
    IF NOT swap_started THEN
        Y11 := TRUE;
        swap_started := TRUE;
    END_IF
END_IF
IF X30 THEN
    Y11 := FALSE;
    swap_started := FALSE;
END_IF

// 4. Pump Allowance Logic (Prevents tank depletion dynamically)
IF D0 < 50 THEN
    pump_a_allowed := FALSE;
ELSIF D0 > 80 THEN
    pump_a_allowed := TRUE;
END_IF

IF D0 < 100 THEN
    pump_b_allowed := FALSE;
ELSIF D0 > 130 THEN
    pump_b_allowed := TRUE;
END_IF

// 5. Line A State Machine
CASE state_a OF
0:
    IF X10 THEN
        Y14 := FALSE;
        a_feed_latched := FALSE;
        state_a := 1;
    ELSIF (X11 OR a_feed_latched) AND NOT is_done THEN
        Y14 := TRUE;
        a_feed_latched := TRUE;
    ELSE
        Y14 := FALSE;
    END_IF
1:
    Y15 := TRUE;
    Y16 := TRUE;
    IF X14 AND X13 THEN
        state_a := 2;
    END_IF
2:
    Y17 := TRUE;
    IF X16 THEN
        state_a := 3;
    END_IF
3:
    Y17 := TRUE;
    IF (D4 + D6) < D5 THEN
        Y18 := pump_a_allowed;
    ELSE
        Y18 := FALSE;
        state_a := 4;
    END_IF
4:
    Y17 := TRUE;
    Y18 := FALSE;
    IF D6 = 0 THEN
        state_a := 5;
    END_IF
5:
    Y17 := FALSE;
    Y18 := FALSE;
    IF X17 THEN
        state_a := 6;
    END_IF
6:
    Y16 := FALSE;
    Y15 := FALSE;
    IF X12 AND X15 THEN
        state_a := 7;
    END_IF
7:
    IF NOT X1A AND NOT X19 AND NOT a_out_started THEN
        Y19 := TRUE;
        a_out_started := TRUE;
    END_IF
    IF a_out_started AND NOT X10 THEN
        Y19 := FALSE;
        a_out_started := FALSE;
        state_a := 0;
    END_IF
END_CASE

// 6. Line B State Machine
CASE state_b OF
0:
    IF X1E THEN
        Y1B := FALSE;
        b_feed_latched := FALSE;
        state_b := 1;
    ELSIF (X1F OR b_feed_latched) AND NOT is_done THEN
        Y1B := TRUE;
        b_feed_latched := TRUE;
    ELSE
        Y1B := FALSE;
    END_IF
1:
    Y1C := TRUE;
    Y1D := TRUE;
    IF X22 AND X21 THEN
        state_b := 2;
    END_IF
2:
    Y1E := TRUE;
    IF X24 THEN
        state_b := 3;
    END_IF
3:
    Y1E := TRUE;
    IF (D9 + D11) < D10 THEN
        Y1F := pump_b_allowed;
    ELSE
        Y1F := FALSE;
        state_b := 4;
    END_IF
4:
    Y1E := TRUE;
    Y1F := FALSE;
    IF D11 = 0 THEN
        state_b := 5;
    END_IF
5:
    Y1E := FALSE;
    Y1F := FALSE;
    IF X25 THEN
        state_b := 6;
    END_IF
6:
    Y1D := FALSE;
    Y1C := FALSE;
    IF X20 AND X23 THEN
        state_b := 7;
    END_IF
7:
    IF NOT X28 AND NOT X27 AND NOT b_out_started THEN
        Y20 := TRUE;
        b_out_started := TRUE;
    END_IF
    IF b_out_started AND NOT X1E THEN
        Y20 := FALSE;
        b_out_started := FALSE;
        state_b := 0;
    END_IF
END_CASE

// 7. Shared Capping Arbitration Logic
Y12 := FALSE;
Y13 := FALSE;

IF X2C THEN
    cap_cmd_active := FALSE;
END_IF

IF X1B THEN cap_wait_a := FALSE; END_IF
IF X29 THEN cap_wait_b := FALSE; END_IF

IF NOT X2C AND NOT cap_cmd_active THEN
    IF X1A AND NOT X1B AND NOT cap_wait_a THEN
        Y12 := TRUE;
        cap_wait_a := TRUE;
        cap_cmd_active := TRUE;
    ELSIF X28 AND NOT X29 AND NOT cap_wait_b THEN
        Y13 := TRUE;
        cap_wait_b := TRUE;
        cap_cmd_active := TRUE;
    END_IF
END_IF

// 8. Exit Release Logic
IF X1B AND X1C AND NOT a_release_active THEN
    Y1A := TRUE;
    a_release_active := TRUE;
END_IF
IF a_release_active AND NOT X1A THEN
    Y1A := FALSE;
    a_release_active := FALSE;
END_IF

IF X29 AND X2A AND NOT b_release_active THEN
    Y21 := TRUE;
    b_release_active := TRUE;
END_IF
IF b_release_active AND NOT X28 THEN
    Y21 := FALSE;
    b_release_active := FALSE;
END_IF

// 9. Final Safety and Completion Flags
IF is_done THEN
    Y10 := FALSE;
    Y14 := FALSE;
    Y1B := FALSE;
END_IF

all_stopped := NOT Y10 AND NOT Y18 AND NOT Y1F AND X17 AND X25 AND X12 AND X20 AND NOT X2C AND NOT X30 AND NOT Y11;

IF is_done AND (state_a = 0) AND (state_b = 0) AND all_stopped THEN
    Y22 := TRUE;
END_IF

// Update scan history
y10_was_false := NOT Y10;

END_PROGRAM