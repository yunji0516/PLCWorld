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

    init_done : BOOL;
    req_latched : BOOL;
    state : INT;
    done : BOOL;

    prof_pos : REAL;
    prof_vel : REAL;
    target_pos : REAL;
    dist : REAL;
    d_stop : REAL;

    cond_stop : BOOL;
    cond_complete : BOOL;
    a_rad : REAL;
    b_mm : REAL;
    m_val : REAL;
    b_req_mm : REAL;
    b_req_dint : DINT;

    ton_stop : TON;
    ton_complete : TON;

    max_v : REAL := 50.0;
    max_a : REAL := 250.0;
    dt : REAL := 0.01;
    deg_to_rad : REAL := 0.017453292519943295;
    dint_to_rad : REAL := 0.00017453292519943295;
END_VAR

IF NOT init_done THEN
    init_done := TRUE;
    prof_pos := REAL(D11) * 0.01;
    prof_vel := 0.0;
    D20 := D11;
    D21 := D13;
    D22 := 0;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y2 := FALSE;
    state := 0;
END_IF;

IF X10 THEN
    req_latched := TRUE;
END_IF;

CASE state OF
    0:
        D20 := D11;
        D21 := D13;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;
        IF req_latched THEN
            prof_pos := REAL(D11) * 0.01;
            prof_vel := 0.0;
            state := 10;
        END_IF;

    10:
        target_pos := REAL(D10) * 0.01;
        dist := target_pos - prof_pos;
        d_stop := (prof_vel * prof_vel) / (2.0 * max_a);

        IF dist > 0.0 THEN
            IF dist <= d_stop THEN
                prof_vel := MAX(0.0, prof_vel - max_a * dt);
            ELSIF prof_vel < max_v THEN
                prof_vel := MIN(max_v, prof_vel + max_a * dt);
            END_IF;
            prof_pos := prof_pos + prof_vel * dt;
            IF prof_pos >= target_pos THEN
                prof_pos := target_pos;
                prof_vel := 0.0;
            END_IF;
        ELSIF dist < 0.0 THEN
            IF (-dist) <= d_stop THEN
                prof_vel := MIN(0.0, prof_vel + max_a * dt);
            ELSIF prof_vel > (-max_v) THEN
                prof_vel := MAX(-max_v, prof_vel - max_a * dt);
            END_IF;
            prof_pos := prof_pos + prof_vel * dt;
            IF prof_pos <= target_pos THEN
                prof_pos := target_pos;
                prof_vel := 0.0;
            END_IF;
        ELSE
            prof_vel := 0.0;
        END_IF;

        D20 := DINT(prof_pos * 100.0);
        D21 := DINT(-45000.0 * SIN(prof_pos * deg_to_rad));
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;

        IF prof_pos = target_pos AND prof_vel = 0.0 THEN
            D20 := D10;
            D21 := D17;
            state := 20;
        END_IF;

    20:
        D20 := D10;
        D21 := D17;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;

        cond_stop := (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 50) AND (ABS(D13 - D17) <= 20) AND (ABS(D14) <= 50);
        ton_stop(IN := cond_stop, PT := T#40ms);

        IF ton_stop.Q THEN
            state := 30;
        END_IF;

    30:
        D20 := D10;
        D21 := D17;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := FALSE;

        IF X11 THEN
            state := 40;
        END_IF;

    40:
        D20 := D10;
        D21 := D17;
        D22 := 0;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;

        a_rad := REAL(D11) * dint_to_rad;
        b_mm := REAL(D13) * 0.01;
        m_val := 88.29 * SIN(a_rad) + 0.1962 * b_mm;

        b_req_mm := -450.0 * SIN(REAL(D10) * dint_to_rad);
        b_req_dint := DINT(b_req_mm * 100.0);

        cond_complete := (ABS(m_val) <= 1.0) AND
                         (ABS(D11 - D10) <= 20) AND
                         (ABS(D13 - b_req_dint) <= 20) AND
                         (ABS(D12) <= 100) AND
                         (ABS(D14) <= 100) AND
                         X11 AND Y22 AND (NOT Y20) AND Y21;

        ton_complete(IN := cond_complete, PT := T#30ms);

        IF ton_complete.Q THEN
            done := TRUE;
        END_IF;

        IF done THEN
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM