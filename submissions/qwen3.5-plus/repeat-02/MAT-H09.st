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
    
    (* Internal state *)
    a_state : INT := 0;
    b_state : INT := 0;
    sys_run : BOOL := FALSE;
    
    (* Tank management *)
    refill_on : BOOL := FALSE;
    swap_trig : BOOL := FALSE;
    prev_brdy : BOOL := TRUE;
    
    (* Flags *)
    a_cap_req : BOOL := FALSE;
    b_cap_req : BOOL := FALSE;
    a_out_issued : BOOL := FALSE;
    b_out_issued : BOOL := FALSE;
    a_rel_issued : BOOL := FALSE;
    b_rel_issued : BOOL := FALSE;
    
    (* Timers *)
    ta_vo : TON;
    ta_vc : TON;
    ta_res : TON;
    ta_nd : TON;
    ta_nu : TON;
    ta_cl : TON;
    ta_ot : TON;
    ta_rl : TON;
    tb_vo : TON;
    tb_vc : TON;
    tb_res : TON;
    tb_nd : TON;
    tb_nu : TON;
    tb_cl : TON;
    tb_ot : TON;
    tb_rl : TON;
    t_swap : TON;
    t_comp : TON;
    
    (* Edge *)
    e_start : R_TRIG;
    
    (* Completion *)
    comp_asserted : BOOL := FALSE;
END_VAR

(* Start detection *)
e_start(CLK := X0);
IF e_start.Q THEN
    sys_run := TRUE;
END_IF;

IF NOT sys_run THEN
    Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE;
    Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
    Y18 := FALSE; Y19 := FALSE;
    Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE;
    Y1E := FALSE; Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE;
    RETURN;
END_IF;

(* ============================= *)
(* Tank management               *)
(* ============================= *)

(* Refill when tank low, batch available, no swap pending *)
IF D0 < 800 AND X31 AND X2F AND NOT swap_trig THEN
    refill_on := TRUE;
END_IF;
IF D0 >= 1400 OR NOT X2F THEN
    refill_on := FALSE;
END_IF;
Y10 := refill_on;

(* Swap on batch_ready falling edge, only if not refilling and tank low *)
IF prev_brdy AND NOT X2F AND NOT Y10 AND D0 <= 100 AND X31 THEN
    swap_trig := TRUE;
END_IF;
prev_brdy := X2F;

IF swap_trig THEN
    t_swap(IN := TRUE, PT := T#2500ms);
    Y11 := TRUE;
    IF t_swap.Q THEN
        Y11 := FALSE;
        t_swap(IN := FALSE, PT := T#2500ms);
        swap_trig := FALSE;
    END_IF;
ELSE
    Y11 := FALSE;
    t_swap(IN := FALSE, PT := T#2500ms);
END_IF;

(* ============================= *)
(* Line A state machine          *)
(* ============================= *)

CASE a_state OF
    0: (* IDLE - wait for container in queue or source *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE;
        Y17 := FALSE; Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        a_cap_req := FALSE; a_out_issued := FALSE; a_rel_issued := FALSE;
        IF D8 > 0 OR X11 THEN
            a_state := 1;
        END_IF;

    1: (* FEED container to station *)
        Y14 := NOT X10;
        IF X10 THEN
            a_state := 2;
        END_IF;

    2: (* CLAMP *)
        Y15 := TRUE;
        ta_cl(IN := TRUE, PT := T#250ms);
        IF ta_cl.Q AND X14 THEN
            Y15 := FALSE;
            a_state := 3;
        END_IF;

    3: (* NOZZLE DOWN *)
        Y16 := TRUE;
        ta_nd(IN := TRUE, PT := T#700ms);
        IF ta_nd.Q AND X13 THEN
            Y16 := FALSE;
            a_state := 4;
        END_IF;

    4: (* VALVE OPEN, wait for actual open *)
        Y17 := TRUE;
        ta_vo(IN := TRUE, PT := T#150ms);
        IF ta_vo.Q OR X16 THEN
            a_state := 5;
        END_IF;

    5: (* PUMP - fill until near goal *)
        Y17 := TRUE;
        Y18 := TRUE;
        IF D4 >= D5 - 150 AND D0 >= 100 THEN
            Y18 := FALSE;
            ta_res(IN := TRUE, PT := T#1800ms);
            a_state := 6;
        END_IF;

    6: (* RESIDUE WAIT - valve stays open, residue flows *)
        Y17 := TRUE;
        Y18 := FALSE;
        IF ta_res.Q THEN
            Y17 := FALSE;
            ta_vc(IN := TRUE, PT := T#500ms);
            a_state := 7;
        END_IF;

    7: (* VALVE CLOSED WAIT *)
        Y17 := FALSE;
        Y18 := FALSE;
        IF ta_vc.Q OR X17 THEN
            a_state := 8;
        END_IF;

    8: (* NOZZLE UP *)
        Y16 := FALSE;
        Y17 := FALSE;
        ta_nu(IN := TRUE, PT := T#700ms);
        IF ta_nu.Q AND X12 THEN
            a_state := 9;
        END_IF;

    9: (* UNCLAMP *)
        Y15 := FALSE;
        Y16 := FALSE;
        IF NOT X14 THEN
            a_state := 10;
        END_IF;

    10: (* OUT - send to cap waiting position *)
        Y19 := NOT X1A;
        ta_ot(IN := TRUE, PT := T#2000ms);
        IF X1A THEN
            Y19 := FALSE;
            a_out_issued := TRUE;
            a_state := 11;
        END_IF;

    11: (* WAIT FOR CAPPED - request capping *)
        Y19 := FALSE;
        IF X1A AND NOT X1B AND NOT a_cap_req AND NOT X2C THEN
            Y12 := TRUE;
            a_cap_req := TRUE;
        ELSIF a_cap_req THEN
            Y12 := FALSE;
        END_IF;
        IF a_cap_req AND (X1B OR NOT X1A) THEN
            a_cap_req := FALSE;
            a_state := 12;
        END_IF;

    12: (* RELEASE to exit *)
        Y12 := FALSE;
        Y19 := FALSE;
        IF X1B AND X1C AND NOT a_rel_issued THEN
            Y1A := TRUE;
            a_rel_issued := TRUE;
            ta_rl(IN := TRUE, PT := T#3000ms);
        END_IF;
        IF a_rel_issued AND (ta_rl.Q OR NOT X1B) THEN
            Y1A := FALSE;
            a_state := 13;
        END_IF;

    13: (* CHECK NEXT CONTAINER *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE;
        Y17 := FALSE; Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF D8 > 0 OR X11 THEN
            a_state := 0;
        ELSE
            a_state := 14;
        END_IF;

    14: (* LINE DONE *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE;
        Y17 := FALSE; Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;

    ELSE
        a_state := 0;
END_CASE;

(* ============================= *)
(* Line B state machine          *)
(* ============================= *)

CASE b_state OF
    20: (* IDLE *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE;
        Y1E := FALSE; Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        b_cap_req := FALSE; b_out_issued := FALSE; b_rel_issued := FALSE;
        IF D13 > 0 OR X1F THEN
            b_state := 21;
        END_IF;

    21: (* FEED *)
        Y1B := NOT X1E;
        IF X1E THEN
            b_state := 22;
        END_IF;

    22: (* CLAMP *)
        Y1C := TRUE;
        tb_cl(IN := TRUE, PT := T#250ms);
        IF tb_cl.Q AND X22 THEN
            Y1C := FALSE;
            b_state := 23;
        END_IF;

    23: (* NOZZLE DOWN *)
        Y1D := TRUE;
        tb_nd(IN := TRUE, PT := T#700ms);
        IF tb_nd.Q AND X21 THEN
            Y1D := FALSE;
            b_state := 24;
        END_IF;

    24: (* VALVE OPEN *)
        Y1E := TRUE;
        tb_vo(IN := TRUE, PT := T#150ms);
        IF tb_vo.Q OR X24 THEN
            b_state := 25;
        END_IF;

    25: (* PUMP *)
        Y1E := TRUE;
        Y1F := TRUE;
        IF D9 >= D10 - 150 AND D0 >= 100 THEN
            Y1F := FALSE;
            tb_res(IN := TRUE, PT := T#1800ms);
            b_state := 26;
        END_IF;

    26: (* RESIDUE WAIT *)
        Y1E := TRUE;
        Y1F := FALSE;
        IF tb_res.Q THEN
            Y1E := FALSE;
            tb_vc(IN := TRUE, PT := T#500ms);
            b_state := 27;
        END_IF;

    27: (* VALVE CLOSED WAIT *)
        Y1E := FALSE;
        Y1F := FALSE;
        IF tb_vc.Q OR X25 THEN
            b_state := 28;
        END_IF;

    28: (* NOZZLE UP *)
        Y1D := FALSE;
        Y1E := FALSE;
        tb_nu(IN := TRUE, PT := T#700ms);
        IF tb_nu.Q AND X20 THEN
            b_state := 29;
        END_IF;

    29: (* UNCLAMP *)
        Y1C := FALSE;
        Y1D := FALSE;
        IF NOT X22 THEN
            b_state := 30;
        END_IF;

    30: (* OUT to cap position *)
        Y20 := NOT X28;
        tb_ot(IN := TRUE, PT := T#2000ms);
        IF X28 THEN
            Y20 := FALSE;
            b_out_issued := TRUE;
            b_state := 31;
        END_IF;

    31: (* WAIT CAPPED *)
        Y20 := FALSE;
        IF X28 AND NOT X29 AND NOT b_cap_req AND NOT X2C THEN
            Y13 := TRUE;
            b_cap_req := TRUE;
        ELSIF b_cap_req THEN
            Y13 := FALSE;
        END_IF;
        IF b_cap_req AND (X29 OR NOT X28) THEN
            b_cap_req := FALSE;
            b_state := 32;
        END_IF;

    32: (* RELEASE *)
        Y13 := FALSE;
        Y20 := FALSE;
        IF X29 AND X2A AND NOT b_rel_issued THEN
            Y21 := TRUE;
            b_rel_issued := TRUE;
            tb_rl(IN := TRUE, PT := T#3000ms);
        END_IF;
        IF b_rel_issued AND (tb_rl.Q OR NOT X29) THEN
            Y21 := FALSE;
            b_state := 33;
        END_IF;

    33: (* CHECK NEXT *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE;
        Y1E := FALSE; Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF D13 > 0 OR X1F THEN
            b_state := 20;
        ELSE
            b_state := 34;
        END_IF;

    34: (* LINE DONE *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE;
        Y1E := FALSE; Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;

    ELSE
        b_state := 20;
END_CASE;

(* ============================= *)
(* Completion check              *)
(* ============================= *)

IF a_state = 14 AND b_state = 34 AND NOT Y10 AND NOT Y11
   AND NOT Y18 AND NOT Y1F AND NOT Y17 AND NOT Y1E
   AND X12 AND X20 AND NOT X2C AND X32 THEN
    t_comp(IN := TRUE, PT := T#500ms);
    IF t_comp.Q THEN
        Y22 := TRUE;
        comp_asserted := TRUE;
    END_IF;
ELSE
    t_comp(IN := FALSE, PT := T#500ms);
    IF NOT t_comp.Q THEN
        Y22 := FALSE;
    END_IF;
    comp_asserted := FALSE;
END_IF;

END_PROGRAM