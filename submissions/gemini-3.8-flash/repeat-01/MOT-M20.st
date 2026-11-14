PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    u_start : DINT := 0;
    target : DINT := 0;
    v_real : REAL := 0.0;
    decel_dist : DINT := 0;
    min_target : DINT := 0;
    park_mod : DINT := 0;
    k : DINT := 0;
    pos_err : DINT := 0;
    spd_err : DINT := 0;
    at_park : BOOL := FALSE;
    timer_in : BOOL := FALSE;
    settle_timer : TON;
END_VAR

CASE state OF
    0:
        IF X10 THEN
            D20 := D15;
            Y20 := TRUE;
            state := 10;
        END_IF;

    10:
        IF X12 THEN
            Y20 := FALSE;
            state := 20;
        END_IF;

    20:
        IF X11 THEN
            u_start := D10;
            state := 30;
        END_IF;

    30:
        IF (D10 - u_start) >= D14 THEN
            Y21 := TRUE;
            state := 40;
        END_IF;

    40:
        IF NOT X12 THEN
            Y21 := FALSE;
            D20 := 0;

            v_real := REAL(D12) / 100.0;
            IF v_real < 0.0 THEN
                v_real := 0.0;
            END_IF;
            decel_dist := DINT((v_real * v_real) / 144.0);
            min_target := D11 + decel_dist + 2000;

            park_mod := D13 MOD 36000;
            IF park_mod < 0 THEN
                park_mod := park_mod + 36000;
            END_IF;

            k := (min_target - park_mod) / 36000;
            target := park_mod + k * 36000;
            WHILE target < min_target DO
                target := target + 36000;
            END_WHILE;

            D21 := target;
            Y22 := TRUE;
            state := 50;
        END_IF;

    50:
        pos_err := ABS(D11 - D21);
        spd_err := ABS(D12);
        at_park := (pos_err <= 20) AND (spd_err <= 100);

        IF settle_timer.Q THEN
            Y2 := TRUE;
            state := 60;
        END_IF;

    60:
        Y2 := TRUE;
        Y22 := TRUE;
        D21 := target;
END_CASE;

timer_in := (state = 50) AND at_park;
settle_timer(IN := timer_in, PT := T#30ms);

END_PROGRAM