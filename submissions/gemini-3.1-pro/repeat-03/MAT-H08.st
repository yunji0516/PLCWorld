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

    P_State : INT := 0;
    R_State : INT := 0;
    products_done : INT := 0;
    recovery_batches_done : INT := 0;
    
    accept_pitch_done : BOOL := FALSE;
    was_recovering : BOOL := FALSE;
    
    unload_started : BOOL := FALSE;
    current_unload_done : BOOL := FALSE;
    
    clamp_timer : TON;
    unload_timer : TON;
END_VAR

// Unconditional Timer Updates
clamp_timer(IN := (P_State = 2 AND X15), PT := T#200ms);
unload_timer(IN := (R_State = 121), PT := T#3s);

IF NOT X10 THEN
    accept_pitch_done := FALSE;
END_IF

// Pitch and Product State Machine
CASE P_State OF
    0:
        IF X10 AND NOT X18 AND NOT Y10 AND NOT accept_pitch_done AND products_done < 6 THEN
            Y10 := TRUE;
            accept_pitch_done := TRUE;
            P_State := 1;
        END_IF
        
    1:
        Y10 := FALSE;
        IF X12 THEN
            Y11 := FALSE;
            P_State := 2;
        ELSIF D3 < 600 THEN
            Y11 := TRUE;
        ELSE
            Y11 := FALSE;
        END_IF
        
    2:
        Y12 := TRUE;
        IF clamp_timer.Q THEN
            P_State := 3;
        END_IF
        
    3:
        D200 := 15;
        Y13 := TRUE;
        IF X14 THEN
            Y13 := FALSE;
            Y12 := FALSE;
            P_State := 4;
        END_IF
        
    4:
        Y14 := TRUE;
        IF X16 THEN
            Y14 := FALSE;
            P_State := 5;
        END_IF
        
    5:
        Y15 := TRUE;
        IF X17 AND X20 AND X19 THEN
            Y16 := TRUE;
            P_State := 6;
        END_IF
        
    6:
        IF X1A THEN
            Y16 := FALSE;
            Y1A := TRUE;
            P_State := 7;
        END_IF
        
    7:
        IF NOT X1A THEN
            Y1A := FALSE;
            Y15 := FALSE;
            products_done := products_done + 1;
            P_State := 8;
        END_IF
        
    8:
        IF NOT X18 THEN
            P_State := 0;
        END_IF
END_CASE

// Recovery and Reel Exchange State Machine
CASE R_State OF
    0:
        IF X21 THEN
            was_recovering := FALSE;
            R_State := 10;
        ELSIF X1B AND recovery_batches_done < 4 THEN
            Y17 := TRUE;
            R_State := 1;
        END_IF
        
    1:
        Y17 := FALSE;
        IF X1D THEN
            Y18 := FALSE;
            Y19 := TRUE;
            R_State := 2;
        ELSIF X21 THEN
            Y18 := FALSE;
            was_recovering := TRUE;
            R_State := 10;
        ELSE
            Y18 := TRUE;
        END_IF
        
    2:
        Y19 := TRUE;
        IF NOT X1D THEN
            Y19 := FALSE;
            recovery_batches_done := recovery_batches_done + 1;
            IF recovery_batches_done >= 4 THEN
                R_State := 12; // Force unload of the final roll, skipping holding and cutting of depleted web
            ELSE
                R_State := 0;
            END_IF
        END_IF
        
    10:
        Y1C := TRUE;
        IF X22 THEN 
            R_State := 11; 
        END_IF
        
    11:
        Y1D := TRUE;
        Y1E := TRUE;
        IF X23 THEN
            Y1D := FALSE;
            Y1E := FALSE;
            R_State := 12;
        END_IF
        
    12:
        Y1F := TRUE;
        unload_started := FALSE;
        current_unload_done := FALSE;
        R_State := 121;
        
    121:
        Y1F := FALSE;
        IF X24 THEN 
            unload_started := TRUE; 
        END_IF
        
        IF (unload_started AND NOT X24) OR unload_timer.Q THEN
            current_unload_done := TRUE;
        END_IF
        
        IF current_unload_done THEN
            IF recovery_batches_done >= 4 THEN
                R_State := 99; // Stop in idle state after final reel is physically received
            ELSIF X25 THEN
                Y20 := TRUE;
                R_State := 13;
            END_IF
        END_IF
        
    13:
        Y20 := FALSE;
        IF X26 THEN
            Y21 := TRUE;
            Y22 := TRUE;
            R_State := 14;
        END_IF
        
    14:
        IF X27 AND X28 THEN
            Y21 := FALSE;
            Y22 := FALSE;
            Y1C := FALSE;
            R_State := 15;
        END_IF
        
    15:
        IF X29 THEN
            IF was_recovering THEN
                R_State := 1;
            ELSE
                R_State := 0;
            END_IF
        END_IF
        
    99:
        ; // Retain sequence termination indefinitely
END_CASE

// Global Completion Evaluation
IF (products_done >= 6) AND (recovery_batches_done >= 4) AND (P_State = 0) AND ((R_State = 99) OR (R_State = 0)) AND NOT X18 AND NOT X1A AND NOT X10 THEN
    Y1B := TRUE;
END_IF

END_PROGRAM