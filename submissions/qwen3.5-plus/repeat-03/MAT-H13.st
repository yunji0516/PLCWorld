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
    D200 : INT;
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
    Y1F : BOOL;
    
    step : INT := 0;
    bundle_count : INT := 0;
    current_target : INT := 2;
    targets : ARRAY[0..2] OF INT := [2, 3, 4];
    
    t_state : TON;
    edge_wrap_off : R_TRIG;
    edge_aligned : R_TRIG;
    b_init : BOOL := FALSE;
END_VAR

Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE; Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
Y1A := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;

edge_wrap_off(CLK := NOT Y16);
edge_aligned(CLK := X29);

IF NOT b_init AND X0 THEN
    b_init := TRUE;
    step := 10;
    bundle_count := 0;
    current_target := targets[0];
    D200 := 1;
END_IF;

CASE step OF
    10:
        Y1D := TRUE;
        IF X25 AND (D9 < current_target) AND X28 THEN
            Y1C := TRUE;
        END_IF;
        IF D9 >= current_target THEN
            Y1F := TRUE;
            t_state(IN := edge_aligned.Q, PT := T#100ms);
            IF t_state.Q THEN step := 20; END_IF;
        END_IF;
        
    20:
        Y1D := TRUE; Y1F := TRUE;
        Y21 := FALSE;
        t_state(IN := X2D, PT := T#200ms);
        IF t_state.Q THEN
            Y20 := TRUE;
            IF X2A THEN step := 30; END_IF;
        END_IF;
        
    30:
        Y1D := TRUE; Y20 := TRUE;
        Y21 := TRUE;
        t_state(IN := X2C, PT := T#200ms);
        IF t_state.Q THEN step := 40; END_IF;
        
    40:
        IF X10 AND X33 THEN Y24 := TRUE; END_IF;
        IF X12 THEN Y24 := FALSE; step := 50; END_IF;
        
    50:
        Y10 := TRUE;
        t_state(IN := X16, PT := T#500ms);
        IF t_state.Q THEN step := 60; END_IF;
        
    60:
        Y14 := TRUE;
        t_state(IN := X13 AND NOT X15 AND NOT X11, PT := T#200ms);
        IF t_state.Q THEN step := 70; END_IF;
        
    70:
        Y11 := TRUE;
        t_state(IN := X19, PT := T#300ms);
        IF t_state.Q THEN
            Y10 := FALSE;
            step := 80;
        END_IF;
        
    80:
        Y13 := TRUE;
        t_state(IN := X12 AND NOT X15, PT := T#200ms);
        IF t_state.Q THEN step := 90; END_IF;
        
    90:
        IF X1C THEN Y16 := TRUE; END_IF;
        IF edge_wrap_off.Q AND X19 AND X1B AND X18 THEN Y17 := TRUE; END_IF;
        IF X1D OR NOT X1C THEN Y17 := FALSE; END_IF;
        t_state(IN := D2 >= D3, PT := T#100ms);
        IF t_state.Q THEN
            Y16 := FALSE;
            step := 100;
        END_IF;
        
    100:
        Y18 := TRUE;
        D200 := bundle_count + 1;
        IF X20 THEN
            Y18 := FALSE;
            step := 110;
        END_IF;
        
    110:
        IF D5 = D0 AND D2 >= D3 THEN Y19 := TRUE; END_IF;
        IF X21 THEN
            Y19 := FALSE;
            step := 120;
        END_IF;
        
    120:
        IF X19 AND X1B AND D2 >= D3 AND X21 THEN Y1A := TRUE; END_IF;
        t_state(IN := X22, PT := T#800ms);
        IF t_state.Q THEN
            Y1A := FALSE;
            step := 130;
        END_IF;
        
    130:
        Y14 := TRUE;
        t_state(IN := X13, PT := T#200ms);
        IF t_state.Q THEN
            Y10 := TRUE;
            IF X16 THEN step := 140; END_IF;
        END_IF;
        
    140:
        Y11 := FALSE;
        IF X22 AND X23 THEN step := 150; END_IF;
        
    150:
        Y14 := FALSE;
        Y15 := TRUE;
        t_state(IN := X14, PT := T#200ms);
        IF t_state.Q THEN step := 160; END_IF;
        
    160:
        Y10 := FALSE;
        t_state(IN := X17, PT := T#300ms);
        IF t_state.Q THEN
            bundle_count := bundle_count + 1;
            step := 170;
        END_IF;
        
    170:
        Y23 := TRUE;
        IF X32 AND X2C THEN Y1E := TRUE; END_IF;
        t_state(IN := TRUE, PT := T#600ms);
        IF t_state.Q THEN
            Y23 := FALSE; Y1E := FALSE;
            IF bundle_count >= 3 THEN
                step := 200;
            ELSE
                current_target := targets[bundle_count];
                D200 := bundle_count + 1;
                step := 10;
            END_IF;
        END_IF;
        
    200:
        IF D2 >= D3 AND X21 AND X22 AND X24 AND X17 AND NOT X11 AND X2D AND X12 THEN
            Y1B := TRUE;
            t_state(IN := TRUE, PT := T#500ms);
        ELSE
            Y1B := FALSE;
            t_state(IN := FALSE);
        END_IF;
        
    ELSE
        step := 0;
END_CASE;

IF NOT X2C THEN
    Y23 := FALSE; Y14 := FALSE; Y15 := FALSE; Y13 := FALSE; Y24 := FALSE;
END_IF;
IF X15 OR X27 THEN
    Y1C := FALSE; Y1E := FALSE;
END_IF;
IF NOT X1C OR X1D THEN
    Y16 := FALSE;
END_IF;
END_PROGRAM