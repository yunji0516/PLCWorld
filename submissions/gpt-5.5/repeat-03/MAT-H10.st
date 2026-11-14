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
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    started : BOOL;
    complete_latched : BOOL;
    extraction_state : INT;
    a_sent : INT;
    b_sent : INT;
    total_sent : INT;
    first_mag_sent : INT;
    a_released_count : INT;
    b_released_count : INT;
    a_assy_requested : BOOL;
    b_assy_requested : BOOL;
    a_release_requested : BOOL;
    b_release_requested : BOOL;
    a_available : BOOL;
    b_available : BOOL;
    can_start_extraction : BOOL;
    need_swap : BOOL;
    swap_pulsed : BOOL;
    swap_started : BOOL;
    empty_taken : BOOL;
    swapped_ready : BOOL;
    completion_conditions : BOOL;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;

IF NOT X1F THEN
    a_assy_requested := FALSE;
    a_release_requested := FALSE;
END_IF;

IF NOT X25 THEN
    b_assy_requested := FALSE;
    b_release_requested := FALSE;
END_IF;

IF started AND X1F AND X20 AND (NOT X21) AND (NOT a_assy_requested) THEN
    Y16 := TRUE;
    a_assy_requested := TRUE;
END_IF;

IF started AND X25 AND X26 AND (NOT X27) AND (NOT b_assy_requested) THEN
    Y17 := TRUE;
    b_assy_requested := TRUE;
END_IF;

IF started AND X22 AND X23 AND a_assy_requested AND (NOT a_release_requested) THEN
    Y18 := TRUE;
    a_release_requested := TRUE;
    IF a_released_count < 3 THEN
        a_released_count := a_released_count + 1;
    END_IF;
END_IF;

IF started AND X28 AND X29 AND b_assy_requested AND (NOT b_release_requested) THEN
    Y19 := TRUE;
    b_release_requested := TRUE;
    IF b_released_count < 4 THEN
        b_released_count := b_released_count + 1;
    END_IF;
END_IF;

a_available := (a_sent < 3) AND (NOT X1F) AND X23;
b_available := (b_sent < 4) AND (NOT X25) AND X29;

IF (D0 = 202) AND X10 AND X1C THEN
    swapped_ready := TRUE;
END_IF;

need_swap := started AND (first_mag_sent >= 4) AND (NOT swapped_ready);

can_start_extraction := started AND (NOT complete_latched) AND (NOT need_swap) AND X10 AND X11 AND X16 AND (NOT X17) AND ((total_sent < 7) AND (a_available OR b_available));

IF NOT started THEN
    Y10 := TRUE;
    Y11 := FALSE;
    extraction_state := 0;
ELSE
    CASE extraction_state OF
        0:
            Y10 := TRUE;
            Y11 := FALSE;
            IF can_start_extraction THEN
                Y10 := TRUE;
                Y11 := TRUE;
                extraction_state := 1;
            END_IF;
        1:
            Y10 := TRUE;
            Y11 := TRUE;
            IF X12 THEN
                Y10 := FALSE;
                Y11 := TRUE;
                extraction_state := 2;
            END_IF;
        2:
            Y10 := FALSE;
            Y11 := TRUE;
            IF X17 THEN
                Y12 := TRUE;
                extraction_state := 3;
            END_IF;
        3:
            Y10 := FALSE;
            Y11 := TRUE;
            Y12 := TRUE;
            IF X18 THEN
                Y12 := FALSE;
                Y10 := TRUE;
                Y11 := FALSE;
                extraction_state := 4;
            END_IF;
        4:
            Y10 := TRUE;
            Y11 := FALSE;
            IF X14 AND X13 THEN
                extraction_state := 5;
            END_IF;
        5:
            Y10 := TRUE;
            Y11 := FALSE;
        6:
            Y10 := TRUE;
            Y11 := FALSE;
            IF X16 AND (NOT X17) THEN
                extraction_state := 0;
            END_IF;
        ELSE
            Y10 := TRUE;
            Y11 := FALSE;
            extraction_state := 0;
    END_CASE;
END_IF;

IF extraction_state = 5 THEN
    IF a_available THEN
        D200 := 1;
        D201 := a_sent + 1;
        Y13 := TRUE;
        a_sent := a_sent + 1;
        total_sent := total_sent + 1;
        IF NOT swapped_ready THEN
            first_mag_sent := first_mag_sent + 1;
        END_IF;
        extraction_state := 6;
    ELSIF b_available THEN
        D200 := 2;
        D201 := b_sent + 1;
        Y13 := TRUE;
        b_sent := b_sent + 1;
        total_sent := total_sent + 1;
        IF NOT swapped_ready THEN
            first_mag_sent := first_mag_sent + 1;
        END_IF;
        extraction_state := 6;
    END_IF;
END_IF;

need_swap := started AND (first_mag_sent >= 4) AND (NOT swapped_ready);

IF need_swap THEN
    IF extraction_state = 0 THEN
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
    END_IF;

    IF (NOT swap_pulsed) AND (extraction_state = 0) AND X18 AND X14 AND X13 AND X1A AND X1B AND (NOT X19) THEN
        Y14 := TRUE;
        swap_pulsed := TRUE;
        swap_started := TRUE;
    END_IF;

    IF swap_started AND (NOT empty_taken) AND (D0 = 202) AND X10 AND X1B AND (NOT X19) THEN
        Y15 := TRUE;
        empty_taken := TRUE;
    END_IF;

    IF (D0 = 202) AND X10 AND X1C THEN
        swapped_ready := TRUE;
    END_IF;
END_IF;

IF (total_sent >= 7) AND (extraction_state = 0) THEN
    Y10 := TRUE;
    Y11 := FALSE;
    Y12 := FALSE;
END_IF;

completion_conditions := started AND
                         (a_released_count >= 3) AND
                         (b_released_count >= 4) AND
                         (D3 >= 3) AND
                         (D4 >= 4) AND
                         X1D AND
                         X1C AND
                         (D0 = 202) AND
                         X10 AND
                         (D1 = 1) AND
                         X16 AND
                         (NOT X17) AND
                         X14 AND
                         X13 AND
                         Y10 AND
                         (NOT Y11);

IF completion_conditions THEN
    complete_latched := TRUE;
END_IF;

Y1A := complete_latched;

END_PROGRAM