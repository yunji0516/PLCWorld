SYSTEM
TASK Main;
END_TASK

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
    D13 : BOOL;
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
    
    (* Edge detectors *)
    start_trig : R_TRIG;
    accept_a_trig : R_TRIG;
    accept_b_trig : R_TRIG;
    head_held_trig : R_TRIG;
    fork_inserted_trig : R_TRIG;
    fork_supporting_trig : R_TRIG;
    fork_at_exit_trig : R_TRIG;
    fork_home_trig : R_TRIG;
    pallet_avail_trig : R_TRIG;
    empty_ins_trig : R_TRIG;
    empty_sup_trig : R_TRIG;
    empty_sta_trig : R_TRIG;
    exit_recv_trig : R_TRIG;
    a_plac_clr_trig : R_TRIG;
    b_plac_clr_trig : R_TRIG;
    a_supp_low_trig : R_TRIG;
    b_supp_low_trig : R_TRIG;
    
    (* State machine *)
    cur_state : INT;
    
    (* Order tracking *)
    a_pending : INT;
    b_pending : INT;
    a_placed : INT;
    b_placed : INT;
    
    (* Layer order: A=[R,B,R], B=[B,R,B,R] *)
    a_layer_order : ARRAY[0..2] OF INT;
    b_layer_order : ARRAY[0..3] OF INT;
    a_layer_idx : INT;
    b_layer_idx : INT;
    
    (* Pallet tracking *)
    a_has_pallet : BOOL;
    b_has_pallet : BOOL;
    pallet_supplying : INT;
    
    (* Bundle state *)
    a_bundle_done : BOOL;
    b_bundle_done : BOOL;
    bundle_done_count : INT;
    
    (* Support height tracking *)
    a_top_height : INT;
    b_top_height : INT;
    
    (* Stability timer *)
    stable_timer : TON;
    
    (* Pulse counters *)
    accept_a_pulse : BOOL;
    accept_b_pulse : BOOL;
    pick_pulse : BOOL;
    pick_kinda : INT;
    place_pulse : BOOL;
    place_side : INT;
    place_mm_val : INT;
    
    (* Fork operation state *)
    fork_op_state : INT;
    fork_target_side : INT;
    
    (* Pallet fork state *)
    pallet_op_state : INT;
    pallet_target_side : INT;
    
    (* Ack state *)
    ack_pending : BOOL;
    ack_done : BOOL;
    
    (* Completion *)
    complete_set : BOOL;
    complete_held : BOOL;
    
    (* Internal latches *)
    started : BOOL;
    a_order_arrived : BOOL;
    b_order_arrived : BOOL;
    
    (* Place clear wait *)
    place_clear_wait_a : BOOL;
    place_clear_wait_b : BOOL;
    
    (* Support lowering *)
    a_support_lowering : BOOL;
    b_support_lowering : BOOL;
    
    (* Fork inserting latch *)
    fork_insert_sent : BOOL;
    
    (* Fork transfer latch *)
    fork_transfer_sent : BOOL;
    
    (* Fork release latch *)
    fork_release_sent : BOOL;
    
    (* Pallet pick latch *)
    pallet_pick_sent : BOOL;
END_VAR

(* State definitions *)
CONST
    ST_IDLE : INT := 0;
    ST_WAIT_ORDERS : INT := 1;
    ST_SUPPLY_PALLET_A : INT := 2;
    ST_SUPPLY_PALLET_B : INT := 3;
    ST_WAIT_PICK_A : INT := 4;
    ST_WAIT_PICK_B : INT := 5;
    ST_WAIT_PLACE_A : INT := 6;
    ST_WAIT_PLACE_B : INT := 7;
    ST_TRANSFER_BUNDLE_A : INT := 8;
    ST_TRANSFER_BUNDLE_B : INT := 9;
    ST_TRANSFER_BUNDLE_WAIT : INT := 10;
    ST_RETURN_PALLET_A : INT := 11;
    ST_RETURN_PALLET_B : INT := 12;
    ST_ACK_AND_HOME : INT := 13;
    ST_COMPLETE_WAIT : INT := 14;
    ST_DONE : INT := 15;
END_CONST

BEGIN
    (* Initialize layer orders *)
    IF NOT started THEN
        a_layer_order[0] := 1; (* R *)
        a_layer_order[1] := 2; (* B *)
        a_layer_order[2] := 1; (* R *)
        b_layer_order[0] := 2; (* B *)
        b_layer_order[1] := 1; (* R *)
        b_layer_order[2] := 2; (* B *)
        b_layer_order[3] := 1; (* R *)
        a_layer_idx := 0;
        b_layer_idx := 0;
        a_pending := 0;
        b_pending := 0;
        a_placed := 0;
        b_placed := 0;
        a_has_pallet := FALSE;
        b_has_pallet := FALSE;
        a_bundle_done := FALSE;
        b_bundle_done := FALSE;
        bundle_done_count := 0;
        a_top_height := 850;
        b_top_height := 850;
        cur_state := ST_IDLE;
        fork_op_state := 0;
        pallet_op_state := 0;
        ack_pending := FALSE;
        ack_done := FALSE;
        complete_set := FALSE;
        complete_held := FALSE;
        started := TRUE;
        a_order_arrived := FALSE;
        b_order_arrived := FALSE;
    END_IF;
    
    (* Edge detection *)
    start_trig(CLK := X0);
    accept_a_trig(CLK := accept_a_pulse);
    accept_b_trig(CLK := accept_b_pulse);
    head_held_trig(CLK := X13);
    fork_inserted_trig(CLK := X15);
    fork_supporting_trig(CLK := X16);
    fork_at_exit_trig(CLK := X17);
    fork_home_trig(CLK := X18);
    pallet_avail_trig(CLK := X27);
    empty_ins_trig(CLK := X2A);
    empty_sup_trig(CLK := X2B);
    empty_sta_trig(CLK := X2C);
    exit_recv_trig(CLK := X19);
    a_plac_clr_trig(CLK := X25);
    b_plac_clr_trig(CLK := X26);
    a_supp_low_trig(CLK := X23);
    b_supp_low_trig(CLK := X24);
    
    (* Read actual heights *)
    a_top_height := DINT(D9);
    b_top_height := DINT(D10);
    
    (* Reset all outputs *)
    accept_a_pulse := FALSE;
    accept_b_pulse := FALSE;
    pick_pulse := FALSE;
    place_pulse := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    D200 := 0;
    D201 := 0;
    D202 := 0;
    D203 := 850;
    D204 := 850;
    fork_op_state := 0;
    fork_insert_sent := FALSE;
    fork_transfer_sent := FALSE;
    fork_release_sent := FALSE;
    pallet_pick_sent := FALSE;
    
    (* Handle order acceptance edges *)
    IF accept_a_trig.Q THEN
        a_pending := a_pending + 1;
        a_order_arrived := TRUE;
    END_IF;
    IF accept_b_trig.Q THEN
        b_pending := b_pending + 1;
        b_order_arrived := TRUE;
    END_IF;
    
    (* State machine *)
    CASE cur_state OF
        
    ST_IDLE:
        IF start_trig.Q THEN
            cur_state := ST_WAIT_ORDERS;
        END_IF;
        
    ST_WAIT_ORDERS:
        (* Wait for both orders to arrive *)
        IF a_order_arrived AND b_order_arrived THEN
            (* Start pallet supply to A first *)
            cur_state := ST_SUPPLY_PALLET_A;
        END_IF;
        
    ST_SUPPLY_PALLET_A:
        (* Check if pallet is available *)
        IF X27 THEN
            (* Send pallet pick rising edge *)
            pallet_pick_sent := TRUE;
            Y1C := TRUE;
            pallet_op_state := 1;
        ELSE
            cur_state := ST_SUPPLY_PALLET_A;
        END_IF;
        
        (* After pallet lifted *)
        IF pallet_op_state = 1 AND X2A THEN
            pallet_op_state := 2;
        END_IF;
        
        (* After pallet supported *)
        IF pallet_op_state = 2 AND X2B THEN
            pallet_op_state := 3;
            Y1E := TRUE;
            D201 := 1;
            pallet_target_side := 1;
        END_IF;
        
        (* After pallet at station *)
        IF pallet_op_state = 3 AND X2C THEN
            Y1F := TRUE;
            pallet_op_state := 4;
        END_IF;
        
        (* After pallet released, fork withdrawn *)
        IF pallet_op_state = 4 AND X18 THEN
            a_has_pallet := TRUE;
            pallet_op_state := 0;
            IF NOT b_has_pallet THEN
                cur_state := ST_SUPPLY_PALLET_B;
            ELSE
                cur_state := ST_WAIT_PICK_A;
            END_IF;
        END_IF;
        
    ST_SUPPLY_PALLET_B:
        IF X27 THEN
            pallet_pick_sent := TRUE;
            Y1C := TRUE;
            pallet_op_state := 1;
        ELSE
            cur_state := ST_SUPPLY_PALLET_B;
        END_IF;
        
        IF pallet_op_state = 1 AND X2A THEN
            pallet_op_state := 2;
        END_IF;
        
        IF pallet_op_state = 2 AND X2B THEN
            pallet_op_state := 3;
            Y1E := TRUE;
            D201 := 2;
            pallet_target_side := 2;
        END_IF;
        
        IF pallet_op_state = 3 AND X2C THEN
            Y1F := TRUE;
            pallet_op_state := 4;
        END_IF;
        
        IF pallet_op_state = 4 AND X18 THEN
            b_has_pallet := TRUE;
            pallet_op_state := 0;
            cur_state := ST_WAIT_PICK_A;
        END_IF;
        
    ST_WAIT_PICK_A:
        (* Check if A has pending layers *)
        IF a_placed < 3 AND X13 AND (a_pending > 0) THEN
            (* Set kind for pick *)
            D200 := a_layer_order[a_layer_idx];
            pick_pulse := TRUE;
            a_pending := a_pending - 1;
            fork_op_state := 0;
            cur_state := ST_WAIT_PLACE_A;
        ELSIF a_placed >= 3 THEN
            (* A is done stacking, check B *)
            IF b_placed < 4 AND b_pending > 0 AND X13 THEN
                D200 := b_layer_order[b_layer_idx];
                pick_pulse := TRUE;
                b_pending := b_pending - 1;
                cur_state := ST_WAIT_PLACE_B;
            ELSE
                cur_state := ST_WAIT_PICK_A;
            END_IF;
        ELSE
            cur_state := ST_WAIT_PICK_A;
        END_IF;
        
    ST_WAIT_PLACE_A:
        (* Wait for head to be free, then place on A *)
        IF NOT X12 AND place_clear_wait_a = FALSE THEN
            (* Wait for place clear *)
            place_clear_wait_a := TRUE;
        END_IF;
        
        IF place_clear_wait_a AND X25 THEN
            (* Place layer on A *)
            D200 := a_layer_order[a_layer_idx];
            D201 := 1;
            place_mm_val := a_top_height;
            D202 := place_mm_val;
            place_pulse := TRUE;
            place_clear_wait_a := FALSE;
            cur_state := ST_WAIT_PICK_A;
        END_IF;
        
    ST_WAIT_PICK_B:
        IF b_placed < 4 AND X13 AND (b_pending > 0) THEN
            D200 := b_layer_order[b_layer_idx];
            pick_pulse := TRUE;
            b_pending := b_pending - 1;
            cur_state := ST_WAIT_PLACE_B;
        ELSIF b_placed >= 4 THEN
            (* B done, try A *)
            IF a_placed < 3 AND a_pending > 0 AND X13 THEN
                D200 := a_layer_order[a_layer_idx];
                pick_pulse := TRUE;
                a_pending := a_pending - 1;
                cur_state := ST_WAIT_PLACE_A;
            ELSE
                cur_state := ST_WAIT_PICK_B;
            END_IF;
        ELSE
            cur_state := ST_WAIT_PICK_B;
        END_IF;
        
    ST_WAIT_PLACE_B:
        IF NOT X12 AND place_clear_wait_b = FALSE THEN
            place_clear_wait_b := TRUE;
        END_IF;
        
        IF place_clear_wait_b AND X26 THEN
            D200 := b_layer_order[b_layer_idx];
            D201 := 2;
            place_mm_val := b_top_height;
            D202 := place_mm_val;
            place_pulse := TRUE;
            place_clear_wait_b := FALSE;
            cur_state := ST_WAIT_PICK_B;
        END_IF;
        
    ST_TRANSFER_BUNDLE_A:
        (* Fork inserts into station A *)
        IF NOT X12 AND NOT X14 THEN
            D201 := 1;
            fork_insert_sent := TRUE;
            Y16 := TRUE;
            fork_op_state := 1;
        END_IF;
        
        (* After fork inserted, lift *)
        IF fork_op_state = 1 AND X15 THEN
            Y17 := TRUE;
            fork_op_state := 2;
        END_IF;
        
        (* Lower support A *)
        IF fork_op_state = 2 THEN
            D203 := 780;
            Y14 := TRUE;
            fork_op_state := 3;
        END_IF;
        
        (* Transfer to exit *)
        IF fork_op_state = 3 THEN
            Y18 := TRUE;
            fork_op_state := 4;
        END_IF;
        
        (* At exit, release *)
        IF fork_op_state = 4 AND X17 THEN
            Y19 := TRUE;
            fork_op_state := 5;
        END_IF;
        
        (* After release, fork goes home *)
        IF fork_op_state = 5 AND X18 THEN
            a_bundle_done := TRUE;
            bundle_done_count := bundle_done_count + 1;
            fork_op_state := 0;
            ack_pending := TRUE;
            
            IF b_bundle_done THEN
                cur_state := ST_ACK_AND_HOME;
            ELSE
                cur_state := ST_ACK_AND_HOME;
            END_IF;
        END_IF;
        
    ST_TRANSFER_BUNDLE_B:
        IF NOT X12 AND NOT X14 THEN
            D201 := 2;
            fork_insert_sent := TRUE;
            Y16 := TRUE;
            fork_op_state := 1;
        END_IF;
        
        IF fork_op_state = 1 AND X15 THEN
            Y17 := TRUE;
            fork_op_state := 2;
        END_IF;
        
        IF fork_op_state = 2 THEN
            D204 := 780;
            Y15 := TRUE;
            fork_op_state := 3;
        END_IF;
        
        IF fork_op_state = 3 THEN
            Y18 := TRUE;
            fork_op_state := 4;
        END_IF;
        
        IF fork_op_state = 4 AND X17 THEN
            Y19 := TRUE;
            fork_op_state := 5;
        END_IF;
        
        IF fork_op_state = 5 AND X18 THEN
            b_bundle_done := TRUE;
            bundle_done_count := bundle_done_count + 1;
            fork_op_state := 0;
            ack_pending := TRUE;
            
            IF a_bundle_done THEN
                cur_state := ST_ACK_AND_HOME;
            ELSE
                cur_state := ST_ACK_AND_HOME;
            END_IF;
        END_IF;
        
    ST_ACK_AND_HOME:
        IF ack_pending AND X19 THEN
            Y1A := TRUE;
            ack_pending := FALSE;
            ack_done := TRUE;
        END_IF;
        
        IF X18 AND ack_done AND NOT X12 AND NOT X14 THEN
            cur_state := ST_COMPLETE_WAIT;
        END_IF;
        
    ST_COMPLETE_WAIT:
        stable_timer(IN := TRUE, PT := T#500ms);
        IF stable_timer.Q THEN
            Y1B := TRUE;
            complete_set := TRUE;
            cur_state := ST_DONE;
        END_IF;
        
    ST_DONE:
        Y1B := TRUE;
        stable_timer(IN := TRUE, PT := T#500ms);
        
    END_CASE;
    
    (* Update layer counts based on placed signals and track layer index *)
    (* Track layer placement by monitoring D9/D10 changes *)
    IF place_pulse THEN
        IF D201 = 1 THEN
            a_layer_idx := a_layer_idx + 1;
            a_placed := a_placed + 1;
        ELSIF D201 = 2 THEN
            b_layer_idx := b_layer_idx + 1;
            b_placed := b_placed + 1;
        END_IF;
    END_IF;
    
    (* Check bundle completion *)
    IF NOT a_bundle_done AND a_placed >= 3 AND X25 THEN
        cur_state := ST_TRANSFER_BUNDLE_A;
    END_IF;
    
    IF NOT b_bundle_done AND b_placed >= 4 AND X26 THEN
        cur_state := ST_TRANSFER_BUNDLE_B;
    END_IF;
    
    (* Ensure complete stays asserted *)
    IF complete_set THEN
        Y1B := TRUE;
    END_IF;
    
END_PROGRAM