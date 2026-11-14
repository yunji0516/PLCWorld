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
    Y1F : BOOL;

    first_scan : BOOL := TRUE;
    last_pitch_id : INT := -1;
    pitch_step : INT := 0;
    products_done : INT := 0;

    rec_step : INT := 0;
    batches_done : INT := 0;
    rolls_unloaded : INT := 0;

    retry_timer : TON;
    rec_retry_timer : TON;
END_VAR

IF first_scan THEN
    last_pitch_id := D0;
    first_scan := FALSE;
END_IF

(* Pitch Processing State Machine *)
CASE pitch_step OF
    0:
        IF X10 AND NOT X18 AND products_done < 6 THEN
            Y10 := TRUE;
            pitch_step := 1;
        END_IF
    1:
        Y10 := FALSE;
        retry_timer(IN := TRUE, PT := T#100ms);
        IF D0 <> last_pitch_id THEN
            last_pitch_id := D0;
            pitch_step := 2;
        ELSIF retry_timer.Q OR NOT X10 THEN
            pitch_step := 0;
        END_IF
    2:
        Y11 := (D3 < 600);
        IF X12 THEN
            Y11 := FALSE;
            Y12 := TRUE;
            pitch_step := 3;
        END_IF
    3:
        IF X15 THEN
            D200 := 15;
            Y13 := TRUE;
            pitch_step := 4;
        END_IF
    4:
        Y13 := FALSE;
        IF X14 THEN
            Y12 := FALSE;
            pitch_step := 5;
        END_IF
    5:
        IF X20 THEN
            Y14 := TRUE;
            pitch_step := 6;
        END_IF
    6:
        Y14 := FALSE;
        IF X16 THEN
            Y15 := TRUE;
            pitch_step := 7;
        END_IF
    7:
        IF X17 AND X19 THEN
            Y16 := TRUE;
            pitch_step := 8;
        END_IF
    8:
        IF X1A THEN
            Y1A := TRUE;
            Y16 := FALSE;
            pitch_step := 9;
        END_IF
    9:
        IF NOT X1A AND NOT X18 THEN
            Y1A := FALSE;
            Y15 := FALSE;
            products_done := products_done + 1;
            pitch_step := 10;
        END_IF
    10:
        IF NOT X17 THEN
            pitch_step := 0;
        END_IF
END_CASE

IF pitch_step <> 1 THEN
    retry_timer(IN := FALSE, PT := T#100ms);
END_IF

(* Recovery Processing State Machine *)
CASE rec_step OF
    0:
        IF batches_done = 4 AND rolls_unloaded = 1 THEN
            rec_step := 10;
        ELSIF X1B AND batches_done < 4 THEN
            Y17 := TRUE;
            rec_step := 1;
        END_IF
    1:
        Y17 := FALSE;
        rec_retry_timer(IN := TRUE, PT := T#100ms);
        IF X1C THEN
            rec_step := 2;
        ELSIF rec_retry_timer.Q OR NOT X1B THEN
            rec_step := 0;
        END_IF
    2:
        IF X1D THEN
            Y18 := FALSE;
            Y19 := TRUE;
            rec_step := 3;
        ELSIF X21 THEN
            Y18 := FALSE;
            rec_step := 10;
        ELSE
            Y18 := TRUE;
        END_IF
    3:
        IF NOT X1D THEN
            Y19 := FALSE;
            batches_done := batches_done + 1;
            rec_step := 0;
        END_IF
    10:
        Y1C := TRUE;
        IF X22 THEN
            Y1D := TRUE;
            Y1E := TRUE;
            rec_step := 11;
        END_IF
    11:
        Y1D := FALSE;
        Y1E := FALSE;
        IF X23 THEN
            Y1F := TRUE;
            rolls_unloaded := rolls_unloaded + 1;
            rec_step := 12;
        END_IF
    12:
        Y1F := FALSE;
        IF batches_done = 4 AND rolls_unloaded = 2 THEN
            rec_step := 20;
        ELSIF X25 THEN
            Y20 := TRUE;
            rec_step := 13;
        END_IF
    13:
        Y20 := FALSE;
        IF X26 THEN
            Y21 := TRUE;
            Y22 := TRUE;
            rec_step := 14;
        END_IF
    14:
        IF X27 AND X28 THEN
            Y21 := FALSE;
            Y22 := FALSE;
            Y1C := FALSE;
            rec_step := 15;
        END_IF
    15:
        IF X29 THEN
            IF batches_done < 4 THEN
                rec_step := 2;
            ELSE
                rec_step := 0;
            END_IF
        END_IF
END_CASE

IF rec_step <> 1 THEN
    rec_retry_timer(IN := FALSE, PT := T#100ms);
END_IF

(* Completion Assertion *)
IF (batches_done = 4) AND (rolls_unloaded = 2) AND (products_done = 6) AND 
   (pitch_step = 0) AND (rec_step = 20) AND NOT X18 AND NOT X16 AND NOT X17 AND NOT X1A AND X1F THEN
    Y1B := TRUE;
END_IF

END_PROGRAM