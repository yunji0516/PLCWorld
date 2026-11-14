PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;

    req_edge : R_TRIG;
    stable_timer : TON;

    state : INT := 0;
    phase : INT := 1;

    tgt_a : DINT;
    tgt_b : DINT;

    accel_mag : REAL := 3000.0;

    completed : BOOL := FALSE;

    actual_a : REAL;
    actual_b : REAL;
    actual_c : REAL;
    actual_a_spd : REAL;
    actual_b_spd : REAL;
    actual_c_spd : REAL;
    tgt_a_real : REAL;
    tgt_b_real : REAL;
    dist_to_tgt : REAL;
    decel_dist : REAL;
    accel_cmd : REAL;
END_VAR

req_edge(CLK := X10);

actual_a := D11 * 0.01;
actual_b := D13 * 0.01;
actual_c := D15 * 0.01;
actual_a_spd := D12 * 0.01;
actual_b_spd := D14 * 0.01;
actual_c_spd := D16 * 0.01;

CASE state OF
    0:
        D20 := D10;
        Y20 := FALSE;
        D21 := 0;
        IF req_edge.Q THEN
            tgt_a := D10;
            tgt_b := D17;
            tgt_a_real := tgt_a * 0.01;
            tgt_b_real := tgt_b * 0.01;
            phase := 1;
            completed := FALSE;
            state := 1;
        END_IF;

    1:
        D20 := tgt_a;
        Y20 := TRUE;

        dist_to_tgt := tgt_b_real - actual_b;

        CASE phase OF
            1:
                IF dist_to_tgt > 0.0 THEN
                    accel_cmd := accel_mag;
                ELSE
                    accel_cmd := -accel_mag;
                END_IF;

                IF accel_cmd > 4000.0 THEN accel_cmd := 4000.0; END_IF;
                IF accel_cmd < -4000.0 THEN accel_cmd := -4000.0; END_IF;

                D21 := DINT(accel_cmd * 100.0);

                decel_dist := actual_b_spd * actual_b_spd / (2.0 * accel_mag);
                IF ABS(dist_to_tgt) <= decel_dist + 15.0 THEN
                    phase := 2;
                END_IF;

            2:
                D21 := 0;

                decel_dist := actual_b_spd * actual_b_spd / (2.0 * accel_mag);
                IF ABS(dist_to_tgt) <= decel_dist + 15.0 THEN
                    phase := 3;
                END_IF;

            3:
                IF dist_to_tgt > 0.0 THEN
                    accel_cmd := -accel_mag;
                ELSE
                    accel_cmd := accel_mag;
                END_IF;

                IF accel_cmd > 4000.0 THEN accel_cmd := 4000.0; END_IF;
                IF accel_cmd < -4000.0 THEN accel_cmd := -4000.0; END_IF;

                D21 := DINT(accel_cmd * 100.0);

                IF ABS(actual_b_spd) <= 0.5 AND ABS(dist_to_tgt) <= 1.0 THEN
                    D21 := 0;
                    phase := 4;
                END_IF;

            4:
                D21 := 0;
        END_CASE;

        IF ABS(actual_a - tgt_a_real) <= 1.0 AND
           ABS(actual_b - tgt_b_real) <= 1.0 AND
           ABS(actual_c) <= 0.2 AND
           ABS(actual_a_spd) <= 1.0 AND
           ABS(actual_b_spd) <= 1.0 AND
           ABS(actual_c_spd) <= 1.0 THEN
            stable_timer(IN := TRUE, PT := T#30ms);
            IF stable_timer.Q THEN
                completed := TRUE;
            END_IF;
        ELSE
            stable_timer(IN := FALSE);
            completed := FALSE;
        END_IF;
END_CASE;

Y2 := completed;

END_PROGRAM