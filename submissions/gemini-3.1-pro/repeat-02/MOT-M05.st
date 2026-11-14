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
    pos_a : REAL := 0.0;
    vel_a : REAL := 0.0;
    req_a : REAL := 0.0;
    dist : REAL := 0.0;
    abs_dist : REAL := 0.0;
    v_target : REAL := 0.0;
    dt : REAL := 0.01;
    a_max : REAL := 40000.0;
    v_max : REAL := 8000.0;

    target_b : REAL := 0.0;
    final_b : DINT := 0;

    settle_timer : TON;
    completion_timer : TON;
    captured_req : DINT := 0;
    settled : BOOL := FALSE;
    completed : BOOL := FALSE;
    ramp_done : BOOL := FALSE;
END_VAR

IF state = 0 THEN
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    D20 := D11;
    D21 := D13;
    D22 := 0;

    IF X10 THEN
        captured_req := D10;
        req_a := REAL(captured_req);
        pos_a := REAL(D11);
        vel_a := 0.0;
        final_b := DINT(-45000.0 * SIN(req_a * 0.0001745329252));
        ramp_done := FALSE;
        state := 1;
    END_IF;
END_IF;

IF state = 1 THEN
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y2 := FALSE;
    D22 := 0;

    dist := req_a - pos_a;
    abs_dist := ABS(dist);

    IF abs_dist < 1.0 AND ABS(vel_a) < 10.0 THEN
        pos_a := req_a;
        vel_a := 0.0;
        v_target := 0.0;
        ramp_done := TRUE;
    ELSE
        ramp_done := FALSE;
        IF abs_dist < 200.0 THEN
            v_target := dist * 20.0;
        ELSE
            v_target := SQRT(80000.0 * abs_dist);
            IF dist < 0.0 THEN v_target := -v_target; END_IF;
        END_IF;

        IF v_target > v_max THEN v_target := v_max; END_IF;
        IF v_target < -v_max THEN v_target := -v_max; END_IF;

        IF v_target > vel_a + a_max * dt THEN
            vel_a := vel_a + a_max * dt;
        ELSIF v_target < vel_a - a_max * dt THEN
            vel_a := vel_a - a_max * dt;
        ELSE
            vel_a := v_target;
        END_IF;

        pos_a := pos_a + vel_a * dt;
    END_IF;

    D20 := DINT(pos_a);

    IF ramp_done THEN
        D21 := final_b;
    ELSE
        target_b := -45000.0 * SIN(pos_a * 0.0001745329252);
        D21 := DINT(target_b);
    END_IF;

    settled := ramp_done AND (ABS(D12) <= 50) AND (ABS(D14) <= 50) AND 
               (ABS(D11 - captured_req) <= 15) AND (ABS(D13 - final_b) <= 15);
END_IF;

IF state = 2 THEN
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y2 := FALSE;
    D20 := captured_req;
    D21 := final_b;
    D22 := 0;

    IF X11 THEN
        state := 3;
    END_IF;
END_IF;

IF state = 3 THEN
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := TRUE;
    D20 := captured_req;
    D21 := final_b;
    D22 := 0;

    completed := (ABS(D11 - captured_req) <= 20) AND
                 (ABS(D13 - final_b) <= 20) AND
                 (ABS(D12) <= 100) AND
                 (ABS(D14) <= 100) AND
                 X11 AND NOT Y20;
END_IF;

settle_timer(IN := (state = 1) AND settled, PT := T#100ms);
IF settle_timer.Q AND state = 1 THEN
    state := 2;
END_IF;

completion_timer(IN := (state = 3) AND completed, PT := T#30ms);
IF completion_timer.Q AND state = 3 THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM