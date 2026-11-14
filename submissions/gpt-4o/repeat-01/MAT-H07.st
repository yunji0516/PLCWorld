``` 
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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
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
    Y1A : BOOL := FALSE;
    Y1B : BOOL := FALSE;
    Y1C : BOOL := FALSE;
    Y1D : BOOL := FALSE;
    Y1E : BOOL := FALSE;
    Y1F : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
    Y27 : BOOL := FALSE;
    Y28 : BOOL := FALSE;
    Y29 : BOOL := FALSE;

    timer_accept_a : TON;
    timer_accept_b : TON;
    timer_core_stop : TON;
    timer_hold_a : TON;
    timer_hold_b : TON;
    timer_nip_a : TON;
    timer_nip_b : TON;
    timer_tape_hold : TON;
    timer_mandrel_move : TON;
    edge_trim_received : R_TRIG;
    edge_start : R_TRIG;
    edge_trim_done : R_TRIG;
    state : INT := 0;
    roll_target : INT := 0;
    tape_held_amount : INT := 0;
    core_position : INT := 0;
END_VAR

// Helper functions and procedures to reduce code repetition.

PROCEDURE ControlOutputs(state : INT)
VAR_INPUT
    state : INT;
END_VAR_INPUT
BEGIN
    // Control procedure based on the device state
    IF state = 1 THEN
        // Prepare A web
        Y10 := TRUE;
    ELSIF state = 2 THEN
        // Prepare B web
        Y11 := TRUE;
    ELSIF state = 3 THEN
        // Handle B jog and trim
        Y14 := TRUE; // Jog B
        IF X15 THEN // If B held
            Y15 := TRUE; // Trim B
        END_IF
    ELSIF state = 4 THEN
        // Acknowledge trim
        IF X17 THEN
            Y16 := TRUE;
        END_IF
    ELSIF state = 5 THEN
        // Accept roll
        IF X1D THEN // Mandrel out
            Y17 := TRUE;
        END_IF
    ELSIF state = 6 THEN
        // Begin winding process
        Y1A := TRUE; // Wind
        // Nip contact
        Y18 := TRUE;
        Y19 := TRUE;
        // Holders contact
        Y12 := TRUE;
        Y13 := TRUE;
    ELSIF state = 7 THEN
        // End winding, tape and eject
        Y1A := FALSE; // Stop Wind
        IF X33 THEN
            Y28 := TRUE; // Apply tape
        END_IF
        IF X28 THEN
            Y20 := TRUE; // Eject
        END_IF
    ELSIF state = 8 THEN
        // Process complete reset
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
        Y1A := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE; // Completion signal
    END_IF
END_PROCEDURE

// Main control logic

BEGIN
    // Edge detection for rising edges
    edge_start(CLK := X0);
    IF edge_start.Q THEN
        state := 1; // Begin process on start signal
    END_IF
    
    edge_trim_received(CLK := X17);
    edge_trim_done(CLK := X16);
    
    CASE state OF
        0: // Idle
            Y22 := FALSE;
            
        1: // Prepare A web
            IF X10 AND NOT X12 THEN
                Y10 := TRUE; // Accept A
            END_IF
            IF X12 THEN
                state := 2;
                Y10 := FALSE;
            END_IF
            
        2: // Prepare B web
            IF X11 AND NOT X13 THEN
                Y11 := TRUE; // Accept B
            END_IF
            IF X13 THEN
                state := 3;
                Y11 := FALSE;
            END_IF
            
        3: // Jog and trim B
            IF X11 AND NOT X15 THEN
                Y14 := TRUE; // Jog B
            ELSIF X15 THEN
                Y14 := FALSE;
                Y15 := TRUE; // Trim B
            END_IF
            IF edge_trim_done.Q THEN
                state := 4;
                Y15 := FALSE;
            END_IF
            
        4: // Acknowledge trim
            IF edge_trim_received.Q THEN
                Y16 := TRUE; // Acknowledge trim
                state := 5;
            END_IF
            
        5: // Accept roll if ready
            IF X18 AND X1D THEN
                Y17 := TRUE; // Accept roll
                state := 6;
            END_IF
            
        6: // Wind process
            IF D6 >= (D4 - 2) AND D6 <= (D4 + 2) THEN
                Y1A := FALSE; // Stop winding
                IF X33 THEN
                    Y28 := TRUE; // Apply tape
                    state := 7;
                END_IF
            END_IF
            
        7: // Eject roll
            IF tape_held_amount >= 80 THEN
                Y20 := TRUE; // Eject
                state := 8;
            END_IF
            
        8: // Completion
            IF X23 THEN
                Y22 := TRUE; // Send complete signal
                state := 0; // Reset back to idle
            END_IF
    END_CASE;
    
    // Call control outputs procedure
    ControlOutputs(state);

END_PROGRAM
```