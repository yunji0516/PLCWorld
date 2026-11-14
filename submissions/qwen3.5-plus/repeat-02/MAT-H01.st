PROGRAM Main
VAR
    step : INT := 0;
    part_idx : INT := 0;
    is_A : BOOL := TRUE;
    move_seq_val : INT := 1;
    current_target : INT := 0;
END_VAR

CASE step OF
    0: (* WAIT_START *)
        IF X0 THEN
            step := 10;
        END_IF;

    10: (* MOVE_SRC *)
        current_target := IF is_A THEN 1 ELSE 2 END_IF;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 20;
        END_IF;

    20: (* WAIT_ARRIVE_SRC *)
        IF NOT X10 AND D0 = current_target THEN
            step := 30;
        END_IF;

    30: (* GRIP_CLOSE_SRC *)
        Y10 := TRUE; Y11 := FALSE;
        step := 40;

    40: (* WAIT_GRIP_CLOSED *)
        IF X12 THEN
            Y10 := FALSE;
            step := 50;
        END_IF;

    50: (* MOVE_CELL *)
        current_target := IF is_A THEN 3 ELSE 4 END_IF;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 60;
        END_IF;

    60: (* WAIT_ARRIVE_CELL *)
        IF NOT X10 AND D0 = current_target THEN
            step := 70;
        END_IF;

    70: (* GRIP_OPEN_CELL *)
        Y11 := TRUE; Y10 := FALSE;
        step := 80;

    80: (* WAIT_GRIP_OPEN *)
        IF X11 THEN
            Y11 := FALSE;
            step := 90;
        END_IF;

    90: (* MOVE_HOME_LOAD *)
        current_target := 0;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 100;
        END_IF;

    100: (* WAIT_HOME_LOAD *)
        IF NOT X10 AND D0 = 0 THEN
            step := 110;
        END_IF;

    110: (* CLOSE_DOOR *)
        IF is_A THEN
            Y16 := TRUE; Y15 := FALSE;
        ELSE
            Y1B := TRUE; Y1A := FALSE;
        END_IF;
        step := 120;

    120: (* WAIT_DOOR_CLOSED *)
        IF (is_A AND X22) OR (NOT is_A AND X2D) THEN
            IF is_A THEN Y16 := FALSE; ELSE Y1B := FALSE; END_IF;
            step := 130;
        END_IF;

    130: (* CLOSE_CLAMP *)
        IF is_A THEN
            Y17 := TRUE; Y18 := FALSE;
        ELSE
            Y1C := TRUE; Y1D := FALSE;
        END_IF;
        step := 140;

    140: (* WAIT_CLAMP_CLOSED *)
        IF (is_A AND X24) OR (NOT is_A AND X2F) THEN
            IF is_A THEN Y17 := FALSE; ELSE Y1C := FALSE; END_IF;
            step := 150;
        END_IF;

    150: (* START_CYCLE *)
        IF is_A THEN
            Y19 := TRUE;
        ELSE
            Y1E := TRUE;
        END_IF;
        step := 155;

    155: (* PULSE_CYCLE_DONE *)
        IF is_A THEN Y19 := FALSE; ELSE Y1E := FALSE; END_IF;
        step := 160;

    160: (* WAIT_DONE *)
        IF (is_A AND X1F) OR (NOT is_A AND X2A) THEN
            step := 170;
        END_IF;

    170: (* OPEN_CLAMP *)
        IF is_A THEN
            Y18 := TRUE; Y17 := FALSE;
        ELSE
            Y1D := TRUE; Y1C := FALSE;
        END_IF;
        step := 180;

    180: (* WAIT_CLAMP_OPEN *)
        IF (is_A AND X23) OR (NOT is_A AND X2E) THEN
            IF is_A THEN Y18 := FALSE; ELSE Y1D := FALSE; END_IF;
            step := 190;
        END_IF;

    190: (* MOVE_CELL_PICK *)
        current_target := IF is_A THEN 3 ELSE 4 END_IF;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 200;
        END_IF;

    200: (* WAIT_ARRIVE_CELL_PICK *)
        IF NOT X10 AND D0 = current_target THEN
            step := 210;
        END_IF;

    210: (* GRIP_CLOSE_CELL *)
        Y10 := TRUE; Y11 := FALSE;
        step := 220;

    220: (* WAIT_GRIP_CLOSED_CELL *)
        IF X12 THEN
            Y10 := FALSE;
            step := 230;
        END_IF;

    230: (* MOVE_HOME_UNLOAD *)
        current_target := 0;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 240;
        END_IF;

    240: (* WAIT_HOME_UNLOAD *)
        IF NOT X10 AND D0 = 0 THEN
            step := 250;
        END_IF;

    250: (* WAIT_BUFFER_VACANT *)
        IF NOT X18 THEN
            step := 255;
        END_IF;

    255: (* MOVE_BUFFER *)
        current_target := 6;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 260;
        END_IF;

    260: (* WAIT_ARRIVE_BUFFER *)
        IF NOT X10 AND D0 = 6 THEN
            step := 270;
        END_IF;

    270: (* GRIP_OPEN_BUFFER *)
        Y11 := TRUE; Y10 := FALSE;
        step := 280;

    280: (* WAIT_GRIP_OPEN_BUFFER *)
        IF X11 THEN
            Y11 := FALSE;
            step := 290;
        END_IF;

    290: (* MOVE_HOME_BUF_PUT *)
        current_target := 0;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 300;
        END_IF;

    300: (* WAIT_HOME_BUF_PUT *)
        IF NOT X10 AND D0 = 0 THEN
            step := 310;
        END_IF;

    310: (* MOVE_BUFFER_PICK *)
        current_target := 6;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 320;
        END_IF;

    320: (* WAIT_ARRIVE_BUF_PICK *)
        IF NOT X10 AND D0 = 6 THEN
            step := 330;
        END_IF;

    330: (* GRIP_CLOSE_BUF *)
        Y10 := TRUE; Y11 := FALSE;
        step := 340;

    340: (* WAIT_GRIP_CLOSED_BUF *)
        IF X12 THEN
            Y10 := FALSE;
            step := 350;
        END_IF;

    350: (* WAIT_INSPECT_IDLE *)
        IF NOT X15 THEN
            step := 355;
        END_IF;

    355: (* MOVE_INSPECT *)
        current_target := 5;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 360;
        END_IF;

    360: (* WAIT_ARRIVE_INSPECT *)
        IF NOT X10 AND D0 = 5 THEN
            step := 370;
        END_IF;

    370: (* GRIP_OPEN_INSPECT *)
        Y11 := TRUE; Y10 := FALSE;
        step := 380;

    380: (* WAIT_GRIP_OPEN_INSPECT *)
        IF X11 THEN
            Y11 := FALSE;
            step := 390;
        END_IF;

    390: (* MOVE_HOME_INS_PUT *)
        current_target := 0;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 400;
        END_IF;

    400: (* WAIT_HOME_INS_PUT *)
        IF NOT X10 AND D0 = 0 THEN
            step := 410;
        END_IF;

    410: (* START_MEASURE *)
        Y12 := TRUE;
        step := 415;

    415: (* PULSE_MEASURE_DONE *)
        Y12 := FALSE;
        step := 420;

    420: (* WAIT_MEASURE *)
        IF X16 THEN
            step := 430;
        END_IF;

    430: (* MOVE_INSPECT_PICK *)
        IF NOT X15 THEN
            current_target := 5;
            IF NOT X10 THEN
                D100 := current_target;
                move_seq_val := move_seq_val + 1;
                D101 := move_seq_val;
                step := 440;
            END_IF;
        END_IF;

    440: (* WAIT_ARRIVE_INSPECT_PICK *)
        IF NOT X10 AND D0 = 5 THEN
            step := 450;
        END_IF;

    450: (* GRIP_CLOSE_INS *)
        Y10 := TRUE; Y11 := FALSE;
        step := 460;

    460: (* WAIT_GRIP_CLOSED_INS *)
        IF X12 THEN
            Y10 := FALSE;
            step := 470;
        END_IF;

    470: (* DETERMINE_TARGET *)
        IF (D4 >= 5800 AND D4 <= 6200) AND (D5 >= 5800 AND D5 <= 6200) THEN
            current_target := 7;
        ELSE
            IF NOT X34 THEN
                current_target := 8;
            ELSIF NOT X35 THEN
                current_target := 9;
            ELSIF NOT X36 THEN
                current_target := 10;
            ELSIF NOT X37 THEN
                current_target := 11;
            ELSE
                current_target := 8;
            END_IF;
        END_IF;
        step := 480;

    480: (* MOVE_TARGET_POSE *)
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 490;
        END_IF;

    490: (* WAIT_ARRIVE_TARGET *)
        IF NOT X10 AND D0 = current_target THEN
            step := 500;
        END_IF;

    500: (* GRIP_OPEN_TARGET *)
        Y11 := TRUE; Y10 := FALSE;
        step := 510;

    510: (* WAIT_GRIP_OPEN_TARGET *)
        IF X11 THEN
            Y11 := FALSE;
            step := 520;
        END_IF;

    520: (* MOVE_HOME_FINAL *)
        current_target := 0;
        IF NOT X10 THEN
            D100 := current_target;
            move_seq_val := move_seq_val + 1;
            D101 := move_seq_val;
            step := 530;
        END_IF;

    530: (* WAIT_HOME_FINAL *)
        IF NOT X10 AND D0 = 0 THEN
            step := 540;
        END_IF;

    540: (* PART_DONE *)
        part_idx := part_idx + 1;
        IF part_idx < 4 THEN
            is_A := (part_idx MOD 2) = 0;
            step := 10;
        ELSE
            step := 1000;
        END_IF;

    1000: (* COMPLETE *)
        Y14 := TRUE;
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE;
        Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
END_CASE;

END_PROGRAM