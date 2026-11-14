PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    timer : TON;
    y2_latched : BOOL;
    a_deg : REAL;
    a_speed_deg : REAL;
    a_rad : REAL;
    a_speed_rad : REAL;
    b_ideal : REAL;
    v_b_ideal : REAL;
    cmd_pos : DINT;
    cmd_vel : DINT;
    result_ok : BOOL;

    DEG_TO_RAD : REAL := 0.017453292519943295;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    Y2 := FALSE;
    y2_latched := FALSE;
    D20 := LIMIT(-200000, D11, 200000);
    D21 := 0;
    timer(IN := FALSE, PT := T#30ms);
ELSE
    Y20 := TRUE;

    a_deg := REAL(D13) * 0.01;
    a_speed_deg := REAL(D14) * 0.01;
    a_rad := a_deg * DEG_TO_RAD;
    a_speed_rad := a_speed_deg * DEG_TO_RAD;

    b_ideal := -450.0 * SIN(a_rad);
    v_b_ideal := -450.0 * COS(a_rad) * a_speed_rad;

    cmd_pos := DINT(ROUND(b_ideal * 100.0));
    cmd_vel := DINT(ROUND(v_b_ideal * 100.0));

    D20 := LIMIT(-200000, cmd_pos, 200000);
    D21 := LIMIT(-200000, cmd_vel, 200000);

    result_ok := (D17 >= -100) AND (D17 <= 100);
    timer(IN := result_ok, PT := T#30ms);

    IF timer.Q THEN
        y2_latched := TRUE;
    END_IF;

    Y2 := y2_latched;
END_IF;

END_PROGRAM