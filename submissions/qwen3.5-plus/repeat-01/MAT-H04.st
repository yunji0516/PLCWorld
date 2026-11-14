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
    start_edge : R_TRIG;
    ack_timer : TON;
    comp_timer : TON;
    state : INT;
    count : DINT;
    content_select : INT;
    i : INT;
    w : WORD;
END_VAR

state := 0;
count := 0;
content_select := 0;

start_edge(CLK := X0);

CASE state OF
    0: (* init - wait for start *)
        Y1B := FALSE; Y1C := FALSE; Y10 := FALSE;
        Y11 := FALSE; Y12 := FALSE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE;
        Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        Y1D := FALSE; Y1E := FALSE;
        D200 := 0;
        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1: (* separator_wait_double *)
        IF X20 THEN
            Y1B := TRUE;
            state := 2;
        END_IF;

    2: (* separator_separate *)
        Y1C := TRUE;
        state := 3;

    3: (* separator_wait_single *)
        IF X23 THEN
            Y1C := FALSE;
            state := 4;
        END_IF;

    4: (* separator_retreat *)
        IF NOT X21 THEN
            Y1B := FALSE;
            count := count + 1;
            state := 5;
        END_IF;

    5: (* pouch_accept *)
        IF X23 AND NOT X21 THEN
            Y10 := TRUE;
            state := 6;
        END_IF;

    6: (* pouch_wait_ready *)
        Y10 := FALSE;
        IF X10 THEN
            state := 7;
        END_IF;

    7: (* pouch_transfer *)
        Y15 := TRUE;
        IF X13 THEN
            Y15 := FALSE;
            state := 8;
        END_IF;

    8: (* pouch_open - apply vacuum pads and open aperture *)
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF X1C AND (D5 >= 44) THEN
            Y14 := FALSE;
            state := 9;
        END_IF;

    9: (* content_prepare - select content from available_mask *)
        IF content_select = 0 AND D4 > 0 THEN
            content_select := 0;
            w := WORD#0;
            i := 0;
            WHILE i < 4 DO
                w := SHL(WORD#1, INT_TO_WORD(i));
                IF AND_WORD(D4, w) <> WORD#0 THEN
                    content_select := INT#1 + DINT_TO_INT(i);
                    EXIT;
                END_IF;
                i := i + 1;
            END_WHILE;
            D200 := content_select;
        END_IF;
        IF X15 AND content_select > 0 THEN
            Y11 := TRUE;
            state := 10;
        END_IF;

    10: (* content_wait_accept *)
        Y11 := FALSE;
        IF content_select > 0 AND (D2 = content_select) THEN
            state := 11;
        END_IF;

    11: (* content_align - activate both alignment stoppers *)
        Y1D := TRUE;
        Y1E := TRUE;
        IF X24 AND X25 THEN
            Y1D := FALSE;
            Y1E := FALSE;
            state := 12;
        END_IF;

    12: (* insert - push content into pouch *)
        IF X13 AND X24 AND X25 AND X1C THEN
            Y16 := TRUE;
            state := 13;
        END_IF;

    13: (* retract - return pusher to home *)
        Y17 := TRUE;
        IF X17 THEN
            Y17 := FALSE;
            state := 14;
        END_IF;

    14: (* release *)
        IF X17 AND X1D THEN
            Y18 := TRUE;
            state := 15;
        END_IF;

    15: (* wait_contained *)
        Y18 := FALSE;
        IF X19 THEN
            state := 16;
        END_IF;

    16: (* ack_exit - acknowledge receipt *)
        Y19 := TRUE;
        ack_timer(IN := TRUE, PT := T#100ms);
        IF ack_timer.Q THEN
            Y19 := FALSE;
            content_select := 0;
            D200 := 0;
            IF count < 4 THEN
                state := 7;
            ELSE
                state := 17;
            END_IF;
        END_IF;

    17: (* completion *)
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE;
        Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        Y19 := FALSE; Y1B := FALSE; Y1C := FALSE;
        Y1D := FALSE; Y1E := FALSE;
        D200 := 0;
        content_select := 0;

        comp_timer(IN := TRUE, PT := T#500ms);
        Y1A := comp_timer.Q;

END_CASE;

END_PROGRAM