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
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    step : INT := 0;
    prev_x16 : BOOL := FALSE;
    prev_x0 : BOOL := FALSE;
    pulse_admit : BOOL := FALSE;
    pulse_inspect : BOOL := FALSE;
    pulse_detach : BOOL := FALSE;
    pulse_move : BOOL := FALSE;
    pulse_left_up : BOOL := FALSE;
    pulse_left_down : BOOL := FALSE;
    pulse_right_up : BOOL := FALSE;
    pulse_right_down : BOOL := FALSE;
    pulse_ack : BOOL := FALSE;

    cmd_jig : INT := 0;
    cmd_target : INT := 0;
    cmd_gen : INT := 0;

    prods_completed : INT := 0;
    timer_inspect : TON;
    inspect_active : BOOL := FALSE;
    last_inspected_prod : INT := 0;
    all_done_flag : BOOL := FALSE;
END_VAR

pulse_admit := FALSE;
pulse_inspect := FALSE;
pulse_detach := FALSE;
pulse_move := FALSE;
pulse_left_up := FALSE;
pulse_left_down := FALSE;
pulse_right_up := FALSE;
pulse_right_down := FALSE;
pulse_ack := FALSE;

IF X16 AND NOT prev_x16 THEN
    pulse_ack := TRUE;
    prods_completed := prods_completed + 1;
END_IF;
prev_x16 := X16;

CASE step OF
    0:
        IF X0 THEN
            step := 10;
        END_IF;

    10:
        IF (D0 <> 0) AND (D5 = 0) AND X10 AND (NOT X12) AND (NOT X11) AND (NOT X1B) THEN
            pulse_admit := TRUE;
            step := 20;
        ELSIF (D0 <> 0) AND (D5 <> 0) THEN
            step := 20;
        END_IF;

    20:
        IF (NOT X12) AND (D5 <> 0) AND (D1 = 0) AND (NOT X11) THEN
            cmd_jig := D0;
            cmd_target := 1;
            pulse_move := TRUE;
            step := 30;
        END_IF;

    30:
        IF (D1 <> 0) AND (NOT X11) THEN
            step := 40;
        END_IF;

    40:
        IF (D1 <> 0) AND (D6 <> 0) AND (NOT X14) THEN
            cmd_gen := D8;
            pulse_inspect := TRUE;
            inspect_active := TRUE;
            step := 50;
        END_IF;

    50:
        IF (D9 = D6) AND (D10 = cmd_gen) AND (NOT X14) THEN
            inspect_active := FALSE;
            last_inspected_prod := D6;
            step := 60;
        END_IF;

    60:
        IF (D2 = 0) AND (NOT X11) THEN
            cmd_jig := D1;
            cmd_target := 2;
            pulse_move := TRUE;
            step := 70;
        END_IF;

    70:
        IF (D2 <> 0) AND (NOT X11) THEN
            step := 80;
        END_IF;

    80:
        IF (D7 <> 0) AND X15 AND (NOT X13) THEN
            pulse_detach := TRUE;
            step := 90;
        END_IF;

    90:
        IF (D7 = 0) AND (NOT X13) THEN
            step := 100;
        END_IF;

    100:
        IF (NOT X19) AND (NOT X1C) THEN
            pulse_right_up := TRUE;
            step := 110;
        ELSIF X19 AND (NOT X1C) THEN
            step := 110;
        END_IF;

    110:
        IF X19 AND (NOT X1C) AND (D3 = 0) AND (NOT X11) THEN
            cmd_jig := D2;
            cmd_target := 3;
            pulse_move := TRUE;
            step := 120;
        END_IF;

    120:
        IF (D3 <> 0) AND X1E AND (NOT X11) THEN
            pulse_right_down := TRUE;
            step := 130;
        END_IF;

    130:
        IF X1A AND (NOT X1C) AND (NOT X11) THEN
            IF D4 = 0 THEN
                cmd_jig := D3;
                cmd_target := 4;
                pulse_move := TRUE;
                step := 140;
            END_IF;
        END_IF;

    140:
        IF (D4 <> 0) AND (NOT X11) THEN
            step := 150;
        END_IF;

    150:
        IF (NOT X18) AND (NOT X1B) THEN
            pulse_left_down := TRUE;
            step := 160;
        ELSIF X18 AND (NOT X1B) THEN
            step := 160;
        END_IF;

    160:
        IF X18 AND (NOT X1B) AND (D0 = 0) AND (NOT X11) THEN
            cmd_jig := D4;
            cmd_target := 0;
            pulse_move := TRUE;
            step := 170;
        END_IF;

    170:
        IF (D0 <> 0) AND X1F AND (NOT X11) THEN
            pulse_left_up := TRUE;
            step := 180;
        END_IF;

    180:
        IF X17 AND (NOT X1B) THEN
            IF prods_completed >= 6 THEN
                step := 200;
            ELSE
                step := 10;
            END_IF;
        END_IF;

    200:
        all_done_flag := TRUE;
END_CASE;

Y10 := pulse_admit;
Y11 := pulse_inspect;
Y12 := pulse_detach;
Y13 := pulse_move;
Y14 := pulse_left_up;
Y15 := pulse_left_down;
Y16 := pulse_right_up;
Y17 := pulse_right_down;
Y18 := pulse_ack;

D200 := cmd_jig;
D201 := cmd_target;
D202 := cmd_gen;

IF all_done_flag AND (prods_completed >= 6) AND (NOT X11) AND (NOT X12) AND (NOT X13) AND (NOT X14) AND (NOT X1B) AND (NOT X1C) THEN
    Y19 := TRUE;
ELSE
    Y19 := FALSE;
END_IF;

END_PROGRAM
