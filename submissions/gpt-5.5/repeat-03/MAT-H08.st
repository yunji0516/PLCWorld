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
    running : BOOL;
    product_state : INT;
    pitches_accepted : INT;
    rec_state : INT;
    rec_batches_done : INT;
    exchange_state : INT;
    roll_count : INT;
    recovery_conn : BOOL := TRUE;
    unload_seen_busy : BOOL;
    recovery_allowed : BOOL;
    terminal_ok : BOOL;
    complete_latched : BOOL;
    edgeHoldTimer : TON;
    unloadTimer : TON;
    threadTimer : TON;
    terminalTimer : TON;
END_VAR

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
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
D200 := 0;

edgeHoldTimer(IN := (exchange_state = 1), PT := T#300ms);
unloadTimer(IN := (exchange_state = 5), PT := T#15s);
threadTimer(IN := (exchange_state = 8), PT := T#700ms);

IF X0 THEN
    running := TRUE;
END_IF;

IF running THEN
    IF (exchange_state = 0) AND (product_state = 0) AND (NOT X11) AND (NOT X13) AND (NOT X18) AND (rec_state = 0) THEN
        IF (roll_count = 0) AND (X21 OR (rec_batches_done >= 2)) THEN
            recovery_conn := FALSE;
            exchange_state := 1;
        ELSIF (roll_count = 1) AND (rec_batches_done >= 4) AND (X21 OR (D5 <= 0) OR (D4 >= 3200) OR X1E OR X1F) THEN
            recovery_conn := FALSE;
            exchange_state := 1;
        END_IF;
    END_IF;

    CASE product_state OF
        0:
            IF (pitches_accepted < 6) AND X10 AND X20 AND (NOT X11) AND (NOT X13) AND (NOT X18) AND (exchange_state = 0) AND (D3 <= 250) THEN
                Y10 := TRUE;
                pitches_accepted := pitches_accepted + 1;
                product_state := 1;
            END_IF;
        1:
            product_state := 2;
        2:
            IF X12 AND (NOT X11) THEN
                product_state := 3;
            ELSE
                IF (D3 <= 590) AND (exchange_state = 0) THEN
                    Y11 := TRUE;
                END_IF;
            END_IF;
        3:
            Y12 := TRUE;
            IF X15 THEN
                product_state := 4;
            END_IF;
        4:
            Y12 := TRUE;
            D200 := 15;
            IF NOT X13 THEN
                Y13 := TRUE;
                product_state := 5;
            END_IF;
        5:
            Y12 := TRUE;
            D200 := 15;
            IF (X14 OR (D1 = 0)) AND (NOT X13) THEN
                product_state := 6;
            END_IF;
        6:
            Y14 := TRUE;
            IF X16 THEN
                product_state := 7;
            END_IF;
        7:
            Y14 := TRUE;
            IF X16 THEN
                Y15 := TRUE;
            END_IF;
            IF X16 AND X17 THEN
                product_state := 8;
            END_IF;
        8:
            Y14 := TRUE;
            IF X16 THEN
                Y15 := TRUE;
            END_IF;
            IF X16 AND X17 AND X19 AND (X14 OR (D1 = 0)) THEN
                Y16 := TRUE;
            END_IF;
            IF X1A THEN
                product_state := 9;
            END_IF;
        9:
            IF (NOT X18) AND X20 AND (NOT X1A) THEN
                product_state := 0;
            END_IF;
        ELSE
            product_state := 0;
    END_CASE;

    CASE exchange_state OF
        0:
            ;
        1:
            Y1C := TRUE;
            IF edgeHoldTimer.Q AND X22 THEN
                exchange_state := 2;
            END_IF;
        2:
            Y1C := TRUE;
            Y1D := TRUE;
            Y1E := TRUE;
            exchange_state := 3;
        3:
            Y1C := TRUE;
            IF X23 THEN
                exchange_state := 4;
            END_IF;
        4:
            Y1C := TRUE;
            Y1F := TRUE;
            unload_seen_busy := FALSE;
            exchange_state := 5;
        5:
            Y1C := TRUE;
            IF X24 THEN
                unload_seen_busy := TRUE;
            END_IF;
            IF (unload_seen_busy AND (NOT X24)) OR unloadTimer.Q THEN
                IF roll_count = 0 THEN
                    roll_count := 1;
                    exchange_state := 6;
                ELSE
                    roll_count := 2;
                    exchange_state := 9;
                END_IF;
            END_IF;
        6:
            Y1C := TRUE;
            IF X25 THEN
                Y20 := TRUE;
                exchange_state := 7;
            END_IF;
        7:
            Y1C := TRUE;
            IF X26 THEN
                exchange_state := 8;
            END_IF;
        8:
            Y1C := TRUE;
            IF NOT X27 THEN
                Y21 := TRUE;
            END_IF;
            IF NOT X28 THEN
                Y22 := TRUE;
            END_IF;
            IF X27 AND X28 AND threadTimer.Q THEN
                exchange_state := 10;
            END_IF;
        10:
            Y1C := TRUE;
            IF X29 THEN
                recovery_conn := TRUE;
                exchange_state := 0;
            END_IF;
        9:
            ;
        ELSE
            exchange_state := 0;
    END_CASE;

    recovery_allowed := recovery_conn AND (exchange_state = 0) AND (NOT X21) AND ((product_state = 0) OR (product_state = 1) OR (product_state = 2) OR (product_state >= 6));

    CASE rec_state OF
        0:
            IF (rec_batches_done < 4) AND X1B AND recovery_allowed THEN
                Y17 := TRUE;
                rec_state := 1;
            END_IF;
        1:
            IF X1D THEN
                rec_batches_done := rec_batches_done + 1;
                rec_state := 2;
            ELSE
                IF recovery_allowed THEN
                    Y18 := TRUE;
                END_IF;
            END_IF;
        2:
            Y19 := TRUE;
            IF NOT X1D THEN
                rec_state := 0;
            END_IF;
        ELSE
            rec_state := 0;
    END_CASE;

    IF X1A THEN
        Y1A := TRUE;
    END_IF;
END_IF;

terminal_ok := running AND (roll_count >= 2) AND (rec_batches_done >= 4) AND (D6 >= 6) AND (pitches_accepted >= 6) AND (product_state = 0) AND (rec_state = 0) AND ((exchange_state = 9) OR (exchange_state = 0)) AND (NOT X11) AND (NOT X13) AND (NOT X18) AND (NOT X1A) AND (NOT X1C) AND (X1F OR ((D4 >= 3200) AND (D5 <= 0)));

terminalTimer(IN := terminal_ok, PT := T#500ms);

IF terminalTimer.Q THEN
    complete_latched := TRUE;
END_IF;

IF complete_latched THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM