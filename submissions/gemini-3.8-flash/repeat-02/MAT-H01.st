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
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT;
    D101 : INT;
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

    step : INT := 0;
    part_idx : INT := 0;
    curr_cell : INT := 0;
    target_pose : INT := 0;
    next_step : INT := 0;
    pulse_timer : INT := 0;
    target_reject : INT := 8;
    is_accepted : BOOL := FALSE;
    started : BOOL := FALSE;
END_VAR

IF NOT started THEN
    IF X0 THEN
        started := TRUE;
        step := 10;
        part_idx := 0;
    END_IF;
    RETURN;
END_IF;

CASE step OF
    10: (* Select next part to process *)
        IF part_idx < 2 THEN
            curr_cell := 3; (* Cell A *)
            target_pose := 1; (* Source A *)
            step := 20;
        ELSIF part_idx < 4 THEN
            curr_cell := 4; (* Cell B *)
            target_pose := 2; (* Source B *)
            step := 20;
        ELSE
            step := 900; (* All parts processed *)
        END_IF;

    (* Move to source *)
    20:
        IF NOT X10 THEN
            D100 := target_pose;
            D101 := D101 + 1;
            step := 21;
        END_IF;

    21:
        IF (NOT X10) AND (D0 = target_pose) AND (D1 = D101) THEN
            Y10 := TRUE;
            Y11 := FALSE;
            step := 22;
        END_IF;

    22: (* Grip workpiece at source *)
        IF X13 OR X12 THEN
            Y10 := FALSE;
            (* Check cell is ready to receive: door open, clamp open *)
            IF curr_cell = 3 THEN
                IF X21 AND X23 THEN
                    step := 30;
                ELSE
                    step := 25;
                END_IF;
            ELSE
                IF X2C AND X2E THEN
                    step := 30;
                ELSE
                    step := 25;
                END_IF;
            END_IF;
        END_IF;

    25: (* Ensure cell door and clamp are open *)
        IF curr_cell = 3 THEN
            Y18 := NOT X23;
            Y17 := FALSE;
            Y15 := NOT X21;
            Y16 := FALSE;
            IF X21 AND X23 THEN
                Y18 := FALSE;
                Y15 := FALSE;
                step := 30;
            END_IF;
        ELSE
            Y1D := NOT X2E;
            Y1C := FALSE;
            Y1A := NOT X2C;
            Y1B := FALSE;
            IF X2C AND X2E THEN
                Y1D := FALSE;
                Y1A := FALSE;
                step := 30;
            END_IF;
        END_IF;

    (* Move robot to cell *)
    30:
        IF NOT X10 THEN
            D100 := curr_cell;
            D101 := D101 + 1;
            step := 31;
        END_IF;

    31:
        IF (NOT X10) AND (D0 = curr_cell) AND (D1 = D101) THEN
            Y11 := TRUE;
            Y10 := FALSE;
            step := 32;
        END_IF;

    32: (* Release workpiece in cell *)
        IF X11 AND (NOT X13) THEN
            Y11 := FALSE;
            step := 40;
        END_IF;

    (* Move robot out of cell sweep to Home (pose 0) *)
    40:
        IF NOT X10 THEN
            D100 := 0;
            D101 := D101 + 1;
            step := 41;
        END_IF;

    41:
        IF (NOT X10) AND (D0 = 0) AND (D1 = D101) THEN
            step := 50;
        END_IF;

    (* Clamp workpiece in cell *)
    50:
        IF curr_cell = 3 THEN
            Y17 := TRUE;
            Y18 := FALSE;
            IF X24 THEN
                Y17 := FALSE;
                step := 52;
            END_IF;
        ELSE
            Y1C := TRUE;
            Y1D := FALSE;
            IF X2F THEN
                Y1C := FALSE;
                step := 52;
            END_IF;
        END_IF;

    (* Close cell door *)
    52:
        IF curr_cell = 3 THEN
            Y16 := TRUE;
            Y15 := FALSE;
            IF X22 THEN
                Y16 := FALSE;
                step := 60;
            END_IF;
        ELSE
            Y1B := TRUE;
            Y1A := FALSE;
            IF X2D THEN
                Y1B := FALSE;
                step := 60;
            END_IF;
        END_IF;

    (* Start machining cycle *)
    60:
        IF curr_cell = 3 THEN
            Y19 := TRUE;
            step := 61;
        ELSE
            Y1E := TRUE;
            step := 61;
        END_IF;

    61:
        IF curr_cell = 3 THEN
            Y19 := FALSE;
            IF X20 THEN
                step := 62;
            END_IF;
        ELSE
            Y1E := FALSE;
            IF X2B THEN
                step := 62;
            END_IF;
        END_IF;

    62: (* Wait for machining completion *)
        IF curr_cell = 3 THEN
            IF X1F AND (NOT X20) THEN
                step := 70;
            END_IF;
        ELSE
            IF X2A AND (NOT X2B) THEN
                step := 70;
            END_IF;
        END_IF;

    (* Open cell door *)
    70:
        IF curr_cell = 3 THEN
            Y15 := TRUE;
            Y16 := FALSE;
            IF X21 THEN
                Y15 := FALSE;
                step := 72;
            END_IF;
        ELSE
            Y1A := TRUE;
            Y1B := FALSE;
            IF X2C THEN
                Y1A := FALSE;
                step := 72;
            END_IF;
        END_IF;

    (* Open cell clamp *)
    72:
        IF curr_cell = 3 THEN
            Y18 := TRUE;
            Y17 := FALSE;
            IF X23 THEN
                Y18 := FALSE;
                step := 80;
            END_IF;
        ELSE
            Y1D := TRUE;
            Y1C := FALSE;
            IF X2E THEN
                Y1D := FALSE;
                step := 80;
            END_IF;
        END_IF;

    (* Pick machined workpiece from cell *)
    80:
        IF NOT X10 THEN
            D100 := curr_cell;
            D101 := D101 + 1;
            step := 81;
        END_IF;

    81:
        IF (NOT X10) AND (D0 = curr_cell) AND (D1 = D101) THEN
            Y10 := TRUE;
            Y11 := FALSE;
            step := 82;
        END_IF;

    82:
        IF X13 OR X12 THEN
            Y10 := FALSE;
            step := 90;
        END_IF;

    (* Move to inspection fixture (pose 5) *)
    90:
        IF NOT X10 THEN
            D100 := 5;
            D101 := D101 + 1;
            step := 91;
        END_IF;

    91:
        IF (NOT X10) AND (D0 = 5) AND (D1 = D101) THEN
            Y11 := TRUE;
            Y10 := FALSE;
            step := 92;
        END_IF;

    92: (* Release workpiece at inspection station *)
        IF X11 AND (NOT X13) THEN
            Y11 := FALSE;
            step := 100;
        END_IF;

    (* Move robot clear to pose 0 before measuring *)
    100:
        IF NOT X10 THEN
            D100 := 0;
            D101 := D101 + 1;
            step := 101;
        END_IF;

    101:
        IF (NOT X10) AND (D0 = 0) AND (D1 = D101) THEN
            IF X14 AND (NOT X15) AND X17 THEN
                Y12 := TRUE;
                step := 110;
            END_IF;
        END_IF;

    (* Pulse measure *)
    110:
        Y12 := FALSE;
        IF X15 THEN
            step := 111;
        END_IF;

    111: (* Wait for measurement done *)
        IF (NOT X15) AND X16 AND X17 THEN
            IF (D4 >= 5800) AND (D4 <= 6200) AND (D5 >= 5800) AND (D5 <= 6200) THEN
                is_accepted := TRUE;
            ELSE
                is_accepted := FALSE;
            END_IF;
            step := 120;
        END_IF;

    (* Pick inspected workpiece *)
    120:
        IF NOT X10 THEN
            D100 := 5;
            D101 := D101 + 1;
            step := 121;
        END_IF;

    121:
        IF (NOT X10) AND (D0 = 5) AND (D1 = D101) THEN
            Y10 := TRUE;
            Y11 := FALSE;
            step := 122;
        END_IF;

    122:
        IF X13 OR X12 THEN
            Y10 := FALSE;
            IF is_accepted THEN
                step := 130;
            ELSE
                step := 140;
            END_IF;
        END_IF;

    (* Accepted workpiece disposition -> Pose 7 *)
    130:
        IF X1A AND (NOT X10) THEN
            D100 := 7;
            D101 := D101 + 1;
            step := 131;
        END_IF;

    131:
        IF (NOT X10) AND (D0 = 7) AND (D1 = D101) THEN
            Y11 := TRUE;
            Y10 := FALSE;
            step := 132;
        END_IF;

    132:
        IF X11 AND (NOT X13) THEN
            Y11 := FALSE;
            step := 133;
        END_IF;

    (* Retract robot before outfeed pulse *)
    133:
        IF NOT X10 THEN
            D100 := 0;
            D101 := D101 + 1;
            step := 134;
        END_IF;

    134:
        IF (NOT X10) AND (D0 = 0) AND (D1 = D101) THEN
            Y13 := TRUE;
            pulse_timer := 0;
            step := 135;
        END_IF;

    135:
        pulse_timer := pulse_timer + 1;
        IF pulse_timer >= 5 THEN
            Y13 := FALSE;
            IF X1A THEN
                part_idx := part_idx + 1;
                step := 10;
            END_IF;
        END_IF;

    (* Rejected workpiece disposition -> distinct reject pocket *)
    140:
        IF NOT X34 THEN
            target_reject := 8;
        ELSIF NOT X35 THEN
            target_reject := 9;
        ELSIF NOT X36 THEN
            target_reject := 10;
        ELSE
            target_reject := 11;
        END_IF;
        step := 141;

    141:
        IF NOT X10 THEN
            D100 := target_reject;
            D101 := D101 + 1;
            step := 142;
        END_IF;

    142:
        IF (NOT X10) AND (D0 = target_reject) AND (D1 = D101) THEN
            Y11 := TRUE;
            Y10 := FALSE;
            step := 143;
        END_IF;

    143:
        IF X11 AND (NOT X13) THEN
            Y11 := FALSE;
            step := 144;
        END_IF;

    144:
        IF NOT X10 THEN
            D100 := 0;
            D101 := D101 + 1;
            step := 145;
        END_IF;

    145:
        IF (NOT X10) AND (D0 = 0) AND (D1 = D101) THEN
            part_idx := part_idx + 1;
            step := 10;
        END_IF;

    (* All parts finished *)
    900:
        IF (NOT X10) AND (D0 = 0) AND (NOT X13) AND X11 THEN
            IF X1B THEN
                Y14 := TRUE;
                step := 999;
            END_IF;
        END_IF;

    999:
        Y14 := TRUE;
END_CASE;

END_PROGRAM