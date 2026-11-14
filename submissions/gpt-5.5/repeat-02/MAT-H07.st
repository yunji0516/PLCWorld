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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;
    state : INT := 0;
    a_prepared : BOOL := FALSE;
    b_accepted : BOOL := FALSE;
    b_prepared : BOOL := FALSE;
    trim_started : BOOL := FALSE;
    active_roll : BOOL := FALSE;
    cut_started : BOOL := FALSE;
    roll_done_count : INT := 0;
    cores_used : INT := 0;
    current_target : INT := 0;
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
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y27 := FALSE;
Y28 := FALSE;
Y29 := FALSE;

CASE state OF
    0:
        IF X0 THEN
            state := 5;
        END_IF;

    5:
        IF a_prepared THEN
            state := 10;
        ELSIF X10 AND X12 THEN
            Y10 := TRUE;
            a_prepared := TRUE;
            state := 10;
        END_IF;

    10:
        IF b_accepted THEN
            state := 15;
        ELSIF X11 AND X13 THEN
            Y11 := TRUE;
            b_accepted := TRUE;
            state := 15;
        END_IF;

    15:
        IF D2 < D0 THEN
            IF b_accepted AND X25 AND (NOT trim_started) AND (NOT active_roll) THEN
                Y14 := TRUE;
            END_IF;
        ELSE
            state := 20;
        END_IF;

    20:
        Y13 := TRUE;
        IF X15 THEN
            state := 25;
        END_IF;

    25:
        Y13 := TRUE;
        IF X15 AND X28 AND (D2 > 0) AND (NOT trim_started) THEN
            Y15 := TRUE;
            trim_started := TRUE;
            state := 30;
        END_IF;

    30:
        Y13 := TRUE;
        IF X16 AND X17 THEN
            Y16 := TRUE;
            b_prepared := TRUE;
            state := 40;
        END_IF;

    40:
        IF X24 AND a_prepared AND b_prepared THEN
            state := 50;
        END_IF;

    50:
        IF roll_done_count >= 3 THEN
            state := 300;
        ELSE
            Y24 := TRUE;
            IF X2E THEN
                state := 52;
            END_IF;
        END_IF;

    52:
        Y24 := TRUE;
        IF X2D THEN
            state := 54;
        ELSE
            IF X2C THEN
                Y23 := TRUE;
            END_IF;
        END_IF;

    54:
        Y24 := TRUE;
        IF X18 AND X19 AND X2D AND X2E AND X1D AND (NOT X1A) AND X24 AND a_prepared AND b_prepared AND (NOT active_roll) AND (cores_used < 3) THEN
            Y17 := TRUE;
            active_roll := TRUE;
            cores_used := cores_used + 1;
            IF D4 > 0 THEN
                current_target := D4;
            ELSE
                IF roll_done_count = 0 THEN
                    current_target := 800;
                ELSIF roll_done_count = 1 THEN
                    current_target := 1000;
                ELSE
                    current_target := 700;
                END_IF;
            END_IF;
            cut_started := FALSE;
            state := 60;
        END_IF;

    60:
        IF active_roll AND (NOT X1A) THEN
            IF X1E THEN
                state := 70;
            ELSE
                Y1F := TRUE;
            END_IF;
        END_IF;

    70:
        Y18 := TRUE;
        Y19 := TRUE;
        IF active_roll AND X1E AND X1B AND X1C AND X24 AND (NOT X1A) THEN
            state := 80;
        END_IF;

    80:
        Y18 := TRUE;
        Y19 := TRUE;
        IF D5 < (current_target - 2) THEN
            IF active_roll AND X1E AND X1B AND X1C AND X24 AND (NOT X1A) THEN
                Y1A := TRUE;
            END_IF;
        ELSE
            state := 90;
        END_IF;

    90:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF X14 AND X15 THEN
            state := 100;
        END_IF;

    100:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF X14 AND X15 AND X28 AND (NOT cut_started) THEN
            Y1C := TRUE;
            Y1D := TRUE;
            cut_started := TRUE;
            state := 110;
        END_IF;

    110:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF X27 AND X28 THEN
            state := 120;
        END_IF;

    120:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF X26 THEN
            state := 130;
        ELSE
            IF active_roll AND X1E AND X1B AND X1C AND X27 AND X28 THEN
                Y1A := TRUE;
            END_IF;
        END_IF;

    130:
        Y1B := TRUE;
        IF X2A AND (NOT X32) THEN
            state := 132;
        ELSIF X2F AND (D9 >= 80) AND (NOT X32) AND (NOT X31) THEN
            Y25 := TRUE;
            state := 131;
        END_IF;

    131:
        Y1B := TRUE;
        IF X2A AND (NOT X32) THEN
            state := 132;
        END_IF;

    132:
        Y1B := TRUE;
        Y26 := TRUE;
        IF X30 THEN
            state := 134;
        END_IF;

    134:
        Y1B := TRUE;
        Y26 := TRUE;
        IF X30 AND X2A AND (NOT X32) THEN
            Y27 := TRUE;
            state := 136;
        END_IF;

    136:
        Y1B := TRUE;
        Y26 := TRUE;
        IF X31 AND (NOT X32) THEN
            state := 138;
        END_IF;

    138:
        Y1B := TRUE;
        Y26 := TRUE;
        IF active_roll AND X1E AND X30 AND X31 AND X26 AND X27 AND (D5 >= (current_target - 2)) AND (NOT X32) THEN
            Y28 := TRUE;
            state := 140;
        END_IF;

    140:
        Y1B := TRUE;
        Y26 := TRUE;
        IF X33 AND (NOT X32) THEN
            state := 150;
        END_IF;

    150:
        Y1B := TRUE;
        IF X1F AND X33 AND (NOT X32) AND X27 AND X26 THEN
            IF X1D THEN
                state := 160;
            ELSE
                Y1E := TRUE;
            END_IF;
        END_IF;

    160:
        Y1B := TRUE;
        IF X1D AND X1F AND X34 THEN
            Y20 := TRUE;
            state := 170;
        END_IF;

    170:
        IF X20 THEN
            active_roll := FALSE;
            state := 180;
        END_IF;

    180:
        IF X22 THEN
            state := 190;
        ELSE
            IF X34 AND X35 THEN
                Y29 := TRUE;
            END_IF;
        END_IF;

    190:
        IF X22 THEN
            Y21 := TRUE;
            roll_done_count := roll_done_count + 1;
            cut_started := FALSE;
            state := 192;
        END_IF;

    192:
        IF X34 AND X20 AND (NOT X32) THEN
            IF roll_done_count >= 3 THEN
                state := 300;
            ELSE
                state := 50;
            END_IF;
        END_IF;

    300:
        Y22 := TRUE;

ELSE
    state := 0;
END_CASE;

END_PROGRAM