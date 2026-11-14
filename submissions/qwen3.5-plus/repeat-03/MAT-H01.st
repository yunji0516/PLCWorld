PROGRAM Main
VAR
    X0 : BOOL; X10 : BOOL; X11 : BOOL; X12 : BOOL; X13 : BOOL; X14 : BOOL;
    X15 : BOOL; X16 : BOOL; X17 : BOOL; X18 : BOOL; X19 : BOOL; X20 : BOOL;
    X21 : BOOL; X22 : BOOL; X23 : BOOL; X24 : BOOL; X25 : BOOL; X26 : BOOL;
    X27 : BOOL; X28 : BOOL; X29 : BOOL; X30 : BOOL; X31 : BOOL; X32 : BOOL;
    X33 : BOOL; X34 : BOOL; X35 : BOOL; X36 : BOOL; X37 : BOOL;
    Y10 : BOOL; Y11 : BOOL; Y12 : BOOL; Y13 : BOOL; Y14 : BOOL; Y15 : BOOL;
    Y16 : BOOL; Y17 : BOOL; Y18 : BOOL; Y19 : BOOL;
    D0 : INT; D1 : INT; D2 : INT; D3 : INT; D4 : INT; D5 : INT; D6 : INT;
    D7 : INT; D8 : INT; D9 : INT; D10 : INT; D11 : INT;
    D100 : INT; D101 : INT;
    X1A : BOOL; X1B : BOOL; X1C : BOOL; X1D : BOOL; X1E : BOOL; X1F : BOOL;
    X2A : BOOL; X2B : BOOL; X2C : BOOL; X2D : BOOL; X2E : BOOL; X2F : BOOL;
    Y1A : BOOL; Y1B : BOOL; Y1C : BOOL; Y1D : BOOL; Y1E : BOOL;

    step : INT := 0;
    move_seq_val : INT := 0;
    target_pose : INT := 0;
    part_type : INT := 1;
    is_good : BOOL := FALSE;
    a_cnt : INT := 0;
    b_cnt : INT := 0;
    rej_cnt : INT := 0;
    cycle_issued : BOOL := FALSE;
    measure_issued : BOOL := FALSE;
    measure_started : BOOL := FALSE;
    outfeed_issued : BOOL := FALSE;
END_VAR

Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
D100 := 0; D101 := 0;

CASE step OF
    0:
        IF X0 THEN step := 1; END_IF;
    1:
        IF a_cnt < 2 THEN
            part_type := 1; step := 2;
        ELSIF b_cnt < 2 THEN
            part_type := 2; step := 2;
        ELSE
            step := 100;
        END_IF;
    2:
        target_pose := IF part_type = 1 THEN 1 ELSE 2 END_IF;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 3;
        END_IF;
    3:
        IF D0 = target_pose AND NOT X10 THEN step := 4; END_IF;
    4:
        Y10 := TRUE;
        IF X12 THEN step := 5; END_IF;
    5:
        target_pose := IF part_type = 1 THEN 3 ELSE 4 END_IF;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 6;
        END_IF;
    6:
        IF D0 = target_pose AND NOT X10 THEN step := 7; END_IF;
    7:
        Y11 := TRUE;
        IF X11 THEN step := 8; END_IF;
    8:
        target_pose := 0;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 9;
        END_IF;
    9:
        IF D0 = target_pose AND NOT X10 THEN step := 10; END_IF;
    10:
        IF part_type = 1 THEN Y16 := TRUE; ELSE Y1B := TRUE; END_IF;
        IF (part_type = 1 AND X22) OR (part_type = 2 AND X2D) THEN step := 11; END_IF;
    11:
        IF part_type = 1 THEN Y17 := TRUE; ELSE Y1C := TRUE; END_IF;
        IF (part_type = 1 AND X24) OR (part_type = 2 AND X2F) THEN step := 12; END_IF;
    12:
        IF part_type = 1 THEN Y19 := TRUE; ELSE Y1E := TRUE; END_IF;
        cycle_issued := TRUE;
        step := 13;
    13:
        cycle_issued := FALSE;
        IF (part_type = 1 AND X1F) OR (part_type = 2 AND X2A) THEN step := 14; END_IF;
    14:
        IF part_type = 1 THEN Y15 := TRUE; ELSE Y1A := TRUE; END_IF;
        IF (part_type = 1 AND X21) OR (part_type = 2 AND X2C) THEN step := 15; END_IF;
    15:
        IF part_type = 1 THEN Y18 := TRUE; ELSE Y1D := TRUE; END_IF;
        IF (part_type = 1 AND X23) OR (part_type = 2 AND X2E) THEN step := 16; END_IF;
    16:
        target_pose := IF part_type = 1 THEN 3 ELSE 4 END_IF;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 17;
        END_IF;
    17:
        IF D0 = target_pose AND NOT X10 THEN step := 18; END_IF;
    18:
        Y10 := TRUE;
        IF X12 THEN step := 19; END_IF;
    19:
        target_pose := 6;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 20;
        END_IF;
    20:
        IF D0 = target_pose AND NOT X10 THEN step := 21; END_IF;
    21:
        Y11 := TRUE;
        IF X11 THEN step := 22; END_IF;
    22:
        target_pose := 0;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 23;
        END_IF;
    23:
        IF D0 = target_pose AND NOT X10 THEN step := 24; END_IF;
    24:
        target_pose := 6;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 25;
        END_IF;
    25:
        IF D0 = target_pose AND NOT X10 THEN step := 26; END_IF;
    26:
        Y10 := TRUE;
        IF X12 THEN step := 27; END_IF;
    27:
        target_pose := 5;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 28;
        END_IF;
    28:
        IF D0 = target_pose AND NOT X10 THEN step := 29; END_IF;
    29:
        Y11 := TRUE;
        IF X11 THEN step := 30; END_IF;
    30:
        target_pose := 0;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 31;
        END_IF;
    31:
        IF D0 = target_pose AND NOT X10 THEN step := 32; END_IF;
    32:
        Y12 := TRUE;
        measure_started := TRUE;
        step := 33;
    33:
        measure_issued := TRUE;
        IF measure_started AND X16 THEN step := 34; END_IF;
    34:
        IF (D4 >= 5800 AND D4 <= 6200) AND (D5 >= 5800 AND D5 <= 6200) THEN
            is_good := TRUE;
        ELSE
            is_good := FALSE;
        END_IF;
        measure_started := FALSE;
        measure_issued := FALSE;
        step := 35;
    35:
        target_pose := 5;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 36;
        END_IF;
    36:
        IF D0 = target_pose AND NOT X10 THEN step := 37; END_IF;
    37:
        Y10 := TRUE;
        IF X12 THEN step := 38; END_IF;
    38:
        IF is_good THEN target_pose := 7; ELSE target_pose := 8 + rej_cnt; END_IF;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 39;
        END_IF;
    39:
        IF D0 = target_pose AND NOT X10 THEN step := 40; END_IF;
    40:
        Y11 := TRUE;
        IF X11 THEN step := 41; END_IF;
    41:
        target_pose := 0;
        IF NOT X10 THEN
            D100 := target_pose; move_seq_val := move_seq_val + 1; D101 := move_seq_val;
            step := 42;
        END_IF;
    42:
        IF D0 = target_pose AND NOT X10 THEN step := 43; END_IF;
    43:
        IF is_good THEN
            IF part_type = 1 THEN a_cnt := a_cnt + 1; END_IF;
            IF part_type = 2 THEN b_cnt := b_cnt + 1; END_IF;
            Y13 := TRUE;
            outfeed_issued := TRUE;
        ELSE
            rej_cnt := rej_cnt + 1;
        END_IF;
        step := 44;
    44:
        outfeed_issued := FALSE;
        step := 1;
    100:
        Y14 := TRUE;
END_CASE;
END_PROGRAM