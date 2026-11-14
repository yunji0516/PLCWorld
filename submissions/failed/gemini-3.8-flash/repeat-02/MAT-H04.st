```iecst
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

    started : BOOL;
    state : INT;
    target_id : INT;
    packages_done : INT;

    ton_sep_hold : TON;
    ton_sep_retreat : TON;
    ton_align : TON;
    ton_close : TON;
    ton_rel : TON;
    ton_shuttle_wait : TON;
    ton_home_settle : TON;
    ton_complete : TON;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    state := 0;
ELSIF state = 0 THEN
    state := 10;
END_IF;

ton_sep_hold(IN := (state = 20), PT := T#300ms);
ton_sep_retreat(IN := (state = 24), PT := T#100ms);
ton_align(IN := (state = 60), PT := T#450ms);
ton_close(IN := (state = 80), PT := T#550ms);
ton_rel(IN := (state = 81), PT := T#100ms);
ton_shuttle_wait(IN := (state = 91), PT := T#150ms);
ton_home_settle(IN := (state = 100 AND X17 AND NOT X16 AND NOT X13 AND NOT X11 AND NOT X14 AND X25), PT := T#200ms);
ton_complete(IN := (state = 110), PT := T#600ms);

CASE state OF
    0:
        Y10 := FALSE;
        Y11 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        D200 := 0;

    10: (* Check supply lead condition *)
        IF X10 AND NOT X12 AND NOT X21 THEN
            IF X20 THEN
                state := 20;
            ELSIF X23 OR (NOT X20) THEN
                state := 30;
            END_IF;
        END_IF;

    20: (* Separator hold engages *)
        Y1B := TRUE;
        IF ton_sep_hold.Q AND X22 THEN
            state := 21;
        END_IF;

    21: (* Pulse separate *)
        Y1B := TRUE;
        Y1C := TRUE;
        IF X21 THEN
            Y1C := FALSE;
            state := 22;
        END_IF;

    22: (* Wait for separator cycle to complete *)
        Y1B := TRUE;
        Y1C := FALSE;
        IF NOT X21 AND X23 THEN
            Y1B := FALSE;
            state := 24;
        END_IF;

    24: (* Wait for separator retreat *)
        Y1B := FALSE;
        Y1C := FALSE;
        IF NOT X21 AND NOT X22 AND ton_sep_retreat.Q THEN
            state := 30;
        END_IF;

    30: (* Accept pouch onto shuttle *)
        IF NOT X11 AND NOT X13 AND NOT X12 THEN
            Y10 := TRUE;
            state := 31;
        END_IF;

    31: (* Wait pouch loaded *)
        IF X12 OR X11 THEN
            Y10 := FALSE;
        END_IF;
        IF X11 AND NOT X12 THEN
            Y10 := FALSE