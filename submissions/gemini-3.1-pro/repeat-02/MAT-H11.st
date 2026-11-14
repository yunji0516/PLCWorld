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
    
    step : INT := 0;
    target_tool : INT := 0;
    current_type : INT := 0;
    comp_timer : TON;
END_VAR

IF NOT X0 THEN
    RETURN;
END_IF;

Y23 := TRUE;
Y24 := TRUE;

CASE step OF
    0:
        IF D7 >= 4 THEN
            step := 990;
        ELSIF X10 THEN
            target_tool := D10;
            current_type := D10;
            IF D10 = 1 THEN
                D201 := 160;
            ELSE
                D201 := 120;
            END_IF;
            
            IF X1A AND NOT X1B THEN
                Y15 := TRUE;
                step := 5;
            ELSIF D8 <> target_tool THEN
                IF D8 <> 0 THEN
                    D200 := D8;
                    Y1F := TRUE;
                    step := 10;
                ELSE
                    D200 := target_tool;
                    Y1F := TRUE;
                    step := 19;
                END_IF;
            ELSE
                step := 30;
            END_IF;
        END_IF;

    5:
        Y15 := FALSE;
        IF NOT X1A AND NOT X1B THEN
            step := 0;
        END_IF;

    10:
        Y1F := FALSE;
        IF X2A AND NOT X11 THEN
            Y20 := TRUE;
            step := 11;
        END_IF;

    11:
        Y20 := FALSE;
        IF NOT X2B THEN
            D200 := target_tool;
            Y1F := TRUE;
            step := 19;
        END_IF;

    19:
        Y1F := FALSE;
        IF NOT X2A OR X11 THEN
            step := 20;
        END_IF;

    20:
        IF X2A AND NOT X11 THEN
            Y21 := TRUE;
            step := 21;
        END_IF;

    21:
        Y21 := FALSE;
        IF X2B THEN
            Y22 := TRUE;
            step := 22;
        END_IF;

    22:
        Y22 := FALSE;
        IF NOT X2A AND NOT X11 THEN
            step := 30;
        END_IF;

    30:
        IF X28 AND X13 AND NOT X11 THEN
            Y10 := TRUE;
            step := 31;
        END_IF;

    31:
        Y10 := FALSE;
        IF X14 AND NOT X11 THEN
            Y11 := TRUE;
            step := 32;
        END_IF;

    32:
        Y11 := FALSE;
        IF X15 THEN
            Y12 := TRUE;
            step := 33;
        END_IF;

    33:
        Y12 := FALSE;
        IF X17 AND X12 AND NOT X11 THEN
            Y13 := TRUE;
            step := 34;
        END_IF;

    34:
        Y13 := FALSE;
        IF X18 THEN
            Y14 := TRUE;
            step := 35;
        END_IF;

    35:
        Y14 := FALSE;
        IF X13 AND NOT X11 THEN
            Y15 := TRUE;
            step := 36;
        END_IF;

    36:
        Y15 := FALSE;
        IF X1A AND NOT X1B THEN
            Y16 := TRUE;
            step := 37;
        END_IF;

    37:
        Y16 := FALSE;
        IF X12 AND NOT X11 THEN
            Y17 := TRUE;
            step := 38;
        END_IF;

    38:
        Y17 := FALSE;
        IF NOT X18 AND X19 THEN
            IF current_type = 1 THEN
                D202 := 160;
            ELSE
                D202 := 120;
            END_IF;
            Y18 := TRUE;
            step := 39;
        END_IF;

    39:
        Y18 := FALSE;
        IF X1C AND X27 AND NOT X11 AND X2D THEN
            Y1D := TRUE;
            step := 391;
        END_IF;

    391:
        IF X23 THEN
            Y1E := TRUE;
            step := 40;
        END_IF;

    40:
        IF X25 AND X26 AND X22 THEN
            Y19 := TRUE;
            step := 41;
        END_IF;

    41:
        Y19 := FALSE;
        IF X1D THEN
            Y1D := FALSE;
            step := 411;
        END_IF;

    411:
        IF X24 AND X25 THEN
            Y1A := TRUE;
            step := 42;
        END_IF;

    42:
        Y1A := FALSE;
        IF X20 THEN
            Y1B := TRUE;
            step := 43;
        END_IF;

    43:
        IF X1F THEN
            Y1B := FALSE;
            Y1E := FALSE;
            step := 0;
        END_IF;

    990:
        Y1C := TRUE;

END_CASE;

comp_timer(IN := (step = 990), PT := T#500ms);

END_PROGRAM