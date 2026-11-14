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
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
    Y19 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
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
    Y1A : BOOL := FALSE;
    Y1B : BOOL := FALSE;
    Y1C : BOOL := FALSE;
    Y1D : BOOL := FALSE;
    Y1E : BOOL := FALSE;
    Y1F : BOOL := FALSE;
    
    // Internal variables
    current_time : TIME := T#0ms;
    pump_a_active, pump_b_active : BOOL := FALSE;
    refill_active : BOOL := FALSE;
    capper_busy_last : BOOL := FALSE;
    
    // Timers for valve delay
    a_valve_timer : TON;
    b_valve_timer : TON;
    
    // Trigger for swap when tank low and empty
    trigger_swap : R_TRIG;
    
    // Helper variables
    max_tank_capacity : INT := 1600; // Represented as 160 mL
    total_pump_rate : INT;
    
END_VAR

// Control Logic Implementation

// Initialize timers
a_valve_timer(IN := FALSE, PT := T#150ms);
b_valve_timer(IN := FALSE, PT := T#150ms);
trigger_swap(CLK := NOT X2F AND D0 < 300 AND D1 > 0); // Trigger swap when batch empty and below 30 mL

// Handle refilling process
IF NOT refill_active AND X2F AND D0 < max_tank_capacity AND D1 > 0 THEN
    Y10 := TRUE;
    refill_active := TRUE;
ELSIF NOT X2F OR D0 >= max_tank_capacity THEN
    Y10 := FALSE;
    refill_active := FALSE;
END_IF

// Handle swap process
IF trigger_swap.Q THEN
    Y11 := TRUE; // Initiate swap
ELSE
    Y11 := FALSE;
END_IF

// Control A Line Pumping and Valve
IF X10 AND NOT X15 AND NOT a_valve_timer.Q THEN
    a_valve_timer(IN := TRUE);
END_IF

IF a_valve_timer.Q OR X15 THEN
    Y15 := TRUE; // Open valve
    IF a_valve_timer.Q THEN
        Y18 := TRUE; // Start pump a
        pump_a_active := TRUE;
    END_IF
END_IF

// Control B Line Pumping and Valve
IF X1E AND NOT X1C AND NOT b_valve_timer.Q THEN
    b_valve_timer(IN := TRUE);
END_IF

IF b_valve_timer.Q OR X1C THEN
    Y1C := TRUE; // Open valve
    IF b_valve_timer.Q THEN
        Y1F := TRUE; // Start pump b
        pump_b_active := TRUE;
    END_IF
END_IF

// Calculate total pump rate in operation and ensure tank balance
total_pump_rate := (SEL(pump_a_active, 100, 0) + SEL(pump_b_active, 100, 0)); // 10 mL/s per pump

IF (D0 - total_pump_rate) < 0 THEN
    // Prevent tank depletion
    IF pump_a_active THEN Y18 := FALSE; END_IF
    IF pump_b_active THEN Y1F := FALSE; END_IF
END_IF

// Capping Logic
IF X12 AND NOT X2C AND X1A THEN
    Y12 := TRUE; // Request cap A
ELSEIF X20 AND NOT X2C AND X28 THEN
    Y13 := TRUE; // Request cap B
ELSE
    Y12 := FALSE;
    Y13 := FALSE;
END_IF

// Handle Line A movement
IF X14 THEN
    Y1A := TRUE; // release A when done
END_IF

// Handle Line B movement
IF X22 THEN
    Y21 := TRUE; // release B when done
END_IF

// Set completion signal
IF D3 >= 6 AND Y10 = FALSE AND Y18 = FALSE AND Y1F = FALSE THEN
    Y22 := TRUE;
    current_time := current_time + T#10ms;
ELSE
    Y22 := FALSE;
    current_time := T#0ms;
END_IF

END_PROGRAM