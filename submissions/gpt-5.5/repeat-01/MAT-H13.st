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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
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
    Y23 : BOOL;
    Y24 : BOOL;
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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    state : INT;
    current_bundle : INT;
    target_count : INT;
    target_len : DINT;
    target_abs : DINT;
    wrap_start : DINT;
    desired_order : INT;
    received_goal : INT;
    started : BOOL;
    complete_latched : BOOL;
    tape_prepared : BOOL;
    swap_requested : BOOL;
    swap_seen_busy : BOOL;
    swapTimer : TON;
END_VAR

IF D10 >= 2 AND D10 <= 4 THEN
    target_count := D10;
ELSE
    IF current_bundle = 0 THEN
        target_count := 2;
    ELSIF current_bundle = 1 THEN
        target_count := 3;
    ELSE
        target_count := 4;
    END_IF;
END_IF;

IF D3 > 100 THEN
    target_len := DINT(D3);
ELSE
    IF target_count = 2 THEN
        target_len := 1192;
    ELSIF target_count = 3 THEN
        target_len := 1472;
    ELSE
        target_len := 1752;
    END_IF;
END_IF;

IF D0 <> 0 THEN
    desired_order := D0;
ELSIF D1 <> 0 THEN
    desired_order := D1;
ELSE
    desired_order := current_bundle + 1;
END_IF;

D200 := desired_order;
target_abs := wrap_start + target_len;

swapTimer(IN := (state = 130), PT := T#8s);

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
Y23 := FALSE;
Y24 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF NOT started AND X0 AND NOT complete_latched THEN
    started := TRUE;
    current_bundle := 0;
    state := 10;
    tape_prepared := FALSE;
    swap_requested := FALSE;
    swap_seen_busy := FALSE;
    wrap_start := 0;
END_IF;

IF started AND NOT complete_latched THEN
    CASE state OF
        10:
            Y1D := TRUE;
            IF X2E THEN
                Y21 := FALSE;
            ELSE
                Y21 := TRUE;
            END_IF;

            IF NOT tape_prepared AND NOT X1F THEN
                D200 := desired_order;
                Y18 := TRUE;
                tape_prepared := TRUE;
            END_IF;

            IF D9 < target_count THEN
                IF X25 AND X26 AND X28 AND NOT X27 AND NOT X15 THEN
                    Y1C := TRUE;
                END_IF;
                IF (NOT X28) AND (NOT X27) AND (NOT X15) THEN
                    Y1E := TRUE;
                END_IF;
            ELSE
                IF (NOT X27) THEN
                    state := 30;
                END_IF;
            END_IF;

        30:
            Y1D := TRUE;
            Y1F := TRUE;
            Y21 := FALSE;
            Y22 := FALSE;
            IF (D9 = target_count) AND X29 AND X2D AND X2E THEN
                Y20 := TRUE;
            END_IF;
            IF X2A THEN
                state := 40;
            END_IF;

        40:
            Y20 := TRUE;
            Y21 := TRUE;
            Y22 := FALSE;
            IF X2C THEN
                state := 50;
            END_IF;

        50:
            Y20 := TRUE;
            Y21 := TRUE;
            Y22 := TRUE;
            IF X2F AND X30 THEN
                state := 60;
            END_IF;

        60:
            Y20 := TRUE;
            Y21 := FALSE;
            Y22 := TRUE;
            IF X2D THEN
                state := 61;
            END_IF;

        61:
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := TRUE;
            IF X2B THEN
                state := 70;
            END_IF;

        70:
            Y20 := FALSE;
            Y21 := TRUE;
            IF X2C THEN
                Y22 := FALSE;
            ELSE
                Y22 := TRUE;
            END_IF;
            IF X2C AND X2E THEN
                state := 75;
            END_IF;

        75:
            Y21 := TRUE;
            IF X32 AND X2C AND X33 AND (NOT X15) THEN
                Y23 := TRUE;
            END_IF;
            IF X10 THEN
                state := 80;
            END_IF;

        80:
            Y21 := TRUE;
            IF (NOT X33) AND (NOT X15) THEN
                Y13 := TRUE;
            END_IF;
            IF X10 AND X33 AND X17 THEN
                Y24 := TRUE;
            END_IF;
            IF X10 AND X12 THEN
                Y10 := TRUE;
            END_IF;
            IF X16 AND ((D1 = desired_order) OR (D1 <> 0) OR (desired_order = 0)) THEN
                state := 90;
            END_IF;

        90:
            Y10 := TRUE;
            Y14 := TRUE;
            IF X13 AND X11 THEN
                state := 100;
            END_IF;

        100:
            Y11 := TRUE;
            IF NOT X19 THEN
                Y10 := TRUE;
            ELSE
                Y10 := FALSE;
            END_IF;
            IF X19 AND X17 THEN
                state := 110;
            END_IF;

        110:
            Y11 := TRUE;
            Y12 := TRUE;
            IF NOT X18 THEN
                Y13 := TRUE;
            ELSE
                IF NOT X15 THEN
                    wrap_start := DINT(D2);
                    state := 120;
                END_IF;
            END_IF;

        120:
            Y11 := TRUE;
            Y12 := TRUE;

            IF tape_prepared AND X20 AND (D5 <> desired_order) AND (desired_order <> 0) THEN
                tape_prepared := FALSE;
            END_IF;
            IF NOT tape_prepared AND NOT X1F THEN
                D200 := desired_order;
                Y18 := TRUE;
                tape_prepared := TRUE;
            END_IF;

            IF (DINT(D2) - wrap_start) >= target_len THEN
                state := 140;
            ELSE
                IF (D4 <= 25) AND X1E AND (NOT swap_requested) AND X19 AND X1B AND X18 AND (NOT X1D) THEN
                    Y17 := TRUE;
                    swap_requested := TRUE;
                    swap_seen_busy := FALSE;
                    state := 130;
                ELSE
                    IF X19 AND X1B AND X18 AND X1C AND (NOT X1D) AND (D4 > 0) THEN
                        Y16 := TRUE;
                    END_IF;
                END_IF;
            END_IF;

        130:
            Y11 := TRUE;
            Y12 := TRUE;
            IF X1D THEN
                swap_seen_busy := TRUE;
            END_IF;
            IF ((swap_seen_busy AND (NOT X1D) AND X1C) OR (swapTimer.Q AND (NOT X1D) AND X1C)) THEN
                state := 120;
            END_IF;

        140:
            Y11 := TRUE;
            Y12 := TRUE;

            IF tape_prepared AND X20 AND (D5 <> desired_order) AND (desired_order <> 0) THEN
                tape_prepared := FALSE;
            END_IF;
            IF NOT tape_prepared AND NOT X1F THEN
                D200 := desired_order;
                Y18 := TRUE;
                tape_prepared := TRUE;
            END_IF;

            IF X20 AND (NOT X1F) AND (D5 = desired_order) AND X19 AND X1B THEN
                Y19 := TRUE;
            END_IF;
            IF X21 THEN
                state := 150;
            END_IF;

        150:
            Y11 := TRUE;
            Y12 := TRUE;
            IF X21 AND X19 AND X1B THEN
                Y1A := TRUE;
            END_IF;
            IF X22 THEN
                state := 160;
            END_IF;

        160:
            Y11 := TRUE;
            Y14 := TRUE;
            IF X13 AND X11 THEN
                Y10 := TRUE;
            END_IF;
            IF X16 THEN
                state := 170;
            END_IF;

        170:
            Y10 := TRUE;
            Y11 := FALSE;
            IF X1A AND X22 AND X23 THEN
                Y15 := TRUE;
                IF X14 THEN
                    state := 180;
                END_IF;
            END_IF;

        180:
            Y10 := FALSE;
            IF NOT X17 THEN
                Y15 := TRUE;
            ELSE
                received_goal := current_bundle + 1;
                state := 190;
            END_IF;

        190:
            IF current_bundle >= 2 THEN
                IF X24 OR (D7 >= 3) THEN
                    complete_latched := TRUE;
                    state := 200;
                END_IF;
            ELSE
                IF (D7 >= received_goal) OR X23 THEN
                    current_bundle := current_bundle + 1;
                    tape_prepared := FALSE;
                    swap_seen_busy := FALSE;
                    wrap_start := DINT(D2);
                    state := 10;
                END_IF;
            END_IF;

        200:
            complete_latched := TRUE;

        ELSE
            state := 10;
    END_CASE;
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
    Y23 := FALSE;
    Y24 := FALSE;
    Y1A := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    Y1B := TRUE;
END_IF;

END_PROGRAM