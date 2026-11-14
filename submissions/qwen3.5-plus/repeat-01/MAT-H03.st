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
    
    start_edge : R_TRIG;
    move_busy_prev : BOOL := FALSE;
    
    j101_pos : INT := 0;
    j102_pos : INT := 4;
    j101_prod : BOOL := FALSE;
    j102_prod : BOOL := FALSE;
    j101_insp : BOOL := FALSE;
    j102_insp : BOOL := FALSE;
    
    loaded_cnt : INT := 0;
    received_cnt : INT := 0;
    
    move_cmd : BOOL := FALSE;
    admit_cmd : BOOL := FALSE;
    inspect_cmd : BOOL := FALSE;
    detach_cmd : BOOL := FALSE;
    ack_cmd : BOOL := FALSE;
    
    lift_l_up_req : BOOL := FALSE;
    lift_l_dn_req : BOOL := FALSE;
    lift_r_up_req : BOOL := FALSE;
    lift_r_dn_req : BOOL := FALSE;
    
    st : INT := 0;
    
    t_comp : TON;
END_VAR

start_edge(CLK := X0);

Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE;
Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
Y18 := FALSE; Y19 := FALSE;
D200 := 0; D201 := 0; D202 := 0;

IF st = 0 THEN
    IF start_edge.Q THEN
        st := 10;
    END_IF;
END_IF;

IF st = 10 THEN
    (* --- Left lift control --- *)
    IF NOT X11 THEN
        IF j101_pos = 0 AND X18 AND NOT lift_l_up_req AND NOT lift_l_dn_req THEN
            lift_l_up_req := TRUE;
        END_IF;
        IF lift_l_up_req THEN
            Y14 := TRUE;
            IF X17 THEN
                lift_l_up_req := FALSE;
            END_IF;
        END_IF;
    END_IF;
    
    (* --- Right lift control --- *)
    IF NOT X11 THEN
        IF j101_pos = 3 AND X19 AND NOT lift_r_dn_req AND NOT lift_r_up_req THEN
            lift_r_dn_req := TRUE;
        END_IF;
        IF lift_r_dn_req THEN
            Y17 := TRUE;
            IF X1A THEN
                lift_r_dn_req := FALSE;
            END_IF;
        END_IF;
    END_IF;
    
    (* --- Horizontal move arbitration (shared channel) --- *)
    IF NOT X11 AND NOT move_cmd THEN
        (* Jig 101 moves *)
        IF j101_pos = 0 AND j101_prod AND X17 AND NOT X11 AND NOT lift_l_up_req THEN
            D200 := 101; D201 := 1; Y13 := TRUE; move_cmd := TRUE;
        ELSIF j101_pos = 1 AND j101_insp AND NOT X11 THEN
            D200 := 101; D201 := 2; Y13 := TRUE; move_cmd := TRUE;
        ELSIF j101_pos = 2 AND NOT j101_prod AND NOT X13 AND NOT X11 THEN
            D200 := 101; D201 := 3; Y13 := TRUE; move_cmd := TRUE;
        ELSIF j101_pos = 3 AND X1A AND NOT lift_r_dn_req AND NOT X11 THEN
            D200 := 101; D201 := 4; Y13 := TRUE; move_cmd := TRUE;
        ELSIF j101_pos = 4 AND NOT X11 AND NOT lift_l_up_req AND NOT lift_l_dn_req THEN
            D200 := 101; D201 := 0; Y13 := TRUE; move_cmd := TRUE;
        (* Jig 102 moves *)
        ELSIF j102_pos = 4 AND NOT X11 AND NOT lift_l_up_req AND NOT lift_l_dn_req THEN
            D200 := 102; D201 := 0; Y13 := TRUE; move_cmd := TRUE;
        ELSIF j102_pos = 0 AND j102_prod AND X17 AND NOT X11 AND NOT lift_l_up_req THEN
            D200 := 102; D201 := 1; Y13 := TRUE; move_cmd := TRUE;
        ELSIF j102_pos = 1 AND j102_insp AND NOT X11 THEN
            D200 := 102; D201 := 2; Y13 := TRUE; move_cmd := TRUE;
        ELSIF j102_pos = 2 AND NOT j102_prod AND NOT X13 AND NOT X11 THEN
            D200 := 102; D201 := 3; Y13 := TRUE; move_cmd := TRUE;
        ELSIF j102_pos = 3 AND X1A AND NOT lift_r_dn_req AND NOT X11 THEN
            D200 := 102; D201 := 4; Y13 := TRUE; move_cmd := TRUE;
        END_IF;
    ELSIF X11 THEN
        move_busy_prev := TRUE;
    ELSIF move_busy_prev AND NOT X11 THEN
        move_busy_prev := FALSE;
        move_cmd := FALSE;
        IF D200 = 101 THEN j101_pos := D201; END_IF;
        IF D200 = 102 THEN j102_pos := D201; END_IF;
    END_IF;
    
    (* --- Product loading at pos 0 --- *)
    IF j101_pos = 0 AND NOT j101_prod AND X10 AND X17 AND NOT admit_cmd AND NOT X12 THEN
        Y10 := TRUE; admit_cmd := TRUE;
    END_IF;
    IF j102_pos = 0 AND NOT j102_prod AND X10 AND X17 AND NOT admit_cmd AND NOT X12 THEN
        Y10 := TRUE; admit_cmd := TRUE;
    END_IF;
    IF admit_cmd AND NOT X12 THEN
        admit_cmd := FALSE;
        IF j101_pos = 0 AND NOT j101_prod THEN
            j101_prod := TRUE; loaded_cnt := loaded_cnt + 1;
        ELSIF j102_pos = 0 AND NOT j102_prod THEN
            j102_prod := TRUE; loaded_cnt := loaded_cnt + 1;
        END_IF;
    END_IF;
    
    (* --- Inspection at pos 1 --- *)
    IF j101_pos = 1 AND j101_prod AND NOT j101_insp AND NOT inspect_cmd AND NOT X14 THEN
        Y11 := TRUE; D202 := D8; inspect_cmd := TRUE;
    END_IF;
    IF j102_pos = 1 AND j102_prod AND NOT j102_insp AND NOT inspect_cmd AND NOT X14 THEN
        Y11 := TRUE; D202 := D8; inspect_cmd := TRUE;
    END_IF;
    IF inspect_cmd AND NOT X14 THEN
        inspect_cmd := FALSE;
        IF j101_pos = 1 AND j101_prod AND NOT j101_insp THEN
            j101_insp := TRUE;
        ELSIF j102_pos = 1 AND j102_prod AND NOT j102_insp THEN
            j102_insp := TRUE;
        END_IF;
    END_IF;
    
    (* --- Extraction at pos 2 --- *)
    IF j101_pos = 2 AND j101_prod AND j101_insp AND X15 AND NOT detach_cmd AND NOT X13 THEN
        Y12 := TRUE; detach_cmd := TRUE;
    END_IF;
    IF j102_pos = 2 AND j102_prod AND j102_insp AND X15 AND NOT detach_cmd AND NOT X13 THEN
        Y12 := TRUE; detach_cmd := TRUE;
    END_IF;
    IF detach_cmd AND NOT X13 THEN
        detach_cmd := FALSE;
        IF j101_pos = 2 AND j101_prod THEN
            j101_prod := FALSE; j101_insp := FALSE;
        ELSIF j102_pos = 2 AND j102_prod THEN
            j102_prod := FALSE; j102_insp := FALSE;
        END_IF;
    END_IF;
    
    (* --- Left lift up for jig returning from pos 4 --- *)
    IF NOT X11 AND NOT lift_l_up_req AND NOT lift_l_dn_req THEN
        IF (j101_pos = 0 OR j102_pos = 0) AND X18 THEN
            lift_l_up_req := TRUE;
        END_IF;
    END_IF;
    
    (* --- Exit confirmation --- *)
    IF X16 AND NOT ack_cmd THEN
        Y18 := TRUE; ack_cmd := TRUE;
        received_cnt := received_cnt + 1;
    END_IF;
    IF NOT X16 THEN
        ack_cmd := FALSE;
    END_IF;
    
    (* --- Completion check --- *)
    IF loaded_cnt >= 6 AND received_cnt >= 6 THEN
        IF j101_pos = 0 AND X17 AND j102_pos = 4 AND X1A THEN
            IF NOT X11 AND NOT X12 AND NOT X13 AND NOT X14 AND NOT Y14 AND NOT Y15 AND NOT Y16 AND NOT Y17 AND NOT lift_l_up_req AND NOT lift_r_dn_req THEN
                Y19 := TRUE;
                t_comp(IN := TRUE, PT := T#500ms);
                IF t_comp.Q THEN
                    st := 100;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
END_IF;

IF st = 100 THEN
    Y19 := TRUE;
END_IF;

END_PROGRAM