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
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    
    pos0_state : INT := 0;
    pos1_state : INT := 0;
    pos2_state : INT := 0;
    
    products_loaded : INT := 0;
    products_received : INT := 0;
    
    req1 : BOOL;
    req2 : BOOL;
    req3 : BOOL;
    req4 : BOOL;
    req5 : BOOL;
    can_move : BOOL;
    move_cmd : BOOL := FALSE;
    
    left_up_cond : BOOL;
    left_dn_cond : BOOL;
    right_up_cond : BOOL;
    right_dn_cond : BOOL;
    
    ack_trig : R_TRIG;
    is_complete : BOOL;
    comp_ton : TON;
END_VAR

(* Position 0 (Upper Left / Loading) State Machine *)
IF D0 == 0 THEN
    pos0_state := 0;
    Y10 := FALSE;
ELSIF D0 > 0 AND pos0_state == 0 THEN
    pos0_state := 1;
END_IF;

CASE pos0_state OF
    1:
        IF X17 AND X1F THEN
            IF D5 > 0 THEN
                pos0_state := 5;
            ELSE
                pos0_state := 2;
            END_IF;
        END_IF;
    2:
        IF X10 AND NOT X12 AND (products_loaded < 6) THEN
            Y10 := TRUE;
            pos0_state := 3;
        END_IF;
    3:
        IF X12 THEN
            Y10 := FALSE;
            products_loaded := products_loaded + 1;
            pos0_state := 4;
        END_IF;
    4:
        IF NOT X12 AND D5 > 0 THEN
            pos0_state := 5;
        END_IF;
    5:
        ; (* Ready for transfer to Pos 1 *)
END_CASE;

(* Position 1 (Upper Inspection) State Machine *)
IF D1 == 0 THEN
    pos1_state := 0;
    Y11 := FALSE;
ELSIF D1 > 0 AND pos1_state == 0 THEN
    pos1_state := 1;
END_IF;

CASE pos1_state OF
    1:
        IF D6 > 0 AND NOT X14 THEN
            D202 := 1;
            Y11 := TRUE;
            pos1_state := 2;
        END_IF;
    2:
        IF X14 THEN
            Y11 := FALSE;
            pos1_state := 3;
        END_IF;
    3:
        IF NOT X14 AND (D9 = D6) AND (D10 = 1) THEN
            pos1_state := 4;
        END_IF;
    4:
        ; (* Ready for transfer to Pos 2 *)
END_CASE;

(* Position 2 (Product Extraction) State Machine *)
IF D2 == 0 THEN
    pos2_state := 0;
    Y12 := FALSE;
ELSIF D2 > 0 AND pos2_state == 0 THEN
    pos2_state := 1;
END_IF;

CASE pos2_state OF
    1:
        IF D7 > 0 AND X15 AND NOT X13 THEN
            Y12 := TRUE;
            pos2_state := 2;
        END_IF;
    2:
        IF X13 THEN
            Y12 := FALSE;
            pos2_state := 3;
        END_IF;
    3:
        IF NOT X13 AND D7 == 0 THEN
            pos2_state := 4;
        END_IF;
    4:
        ; (* Ready for transfer to Pos 3 *)
END_CASE;

(* External Reception Acknowledgment and Counting *)
ack_trig(CLK := X16);
IF ack_trig.Q THEN
    products_received := products_received + 1;
END_IF;
Y18 := X16;

(* Lift Movement Control (Mutually Exclusive with Horizontal Transfer) *)
left_up_cond := (D0 > 0) AND NOT X17 AND X1F AND NOT X11 AND NOT move_cmd;
IF left_up_cond THEN
    Y14 := TRUE;
END_IF;
IF X17 THEN
    Y14 := FALSE;
END_IF;

left_dn_cond := (D0 == 0) AND NOT X18 AND NOT X11 AND NOT move_cmd;
IF left_dn_cond THEN
    Y15 := TRUE;
END_IF;
IF X18 THEN
    Y15 := FALSE;
END_IF;

right_up_cond := (D3 == 0) AND NOT X19 AND NOT X11 AND NOT move_cmd;
IF right_up_cond THEN
    Y16 := TRUE;
END_IF;
IF X19 THEN
    Y16 := FALSE;
END_IF;

right_dn_cond := (D3 > 0) AND NOT X1A AND X1E AND NOT X11 AND NOT move_cmd;
IF right_dn_cond THEN
    Y17 := TRUE;
END_IF;
IF X1A THEN
    Y17 := FALSE;
END_IF;

(* Horizontal Transfer Arbiter (Pull Priority) *)
req1 := (pos0_state = 5) AND (D1 = 0) AND X17 AND X1F;
req2 := (pos1_state = 4) AND (D2 = 0);
req3 := (pos2_state = 4) AND (D3 = 0) AND X19;
req4 := (D3 > 0) AND X1A AND X1E AND (D4 = 0);
req5 := (D4 > 0) AND (D0 = 0) AND X18;

can_move := NOT X11 AND NOT move_cmd AND NOT X1B AND NOT X1C AND 
            NOT Y14 AND NOT Y15 AND NOT Y16 AND NOT Y17;

IF can_move THEN
    IF req5 THEN
        D200 := D4;
        D201 := 0;
        move_cmd := TRUE;
    ELSIF req4 THEN
        D200 := D3;
        D201 := 4;
        move_cmd := TRUE;
    ELSIF req3 THEN
        D200 := D2;
        D201 := 3;
        move_cmd := TRUE;
    ELSIF req2 THEN
        D200 := D1;
        D201 := 2;
        move_cmd := TRUE;
    ELSIF req1 THEN
        D200 := D0;
        D201 := 1;
        move_cmd := TRUE;
    END_IF;
END_IF;

IF move_cmd AND X11 THEN
    move_cmd := FALSE;
END_IF;

Y13 := move_cmd;

(* Completion Declaration *)
is_complete := (D0 > 0) AND X17 AND X1F AND (D4 > 0) AND (products_received >= 6) AND 
               NOT X11 AND NOT X12 AND NOT X13 AND NOT X14 AND 
               NOT move_cmd AND NOT Y10 AND NOT Y11 AND NOT Y12 AND
               NOT Y14 AND NOT Y15 AND NOT Y16 AND NOT Y17 AND
               (pos0_state = 2) AND (pos1_state = 0) AND (pos2_state = 0);

comp_ton(IN := is_complete, PT := T#500ms);

IF comp_ton.Q THEN
    Y19 := TRUE;
END_IF;

END_PROGRAM