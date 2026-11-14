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
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    start_latched : BOOL;
    a_accept_sent : BOOL;
    b_accept_sent : BOOL;
    pallet_step : INT;
    pallet_target : INT;
    head_carry : BOOL;
    carry_side : INT;
    carry_kind : INT;
    computed_a_kind : INT;
    computed_b_kind : INT;
    need_a_kind : INT;
    need_b_kind : INT;
    a_ready_for_pick : BOOL;
    b_ready_for_pick : BOOL;
    ship_step : INT;
    ship_target : INT;
    a_low_cmd : BOOL;
    b_low_cmd : BOOL;
    a_shipped : BOOL;
    b_shipped : BOOL;
    sent_count : INT;
    complete_latched : BOOL;
END_VAR

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y1B := complete_latched;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF X0 THEN
    start_latched := TRUE;
END_IF;

IF D11 = 0 THEN
    computed_a_kind := 1;
ELSIF D11 = 1 THEN
    computed_a_kind := 2;
ELSIF D11 = 2 THEN
    computed_a_kind := 1;
ELSE
    computed_a_kind := 0;
END_IF;

IF D12 = 0 THEN
    computed_b_kind := 2;
ELSIF D12 = 1 THEN
    computed_b_kind := 1;
ELSIF D12 = 2 THEN
    computed_b_kind := 2;
ELSIF D12 = 3 THEN
    computed_b_kind := 1;
ELSE
    computed_b_kind := 0;
END_IF;

IF (D7 = 1) OR (D7 = 2) THEN
    need_a_kind := D7;
ELSE
    need_a_kind := computed_a_kind;
END_IF;

IF (D8 = 1) OR (D8 = 2) THEN
    need_b_kind := D8;
ELSE
    need_b_kind := computed_b_kind;
END_IF;

a_ready_for_pick := FALSE;
IF (need_a_kind = 1) AND X10 THEN
    a_ready_for_pick := TRUE;
ELSIF (need_a_kind = 2) AND X11 THEN
    a_ready_for_pick := TRUE;
END_IF;

b_ready_for_pick := FALSE;
IF (need_b_kind = 1) AND X10 THEN
    b_ready_for_pick := TRUE;
ELSIF (need_b_kind = 2) AND X11 THEN
    b_ready_for_pick := TRUE;
END_IF;

IF start_latched AND NOT complete_latched THEN
    IF X1B AND NOT a_accept_sent THEN
        Y10 := TRUE;
        a_accept_sent := TRUE;
    END_IF;

    IF X1C AND NOT b_accept_sent THEN
        Y11 := TRUE;
        b_accept_sent := TRUE;
    END_IF;

    CASE pallet_step OF
        0:
            IF (ship_step = 0) AND X27 AND X18 AND NOT X14 THEN
                IF NOT X28 THEN
                    pallet_target := 1;
                    D201 := 1;
                    Y1C := TRUE;
                    pallet_step := 1;
                ELSIF NOT X29 THEN
                    pallet_target := 2;
                    D201 := 2;
                    Y1C := TRUE;
                    pallet_step := 1;
                END_IF;
            END_IF;
        1:
            IF X2A THEN
                Y1D := TRUE;
                pallet_step := 2;
            END_IF;
        2:
            IF X2B THEN
                D201 := pallet_target;
                Y1E := TRUE;
                pallet_step := 3;
            END_IF;
        3:
            IF X2C THEN
                Y1F := TRUE;
                pallet_step := 4;
            END_IF;
        4:
            IF X18 AND NOT X14 THEN
                IF ((pallet_target = 1) AND X28) OR ((pallet_target = 2) AND X29) THEN
                    pallet_step := 0;
                    pallet_target := 0;
                END_IF;
            END_IF;
        ELSE
            pallet_step := 0;
            pallet_target := 0;
    END_CASE;

    IF (pallet_step = 0) AND (ship_step = 0) THEN
        IF NOT head_carry THEN
            IF NOT X12 AND NOT X13 THEN
                IF a_accept_sent AND X28 AND X25 AND (D11 < 3) AND NOT X1F AND a_ready_for_pick THEN
                    carry_side := 1;
                    carry_kind := need_a_kind;
                    D200 := need_a_kind;
                    Y12 := TRUE;
                    head_carry := TRUE;
                ELSIF b_accept_sent AND X29 AND X26 AND (D12 < 4) AND NOT X20 AND b_ready_for_pick THEN
                    carry_side := 2;
                    carry_kind := need_b_kind;
                    D200 := need_b_kind;
                    Y12 := TRUE;
                    head_carry := TRUE;
                END_IF;
            END_IF;
        ELSE
            IF X13 AND NOT X12 AND (D5 = carry_kind) THEN
                IF (carry_side = 1) AND X28 AND X25 THEN
                    D201 := 1;
                    D202 := D9;
                    Y13 := TRUE;
                    head_carry := FALSE;
                ELSIF (carry_side = 2) AND X29 AND X26 THEN
                    D201 := 2;
                    D202 := D10;
                    Y13 := TRUE;
                    head_carry := FALSE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

    CASE ship_step OF
        0:
            IF (pallet_step = 0) AND X18 AND NOT X14 AND NOT X12 AND NOT X13 AND NOT head_carry THEN
                IF X1F AND NOT a_shipped THEN
                    ship_target := 1;
                    D201 := 1;
                    Y16 := TRUE;
                    ship_step := 1;
                ELSIF X20 AND NOT b_shipped THEN
                    ship_target := 2;
                    D201 := 2;
                    Y16 := TRUE;
                    ship_step := 1;
                END_IF;
            END_IF;
        1:
            IF X15 THEN
                D201 := ship_target;
                Y17 := TRUE;
                ship_step := 2;
            END_IF;
        2:
            IF X16 THEN
                IF ship_target = 1 THEN
                    a_low_cmd := TRUE;
                ELSIF ship_target = 2 THEN
                    b_low_cmd := TRUE;
                END_IF;
                ship_step := 3;
            END_IF;
        3:
            IF ship_target = 1 THEN
                a_low_cmd := TRUE;
                IF X23 THEN
                    D201 := 1;
                    Y18 := TRUE;
                    ship_step := 4;
                END_IF;
            ELSIF ship_target = 2 THEN
                b_low_cmd := TRUE;
                IF X24 THEN
                    D201 := 2;
                    Y18 := TRUE;
                    ship_step := 4;
                END_IF;
            END_IF;
        4:
            IF ship_target = 1 THEN
                a_low_cmd := TRUE;
            ELSIF ship_target = 2 THEN
                b_low_cmd := TRUE;
            END_IF;

            IF X17 THEN
                Y19 := TRUE;
                sent_count := sent_count + 1;
                ship_step := 5;
            END_IF;
        5:
            IF ship_target = 1 THEN
                a_low_cmd := TRUE;
            ELSIF ship_target = 2 THEN
                b_low_cmd := TRUE;
            END_IF;

            IF X18 AND NOT X14 THEN
                a_low_cmd := FALSE;
                b_low_cmd := FALSE;
                ship_step := 6;
            END_IF;
        6:
            IF X19 AND (D14 >= sent_count) THEN
                Y1A := TRUE;
                IF ship_target = 1 THEN
                    a_shipped := TRUE;
                ELSIF ship_target = 2 THEN
                    b_shipped := TRUE;
                END_IF;
                ship_target := 0;
                ship_step := 0;
            END_IF;
        ELSE
            ship_step := 0;
            ship_target := 0;
            a_low_cmd := FALSE;
            b_low_cmd := FALSE;
    END_CASE;

    IF a_shipped AND b_shipped AND X1A AND (D14 >= 2) AND X18 AND NOT X14 AND NOT X12 AND NOT X13 AND NOT head_carry AND X21 AND X22 AND (pallet_step = 0) AND (ship_step = 0) THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

IF complete_latched THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y1A := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    a_low_cmd := FALSE;
    b_low_cmd := FALSE;
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

IF a_low_cmd THEN
    D203 := 780;
ELSE
    D203 := 850;
END_IF;

IF b_low_cmd THEN
    D204 := 780;
ELSE
    D204 := 850;
END_IF;

Y14 := TRUE;
Y15 := TRUE;

END_PROGRAM