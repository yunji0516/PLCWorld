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
    
    products_loaded : INT := 0;
    products_received : INT := 0;
    jig_inspected : ARRAY[0..200] OF BOOL;
    
    lift_left_cmd : INT := 0;
    lift_right_cmd : INT := 0;
    
    load_state : INT := 0;
    inspect_state : INT := 0;
    unload_state : INT := 0;
    move_seq : INT := 0;
    
    ack_trig : R_TRIG;
    complete_ton : TON;
    is_completed : BOOL := FALSE;
    running : BOOL := FALSE;
    complete_cond : BOOL;
END_VAR

IF X0 THEN
    running := TRUE;
END_IF;

IF NOT running THEN
    RETURN;
END_IF;

(* Clear inspection flag when a jig returns to the starting position *)
IF D0 > 0 THEN
    jig_inspected[D0] := FALSE;
END_IF;

(* Left Lift Control *)
IF D0 > 0 THEN
    IF X18 AND X1F AND NOT X11 AND (move_seq = 0) THEN
        lift_left_cmd := 1;
    ELSIF X17 THEN
        lift_left_cmd := 0;
    END_IF;
ELSE
    IF X17 AND NOT X11 AND (move_seq = 0) THEN
        lift_left_cmd := -1;
    ELSIF X18 THEN
        lift_left_cmd := 0;
    END_IF;
END_IF;

IF lift_left_cmd = 1 THEN
    Y14 := TRUE; Y15 := FALSE;
ELSIF lift_left_cmd = -1 THEN
    Y14 := FALSE; Y15 := TRUE;
ELSE
    Y14 := FALSE; Y15 := FALSE;
END_IF;

(* Right Lift Control *)
IF D3 > 0 THEN
    IF X19 AND X1E AND NOT X11 AND (move_seq = 0) THEN
        lift_right_cmd := -1;
    ELSIF X1A THEN
        lift_right_cmd := 0;
    END_IF;
ELSE
    IF X1A AND NOT X11 AND (move_seq = 0) THEN
        lift_right_cmd := 1;
    ELSIF X19 THEN
        lift_right_cmd := 0;
    END_IF;
END_IF;

IF lift_right_cmd = 1 THEN
    Y16 := TRUE; Y17 := FALSE;
ELSIF lift_right_cmd = -1 THEN
    Y16 := FALSE; Y17 := TRUE;
ELSE
    Y16 := FALSE; Y17 := FALSE;
END_IF;

(* Load Product *)
CASE load_state OF
0:
    IF (D0 > 0) AND X17 AND X10 AND (D5 = 0) AND NOT X12 AND (products_loaded < 6) THEN
        Y10 := TRUE;
        products_loaded := products_loaded + 1;
        load_state := 1;
    END_IF;
1:
    IF X12 THEN
        Y10 := FALSE;
        load_state := 2;
    END_IF;
2:
    IF NOT X12 THEN
        load_state := 0;
    END_IF;
END_CASE;

(* Inspect Product *)
CASE inspect_state OF
0:
    IF (D1 > 0) AND (D6 > 0) AND NOT jig_inspected[D1] AND NOT X14 THEN
        Y11 := TRUE;
        D202 := D8;
        inspect_state := 1;
    END_IF;
1:
    IF X14 THEN
        Y11 := FALSE;
        inspect_state := 2;
    END_IF;
2:
    IF NOT X14 THEN
        jig_inspected[D1] := TRUE;
        inspect_state := 0;
    END_IF;
END_CASE;

(* Unload Product *)
CASE unload_state OF
0:
    IF (D2 > 0) AND (D7 > 0) AND X15 AND NOT X13 THEN
        Y12 := TRUE;
        unload_state := 1;
    END_IF;
1:
    IF X13 THEN
        Y12 := FALSE;
        unload_state := 2;
    END_IF;
2:
    IF NOT X13 THEN
        unload_state := 0;
    END_IF;
END_CASE;

(* Horizontal Transfer Engine *)
CASE move_seq OF
0:
    IF NOT X11 AND (lift_left_cmd = 0) AND (lift_right_cmd = 0) THEN
        IF (D0 > 0) AND X17 AND (D5 > 0) AND (D1 = 0) AND NOT X12 AND (load_state = 0) THEN
            D200 := D0; D201 := 1; Y13 := TRUE; move_seq := 1;
        ELSIF (D1 > 0) AND jig_inspected[D1] AND (D2 = 0) AND (inspect_state = 0) THEN
            D200 := D1; D201 := 2; Y13 := TRUE; move_seq := 1;
        ELSIF (D2 > 0) AND (D7 = 0) AND (D3 = 0) AND X19 AND NOT X13 AND (unload_state = 0) THEN
            D200 := D2; D201 := 3; Y13 := TRUE; move_seq := 1;
        ELSIF (D3 > 0) AND X1A AND (D4 = 0) THEN
            D200 := D3; D201 := 4; Y13 := TRUE; move_seq := 1;
        ELSIF (D4 > 0) AND X18 AND (D0 = 0) THEN
            D200 := D4; D201 := 0; Y13 := TRUE; move_seq := 1;
        END_IF;
    END_IF;
1:
    IF X11 THEN
        Y13 := FALSE;
        move_seq := 2;
    END_IF;
2:
    IF NOT X11 THEN
        move_seq := 0;
    END_IF;
END_CASE;

(* Product Reception Confirmation *)
ack_trig(CLK := X16);
IF ack_trig.Q THEN
    products_received := products_received + 1;
END_IF;
Y18 := X16;

(* Task Completion Observation *)
complete_cond := (D0 > 0) AND (D4 > 0) AND (products_received >= 6) AND 
                 NOT X11 AND NOT X12 AND NOT X13 AND NOT X14 AND 
                 (lift_left_cmd = 0) AND (lift_right_cmd = 0) AND (move_seq = 0) AND X17;

complete_ton(IN := complete_cond, PT := T#500ms);
IF complete_ton.Q THEN
    is_completed := TRUE;
END_IF;
Y19 := is_completed;

END_PROGRAM