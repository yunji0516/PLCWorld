PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    started : BOOL;
    state : INT;
    first_target : DINT;
    second_target : DINT;
    depth_target : DINT;
    reach_target : DINT;
    first_done : BOOL;
    second_done : BOOL;
    a_arrived : BOOL;
    b_arrived : BOOL;
    c_arrived : BOOL;
    all_arrived : BOOL;
    pos_tol : DINT := 20;
    vel_tol : DINT := 100;
    high_b : DINT := 12000;
    zero : DINT := 0;
    full_rate : DINT := 1000;
END_VAR

IF (NOT started) THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y2 := FALSE;
    D20 := zero;
    D21 := full_rate;
    D24 := zero;
    D25 := full_rate;
    D28 := zero;
    D29 := full_rate;

    IF X0 THEN
        started := TRUE;
        state := 10;
        first_target := D101;
        second_target := D102;
        depth_target := D103;
        reach_target := D104;
        first_done := FALSE;
        second_done := FALSE;
    END_IF;
END_IF;

IF started THEN
    D21 := full_rate;
    D25 := full_rate;
    D29 := full_rate;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;

    CASE state OF
        10:
            D20 := zero;
            D24 := high_b;
            D28 := zero;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived THEN
                state := 20;
            END_IF;

        20:
            D20 := first_target;
            D24 := high_b;
            D28 := zero;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived THEN
                state := 30;
            END_IF;

        30:
            D20 := first_target;
            D24 := zero;
            D28 := zero;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived THEN
                first_done := TRUE;
                state := 40;
            END_IF;

        40:
            D20 := first_target;
            D24 := high_b;
            D28 := zero;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived THEN
                state := 50;
            END_IF;

        50:
            D20 := second_target;
            D24 := high_b;
            D28 := reach_target;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived THEN
                state := 60;
            END_IF;

        60:
            D20 := second_target;
            D24 := depth_target;
            D28 := reach_target;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived THEN
                second_done := TRUE;
                state := 70;
            END_IF;

        70:
            D20 := second_target;
            D24 := high_b;
            D28 := reach_target;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived THEN
                state := 80;
            END_IF;

        80:
            D20 := zero;
            D24 := high_b;
            D28 := zero;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived THEN
                state := 90;
            END_IF;

        90:
            D20 := zero;
            D24 := zero;
            D28 := zero;

            a_arrived := (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol);
            b_arrived := (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol);
            c_arrived := (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol);
            all_arrived := a_arrived AND b_arrived AND c_arrived;

            IF all_arrived AND first_done AND second_done THEN
                state := 100;
            END_IF;

        100:
            D20 := zero;
            D24 := zero;
            D28 := zero;
            Y2 := TRUE;

        ELSE
            D20 := zero;
            D24 := high_b;
            D28 := zero;
            Y2 := FALSE;
            state := 10;
    END_CASE;

    IF state <> 100 THEN
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM