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

    m_state : INT := 0;
    c_state : INT := 0;
    sep_state : INT := 0;

    packages_done : INT := 0;

    req_id : INT := 0;
    mask_val : INT := 0;
    mask_match : BOOL := FALSE;

    sep_timer : TON;
    sep_timer_in : BOOL := FALSE;
END_VAR

(* Single-Sheet Separation State Machine *)
CASE sep_state OF
    0:
        IF X10 AND X20 AND NOT X21 AND packages_done < 4 THEN
            Y1B := TRUE;
            sep_timer_in := TRUE;
            sep_state := 1;
        END_IF;
    1:
        Y1B := TRUE;
        IF sep_timer.Q THEN
            Y1C := TRUE;
            sep_state := 2;
        END_IF;
    2:
        Y1B := TRUE;
        Y1C := FALSE;
        IF X21 THEN
            sep_state := 3;
        END_IF;
    3:
        Y1B := TRUE;
        IF NOT X21 THEN
            Y1B := FALSE;
            sep_timer_in := FALSE;
            sep_state := 0;
        END_IF;
END_CASE;

sep_timer(IN := sep_timer_in, PT := T#250ms);

(* Content Alignment and Preparation State Machine *)
CASE c_state OF
    0:
        IF (m_state = 2 OR m_state = 3 OR m_state = 4) AND D0 > 0 AND D2 = 0 AND NOT X14 THEN
            req_id := D0;
            mask_match := FALSE;
            CASE req_id OF
                1: mask_val := D4;
                2: mask_val := D4 / 2;
                3: mask_val := D4 / 4;
                4: mask_val := D4 / 8;
            ELSE
                mask_val := 0;
            END_CASE;

            IF req_id > 0 AND (mask_val - (mask_val / 2) * 2) <> 0 THEN
                mask_match := TRUE;
            END_IF;

            IF mask_match THEN
                D200 := req_id;
                Y11 := TRUE;
                c_state := 1;
            END_IF;
        END_IF;
    1:
        Y11 := FALSE;
        IF D2 = req_id AND X15 THEN
            Y1D := TRUE;
            Y1E := TRUE;
            c_state := 2;
        END_IF;
    2:
        IF X24 THEN
            Y1D := FALSE;
            Y1E := FALSE;
            c_state := 3;
        END_IF;
    3:
        IF X25 THEN
            c_state := 4;
        END_IF;
    4:
        IF D2 = 0 THEN
            c_state := 0;
        END_IF;
END_CASE;

(* Main Insertion and Packaging State Machine *)
CASE m_state OF
    0:
        IF X10 AND X23 AND NOT X21 AND sep_state = 0 AND packages_done < 4 THEN
            Y10 := TRUE;
            m_state := 1;
        END_IF;
    1:
        Y10 := FALSE;
        IF X11 THEN
            Y15 := TRUE;
            m_state := 2;
        END_IF;
    2:
        IF X13 THEN
            Y12 := TRUE;
            Y13 := TRUE;
            m_state := 3;
        END_IF;
    3:
        IF X1A AND X1B THEN
            Y14 := TRUE;
            m_state := 4;
        END_IF;
    4:
        IF X13 AND D5 >= (D6 + 4) AND D6 > 0 AND c_state = 4 THEN
            Y16 := TRUE;
            m_state := 5;
        END_IF;
    5:
        IF X19 THEN
            Y16 := FALSE;
            Y17 := TRUE;
            m_state := 6;
        END_IF;
    6:
        IF X17 THEN
            Y17 := FALSE;
            m_state := 7;
        END_IF;
    7:
        IF X1D AND NOT X14 AND X19 AND X17 THEN
            Y18 := TRUE;
            m_state := 8;
        END_IF;
    8:
        Y18 := FALSE;
        Y15 := FALSE;
        Y14 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        IF X1E THEN
            Y19 := TRUE;
            m_state := 9;
        END_IF;
    9:
        IF NOT X1E THEN
            Y19 := FALSE;
            packages_done := packages_done + 1;
            m_state := 10;
        END_IF;
    10:
        IF NOT X11 AND NOT X13 THEN
            m_state := 0;
        END_IF;
END_CASE;

(* Task Completion Output *)
IF packages_done >= 4 AND m_state = 0 THEN
    IF NOT X11 AND NOT X13 AND NOT X14 AND D2 = 0 AND X17 THEN
        Y1A := TRUE;
    END_IF;
END_IF;

END_PROGRAM