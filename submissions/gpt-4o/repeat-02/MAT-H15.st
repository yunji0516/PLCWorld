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
    D200 : INT := 0;
    D201 : INT := 0;
    D202 : INT := 0;
    D203 : INT := 850; 
    D204 : INT := 850; 
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL := FALSE;
    Y1B : BOOL := FALSE;
    Y1C : BOOL := FALSE;
    Y1D : BOOL := FALSE;
    Y1E : BOOL := FALSE;
    Y1F : BOOL := FALSE;

    state : INT := 0;
    next_type : INT;
    layer_count : INT;
    timer : TON;
    edge_accept_a : R_TRIG;
    edge_accept_b : R_TRIG;
END_VAR

(* Implement the control logic here. *)

(* Check initial conditions and handle startup *)
IF X0 THEN
    state := 1;
END_IF

(* Main State Machine *)
CASE state OF
    0: (* Initial State *)
        Y10 := FALSE;
        Y11 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y16 := FALSE;
        Y18 := FALSE;
        Y19 := FALSE;
        
    1: (* Accept orders *)
        edge_accept_a(CLK := X1B);
        edge_accept_b(CLK := X1C);
        
        IF edge_accept_a.Q THEN
            Y10 := TRUE;
            next_type := D7; (* Next plate type for A *)
            state := 2;
        ELSIF edge_accept_b.Q THEN
            Y11 := TRUE;
            next_type := D8; (* Next plate type for B *)
            state := 2;
        END_IF
        
    2: (* Prepare to pick and place *)
        IF NOT X12 THEN
            Y12 := TRUE; 
            D200 := next_type;
            state := 3;
        END_IF
        
    3: (* Place the plate *)
        IF X25 OR X26 THEN
            Y13 := TRUE; 
            IF next_type = 1 THEN
                D202 := D9;
            ELSE
                D202 := D10;
            END_IF
            state := 4;
        END_IF
        
    4: (* Release and check complete *)
        Y12 := FALSE;
        Y13 := FALSE;
        
        IF X19 THEN
            Y1A := TRUE;
            state := 5;
        END_IF
        
    5: (* Confirm exit received *)
        IF Y1A THEN
            timer(IN := TRUE, PT := T#500ms);
            IF timer.Q THEN
                Y1A := FALSE;
                state := 6;
            END_IF
        END_IF
        
    6: (* Reset and prepare for next operation *)
        Y10 := FALSE;
        Y11 := FALSE;
        state := 0;
        
        (* Ensure supports and fork return to home positions *)
        IF X21 AND X22 AND X18 THEN
            Y1B := TRUE;
        END_IF
        
END_CASE

END_PROGRAM