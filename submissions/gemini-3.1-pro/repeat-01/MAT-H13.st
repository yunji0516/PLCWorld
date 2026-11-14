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

    started : BOOL := FALSE;
    f_state : INT := 0;
    tg_state : INT := 0;
    w_state : INT := 0;
    f_index_pulse : BOOL := FALSE;
    supply_belt_loaded : BOOL := FALSE;
    wrap_done_and_separated : BOOL := FALSE;
    tg_ready_to_extract : BOOL := FALSE;
    bundles_discharged : INT := 0;
END_VAR

IF NOT started AND X0 THEN
    Y21 := TRUE;
    Y22 := FALSE;
    Y13 := TRUE;
    started := TRUE;
END_IF;

IF started THEN
    (* Forming logic *)
    CASE f_state OF
        0:
            IF D9 = D10 AND D10 > 0 AND NOT X27 THEN
                Y1C := FALSE;
                Y1E := FALSE;
                Y1F := TRUE;
                f_state := 1;
            ELSIF D9 < D10 THEN
                IF X25 THEN
                    Y1D := TRUE;
                    IF X28 AND NOT f_index_pulse THEN
                        Y1C := TRUE;
                    ELSE
                        Y1C := FALSE;
                        IF NOT X27 AND NOT Y1F THEN
                            Y1E := TRUE;
                            f_index_pulse := TRUE;
                        END_IF;
                    END_IF;
                ELSE
                    Y1C := FALSE;
                END_IF;
            END_IF;
            
            IF X28 AND f_index_pulse THEN
                Y1E := FALSE;
                f_index_pulse := FALSE;
            END_IF;
        1:
            IF X29 THEN
                Y22 := FALSE;
                Y21 := FALSE;
                f_state := 2;
            END_IF;
        2:
            IF X2D AND X2E THEN
                Y20 := TRUE;
                f_state := 3;
            END_IF;
        3:
            IF X2A THEN
                Y21 := TRUE;
                Y1F := FALSE;
                f_state := 4;
            END_IF;
        4:
            IF X2C THEN
                Y22 := TRUE;
                f_state := 5;
            END_IF;
        5:
            IF X2F THEN
                IF X30 THEN
                    Y21 := FALSE;
                    f_state := 6;
                END_IF;
            END_IF;
        6:
            IF X2D THEN
                Y20 := FALSE;
                f_state := 7;
            END_IF;
        7:
            IF X2B THEN
                Y21 := TRUE;
                supply_belt_loaded := TRUE;
                f_state := 8;
            END_IF;
        8:
            IF X2C THEN
                Y22 := FALSE;
                f_state := 0;
            END_IF;
    END_CASE;

    (* Transfer Gripper Logic *)
    CASE tg_state OF
        0:
            Y13 := TRUE;
            IF X10 AND X33 THEN
                Y24 := TRUE;
                tg_state := 1;
            END_IF;
        1:
            IF X12 THEN
                Y10 := TRUE;
                tg_state := 2;
            END_IF;
        2:
            IF X16 THEN
                Y24 := FALSE;
                Y13 := FALSE;
                Y14 := TRUE;
                tg_state := 3;
            END_IF;
        3:
            IF X13 AND X11 THEN
                Y11 := TRUE;
                tg_state := 4;
            END_IF;
        4:
            IF X19 THEN
                Y10 := FALSE;
                tg_state := 5;
            END_IF;
        5:
            IF X17 THEN
                Y14 := FALSE;
                Y13 := TRUE;
                tg_state := 6;
            END_IF;
        6:
            IF X33 AND wrap_done_and_separated THEN
                Y13 := FALSE;
                Y14 := TRUE;
                tg_state := 7;
            END_IF;
        7:
            IF X13 THEN
                Y10 := TRUE;
                tg_state := 8;
            END_IF;
        8:
            IF X16 THEN
                tg_ready_to_extract := TRUE;
                tg_state := 9;
            END_IF;
        9:
            IF X1A AND X23 THEN
                Y14 := FALSE;
                Y15 := TRUE;
                tg_ready_to_extract := FALSE;
                tg_state := 10;
            END_IF;
        10:
            IF X14 THEN
                Y10 := FALSE;
                tg_state := 11;
            END_IF;
        11:
            IF X17 THEN
                Y15 := FALSE;
                Y13 := TRUE;
                bundles_discharged := bundles_discharged + 1;
                wrap_done_and_separated := FALSE;
                tg_state := 0;
            END_IF;
    END_CASE;

    (* Wrapping Logic *)
    CASE w_state OF
        0:
            IF X19 THEN
                Y12 := TRUE;
                w_state := 1;
            END_IF;
        1:
            IF X1B AND X18 THEN
                D200 := D0;
                Y18 := TRUE;
                Y16 := TRUE;
                w_state := 2;
            END_IF;
        2:
            Y18 := FALSE;
            IF NOT X1C THEN
                Y16 := FALSE;
                Y17 := TRUE;
                w_state := 3;
            ELSIF D4 >= D3 THEN
                Y16 := FALSE;
                w_state := 4;
            END_IF;
        3:
            IF X1C THEN
                Y17 := FALSE;
                Y16 := TRUE;
                w_state := 2;
            END_IF;
        4:
            IF X20 AND D5 = D0 THEN
                Y19 := TRUE;
                w_state := 5;
            END_IF;
        5:
            IF X21 THEN
                Y19 := FALSE;
                Y1A := TRUE;
                w_state := 6;
            END_IF;
        6:
            IF X22 THEN
                Y1A := FALSE;
                Y12 := FALSE;
                wrap_done_and_separated := TRUE;
                w_state := 7;
            END_IF;
        7:
            IF tg_ready_to_extract THEN
                Y11 := FALSE;
                w_state := 8;
            END_IF;
        8:
            IF NOT wrap_done_and_separated THEN
                w_state := 0;
            END_IF;
    END_CASE;

    (* Supply Belt Logic *)
    IF supply_belt_loaded AND X32 AND NOT X10 AND NOT X15 THEN
        Y23 := TRUE;
    ELSE
        Y23 := FALSE;
    END_IF;

    IF X10 THEN
        supply_belt_loaded := FALSE;
    END_IF;

    (* Completion Logic *)
    IF bundles_discharged >= 3 THEN
        Y1B := TRUE;
    END_IF;
END_IF;

END_PROGRAM