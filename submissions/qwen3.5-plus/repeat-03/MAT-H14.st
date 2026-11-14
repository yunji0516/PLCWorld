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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    step : INT := 0;
    tray_count : INT := 0;
    current_lane : INT := 0;
    pre_mass_val : INT := 0;
    post_mass_val : INT := 0;
    seq_pre_req : INT := 0;
    seq_post_req : INT := 0;
    complete_timer : TON;
    is_complete : BOOL := FALSE;
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
D200 := 0;
D201 := 0;
D202 := 0;
D203 := 0;
D204 := 0;

CASE step OF
    0:
        IF X0 AND X10 AND X1F AND (tray_count < 4) THEN
            step := 1;
        END_IF;
    1:
        Y10 := TRUE;
        IF X11 THEN step := 2; END_IF;
    2:
        Y17 := TRUE;
        IF X1E THEN step := 3; END_IF;
    3:
        seq_pre_req := seq_pre_req + 1;
        D202 := seq_pre_req;
        Y11 := TRUE;
        Y17 := TRUE;
        step := 4;
    4:
        Y17 := TRUE;
        IF D4 = seq_pre_req AND NOT X15 THEN
            pre_mass_val := D2;
            step := 5;
        END_IF;
    5:
        Y17 := FALSE;
        IF X1F THEN step := 6; END_IF;
    6:
        IF X17 THEN
            current_lane := 1;
        ELSIF X19 THEN
            current_lane := 2;
        ELSE
            step := 6;
        END_IF;
        IF current_lane > 0 THEN
            D200 := current_lane;
            Y12 := TRUE;
            step := 7;
        END_IF;
    7:
        D200 := current_lane;
        IF current_lane = 1 AND NOT X17 THEN
            step := 8;
        ELSIF current_lane = 2 AND NOT X19 THEN
            step := 8;
        END_IF;
    8:
        IF current_lane = 1 AND X18 THEN
            step := 9;
        ELSIF current_lane = 2 AND X1A THEN
            step := 9;
        END_IF;
    9:
        D201 := current_lane;
        Y13 := TRUE;
        step := 10;
    10:
        D201 := current_lane;
        IF X13 THEN step := 11; END_IF;
    11:
        Y18 := TRUE;
        IF X20 THEN step := 12; END_IF;
    12:
        seq_post_req := seq_post_req + 1;
        D203 := seq_post_req;
        Y14 := TRUE;
        Y18 := TRUE;
        step := 13;
    13:
        Y18 := TRUE;
        IF D5 = seq_post_req AND NOT X16 THEN
            post_mass_val := D3;
            step := 14;
        END_IF;
    14:
        Y18 := FALSE;
        IF X21 THEN step := 15; END_IF;
    15:
        IF (post_mass_val - pre_mass_val) >= 95 AND (post_mass_val - pre_mass_val) <= 105 THEN
            D204 := 1;
            IF NOT X1B THEN
                step := 15;
            END_IF;
        ELSE
            D204 := 2;
            IF NOT X1C THEN
                step := 15;
            END_IF;
        END_IF;
        Y15 := TRUE;
        step := 16;
    16:
        IF NOT X13 THEN
            tray_count := tray_count + 1;
            step := 0;
        END_IF;
    ELSE
        step := 0;
END_CASE;

IF tray_count >= 4 AND NOT X11 AND NOT X13 AND X17 AND X19 THEN
    complete_timer(IN := TRUE, PT := T#500ms);
    IF complete_timer.Q THEN
        is_complete := TRUE;
    END_IF;
ELSE
    complete_timer(IN := FALSE, PT := T#500ms);
    is_complete := FALSE;
END_IF;
Y16 := is_complete;

END_PROGRAM