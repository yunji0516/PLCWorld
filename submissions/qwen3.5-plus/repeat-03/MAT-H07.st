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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;
    
    (* Edge detectors for rising edge signals *)
    edge_accept_a : R_TRIG;
    edge_accept_b : R_TRIG;
    edge_trim_b : R_TRIG;
    edge_ack_trim : R_TRIG;
    edge_accept_roll : R_TRIG;
    edge_cut_a : R_TRIG;
    edge_cut_b : R_TRIG;
    edge_eject : R_TRIG;
    edge_ack_exit : R_TRIG;
    edge_tape_cut : R_TRIG;
    edge_tape_apply : R_TRIG;
    
    (* Timers *)
    timer_core_stop : TON;
    timer_tape_hold : TON;
    
    (* State machine *)
    state : INT := 0;
    roll_number : INT := 0;
    a_accepted : BOOL := FALSE;
    b_accepted : BOOL := FALSE;
    b_prepared : BOOL := FALSE;
    target_reached : BOOL := FALSE;
    
    (* Target lengths for 3 rolls *)
    target_lengths : ARRAY[0..2] OF INT := [800, 1000, 700];
END_VAR

(* Update edge detectors for rising edge signals *)
edge_accept_a(CLK := X10);
edge_accept_b(CLK := X11);
edge_trim_b(CLK := Y15);
edge_ack_trim(CLK := X17);
edge_accept_roll(CLK := X19);
edge_cut_a(CLK := Y1C);
edge_cut_b(CLK := Y1D);
edge_eject(CLK := Y20);
edge_ack_exit(CLK := X22);
edge_tape_cut(CLK := Y27);
edge_tape_apply(CLK := Y28);

(* Main state machine *)
CASE state OF
    0: (* WAIT_START *)
        IF X0 THEN
            state := 1;
        END_IF;
        
    1: (* ACCEPT_WEBS *)
        Y10 := NOT a_accepted;
        Y11 := NOT b_accepted;
        IF X12 AND X13 THEN
            Y10 := FALSE;
            Y11 := FALSE;
            a_accepted := TRUE;
            b_accepted := TRUE;
            state := 2;
        END_IF;
        
    2: (* B_PREPARE *)
        (* Jog B to origin_b *)
        IF D2 < D0 THEN
            Y14 := TRUE;
        ELSE
            Y14 := FALSE;
        END_IF;
        
        (* After actual contact with hold_b, trim B *)
        IF X15 AND D2 = D0 THEN
            Y15 := TRUE;
        END_IF;
        
        IF X16 AND X17 THEN
            Y15 := FALSE;
            b_prepared := TRUE;
            state := 3;
        END_IF;
        
    3: (* WAIT_ROLL *)
        IF X18 THEN
            state := 4;
        END_IF;
        
    4: (* CORE_PREP *)
        (* Feed core only for rolls after the first *)
        IF roll_number > 0 THEN
            Y23 := TRUE;
        END_IF;
        
        IF X2C THEN
            Y23 := FALSE;
            Y24 := TRUE;
            timer_core_stop(IN := TRUE, PT := T#250ms);
        END_IF;
        
        IF timer_core_stop.Q THEN
            timer_core_stop(IN := FALSE);
            Y24 := FALSE;
        END_IF;
        
        IF X2D AND NOT timer_core_stop.Q THEN
            Y17 := TRUE;
        END_IF;
        
        IF X19 THEN
            Y17 := FALSE;
            state := 5;
        END_IF;
        
    5: (* WINDING *)
        IF X1E AND X1B AND X1C THEN
            Y1A := TRUE;
        END_IF;
        
        IF D6 >= target_lengths[roll_number] THEN
            Y1A := FALSE;
            target_reached := TRUE;
        END_IF;
        
        IF target_reached THEN
            IF NOT X1B AND NOT X1C THEN
                state := 6;
            END_IF;
        END_IF;
        
    6: (* CUT *)
        Y1C := TRUE;
        Y1D := TRUE;
        
        IF X29 AND X27 AND X28 THEN
            Y1C := FALSE;
            Y1D := FALSE;
            state := 7;
        END_IF;
        
    7: (* TAIL_WIND *)
        Y1A := TRUE;
        IF X26 THEN
            Y1A := FALSE;
            state := 8;
        END_IF;
        
    8: (* TAPE_PREPARE *)
        IF D9 >= 80 AND NOT X32 THEN
            Y25 := TRUE;
        END_IF;
        
        IF X2F THEN
            Y25 := FALSE;
            state := 9;
        END_IF;
        
    9: (* TAPE_HOLD *)
        Y26 := TRUE;
        timer_tape_hold(IN := Y26, PT := T#200ms);
        
        IF timer_tape_hold.Q THEN
            timer_tape_hold(IN := FALSE);
            Y26 := FALSE;
            state := 10;
        END_IF;
        
    10: (* TAPE_CUT *)
        IF X30 THEN
            Y27 := TRUE;
        END_IF;
        
        IF X31 THEN
            Y27 := FALSE;
            state := 11;
        END_IF;
        
    11: (* EXTEND_MANDREL *)
        Y1F := TRUE;
        
        IF X1E THEN
            Y1F := FALSE;
            state := 12;
        END_IF;
        
    12: (* TAPE_APPLY *)
        IF X1E AND D6 >= target_lengths[roll_number] AND X2F AND X30 THEN
            Y28 := TRUE;
        END_IF;
        
        IF X24 THEN
            Y28 := FALSE;
            state := 13;
        END_IF;
        
    13: (* RETRACT *)
        IF X1F AND X27 AND X28 THEN
            Y1E := TRUE;
        END_IF;
        
        IF X1D THEN
            Y1E := FALSE;
            state := 14;
        END_IF;
        
    14: (* EJECT *)
        Y20 := TRUE;
        
        IF X22 THEN
            Y20 := FALSE;
            state := 15;
        END_IF;
        
    15: (* EXIT_ACK *)
        Y21 := TRUE;
        
        IF X35 AND X21 THEN
            Y21 := FALSE;
            roll_number := roll_number + 1;
            IF roll_number < 3 THEN
                a_accepted := FALSE;
                b_accepted := FALSE;
                b_prepared := FALSE;
                target_reached := FALSE;
                state := 3;
            ELSE
                state := 16;
            END_IF;
        END_IF;
        
    16: (* COMPLETE *)
        Y22 := TRUE;
END_CASE;

END_PROGRAM