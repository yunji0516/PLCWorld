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
    started : BOOL;
    complete_latched : BOOL;
    p_state : INT;
    r_state : INT;
    product_count : INT;
    recovery_count : INT;
    roll_count : INT;
    unload_seen_busy : BOOL;
    unsafe_drag : BOOL;
    recovery_connected_ok : BOOL;
    terminal_ok : BOOL;
    edgeHoldTimer : TON;
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

IF X0 THEN
    started := TRUE;
END_IF;

unsafe_drag := X16 AND (D1 <> 0);

edgeHoldTimer(IN := (r_state = 100), PT := T#300ms);

IF NOT complete_latched THEN
    IF started THEN
        CASE p_state OF
            0:
                IF (product_count < 6) AND X10 AND (NOT X11) AND (NOT X18) AND (NOT X13) AND X20 AND (NOT X1A) AND (D3 < 580) THEN
                    Y10 := TRUE;
                    p_state := 10;
                END_IF;
            10:
                IF X12 THEN
                    p_state := 20;
                ELSE
                    IF (D3 < 580) AND (NOT unsafe_drag) THEN
                        Y11 := TRUE;
                    END_IF;
                END_IF;
            20:
                Y12 := TRUE;
                IF X15 THEN
                    p_state := 30;
                END_IF;
            30:
                Y12 := TRUE;
                D200 := 15;
                IF NOT X13 THEN
                    Y13 := TRUE;
                    p_state := 40;
                END_IF;
            40:
                Y12 := TRUE;
                D200 := 15;
                IF X14 OR (D1 = 0) THEN
                    p_state := 50;
                END_IF;
            50:
                Y14 := TRUE;
                IF X16 THEN
                    p_state := 60;
                END_IF;
            60:
                Y14 := TRUE;
                IF X16 THEN
                    Y15 := TRUE;
                END_IF;
                IF X16 AND X17 THEN
                    p_state := 70;
                END_IF;
            70:
                Y14 := TRUE;
                IF X16 THEN
                    Y15 := TRUE;
                END_IF;
                IF X16 AND X17 AND X19 AND (D1 = 0) AND (NOT X18) THEN
                    Y16 := TRUE;
                    p_state := 80;
                END_IF;
            80:
                Y14 := TRUE;
                IF X16 THEN
                    Y15 := TRUE;
                END_IF;
                IF D1 = 0 THEN
                    Y16 := TRUE;
                END_IF;
                IF X1A THEN
                    Y1A := TRUE;
                    IF product_count < 6 THEN
                        product_count := product_count + 1;
                    END_IF;
                    p_state := 90;
                END_IF;
            90:
                IF (NOT X18) AND X20 AND (NOT X1A) THEN
                    p_state := 0;
                END_IF;
            ELSE
                p_state := 0;
        END_CASE;

        recovery_connected_ok := (roll_count = 0) OR X29;

        CASE r_state OF
            0:
                IF (recovery_count < 4) AND X1B AND recovery_connected_ok THEN
                    Y17 := TRUE;
                    r_state := 10;
                END_IF;
            10:
                IF X1D THEN
                    Y19 := TRUE;
                    IF recovery_count < 4 THEN
                        recovery_count := recovery_count + 1;
                    END_IF;
                    IF (recovery_count = 2) OR (recovery_count = 4) OR X21 THEN
                        r_state := 100;
                    ELSE
                        r_state := 0;
                    END_IF;
                ELSE
                    IF X21 THEN
                        r_state := 100;
                    ELSE
                        IF NOT unsafe_drag THEN
                            Y18 := TRUE;
                        END_IF;
                    END_IF;
                END_IF;
            100:
                Y1C := TRUE;
                IF edgeHoldTimer.Q AND X22 THEN
                    r_state := 110;
                END_IF;
            110:
                Y1C := TRUE;
                Y1D := TRUE;
                Y1E := TRUE;
                r_state := 120;
            120:
                Y1C := TRUE;
                IF X23 AND (NOT X24) THEN
                    Y1F := TRUE;
                    unload_seen_busy := FALSE;
                    r_state := 130;
                END_IF;
            130:
                Y1C := TRUE;
                IF X24 THEN
                    unload_seen_busy := TRUE;
                END_IF;
                IF unload_seen_busy AND (NOT X24) THEN
                    IF roll_count < 2 THEN
                        roll_count := roll_count + 1;
                    END_IF;
                    IF (roll_count < 2) AND (recovery_count < 4) THEN
                        r_state := 140;
                    ELSE
                        r_state := 0;
                    END_IF;
                END_IF;
            140:
                Y1C := TRUE;
                IF X26 THEN
                    r_state := 150;
                ELSE
                    IF X25 AND (NOT X24) THEN
                        Y20 := TRUE;
                    END_IF;
                END_IF;
            150:
                Y1C := TRUE;
                IF NOT X27 THEN
                    Y21 := TRUE;
                END_IF;
                IF NOT X28 THEN
                    Y22 := TRUE;
                END_IF;
                IF X27 AND X28 THEN
                    r_state := 160;
                END_IF;
            160:
                IF X29 THEN
                    r_state := 0;
                END_IF;
            ELSE
                r_state := 0;
        END_CASE;
    END_IF;

    terminal_ok := started AND
                   (product_count >= 6) AND
                   (D6 >= 6) AND
                   (recovery_count >= 4) AND
                   (D4 >= 3200) AND
                   (roll_count >= 2) AND
                   (p_state = 0) AND
                   (r_state = 0) AND
                   (NOT X11) AND
                   (NOT X13) AND
                   (NOT X18) AND
                   (NOT X24) AND
                   (NOT X1A);

    IF terminal_ok THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

IF complete_latched THEN
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
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    D200 := 0;
    Y1B := TRUE;
END_IF;

END_PROGRAM