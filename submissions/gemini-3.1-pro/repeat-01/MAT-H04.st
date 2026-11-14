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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
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
    
    p_state : INT;
    c_state : INT;
    i_state : INT;
    insert_done : BOOL;
    sep_timer : TON;
    target_id : INT;
    bit_mask : WORD;
END_VAR

IF X0 THEN
    IF p_state = 0 THEN p_state := 1; END_IF;
    IF c_state = 0 THEN c_state := 1; END_IF;
END_IF;

(* Pouch Module State Machine *)
CASE p_state OF
1:
    IF X10 THEN
        IF X20 AND NOT X21 THEN
            p_state := 10;
        ELSIF X23 THEN
            p_state := 2;
        END_IF;
    END_IF;
10:
    Y1B := TRUE;
    sep_timer(IN:=TRUE, PT:=T#250ms);
    IF sep_timer.Q THEN
        Y1C := TRUE;
        p_state := 11;
    END_IF;
11:
    Y1B := TRUE;
    sep_timer(IN:=TRUE, PT:=T#250ms);
    IF X21 THEN
        Y1C := FALSE;
        p_state := 12;
    END_IF;
12:
    Y1B := TRUE;
    IF NOT X21 THEN
        Y1B := FALSE;
        p_state := 1;
    END_IF;
2:
    Y10 := TRUE;
    IF X11 THEN
        Y10 := FALSE;
        p_state := 3;
    END_IF;
3:
    Y15 := TRUE;
    IF X13 THEN
        p_state := 4;
    END_IF;
4:
    Y15 := TRUE;
    Y12 := TRUE;
    Y13 := TRUE;
    Y14 := TRUE;
    IF insert_done THEN
        p_state := 5;
    END_IF;
5:
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    IF NOT X13 AND NOT X11 THEN
        p_state := 1;
    END_IF;
END_CASE;

IF p_state <> 10 AND p_state <> 11 THEN
    sep_timer(IN:=FALSE, PT:=T#250ms);
END_IF;

(* Content Module State Machine *)
CASE c_state OF
1:
    target_id := 0;
    IF D0 > 0 THEN
        target_id := D0;
    ELSIF D1 > 0 THEN
        target_id := D1;
    END_IF;

    IF target_id >= 1 AND target_id <= 4 AND D2 = 0 THEN
        bit_mask := WORD#0;
        IF target_id = 1 THEN bit_mask := WORD#1; END_IF;
        IF target_id = 2 THEN bit_mask := WORD#2; END_IF;
        IF target_id = 3 THEN bit_mask := WORD#4; END_IF;
        IF target_id = 4 THEN bit_mask := WORD#8; END_IF;

        IF (AND_WORD(INT_TO_WORD(D4), bit_mask) <> WORD#0) THEN
            D200 := target_id;
            Y11 := TRUE;
            c_state := 2;
        END_IF;
    END_IF;
2:
    IF X14 OR X15 THEN
        Y11 := FALSE;
    END_IF;
    IF X15 THEN
        c_state := 3;
    END_IF;
3:
    Y1D := TRUE;
    Y1E := TRUE;
    IF X24 THEN
        c_state := 4;
    END_IF;
4:
    Y1D := FALSE;
    Y1E := FALSE;
    IF X25 THEN
        c_state := 5;
    END_IF;
5:
    IF insert_done THEN
        c_state := 6;
    END_IF;
6:
    IF D2 = 0 THEN
        c_state := 1;
    END_IF;
END_CASE;

(* Insertion and Release Module State Machine *)
CASE i_state OF
0:
    IF p_state = 4 AND c_state = 5 THEN
        IF D0 > 0 AND D0 = D2 AND X13 AND X1A AND X1B AND X25 AND X15 THEN
            IF D5 >= (D6 + 4) THEN
                Y16 := TRUE;
                i_state := 1;
            END_IF;
        END_IF;
    END_IF;
1:
    IF X19 AND X18 THEN
        Y16 := FALSE;
        Y17 := TRUE;
        i_state := 2;
    END_IF;
2:
    IF X17 THEN
        Y17 := FALSE;
        i_state := 3;
    END_IF;
3:
    IF X19 AND X17 AND X1D THEN
        Y18 := TRUE;
        i_state := 4;
    END_IF;
4:
    Y18 := FALSE;
    IF X1E THEN
        Y19 := TRUE;
        i_state := 5;
    END_IF;
5:
    IF NOT X1E THEN
        Y19 := FALSE;
        insert_done := TRUE;
        i_state := 6;
    END_IF;
6:
    IF p_state <> 4 AND c_state <> 5 THEN
        insert_done := FALSE;
        i_state := 0;
    END_IF;
END_CASE;

(* Completion Handling *)
IF D7 = 4 AND NOT Y15 AND NOT X13 AND D2 = 0 AND X17 AND p_state = 1 AND c_state = 1 THEN
    Y1A := TRUE;
END_IF;

END_PROGRAM