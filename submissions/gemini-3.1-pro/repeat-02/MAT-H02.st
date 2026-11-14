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
    D16 : INT;
    D200 : INT;
    D201 : INT;
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
    
    (* Internal Variables *)
    target_found : INT;
    gen_to_set : INT;
    dock_cmd : BOOL;
    load_cmd : BOOL;
    unload_cmd : BOOL;
    
    dock_trig : R_TRIG;
    load_trig : R_TRIG;
    unload_trig : R_TRIG;
    
    accept_a_trig : R_TRIG;
    accept_b_trig : R_TRIG;
    close_a_trig : R_TRIG;
    close_b_trig : R_TRIG;
    release_a_trig : R_TRIG;
    release_b_trig : R_TRIG;
    
    box_state : INT := 0;
    dispatch_trig : R_TRIG;
    
    pack_a_req : BOOL;
    pack_b_req : BOOL;
    pack_cmd_a : BOOL;
    pack_cmd_b : BOOL;
    a_packing : BOOL;
    b_packing : BOOL;
    a_packed_latch : BOOL;
    b_packed_latch : BOOL;
    
    pack_a_trig : R_TRIG;
    pack_b_trig : R_TRIG;
    
    ack_a_trig : R_TRIG;
    ack_b_trig : R_TRIG;
    
    complete_latch : BOOL;
END_VAR

IF X0 THEN
    
    (* Deck Transport Logic *)
    load_cmd := FALSE;
    unload_cmd := FALSE;
    dock_cmd := FALSE;

    IF NOT X11 THEN
        IF D1 = 0 THEN
            target_found := 0;
            IF D6 > 0 AND ((D6 = D11 AND X15) OR (D6 = D12 AND X16)) THEN
                target_found := 2;
            ELSIF D8 > 0 AND ((D8 = D11 AND X15) OR (D8 = D12 AND X16)) THEN
                target_found := 3;
            ELSIF X10 AND D4 > 0 THEN
                IF (D4 = D11 AND X15) OR (D4 = D12 AND X16) OR (D6 = 0) OR (D8 = 0) THEN
                    target_found := 1;
                END_IF;
            END_IF;
            
            IF target_found > 0 THEN
                IF D0 = target_found THEN
                    load_cmd := TRUE;
                ELSE
                    D200 := target_found;
                    dock_cmd := TRUE;
                END_IF;
            END_IF;
        ELSE
            IF X12 THEN
                target_found := 0;
                gen_to_set := 0;
                IF D2 = D11 AND X15 THEN
                    target_found := 4;
                    gen_to_set := D9;
                ELSIF D2 = D12 AND X16 THEN
                    target_found := 5;
                    gen_to_set := D10;
                ELSIF D6 = 0 THEN
                    target_found := 2;
                ELSIF D8 = 0 THEN
                    target_found := 3;
                END_IF;
                
                IF target_found > 0 THEN
                    IF D0 = target_found THEN
                        IF target_found = 4 OR target_found = 5 THEN
                            D201 := gen_to_set;
                        END_IF;
                        unload_cmd := TRUE;
                    ELSE
                        D200 := target_found;
                        dock_cmd := TRUE;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

    dock_trig(CLK := dock_cmd);
    Y10 := dock_trig.Q;

    load_trig(CLK := load_cmd);
    Y11 := load_trig.Q;

    unload_trig(CLK := unload_cmd);
    Y12 := unload_trig.Q;

    (* Order Acceptance *)
    accept_a_trig(CLK := X13);
    Y13 := accept_a_trig.Q;

    accept_b_trig(CLK := X14);
    Y14 := accept_b_trig.Q;

    (* Order Assembly *)
    close_a_trig(CLK := (D13 = 2));
    Y15 := close_a_trig.Q;

    close_b_trig(CLK := (D14 = 2));
    Y16 := close_b_trig.Q;

    (* Order Release *)
    release_a_trig(CLK := (X17 AND X19));
    Y17 := release_a_trig.Q;

    release_b_trig(CLK := (X18 AND X1A));
    Y18 := release_b_trig.Q;

    (* Box Logistics State Machine *)
    CASE box_state OF
        0:
            Y1C := TRUE;
            Y1D := FALSE;
            IF X1F THEN 
                box_state := 1; 
            END_IF;
        1:
            Y1C := FALSE;
            Y1D := TRUE;
            IF X20 THEN 
                box_state := 2; 
            END_IF;
        2:
            Y1D := TRUE;
            IF X24 THEN 
                box_state := 3; 
            END_IF;
        3:
            Y1D := FALSE;
            IF NOT X20 AND X25 THEN 
                box_state := 4; 
            END_IF;
        4:
            IF NOT X1F THEN 
                box_state := 0; 
            END_IF;
    END_CASE;

    dispatch_trig(CLK := (box_state = 4));
    Y20 := dispatch_trig.Q;

    (* Mutually Exclusive Packing Controls *)
    IF X21 AND pack_cmd_a THEN
        pack_cmd_a := FALSE;
        a_packing := TRUE;
    END_IF;
    IF X22 THEN
        a_packing := FALSE;
        a_packed_latch := TRUE;
    END_IF;
    IF NOT X1B THEN
        a_packed_latch := FALSE;
    END_IF;

    IF X21 AND pack_cmd_b THEN
        pack_cmd_b := FALSE;
        b_packing := TRUE;
    END_IF;
    IF X23 THEN
        b_packing := FALSE;
        b_packed_latch := TRUE;
    END_IF;
    IF NOT X1C THEN
        b_packed_latch := FALSE;
    END_IF;

    pack_a_req := X1B AND (D16 = D9) AND X20;
    pack_b_req := X1C AND (D16 = D10) AND X20;

    IF NOT X21 AND NOT pack_cmd_a AND NOT pack_cmd_b AND NOT a_packing AND NOT b_packing THEN
        IF pack_a_req AND NOT a_packed_latch THEN
            pack_cmd_a := TRUE;
        ELSIF pack_b_req AND NOT b_packed_latch THEN
            pack_cmd_b := TRUE;
        END_IF;
    END_IF;

    pack_a_trig(CLK := pack_cmd_a);
    Y1E := pack_a_trig.Q;

    pack_b_trig(CLK := pack_cmd_b);
    Y1F := pack_b_trig.Q;

    (* Kit Result Confirmation *)
    ack_a_trig(CLK := X22);
    Y19 := ack_a_trig.Q;

    ack_b_trig(CLK := X23);
    Y1A := ack_b_trig.Q;

    (* Global Completion Evaluation *)
    IF X1D AND D1 = 0 AND NOT X11 THEN
        complete_latch := TRUE;
    END_IF;
    Y1B := complete_latch;

END_IF;

END_PROGRAM