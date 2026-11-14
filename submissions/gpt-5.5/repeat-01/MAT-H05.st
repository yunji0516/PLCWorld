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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    started : BOOL;
    complete_latch : BOOL;
    stage : INT;
    op_state : INT;
    output_state : INT;
    rot_state : INT;
    rot_request : BOOL;
    rot_done : BOOL;
    safe_idle : BOOL;
END_VAR

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := TRUE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := complete_latch;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
D200 := D5;
rot_done := FALSE;

IF X0 THEN
    started := TRUE;
END_IF;

safe_idle := X19 AND (NOT X18) AND X1B AND (NOT X14) AND (NOT X15) AND (NOT X16) AND (NOT X17) AND (NOT X25) AND (NOT X20) AND (NOT X1E) AND (NOT X26) AND (NOT X27);

IF started AND X1F AND safe_idle THEN
    complete_latch := TRUE;
END_IF;

IF complete_latch THEN
    Y1A := TRUE;
    Y17 := TRUE;
    rot_request := FALSE;
ELSE
    CASE rot_state OF
        0:
            Y17 := TRUE;
            IF rot_request AND X19 AND (NOT X18) AND X1B AND (NOT X17) AND (NOT X25) THEN
                Y17 := FALSE;
                rot_state := 1;
            END_IF;
        1:
            Y17 := FALSE;
            IF X1A AND (NOT X18) THEN
                Y18 := TRUE;
                rot_state := 2;
            END_IF;
        2:
            Y17 := FALSE;
            IF X18 THEN
                rot_state := 3;
            END_IF;
        3:
            Y17 := FALSE;
            IF NOT X18 THEN
                Y17 := TRUE;
                rot_state := 4;
            END_IF;
        4:
            Y17 := TRUE;
            IF X19 THEN
                rot_state := 0;
                rot_request := FALSE;
                rot_done := TRUE;
            END_IF;
        ELSE
            rot_state := 0;
            rot_request := FALSE;
    END_CASE;

    IF started THEN
        CASE stage OF
            0:
                output_state := 0;
                op_state := 0;
                IF D0 <> 0 THEN
                    stage := 20;
                ELSIF X10 AND (D0 = 0) AND X19 AND (NOT X18) AND (NOT X14) AND (NOT X20) AND (NOT X25) AND (NOT X26) THEN
                    Y10 := TRUE;
                    stage := 1;
                END_IF;

            1:
                IF (D0 <> 0) AND (NOT X14) THEN
                    stage := 20;
                    op_state := 0;
                END_IF;

            20:
                IF rot_done THEN
                    stage := 30;
                    op_state := 0;
                ELSE
                    rot_request := TRUE;
                END_IF;

            30:
                IF (rot_state = 0) AND X19 AND (NOT X18) THEN
                    IF D1 <> 0 THEN
                        IF X21 THEN
                            stage := 40;
                            op_state := 0;
                        ELSE
                            CASE op_state OF
                                0:
                                    IF X13 AND (NOT X15) THEN
                                        Y12 := TRUE;
                                        op_state := 1;
                                    ELSIF X12 AND (NOT X13) THEN
                                        Y11 := TRUE;
                                    END_IF;
                                1:
                                    IF X21 AND (NOT X15) THEN
                                        stage := 40;
                                        op_state := 0;
                                    END_IF;
                                ELSE
                                    op_state := 0;
                            END_CASE;
                        END_IF;
                    END_IF;
                END_IF;

            40:
                IF rot_done THEN
                    stage := 50;
                    op_state := 0;
                ELSE
                    rot_request := TRUE;
                END_IF;

            50:
                IF (rot_state = 0) AND X19 AND (NOT X18) THEN
                    IF D2 <> 0 THEN
                        IF X22 THEN
                            stage := 60;
                            op_state := 0;
                        ELSE
                            CASE op_state OF
                                0:
                                    IF NOT X16 THEN
                                        D200 := D5;
                                        Y13 := TRUE;
                                        op_state := 1;
                                    END_IF;
                                1:
                                    D200 := D5;
                                    IF X22 AND (NOT X16) THEN
                                        stage := 60;
                                        op_state := 0;
                                    END_IF;
                                ELSE
                                    op_state := 0;
                            END_CASE;
                        END_IF;
                    END_IF;
                END_IF;

            60:
                IF rot_done THEN
                    stage := 70;
                    output_state := 0;
                    op_state := 0;
                ELSE
                    rot_request := TRUE;
                END_IF;

            70:
                IF (rot_state = 0) AND X19 AND (NOT X18) THEN
                    CASE output_state OF
                        0:
                            IF X20 THEN
                                IF X24 THEN
                                    output_state := 100;
                                ELSE
                                    output_state := 10;
                                END_IF;
                            ELSIF D3 = 0 THEN
                                stage := 0;
                                output_state := 0;
                            END_IF;

                        10:
                            IF X20 AND (NOT X24) AND X1B AND X1D AND (NOT X1E) AND (NOT X17) THEN
                                Y14 := TRUE;
                                output_state := 11;
                            END_IF;

                        11:
                            Y14 := TRUE;
                            IF X1C THEN
                                output_state := 12;
                            END_IF;

                        12:
                            Y15 := TRUE;
                            IF X1B AND (NOT X17) THEN
                                output_state := 13;
                            END_IF;

                        13:
                            IF X20 AND (NOT X24) AND X1B AND X1D AND (NOT X1E) THEN
                                Y16 := TRUE;
                                output_state := 14;
                            ELSIF NOT X20 THEN
                                output_state := 14;
                            END_IF;

                        14:
                            IF X1E THEN
                                Y19 := TRUE;
                                output_state := 15;
                            END_IF;

                        15:
                            IF NOT X1E THEN
                                stage := 0;
                                output_state := 0;
                                op_state := 0;
                            END_IF;

                        100:
                            IF X20 AND X24 AND X1B AND (NOT X25) THEN
                                Y1B := TRUE;
                                output_state := 101;
                            END_IF;

                        101:
                            IF X26 AND (NOT X25) THEN
                                output_state := 102;
                            END_IF;

                        102:
                            Y1C := TRUE;
                            IF X27 THEN
                                output_state := 103;
                            END_IF;

                        103:
                            Y1C := TRUE;
                            IF X27 AND (NOT X25) THEN
                                Y1D := TRUE;
                                output_state := 104;
                            END_IF;

                        104:
                            Y1C := TRUE;
                            IF X28 AND (NOT X25) THEN
                                output_state := 105;
                            END_IF;

                        105:
                            Y1C := TRUE;
                            IF X27 AND (NOT X25) THEN
                                Y1E := TRUE;
                                output_state := 106;
                            END_IF;

                        106:
                            Y1C := TRUE;
                            IF X29 AND (NOT X25) THEN
                                output_state := 107;
                            END_IF;

                        107:
                            IF (NOT X27) AND X2A AND X19 AND (NOT X18) AND (D0 = 0) AND (NOT X25) THEN
                                Y1F := TRUE;
                                output_state := 108;
                            END_IF;

                        108:
                            IF (NOT X25) AND (NOT X26) AND (D0 <> 0) THEN
                                stage := 20;
                                output_state := 0;
                                op_state := 0;
                            END_IF;

                        ELSE
                            output_state := 0;
                    END_CASE;
                END_IF;

            ELSE
                stage := 0;
                op_state := 0;
                output_state := 0;
        END_CASE;
    END_IF;
END_IF;

END_PROGRAM