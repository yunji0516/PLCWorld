PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;

    start_triggered : BOOL := FALSE;
    materials_loaded : INT := 0;
    left_loaded : INT := 0;
    right_loaded : INT := 0;
    loading_left : BOOL := FALSE;
    loading_right : BOOL := FALSE;
    depart_triggered : BOOL := FALSE;
    index : INT;
    balances : ARRAY[1..6] OF INT;
    selected_materials : ARRAY[1..4] OF INT;
    
    rtrig_start : R_TRIG;
    ton_placement : TON;
    ton_depart : TON;
END_VAR

// Initialize balance combinations
balances[1] := D20 + D21; // Option 1: Material 1 & 2 on left
balances[2] := D20 + D22; // Option 2: Material 1 & 3 on left
balances[3] := D20 + D23; // Option 3: Material 1 & 4 on left
balances[4] := D21 + D22; // Option 4: Material 2 & 3 on left
balances[5] := D21 + D23; // Option 5: Material 2 & 4 on left
balances[6] := D22 + D23; // Option 6: Material 3 & 4 on left

rtrig_start(CLK := X10);
ton_placement(IN := loading_left OR loading_right, PT := T#500ms);
ton_depart(IN := depart_triggered, PT := T#2000ms);

IF rtrig_start.Q THEN
    start_triggered := TRUE;
    index := 1;
END_IF

IF start_triggered AND (materials_loaded < 4) THEN
    // Check left-right loading balance
    FOR i := 1 TO 6 DO
        IF ABS(balances[i] - (D20 + D21 + D22 + D23 - balances[i])) <= 1 THEN
            // Assign materials to left and right according to balance option
            CASE i OF
                1: (* w1, w2 on left, w3, w4 on right *)
                    selected_materials[1] := D20; selected_materials[2] := D21;
                    selected_materials[3] := D22; selected_materials[4] := D23;
                2: (* w1, w3 on left, w2, w4 on right *)
                    selected_materials[1] := D20; selected_materials[2] := D22;
                    selected_materials[3] := D21; selected_materials[4] := D23;
                3: (* w1, w4 on left, w2, w3 on right *)
                    selected_materials[1] := D20; selected_materials[2] := D23;
                    selected_materials[3] := D21; selected_materials[4] := D22;
                4: (* w2, w3 on left, w1, w4 on right *)
                    selected_materials[1] := D21; selected_materials[2] := D22;
                    selected_materials[3] := D20; selected_materials[4] := D23;
                5: (* w2, w4 on left, w1, w3 on right *)
                    selected_materials[1] := D21; selected_materials[2] := D23;
                    selected_materials[3] := D20; selected_materials[4] := D22;
                6: (* w3, w4 on left, w1, w2 on right *)
                    selected_materials[1] := D22; selected_materials[2] := D23;
                    selected_materials[3] := D20; selected_materials[4] := D21;
            END_CASE;
            EXIT;
        END_IF
    END_FOR
    // Assign materials to be loaded based on index
    IF index <= 2 THEN
        IF X20 AND NOT loading_left THEN
            loading_left := TRUE;
            Y20 := TRUE;
        END_IF
    ELSE
        IF X20 AND NOT loading_right THEN
            loading_right := TRUE;
            Y21 := TRUE;
        END_IF
    END_IF
ENDIF

IF ton_placement.Q THEN
    IF loading_left AND X21 THEN
        left_loaded := left_loaded + 1;
        materials_loaded := materials_loaded + 1;
        loading_left := FALSE;
        Y20 := FALSE;
    END_IF
    IF loading_right AND X21 THEN
        right_loaded := right_loaded + 1;
        materials_loaded := materials_loaded + 1;
        loading_right := FALSE;
        Y21 := FALSE;
    END_IF
    index := index + 1;
ENDIF

IF materials_loaded = 4 AND NOT X23 THEN
    depart_triggered := TRUE;
    Y22 := TRUE;
END_IF

IF ton_depart.Q AND X23 THEN
    depart_triggered := FALSE;
    Y22 := FALSE;
    Y2 := TRUE; // Completion claim
END_IF

END_PROGRAM