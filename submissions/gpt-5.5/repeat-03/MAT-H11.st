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
    step : INT;
    product_count : INT;
    current_id : INT;
    current_type : INT;
    current_width : INT;
    b_width_prepared : BOOL;
    complete_latched : BOOL;
    b_mask_clear : BOOL;
    pad_timer : TON;
    b_adjust_timer : TON;
    b_clamp_timer : TON;
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
Y23 := FALSE;
Y24 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF current_type = 2 THEN
    current_width := 120;
ELSE
    current_width := 160;
END_IF;

IF current_type <> 0 THEN
    D200 := current_type;
END_IF;
D201 := current_width;
D202 := current_width;

b_mask_clear := (D6 = 0) OR (D6 = 1) OR (D6 = 4) OR (D6 = 5);

pad_timer(IN := (step = 73) AND X18, PT := T#250ms);
b_adjust_timer(IN := (step >= 10) AND (step < 92) AND (NOT b_width_prepared), PT := T#6s);
b_clamp_timer(IN := (step = 82) AND X2D AND X27, PT := T#300ms);

IF b_adjust_timer.Q THEN
    b_width_prepared := TRUE;
END_IF;

IF (step >= 10) AND (step <= 50) AND (NOT X28) THEN
    Y23 := TRUE;
END_IF;

IF (step >= 10) AND (step < 90) AND (NOT b_width_prepared) THEN
    Y24 := TRUE;
END_IF;

IF (step >= 82) AND (step <= 84) AND (NOT X2D) THEN
    Y24 := TRUE;
END_IF;

IF (step >= 82) AND (step <= 90) AND X2D AND X27 THEN
    Y1D := TRUE;
END_IF;

IF (step >= 83) AND (step <= 91) THEN
    Y1E := TRUE;
END_IF;

CASE step OF
0:
    IF X0 THEN
        step := 5;
    END_IF;

5:
    IF product_count >= 4 THEN
        step := 100;
    ELSIF X1A AND (NOT X1B) AND (NOT X17) AND (NOT X11) AND (NOT X29) THEN
        Y15 := TRUE;
        step := 6;
    ELSIF X10 THEN
        current_id := D0;
        IF D10 = 2 THEN
            current_type := 2;
            current_width := 120;
        ELSE
            current_type := 1;
            current_width := 160;
        END_IF;
        D200 := current_type;
        D201 := current_width;
        D202 := current_width;
        b_width_prepared := FALSE;
        step := 10;
    END_IF;

6:
    IF (NOT X1B) AND (NOT X1A) THEN
        step := 5;
    END_IF;

10:
    D200 := current_type;
    IF (D8 = current_type) AND X2B AND (NOT X29) AND (NOT X11) AND X13 AND (NOT X12) AND (NOT X2A) THEN
        step := 50;
    ELSIF (D8 = current_type) AND X2B AND X2A AND (NOT X29) AND (NOT X11) THEN
        step := 34;
    ELSIF D8 <> 0 THEN
        step := 20;
    ELSE
        step := 30;
    END_IF;

20:
    D200 := D8;
    IF (D8 <> 0) AND (NOT X11) AND (NOT X29) AND X13 AND (NOT X12) THEN
        Y1F := TRUE;
        step := 21;
    END_IF;

21:
    D200 := D8;
    IF X2A AND (D9 = D200) AND (NOT X29) THEN
        step := 22;
    END_IF;

22:
    D200 := D8;
    IF X2A AND (NOT X12) THEN
        Y20 := TRUE;
        step := 23;
    END_IF;

23:
    IF (D8 = 0) AND (NOT X29) THEN
        step := 30;
    END_IF;

30:
    D200 := current_type;
    IF (current_type <> 0) AND (D8 = 0) AND (NOT X11) AND (NOT X29) AND X13 AND (NOT X12) THEN
        Y1F := TRUE;
        step := 31;
    END_IF;

31:
    D200 := current_type;
    IF X2A AND (D9 = current_type) AND (NOT X29) THEN
        step := 32;
    END_IF;

32:
    D200 := current_type;
    IF X2A AND (D9 = current_type) AND (NOT X29) THEN
        Y21 := TRUE;
        step := 33;
    END_IF;

33:
    D200 := current_type;
    IF (D8 = current_type) AND X2B AND (NOT X29) THEN
        step := 34;
    END_IF;

34:
    D200 := current_type;
    IF (D8 = current_type) AND X2B AND (NOT X29) THEN
        Y22 := TRUE;
        step := 35;
    END_IF;

35:
    D200 := current_type;
    IF (D8 = current_type) AND X2B AND (NOT X29) AND (NOT X2A) AND X13 AND (NOT X11) THEN
        step := 50;
    END_IF;

50:
    D200 := current_type;
    IF X10 AND X28 AND (D8 = current_type) AND X2B AND (NOT X2A) AND (NOT X11) AND (NOT X29) AND X13 AND (NOT X12) AND (NOT X17) AND (NOT X1A) AND (NOT X1B) THEN
        current_id := D0;
        Y10 := TRUE;
        step := 51;
    END_IF;

51:
    IF X14 AND (NOT X11) AND X13 AND (NOT X12) THEN
        step := 60;
    END_IF;

60:
    IF X15 THEN
        step := 70;
    ELSE
        IF X14 AND X2C AND (D5 = 1) THEN
            Y11 := TRUE;
        END_IF;
    END_IF;

70:
    IF X15 AND (NOT X16) AND (NOT X11) AND X13 AND (NOT X12) AND (NOT X17) THEN
        Y12 := TRUE;
        step := 71;
    END_IF;

71:
    IF X17 AND (NOT X11) THEN
        step := 72;
    END_IF;

72:
    IF X17 AND (NOT X1B) THEN
        IF NOT X18 THEN
            Y13 := TRUE;
        END_IF;
        step := 73;
    END_IF;

73:
    IF pad_timer.Q THEN
        step := 74;
    END_IF;

74:
    IF X18 THEN
        Y14 := TRUE;
    END_IF;
    IF X18 AND (NOT X12) AND X13 AND (NOT X11) THEN
        step := 75;
    END_IF;

75:
    IF X17 AND X18 AND X13 AND (NOT X11) AND (NOT X1B) THEN
        Y15 := TRUE;
        step := 76;
    END_IF;

76:
    IF X1A AND (NOT X1B) THEN
        step := 77;
    END_IF;

77:
    IF (D8 = current_type) AND X2B AND (NOT X11) AND X13 AND (NOT X29) THEN
        Y16 := TRUE;
        step := 78;
    END_IF;

78:
    IF X12 AND (NOT X11) THEN
        step := 79;
    END_IF;

79:
    Y17 := TRUE;
    IF X19 AND b_mask_clear THEN
        step := 80;
    END_IF;

80:
    Y17 := TRUE;
    IF X19 AND b_mask_clear AND b_width_prepared AND (NOT X11) AND (NOT X1B) AND X17 THEN
        Y18 := TRUE;
        step := 81;
    END_IF;

81:
    Y17 := TRUE;
    IF X1C AND (NOT X11) AND X13 AND (NOT X12) AND X27 THEN
        step := 82;
    END_IF;

82:
    IF X2D AND X27 AND b_clamp_timer.Q AND X23 THEN
        step := 83;
    END_IF;

83:
    IF X23 AND X25 AND X26 AND b_mask_clear THEN
        step := 84;
    END_IF;

84:
    IF X1D THEN
        step := 90;
    ELSE
        IF X1C AND X2D AND X22 AND X23 AND X25 AND X26 AND X27 AND b_mask_clear AND (D5 = 2) AND (NOT X11) AND (NOT X29) AND X13 THEN
            Y19 := TRUE;
        END_IF;
    END_IF;

90:
    IF X1D AND X1F AND X25 AND X26 AND (NOT X11) AND (NOT X29) THEN
        Y1A := TRUE;
        step := 91;
    END_IF;

91:
    Y1A := TRUE;
    IF X20 THEN
        step := 92;
    END_IF;

92:
    Y1B := TRUE;
    product_count := product_count + 1;
    step := 93;

93:
    Y1B := TRUE;
    IF NOT X20 THEN
        IF product_count >= 4 THEN
            step := 100;
        ELSE
            step := 5;
        END_IF;
    END_IF;

100:
    IF (product_count >= 4) AND (NOT X11) AND (NOT X29) AND (NOT X1B) AND (NOT X16) AND (NOT X1E) AND (NOT X12) AND X13 AND (NOT X17) AND (NOT X1C) AND (NOT X20) AND (NOT X2A) THEN
        complete_latched := TRUE;
    END_IF;

ELSE
    step := 0;
END_CASE;

Y1C := complete_latched;

END_PROGRAM