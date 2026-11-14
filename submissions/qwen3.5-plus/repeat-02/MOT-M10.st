PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;
    state : INT := 0;
    start_detected : BOOL := FALSE;
    target_a : DINT;
    pos_tol : DINT := 20;
    spd_tol : DINT := 100;
END_VAR

IF X0 AND NOT start_detected THEN
    start_detected := TRUE;
    target_a := D101;
END_IF;

CASE state OF
    0: // IDLE - wait for start request
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF start_detected THEN
            state := 1;
        END_IF;

    1: // MOVE_A_TO_500 - approach corner horizontally
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 500;
        D24 := 0;
        D25 := 500;
        IF ABS(D10 - 50000) <= pos_tol AND ABS(D11) <= spd_tol THEN
            state := 2;
        END_IF;

    2: // ROTATE_B_TO_90 - rotate head at corner
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 500;
        D24 := 9000;
        D25 := 500;
        IF ABS(D12 - 9000) <= pos_tol AND ABS(D13) <= spd_tol THEN
            state := 3;
        END_IF;

    3: // MOVE_A_TO_TARGET - go to requested position vertically
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := target_a;
        D21 := 500;
        D24 := 9000;
        D25 := 500;
        IF ABS(D10 - target_a) <= pos_tol AND ABS(D11) <= spd_tol THEN
            state := 4;
        END_IF;

    4: // MOVE_A_BACK_TO_500 - return vertically to corner
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 500;
        D24 := 9000;
        D25 := 500;
        IF ABS(D10 - 50000) <= pos_tol AND ABS(D11) <= spd_tol THEN
            state := 5;
        END_IF;

    5: // ROTATE_B_TO_0 - rotate head back at corner
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 500;
        D24 := 0;
        D25 := 500;
        IF ABS(D12 - 0) <= pos_tol AND ABS(D13) <= spd_tol THEN
            state := 6;
        END_IF;

    6: // MOVE_A_BACK_TO_200 - return horizontally to start
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 20000;
        D21 := 500;
        D24 := 0;
        D25 := 500;
        IF ABS(D10 - 20000) <= pos_tol AND ABS(D11) <= spd_tol THEN
            state := 7;
        END_IF;

    7: // COMPLETED
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 20000;
        D21 := 500;
        D24 := 0;
        D25 := 500;
        Y2 := TRUE;

    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
END_CASE;

END_PROGRAM