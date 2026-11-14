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
    run_latch : BOOL := FALSE;
    complete_latch : BOOL := FALSE;
    a_state : INT := 0;
    b_state : INT := 0;
    active_line : INT := 0;
    cap_state : INT := 0;
    cap_seen_busy : BOOL := FALSE;
    cap_turn : INT := 0;
    swap_wait_ready : BOOL := FALSE;
    a_open_delay : TON;
    b_open_delay : TON;
    a_need_pump : BOOL := FALSE;
    b_need_pump : BOOL := FALSE;
    a_cap_ready : BOOL := FALSE;
    b_cap_ready : BOOL := FALSE;
    complete_ready : BOOL := FALSE;
    fill_tol : INT := 2;
END_VAR

IF X0 THEN
    run_latch := TRUE;
END_IF;

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

a_open_delay(IN := ((a_state = 4) AND X10 AND X16), PT := T#150ms);
b_open_delay(IN := ((b_state = 4) AND X1E AND X24), PT := T#150ms);

IF NOT run_latch THEN
    a_state := 0;
    b_state := 0;
    active_line := 0;
    cap_state := 0;
    cap_seen_busy := FALSE;
ELSE
    IF NOT complete_latch THEN
        Y10 := X2F AND (D1 > 0) AND (NOT X30) AND (D0 <= 1585) AND (NOT X32);

        IF X2F THEN
            swap_wait_ready := FALSE;
        END_IF;

        IF (NOT swap_wait_ready) AND (NOT X2F) AND X31 AND (NOT X30) AND (NOT Y10) AND (D1 <= 0) AND (NOT X32) THEN
            Y11 := TRUE;
            swap_wait_ready := TRUE;
        END_IF;

        CASE a_state OF
            0:
                IF X10 THEN
                    a_state := 2;
                ELSIF X11 THEN
                    a_state := 1;
                END_IF;
            1:
                IF X10 THEN
                    a_state := 2;
                ELSIF NOT X11 THEN
                    a_state := 0;
                END_IF;
            2:
                IF NOT X10 THEN
                    a_state := 0;
                ELSIF X14 THEN
                    a_state := 3;
                END_IF;
            3:
                IF NOT X10 THEN
                    a_state := 0;
                ELSIF X13 THEN
                    a_state := 4;
                END_IF;
            4:
                IF NOT X10 THEN
                    a_state := 0;
                ELSIF a_open_delay.Q THEN
                    a_state := 5;
                END_IF;
            5:
                IF NOT X10 THEN
                    a_state := 0;
                ELSIF (D5 <= 0) OR ((D4 + D6) >= D5) THEN
                    a_state := 6;
                END_IF;
            6:
                IF NOT X10 THEN
                    a_state := 0;
                ELSIF D6 <= 0 THEN
                    IF D4 >= (D5 - fill_tol) THEN
                        a_state := 7;
                    ELSE
                        a_state := 5;
                    END_IF;
                END_IF;
            7:
                IF NOT X10 THEN
                    a_state := 0;
                ELSIF X17 THEN
                    a_state := 8;
                END_IF;
            8:
                IF NOT X10 THEN
                    a_state := 0;
                ELSIF X12 AND X15 THEN
                    a_state := 9;
                END_IF;
            9:
                IF NOT X10 THEN
                    a_state := 0;
                ELSIF X1A THEN
                    a_state := 10;
                END_IF;
            10:
                IF NOT X10 THEN
                    a_state := 0;
                END_IF;
        ELSE
            a_state := 0;
        END_CASE;

        CASE b_state OF
            0:
                IF X1E THEN
                    b_state := 2;
                ELSIF X1F THEN
                    b_state := 1;
                END_IF;
            1:
                IF X1E THEN
                    b_state := 2;
                ELSIF NOT X1F THEN
                    b_state := 0;
                END_IF;
            2:
                IF NOT X1E THEN
                    b_state := 0;
                ELSIF X22 THEN
                    b_state := 3;
                END_IF;
            3:
                IF NOT X1E THEN
                    b_state := 0;
                ELSIF X21 THEN
                    b_state := 4;
                END_IF;
            4:
                IF NOT X1E THEN
                    b_state := 0;
                ELSIF b_open_delay.Q THEN
                    b_state := 5;
                END_IF;
            5:
                IF NOT X1E THEN
                    b_state := 0;
                ELSIF (D10 <= 0) OR ((D9 + D11) >= D10) THEN
                    b_state := 6;
                END_IF;
            6:
                IF NOT X1E THEN
                    b_state := 0;
                ELSIF D11 <= 0 THEN
                    IF D9 >= (D10 - fill_tol) THEN
                        b_state := 7;
                    ELSE
                        b_state := 5;
                    END_IF;
                END_IF;
            7:
                IF NOT X1E THEN
                    b_state := 0;
                ELSIF X25 THEN
                    b_state := 8;
                END_IF;
            8:
                IF NOT X1E THEN
                    b_state := 0;
                ELSIF X20 AND X23 THEN
                    b_state := 9;
                END_IF;
            9:
                IF NOT X1E THEN
                    b_state := 0;
                ELSIF X28 THEN
                    b_state := 10;
                END_IF;
            10:
                IF NOT X1E THEN
                    b_state := 0;
                END_IF;
        ELSE
            b_state := 0;
        END_CASE;

        Y14 := (a_state = 1) AND X11 AND (NOT X10);
        Y15 := X10 AND (a_state >= 2) AND (a_state <= 7);
        Y16 := X10 AND (a_state >= 3) AND (a_state <= 7);
        Y17 := X10 AND ((a_state = 4) OR (a_state = 5) OR (a_state = 6));
        Y19 := X10 AND (a_state = 9) AND (NOT X1A);

        Y1B := (b_state = 1) AND X1F AND (NOT X1E);
        Y1C := X1E AND (b_state >= 2) AND (b_state <= 7);
        Y1D := X1E AND (b_state >= 3) AND (b_state <= 7);
        Y1E := X1E AND ((b_state = 4) OR (b_state = 5) OR (b_state = 6));
        Y20 := X1E AND (b_state = 9) AND (NOT X28);

        a_need_pump := X10 AND (a_state = 5) AND X16 AND ((D4 + D6) < D5) AND (D0 >= 3);
        b_need_pump := X1E AND (b_state = 5) AND X24 AND ((D9 + D11) < D10) AND (D0 >= 3);

        IF (active_line = 1) AND (NOT a_need_pump) THEN
            active_line := 0;
        END_IF;
        IF (active_line = 2) AND (NOT b_need_pump) THEN
            active_line := 0;
        END_IF;

        IF active_line = 0 THEN
            IF a_need_pump THEN
                active_line := 1;
            ELSIF b_need_pump THEN
                active_line := 2;
            END_IF;
        END_IF;

        Y18 := a_need_pump AND (active_line = 1);
        Y1F := b_need_pump AND (active_line = 2);

        Y1A := X1A AND X1B AND X1C AND (NOT X19);
        Y21 := X28 AND X29 AND X2A AND (NOT X27);

        CASE cap_state OF
            0:
                cap_seen_busy := FALSE;
            1:
                IF X2C THEN
                    cap_seen_busy := TRUE;
                END_IF;
                IF X1B OR (NOT X1A) OR (cap_seen_busy AND (NOT X2C) AND (NOT X1B)) THEN
                    cap_state := 0;
                    cap_seen_busy := FALSE;
                END_IF;
            2:
                IF X2C THEN
                    cap_seen_busy := TRUE;
                END_IF;
                IF X29 OR (NOT X28) OR (cap_seen_busy AND (NOT X2C) AND (NOT X29)) THEN
                    cap_state := 0;
                    cap_seen_busy := FALSE;
                END_IF;
        ELSE
            cap_state := 0;
            cap_seen_busy := FALSE;
        END_CASE;

        a_cap_ready := X1A AND (NOT X1B);
        b_cap_ready := X28 AND (NOT X29);

        IF (cap_state = 0) AND (NOT X2C) THEN
            IF a_cap_ready AND b_cap_ready THEN
                IF cap_turn = 0 THEN
                    Y12 := TRUE;
                    cap_state := 1;
                    cap_turn := 1;
                ELSE
                    Y13 := TRUE;
                    cap_state := 2;
                    cap_turn := 0;
                END_IF;
            ELSIF a_cap_ready THEN
                Y12 := TRUE;
                cap_state := 1;
                cap_turn := 1;
            ELSIF b_cap_ready THEN
                Y13 := TRUE;
                cap_state := 2;
                cap_turn := 0;
            END_IF;
        END_IF;
    END_IF;
END_IF;

complete_ready := X32 AND (D3 >= 6) AND X1D AND X2B AND X17 AND X25 AND X12 AND X20 AND
                  X18 AND X26 AND (NOT X2C) AND (NOT X30) AND (NOT X10) AND (NOT X1E) AND
                  (NOT X1A) AND (NOT X28);

IF complete_ready THEN
    complete_latch := TRUE;
END_IF;

IF complete_latch THEN
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
ELSE
    Y22 := FALSE;
END_IF;

END_PROGRAM