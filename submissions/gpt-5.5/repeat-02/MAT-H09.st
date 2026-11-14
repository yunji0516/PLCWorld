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
    state : INT := 0;
    swap_state : INT := 0;
    a_count : INT := 0;
    b_count : INT := 0;
    last_accepted : INT := 0;
    first_scan : BOOL := TRUE;
    run_latch : BOOL := FALSE;
    a_available : BOOL;
    b_available : BOOL;
    process_done : BOOL;
    safe_complete : BOOL;
    a_fill_sum : INT;
    b_fill_sum : INT;
    a_valve_timer : TON;
    b_valve_timer : TON;
END_VAR

IF first_scan THEN
    last_accepted := D3;
    first_scan := FALSE;
END_IF;

IF X0 THEN
    run_latch := TRUE;
END_IF;

process_done := (D3 >= 6) OR X32 OR ((a_count >= 3) AND (b_count >= 3) AND (D3 >= 6));

a_valve_timer(IN := (state = 130) AND X10 AND X16, PT := T#150ms);
b_valve_timer(IN := (state = 230) AND X1E AND X24, PT := T#150ms);

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
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF run_latch AND NOT process_done THEN
    IF swap_state = 0 THEN
        IF (NOT X2F) AND (D1 <= 0) AND X31 AND (NOT X30) THEN
            Y11 := TRUE;
            swap_state := 1;
        END_IF;
    ELSIF swap_state = 1 THEN
        IF X30 THEN
            swap_state := 2;
        ELSIF X2F THEN
            swap_state := 0;
        END_IF;
    ELSE
        IF NOT X30 THEN
            swap_state := 0;
        END_IF;
    END_IF;

    IF X2F AND (D1 > 0) AND (NOT X30) AND (NOT Y11) AND (D0 < 1550) THEN
        Y10 := TRUE;
    END_IF;
END_IF;

CASE state OF
0:
    IF run_latch THEN
        IF process_done THEN
            state := 900;
        ELSE
            a_available := (a_count < 3) AND (X10 OR X11);
            b_available := (b_count < 3) AND (X1E OR X1F);

            IF a_available AND b_available THEN
                IF a_count <= b_count THEN
                    state := 100;
                ELSE
                    state := 200;
                END_IF;
            ELSIF a_available THEN
                state := 100;
            ELSIF b_available THEN
                state := 200;
            END_IF;
        END_IF;
    END_IF;

100:
    IF X10 THEN
        state := 110;
    ELSIF X11 THEN
        Y14 := TRUE;
    ELSE
        state := 0;
    END_IF;

110:
    IF X10 THEN
        Y15 := TRUE;
        IF X14 THEN
            state := 120;
        END_IF;
    ELSE
        state := 0;
    END_IF;

120:
    IF X10 THEN
        Y15 := TRUE;
        Y16 := TRUE;
        IF X13 AND (D0 >= (D5 + 50)) THEN
            state := 130;
        END_IF;
    ELSE
        state := 0;
    END_IF;

130:
    IF X10 THEN
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := TRUE;
        a_fill_sum := D4 + D6;

        IF a_valve_timer.Q AND (D0 >= 20) AND (a_fill_sum < (D5 - 2)) THEN
            Y18 := TRUE;
        END_IF;

        IF ((D6 <= 0) OR X18) AND (D4 >= (D5 - 5)) THEN
            Y18 := FALSE;
            state := 150;
        END_IF;

        IF D4 > (D5 + 5) THEN
            Y18 := FALSE;
            state := 150;
        END_IF;
    ELSE
        state := 150;
    END_IF;

150:
    Y15 := TRUE;
    Y16 := TRUE;
    Y17 := FALSE;
    Y18 := FALSE;
    IF X17 THEN
        state := 151;
    END_IF;

151:
    Y15 := TRUE;
    Y16 := FALSE;
    IF X12 THEN
        state := 152;
    END_IF;

152:
    Y15 := FALSE;
    IF X15 THEN
        state := 160;
    END_IF;

160:
    IF X1A THEN
        state := 170;
    ELSIF X10 AND (NOT X1A) AND (NOT X19) THEN
        Y19 := TRUE;
    END_IF;

170:
    IF X1A AND X1B THEN
        state := 190;
    ELSIF X1A AND (NOT X1B) AND (NOT X2C) THEN
        Y12 := TRUE;
        state := 180;
    END_IF;

180:
    IF X1B THEN
        state := 190;
    END_IF;

190:
    IF X1A AND X1B AND X1C AND (NOT X19) THEN
        Y1A := TRUE;
        state := 195;
    END_IF;

195:
    IF D3 > last_accepted THEN
        last_accepted := D3;
        IF a_count < 3 THEN
            a_count := a_count + 1;
        END_IF;
        state := 0;
    END_IF;

200:
    IF X1E THEN
        state := 210;
    ELSIF X1F THEN
        Y1B := TRUE;
    ELSE
        state := 0;
    END_IF;

210:
    IF X1E THEN
        Y1C := TRUE;
        IF X22 THEN
            state := 220;
        END_IF;
    ELSE
        state := 0;
    END_IF;

220:
    IF X1E THEN
        Y1C := TRUE;
        Y1D := TRUE;
        IF X21 AND (D0 >= (D10 + 50)) THEN
            state := 230;
        END_IF;
    ELSE
        state := 0;
    END_IF;

230:
    IF X1E THEN
        Y1C := TRUE;
        Y1D := TRUE;
        Y1E := TRUE;
        b_fill_sum := D9 + D11;

        IF b_valve_timer.Q AND (D0 >= 20) AND (b_fill_sum < (D10 - 2)) THEN
            Y1F := TRUE;
        END_IF;

        IF ((D11 <= 0) OR X26) AND (D9 >= (D10 - 5)) THEN
            Y1F := FALSE;
            state := 250;
        END_IF;

        IF D9 > (D10 + 5) THEN
            Y1F := FALSE;
            state := 250;
        END_IF;
    ELSE
        state := 250;
    END_IF;

250:
    Y1C := TRUE;
    Y1D := TRUE;
    Y1E := FALSE;
    Y1F := FALSE;
    IF X25 THEN
        state := 251;
    END_IF;

251:
    Y1C := TRUE;
    Y1D := FALSE;
    IF X20 THEN
        state := 252;
    END_IF;

252:
    Y1C := FALSE;
    IF X23 THEN
        state := 260;
    END_IF;

260:
    IF X28 THEN
        state := 270;
    ELSIF X1E AND (NOT X28) AND (NOT X27) THEN
        Y20 := TRUE;
    END_IF;

270:
    IF X28 AND X29 THEN
        state := 290;
    ELSIF X28 AND (NOT X29) AND (NOT X2C) THEN
        Y13 := TRUE;
        state := 280;
    END_IF;

280:
    IF X29 THEN
        state := 290;
    END_IF;

290:
    IF X28 AND X29 AND X2A AND (NOT X27) THEN
        Y21 := TRUE;
        state := 295;
    END_IF;

295:
    IF D3 > last_accepted THEN
        last_accepted := D3;
        IF b_count < 3 THEN
            b_count := b_count + 1;
        END_IF;
        state := 0;
    END_IF;

900:
    state := 900;

ELSE
    state := 0;
END_CASE;

safe_complete := run_latch AND ((D3 >= 6) OR X32) AND (NOT X30) AND (NOT X2C) AND X12 AND X20 AND X17 AND X25;

IF safe_complete THEN
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
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    Y22 := TRUE;
    state := 900;
END_IF;

END_PROGRAM