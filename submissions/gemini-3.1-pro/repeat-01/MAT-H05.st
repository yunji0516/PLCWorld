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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    init_done : BOOL := FALSE;
    p0 : INT := 0;
    p1 : INT := 1;
    p2 : INT := 2;
    p3 : INT := 3;
    pocket_has_body : ARRAY[0..3] OF BOOL;
    pocket_has_insert : ARRAY[0..3] OF BOOL;
    pocket_generation : ARRAY[0..3] OF INT;
    pocket_inspection_done : ARRAY[0..3] OF BOOL;
    
    turn_state : INT := 0;
    st_pos0 : INT := 0;
    st_pos1 : INT := 0;
    st_pos2 : INT := 0;
    st_pos3 : INT := 0;
    rework_state : INT := 0;
    exit_state : INT := 0;
    
    pos0_ready : BOOL;
    pos1_ready : BOOL;
    pos2_ready : BOOL;
    pos3_ready : BOOL;
    
    good_parts_count : INT := 0;
    complete_cond : BOOL;
END_VAR

IF NOT init_done THEN
    pocket_generation[0] := 1;
    pocket_generation[1] := 1;
    pocket_generation[2] := 1;
    pocket_generation[3] := 1;
    Y17 := TRUE;
    init_done := TRUE;
END_IF;

(* Rework Logic *)
IF rework_state = 0 THEN
    IF X20 AND X24 AND X1B AND NOT X25 THEN
        Y1B := TRUE;
        rework_state := 1;
    END_IF;
ELSIF rework_state = 1 THEN
    Y1B := FALSE;
    IF X26 THEN
        Y1C := TRUE;
        rework_state := 2;
    END_IF;
ELSIF rework_state = 2 THEN
    IF X27 AND NOT X25 THEN
        Y1D := TRUE;
        rework_state := 3;
    END_IF;
ELSIF rework_state = 3 THEN
    Y1D := FALSE;
    IF X28 AND NOT X25 THEN
        Y1E := TRUE;
        rework_state := 4;
    END_IF;
ELSIF rework_state = 4 THEN
    Y1E := FALSE;
    IF X29 THEN
        Y1C := FALSE;
        rework_state := 5;
    END_IF;
ELSIF rework_state = 5 THEN
    IF NOT X27 AND X2A THEN
        rework_state := 6;
    END_IF;
END_IF;

(* Exit Transport Logic *)
IF exit_state = 0 THEN
    IF X20 AND NOT X24 AND X1B THEN
        exit_state := 1;
    END_IF;
ELSIF exit_state = 1 THEN
    IF X1D AND NOT X1E THEN
        Y16 := TRUE;
        exit_state := 2;
    END_IF;
ELSIF exit_state = 2 THEN
    Y16 := FALSE;
    IF X1E THEN
        Y19 := TRUE;
        exit_state := 3;
        good_parts_count := good_parts_count + 1;
    END_IF;
ELSIF exit_state = 3 THEN
    Y19 := FALSE;
    IF NOT X1E THEN
        exit_state := 0;
    END_IF;
END_IF;

(* Position 0: Load or Return Body *)
IF st_pos0 = 0 THEN
    IF X19 AND turn_state = 0 AND NOT pocket_has_body[p0] THEN
        IF rework_state = 6 THEN
            Y1F := TRUE;
            st_pos0 := 5;
        ELSIF X10 AND NOT X11 THEN
            Y10 := TRUE;
            st_pos0 := 1;
        END_IF;
    END_IF;
ELSIF st_pos0 = 1 THEN
    Y10 := FALSE;
    IF X14 THEN
        st_pos0 := 2;
    END_IF;
ELSIF st_pos0 = 2 THEN
    IF NOT X14 THEN
        pocket_has_body[p0] := TRUE;
        pocket_has_insert[p0] := FALSE;
        pocket_generation[p0] := 1;
        pocket_inspection_done[p0] := FALSE;
        st_pos0 := 0;
    END_IF;
ELSIF st_pos0 = 5 THEN
    Y1F := FALSE;
    IF NOT X26 THEN
        pocket_has_body[p0] := TRUE;
        pocket_has_insert[p0] := TRUE;
        pocket_generation[p0] := pocket_generation[p0] + 1;
        pocket_inspection_done[p0] := FALSE;
        rework_state := 0;
        st_pos0 := 0;
    END_IF;
END_IF;

(* Position 1: Insert *)
IF st_pos1 = 0 THEN
    IF X19 AND turn_state = 0 AND pocket_has_body[p1] AND NOT pocket_has_insert[p1] THEN
        IF X12 THEN
            Y11 := TRUE;
            st_pos1 := 1;
        END_IF;
    END_IF;
ELSIF st_pos1 = 1 THEN
    Y11 := FALSE;
    IF X13 THEN
        Y12 := TRUE;
        st_pos1 := 2;
    END_IF;
ELSIF st_pos1 = 2 THEN
    Y12 := FALSE;
    IF X21 THEN
        pocket_has_insert[p1] := TRUE;
        st_pos1 := 0;
    END_IF;
END_IF;

(* Position 2: Inspect *)
IF st_pos2 = 0 THEN
    IF X19 AND turn_state = 0 AND pocket_has_body[p2] AND pocket_has_insert[p2] AND NOT pocket_inspection_done[p2] THEN
        D200 := pocket_generation[p2];
        Y13 := TRUE;
        st_pos2 := 1;
    END_IF;
ELSIF st_pos2 = 1 THEN
    Y13 := FALSE;
    IF X16 THEN
        st_pos2 := 2;
    END_IF;
ELSIF st_pos2 = 2 THEN
    IF NOT X16 AND X22 THEN
        pocket_inspection_done[p2] := TRUE;
        st_pos2 := 0;
    END_IF;
END_IF;

(* Position 3: Eject *)
IF st_pos3 = 0 THEN
    IF X19 AND turn_state = 0 AND pocket_has_body[p3] AND pocket_inspection_done[p3] THEN
        IF X1B THEN
            Y14 := TRUE;
            Y15 := FALSE;
            st_pos3 := 1;
        END_IF;
    END_IF;
ELSIF st_pos3 = 1 THEN
    IF X1C THEN
        pocket_has_body[p3] := FALSE;
        pocket_has_insert[p3] := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        st_pos3 := 2;
    END_IF;
ELSIF st_pos3 = 2 THEN
    IF X1B THEN
        Y15 := FALSE;
        st_pos3 := 0;
    END_IF;
END_IF;

(* Table Rotation Logic *)
pos0_ready := FALSE;
IF pocket_has_body[p0] THEN
    pos0_ready := TRUE;
ELSIF X11 AND rework_state = 0 AND NOT (X20 AND X24) THEN
    pos0_ready := TRUE;
END_IF;

pos1_ready := NOT pocket_has_body[p1] OR pocket_has_insert[p1];
pos2_ready := NOT pocket_has_body[p2] OR pocket_inspection_done[p2];
pos3_ready := NOT pocket_has_body[p3];

IF turn_state = 0 THEN
    IF pos0_ready AND pos1_ready AND pos2_ready AND pos3_ready AND X1B AND X19 AND 
       st_pos0 = 0 AND st_pos1 = 0 AND st_pos2 = 0 AND st_pos3 = 0 AND good_parts_count < 6 THEN
        Y17 := FALSE;
        turn_state := 1;
    END_IF;
ELSIF turn_state = 1 THEN
    IF X1A THEN
        Y18 := TRUE;
        turn_state := 2;
    END_IF;
ELSIF turn_state = 2 THEN
    Y18 := FALSE;
    IF X18 THEN
        turn_state := 3;
    END_IF;
ELSIF turn_state = 3 THEN
    IF NOT X18 THEN
        Y17 := TRUE;
        turn_state := 4;
    END_IF;
ELSIF turn_state = 4 THEN
    IF X19 THEN
        p0 := (p0 + 3) MOD 4;
        p1 := (p1 + 3) MOD 4;
        p2 := (p2 + 3) MOD 4;
        p3 := (p3 + 3) MOD 4;
        turn_state := 0;
    END_IF;
END_IF;

(* Completion Check *)
complete_cond := (good_parts_count = 6) AND (turn_state = 0) AND 
                 (st_pos0 = 0) AND (st_pos1 = 0) AND (st_pos2 = 0) AND (st_pos3 = 0) AND 
                 (exit_state = 0) AND (rework_state = 0) AND X1B AND X19 AND NOT X26 AND NOT X20;

IF complete_cond THEN
    Y1A := TRUE;
END_IF;

END_PROGRAM