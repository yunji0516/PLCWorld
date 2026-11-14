PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    req_latched : BOOL := FALSE;
    target_a : DINT := 0;
    initial_a : DINT := 0;
    initial_b : DINT := 0;
    final_b : DINT := 0;
    initial_b_offset : DINT := 0;
    progress : REAL := 0.0;
    travel_time : REAL := 1.0;
    travel_time_a : REAL := 0.0;
    travel_time_b : REAL := 0.0;
    target_a_rad : REAL := 0.0;
    initial_a_rad : REAL := 0.0;
    b_from_a : REAL := 0.0;
    cur_a : REAL := 0.0;
    cur_a_rad : REAL := 0.0;
    ideal_b : REAL := 0.0;
    cur_b : REAL := 0.0;
    a_act_rad : REAL := 0.0;
    mom : REAL := 0.0;
    settle_count : INT := 0;
    hold_count : INT := 0;
END_VAR

IF NOT req_latched THEN
    IF X10 THEN
        req_latched := TRUE;
        target_a := D10;
        initial_a := D11;
        initial_b := D13;

        target_a_rad := (REAL(target_a) * 0.01) * 3.14159265358979 / 180.0;
        b_from_a := -45000.0 * SIN(target_a_rad);
        IF (D17 <> 0) OR (target_a = 0) THEN
            final_b := D17;
        ELSE
            final_b := DINT(b_from_a);
        END_IF;

        initial_a_rad := (REAL(initial_a) * 0.01) * 3.14159265358979 / 180.0;
        initial_b_offset := initial_b - DINT(-45000.0 * SIN(initial_a_rad));

        travel_time_a := ABS(REAL(target_a - initial_a)) / 4000.0;
        travel_time_b := ABS(REAL(final_b - initial_b)) / 40000.0;
        travel_time := MAX(0.5, MAX(travel_time_a, travel_time_b));
        progress := 0.0;
        state := 1;
    ELSE
        D20 := D11;
        D21 := D13;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;
    END_IF;
END_IF;

CASE state OF
    1:
        progress := progress + 0.010 / travel_time;
        IF progress >= 1.0 THEN
            progress := 1.0;
            D20 := target_a;
            D21 := final_b;
            settle_count := 0;
            state := 2;
        ELSE
            cur_a := REAL(initial_a) + progress * REAL(target_a - initial_a);
            cur_a_rad := (cur_a * 0.01) * 3.14159265358979 / 180.0;
            ideal_b := -45000.0 * SIN(cur_a_rad);
            cur_b := ideal_b + REAL(initial_b_offset) * (1.0 - progress);
            D20 := DINT(cur_a);
            D21 := DINT(cur_b);
        END_IF;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;

    2:
        D20 := target_a;
        D21 := final_b;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;

        IF (ABS(D11 - target_a) <= 20) AND (ABS(D13 - final_b) <= 20) AND
           (ABS(D12) <= 80) AND (ABS(D14) <= 80) THEN
            settle_count := settle_count + 1;
            IF settle_count >= 4 THEN
                state := 3;
            END_IF;
        ELSE
            settle_count := 0;
        END_IF;

    3:
        D20 := target_a;
        D21 := final_b;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := FALSE;

        IF X11 THEN
            hold_count := 0;
            state := 4;
        END_IF;

    4:
        D20 := target_a;
        D21 := final_b;
        D22 := 0;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := FALSE;

        a_act_rad := (REAL(D11) * 0.01) * 3.14159265358979 / 180.0;
        mom := 88.29 * SIN(a_act_rad) + 0.1962 * (REAL(D13) * 0.01);

        IF (ABS(D11 - target_a) <= 20) AND
           (ABS(D13 - final_b) <= 20) AND
           (ABS(D12) <= 100) AND
           (ABS(D14) <= 100) AND
           (ABS(mom) <= 1.0) AND
           X11 THEN
            hold_count := hold_count + 1;
            IF hold_count >= 3 THEN
                state := 5;
                Y2 := TRUE;
            END_IF;
        ELSE
            hold_count := 0;
        END_IF;

    5:
        D20 := target_a;
        D21 := final_b;
        D22 := 0;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM