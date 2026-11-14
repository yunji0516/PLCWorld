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
    X33 : BOOL;
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
    Y23 : BOOL;
    Y24 : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    
    state : INT := 0;
    next_tape_ready : BOOL := FALSE;
    wrap_complete : BOOL := FALSE;
    tape_applied : BOOL := FALSE;
    tape_request_timer : TON;
    transfer_gripper_timer : TON;
    form_index_timer : TON;
    bundle_complete : BOOL := FALSE;
    
END_VAR

(* Implement the control logic here. *)

(* State machine for bundle forming and transferring *)
CASE state OF
    0: (* Initial state *)
        IF X0 THEN
            state := 1;
        END_IF;
        
    1: (* Initialize form gripper and lower forming head *)
        Y21 := TRUE; (* Lower forming head *)
        Y20 := TRUE; (* Close gripper *)
        IF form_complete THEN
            Y22 := TRUE; (* Move forming table to supply *)
            state := 2;
        END_IF;
        
    2: (* Form a bundle from the available items *)
        IF X25 AND NOT X27 THEN
            Y1C := TRUE; (* Start unit feed *)
            Y1D := TRUE; (* Close form stop *)
            IF X26 THEN
                Y1C := FALSE; (* Stop unit feed *)
                form_index_timer(IN := TRUE, PT := T#800ms);
                IF form_index_timer.Q THEN
                    Y1E := TRUE; (* Move index forward *)
                    form_index_timer(IN := FALSE);
                    Y1D := FALSE; (* Open form stop *)
                    state := 3;
                END_IF;
            END_IF;
        END_IF;
        
    3: (* Aligning and gripping *)
        IF X29 THEN
            Y1F := TRUE; (* Engage form align *)
            Y20 := FALSE; (* Release gripper to form bundle *)
            IF X2A THEN
                Y1F := FALSE; (* Disengage form align *)
                state := 4;
            END_IF;
        END_IF;
        
    4: (* Transfer to wrapping position *)
        IF X12 THEN
            Y13 := TRUE; (* Move to wrapping station *)
            transfer_gripper_timer(IN := TRUE, PT := T#1000ms);
            IF transfer_gripper_timer.Q THEN
                Y10 := TRUE; (* Grip bundle *)
                state := 5;
            END_IF;
        END_IF;
        
    5: (* Wrapping process *)
        IF X19 AND X1B AND X18 THEN
            Y16 := TRUE; (* Start wrapping *)
            IF D4 < D3 THEN
                Y16 := FALSE; (* Stop wrapping when D4 meets D3 *)
                wrap_complete := TRUE;
                state := 6;
            END_IF;
        END_IF;
    
    6: (* Apply tape and move to exit *)
        IF NOT tape_applied AND X20 THEN
            Y18 := TRUE; (* Prepare tape *)
            tape_request_timer(IN := TRUE, PT := T#5000ms);
            IF tape_request_timer.Q THEN
                Y19 := TRUE; (* Apply tape *)
                tape_applied := TRUE;
                tape_request_timer(IN := FALSE);
            END_IF;
        ELSE
            Y14 := TRUE; (* Move to exit point *)
            IF X14 AND Y15 THEN
                Y10 := FALSE; (* Release gripper at exit *)
                state := 0; (* Reset for next operation *)
                bundle_complete := TRUE;
            END_IF;
        END_IF;

ELSE
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
    Y23 := FALSE;
    Y24 := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
END_CASE;

END_PROGRAM