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
    D12 : INT;
    D13 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    state : INT;
    done_count : INT;
    current_id : INT;
    current_type : INT;
    desired_tool : INT := 1;
    selected_tool : INT := 1;
    current_width : INT := 160;
    target_a_width : INT := 160;
    target_b_width : INT := 160;
    b_clamp_hold : BOOL;
    b_keeper_hold : BOOL;
    complete_latched : BOOL;
    current_a_done : BOOL;
    b_pad_clear : BOOL;
    a_face_ok : BOOL;
    b_face_ok : BOOL;
    clampTimer : TON;
END_VAR

b_pad_clear := (AND_WORD(WORD(D6), WORD(2)) = WORD(0));
a_face_ok := (D5 = 0) OR (D5 = 1);
b_face_ok := (D5 = 1) OR (D5 = 2);

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
Y1F := FALSE;

CASE state OF
    0:
        b_clamp_hold := FALSE;
        b_keeper_hold := FALSE;
        current_a_done := FALSE;
        IF X0 THEN
            done_count := 0;
            complete_latched := FALSE;
            state := 5;
        END_IF;

    5:
        b_clamp_hold := FALSE;
        b_keeper_hold := FALSE;
        current_a_done := FALSE;
        IF done_count >= 4 THEN
            state := 200;
        ELSIF X10 THEN
            current_id := D0;
            current_type := D10;
            IF D10 = 1 THEN
                desired_tool := 1;
                current_width := 160;
            ELSE
                desired_tool := 2;
                current_width := 120;
            END_IF;
            selected_tool := desired_tool;
            target_a_width := current_width;
            target_b_width := current_width;
            state := 10;
        END_IF;

    10:
        target_a_width := current_width;
        IF NOT X28 THEN
            Y23 := TRUE;
        ELSE
            Y23 := FALSE;
            state := 20;
        END_IF;

    20:
        IF (NOT X17) AND (NOT X1B) AND X1A THEN
            Y15 := TRUE;
            state := 21;
        ELSIF (NOT X17) AND (NOT X1B) AND (NOT X1A) THEN
            state := 30;
        END_IF;

    21:
        IF (NOT X1B) AND (NOT X1A) THEN
            state := 30;
        END_IF;

    30:
        selected_tool := desired_tool;
        IF (D8 = desired_tool) AND X2B AND (NOT X29) THEN
            IF X2A THEN
                state := 54;
            ELSE
                state := 60;
            END_IF;
        ELSIF D8 <> 0 THEN
            selected_tool := D8;
            state := 31;
        ELSE
            selected_tool := desired_tool;
            state := 45;
        END_IF;

    31:
        selected_tool := D8;
        IF (NOT X11) AND (NOT X12) AND X13 AND (NOT X29) THEN
            Y1F := TRUE;
            state := 32;
        END_IF;

    32:
        selected_tool := D200;
        IF X2A AND (D9 = D200) AND (NOT X29) THEN
            state := 33;
        END_IF;

    33:
        IF X2A AND (NOT X12) AND (NOT X29) THEN
            Y20 := TRUE;
            state := 34;
        END_IF;

    34:
        IF (NOT X29) AND ((D8 = 0) OR (NOT X2B)) THEN
            selected_tool := desired_tool;
            state := 45;
        END_IF;

    45:
        selected_tool := desired_tool;
        IF (D8 = desired_tool) AND X2B THEN
            state := 54;
        ELSE
            state := 46;
        END_IF;

    46:
        selected_tool := desired_tool;
        IF (NOT X11) AND (NOT X12) AND X13 AND (NOT X29) THEN
            Y1F := TRUE;
            state := 47;
        END_IF;

    47:
        selected_tool := desired_tool;
        IF X2A AND (D9 = desired_tool) AND (NOT X29) THEN
            state := 48;
        END_IF;

    48:
        selected_tool := desired_tool;
        IF X2A AND (D9 = desired_tool) AND (NOT X29) THEN
            Y21 := TRUE;
            state := 49;
        END_IF;

    49:
        selected_tool := desired_tool;
        IF (NOT X29) AND (D8 = desired_tool) AND X2B THEN
            state := 54;
        END_IF;

    54:
        selected_tool := desired_tool;
        IF (D8 = desired_tool) AND X2B AND X2A AND (NOT X29) THEN
            Y22 := TRUE;
            state := 55;
        ELSIF (D8 = desired_tool) AND X2B AND (NOT X2A) AND (NOT X29) THEN
            state := 60;
        END_IF;

    55:
        selected_tool := desired_tool;
        IF (NOT X29) AND (NOT X2A) AND X13 AND (NOT X11) THEN
            state := 60;
        END_IF;

    60:
        selected_tool := desired_tool;
        target_a_width := current_width;
        IF X10 AND X28 AND (NOT X14) AND (NOT X1A) AND (NOT X1B) AND
           (D8 = desired_tool) AND X2B AND (NOT X2A) AND
           (NOT X11) AND (NOT X12) AND X13 AND (NOT X29) THEN
            current_id := D0;
            current_type := D10;
            Y10 := TRUE;
            state := 61;
        END_IF;

    61:
        IF X14 AND (D1 = current_id) AND (NOT X11) AND (NOT X12) AND X13 THEN
            state := 70;
        END_IF;

    70:
        target_a_width := current_width;
        IF X14 AND (D1 = current_id) AND X2C AND a_face_ok AND
           (NOT X16) AND (NOT X11) AND (NOT X12) THEN
            Y11 := TRUE;
            state := 71;
        END_IF;

    71:
        IF X15 AND (D1 = current_id) AND (NOT X16) THEN
            current_a_done := TRUE;
            state := 80;
        END_IF;

    80:
        IF current_a_done AND (NOT X11) AND (NOT X12) AND X13 AND
           (NOT X17) AND (NOT X1B) AND (D8 = desired_tool) AND X2B THEN
            Y12 := TRUE;
            state := 81;
        END_IF;

    81:
        IF X17 AND (D2 = current_id) AND (NOT X11) AND X12 THEN
            state := 82;
        END_IF;

    82:
        IF X17 AND (D2 = current_id) AND (NOT X18) AND (NOT X1B) THEN
            Y13 := TRUE;
            state := 83;
        ELSIF X18 THEN
            state := 84;
        END_IF;

    83:
        IF X18 AND X17 AND (D2 = current_id) THEN
            state := 84;
        END_IF;

    84:
        IF X18 AND X17 AND (NOT X11) THEN
            Y14 := TRUE;
            state := 85;
        END_IF;

    85:
        IF (NOT X12) AND X13 AND (NOT X11) THEN
            state := 86;
        END_IF;

    86:
        IF X17 AND X18 AND (NOT X1B) AND (NOT X1A) THEN
            Y15 := TRUE;
            state := 87;
        END_IF;

    87:
        IF X1A AND (NOT X1B) THEN
            state := 88;
        END_IF;

    88:
        IF X17 AND X1A AND (NOT X11) AND (NOT X12) AND
           (D8 = desired_tool) AND X2B AND (NOT X29) THEN
            Y16 := TRUE;
            state := 89;
        END_IF;

    89:
        IF X12 AND (D4 = current_id) AND (NOT X11) THEN
            state := 90;
        END_IF;

    90:
        target_b_width := current_width;
        IF X12 AND X1A AND X17 THEN
            Y17 := TRUE;
            IF X19 THEN
                state := 91;
            END_IF;
        END_IF;

    91:
        target_b_width := current_width;
        IF X19 AND b_pad_clear AND (NOT X11) AND X12 AND (NOT X1C) THEN
            Y18 := TRUE;
            state := 92;
        END_IF;

    92:
        target_b_width := current_width;
        IF X1C AND (D3 = current_id) AND (NOT X11) AND (NOT X12) AND X13 AND X27 THEN
            IF (done_count < 3) AND X1A AND (NOT X1B) AND (NOT X17) THEN
                Y15 := TRUE;
                state := 94;
            ELSE
                state := 100;
            END_IF;
        END_IF;

    94:
        IF (NOT X1A) AND (NOT X1B) THEN
            state := 100;
        END_IF;

    100:
        target_b_width := current_width;
        IF NOT X2D THEN
            Y24 := TRUE;
        ELSIF X1C AND (D3 = current_id) AND X27 AND (NOT X11) AND (NOT X12) THEN
            state := 110;
        END_IF;

    110:
        b_clamp_hold := TRUE;
        state := 111;

    111:
        b_clamp_hold := TRUE;
        IF clampTimer.Q AND X23 THEN
            state := 120;
        END_IF;

    120:
        b_clamp_hold := TRUE;
        b_keeper_hold := TRUE;
        IF X25 THEN
            state := 130;
        END_IF;

    130:
        b_clamp_hold := TRUE;
        b_keeper_hold := TRUE;
        IF X1C AND (D3 = current_id) AND current_a_done AND X22 AND
           X23 AND X25 AND X26 AND X2D AND b_pad_clear AND b_face_ok AND
           (NOT X1E) AND (NOT X11) AND (NOT X12) AND (NOT X29) THEN
            Y19 := TRUE;
            state := 131;
        END_IF;

    131:
        b_clamp_hold := TRUE;
        b_keeper_hold := TRUE;
        IF X1D AND (D3 = current_id) AND (NOT X1E) THEN
            state := 140;
        END_IF;

    140:
        b_clamp_hold := FALSE;
        b_keeper_hold := TRUE;
        IF X24 AND X25 THEN
            state := 150;
        END_IF;

    150:
        b_clamp_hold := FALSE;
        b_keeper_hold := TRUE;
        IF X1D AND X24 AND X25 AND X1F AND (NOT X20) THEN
            Y1A := TRUE;
            state := 151;
        END_IF;

    151:
        b_clamp_hold := FALSE;
        b_keeper_hold := TRUE;
        Y1A := TRUE;
        IF X20 AND (D7 = current_id) THEN
            state := 152;
        END_IF;

    152:
        b_clamp_hold := FALSE;
        b_keeper_hold := TRUE;
        Y1B := TRUE;
        done_count := done_count + 1;
        state := 153;

    153:
        b_clamp_hold := FALSE;
        Y1B := TRUE;
        IF NOT X20 THEN
            b_keeper_hold := FALSE;
            IF done_count >= 4 THEN
                state := 200;
            ELSE
                state := 5;
            END_IF;
        END_IF;

    200:
        b_clamp_hold := FALSE;
        b_keeper_hold := FALSE;
        IF (done_count >= 4) AND X21 AND (NOT X11) AND (NOT X12) AND
           (NOT X16) AND (NOT X1E) AND (NOT X1B) AND (NOT X29) AND
           (NOT X2A) AND (NOT X17) AND (NOT X1C) AND (NOT X20) THEN
            complete_latched := TRUE;
        END_IF;

ELSE
    state := 0;
END_CASE;

clampTimer(IN := b_clamp_hold, PT := T#300ms);

Y1D := b_clamp_hold;
Y1E := b_keeper_hold;

D200 := selected_tool;
D201 := target_a_width;
D202 := target_b_width;

IF complete_latched THEN
    Y1C := TRUE;
ELSE
    Y1C := FALSE;
END_IF;

END_PROGRAM