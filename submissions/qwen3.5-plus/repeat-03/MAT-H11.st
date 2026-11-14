PROGRAM Main
VAR
    X0 : BOOL; X10 : BOOL; X11 : BOOL; X12 : BOOL; X13 : BOOL;
    X14 : BOOL; X15 : BOOL; X16 : BOOL; X17 : BOOL; X18 : BOOL;
    X19 : BOOL; X20 : BOOL; X21 : BOOL; X22 : BOOL; X23 : BOOL;
    X24 : BOOL; X25 : BOOL; X26 : BOOL; X27 : BOOL; X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL; Y11 : BOOL; Y12 : BOOL; Y13 : BOOL; Y14 : BOOL;
    Y15 : BOOL; Y16 : BOOL; Y17 : BOOL; Y18 : BOOL; Y19 : BOOL;
    Y20 : BOOL; Y21 : BOOL; Y22 : BOOL; Y23 : BOOL; Y24 : BOOL;
    D0 : INT; D1 : INT; D2 : INT; D3 : INT; D4 : INT;
    D5 : INT; D6 : INT; D7 : INT; D8 : INT; D9 : INT;
    D10 : INT; D11 : INT; D12 : INT; D13 : INT;
    D200 : INT; D201 : INT; D202 : INT;
    X1A : BOOL; X1B : BOOL; X1C : BOOL; X1D : BOOL; X1E : BOOL;
    X1F : BOOL; X2A : BOOL; X2B : BOOL; X2C : BOOL; X2D : BOOL;
    Y1A : BOOL; Y1B : BOOL; Y1C : BOOL; Y1D : BOOL; Y1E : BOOL; Y1F : BOOL;
    step : INT := 0;
    product_idx : INT := 1;
    target_w : INT := 160;
    timer_300 : TON;
    timer_comp : TON;
END_VAR

IF step <> 19 THEN timer_300(IN := FALSE); END_IF;
IF step <> 50 THEN timer_comp(IN := FALSE); END_IF;

CASE step OF
    0: (* INIT & WAIT START *)
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
        Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
        Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;
        D200 := 0; D201 := 200; D202 := 200;
        IF X0 THEN step := 1; END_IF;

    1: (* SET A WIDTH *)
        IF product_idx MOD 2 = 1 THEN target_w := 160 ELSE target_w := 120 END_IF;
        D201 := target_w;
        Y23 := TRUE;
        IF X2C THEN
            Y23 := FALSE;
            step := 2;
        END_IF;

    2: (* WAIT SOURCE READY *)
        Y23 := FALSE;
        IF X10 THEN step := 3; END_IF;

    3: (* ADMIIT PULSE *)
        Y10 := TRUE;
        step := 4;

    4: (* ADMIIT OFF *)
        Y10 := FALSE;
        step := 5;

    5: (* WORK A *)
        Y11 := TRUE;
        IF X15 THEN
            Y11 := FALSE;
            step := 6;
        END_IF;

    6: (* TO CRADLE *)
        Y12 := TRUE;
        IF X17 OR X19 THEN
            Y12 := FALSE;
            step := 7;
        END_IF;

    7: (* CRADLE LOCK PULSE *)
        Y13 := TRUE;
        step := 8;

    8: (* CRADLE LOCK OFF & WAIT *)
        Y13 := FALSE;
        IF X18 THEN step := 9; END_IF;

    9: (* HEAD RELEASE PULSE *)
        Y14 := TRUE;
        step := 10;

    10: (* HEAD RELEASE OFF & WAIT *)
        Y14 := FALSE;
        IF X13 THEN step := 11; END_IF;

    11: (* ROTATE PULSE *)
        Y15 := TRUE;
        step := 12;

    12: (* ROTATE OFF & WAIT *)
        Y15 := FALSE;
        IF X1A THEN step := 13; END_IF;

    13: (* HEAD GRIP PULSE *)
        Y16 := TRUE;
        step := 14;

    14: (* HEAD GRIP OFF & WAIT *)
        Y16 := FALSE;
        IF X12 THEN step := 15; END_IF;

    15: (* CRADLE UNLOCK PULSE *)
        Y17 := TRUE;
        step := 16;

    16: (* CRADLE UNLOCK OFF & WAIT *)
        Y17 := FALSE;
        IF X19 THEN step := 17; END_IF;

    17: (* SET B WIDTH *)
        D202 := target_w;
        Y24 := TRUE;
        IF X2D THEN
            Y24 := FALSE;
            step := 18;
        END_IF;

    18: (* TO B *)
        Y18 := TRUE;
        IF X27 THEN
            Y18 := FALSE;
            step := 19;
        END_IF;

    19: (* CLAMP DELAY 300ms *)
        timer_300(IN := TRUE, PT := T#300ms);
        IF timer_300.Q THEN
            step := 20;
        END_IF;

    20: (* B CLAMP & KEEPER *)
        Y1D := TRUE;
        Y1E := TRUE;
        IF X23 AND X25 AND X26 AND X22 THEN
            step := 21;
        END_IF;

    21: (* WORK B *)
        Y19 := TRUE;
        IF X1D THEN
            Y19 := FALSE;
            step := 22;
        END_IF;

    22: (* RELEASE PULSE *)
        Y1A := TRUE;
        step := 23;

    23: (* RELEASE OFF & WAIT *)
        Y1A := FALSE;
        IF X20 THEN step := 24; END_IF;

    24: (* ACK EXIT PULSE *)
        Y1B := TRUE;
        step := 25;

    25: (* ACK EXIT OFF *)
        Y1B := FALSE;
        step := 26;

    26: (* TOOL CHECK *)
        IF product_idx MOD 2 = 1 THEN
            IF D8 <> 1 THEN step := 30; END_IF;
        ELSE
            IF D8 <> 2 THEN step := 30; END_IF;
        END_IF;
        IF step = 26 THEN step := 40; END_IF;

    30: (* TOOL DOCK *)
        IF product_idx MOD 2 = 1 THEN D200 := 1 ELSE D200 := 2 END_IF;
        Y1F := TRUE;
        IF X2A THEN
            Y1F := FALSE;
            step := 31;
        END_IF;

    31: (* TOOL LOCK PULSE *)
        Y21 := TRUE;
        step := 32;

    32: (* TOOL LOCK OFF & WAIT *)
        Y21 := FALSE;
        IF X2B THEN step := 33; END_IF;

    33: (* TOOL RETURN PULSE *)
        Y22 := TRUE;
        step := 34;

    34: (* TOOL RETURN OFF & WAIT *)
        Y22 := FALSE;
        IF X13 THEN step := 40; END_IF;

    40: (* NEXT PRODUCT *)
        product_idx := product_idx + 1;
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
        Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
        Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;
        D200 := 0;
        IF product_idx > 4 THEN
            step := 50;
        ELSE
            step := 1;
        END_IF;

    50: (* COMPLETE *)
        Y1C := TRUE;
        timer_comp(IN := TRUE, PT := T#500ms);
END_CASE;

END_PROGRAM