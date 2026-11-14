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
    started : BOOL := FALSE;
    pos_tol : DINT := 20;   // 0.2 mm/deg * 100
    vel_tol : DINT := 100;  // 1 mm/s or deg/s * 100
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    // Safety: do not enable axes before X0 request.
    Y20 := FALSE;
    Y21 := FALSE;
    D20 := 20000; // prepare a_target = 200 mm (raw *100)
    D21 := 0;
    D24 := 0;     // prepare b_target = 0 deg
    D25 := 0;
    Y2 := FALSE;
ELSE
    CASE state OF

        0: // Move a from 200 to the corner s=500, keep B=0 (b disabled/at rest)
            Y20 := TRUE;
            Y21 := FALSE;
            D20 := 50000;
            D21 := 1000;
            D24 := 0;
            D25 := 0;
            IF ABS(D10 - 50000) <= pos_tol AND ABS(D11) <= vel_tol THEN
                state := 1;
            END_IF;

        1: // At corner, rotate B from 0 to 90 while a holds at 500
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D21 := 1000;
            D24 := 9000;
            D25 := 1000;
            IF ABS(D12 - 9000) <= pos_tol AND ABS(D13) <= vel_tol THEN
                state := 2;
            END_IF;

        2: // Move a from 500 to the requested target, B held at 90
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := D101;
            D21 := 1000;
            D24 := 9000;
            D25 := 1000;
            IF ABS(D10 - D101) <= pos_tol AND ABS(D11) <= vel_tol THEN
                state := 3;
            END_IF;

        3: // Arrived at requested s with B=90; begin return: move a back to 500
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D21 := 1000;
            D24 := 9000;
            D25 := 1000;
            IF ABS(D10 - 50000) <= pos_tol AND ABS(D11) <= vel_tol THEN
                state := 4;
            END_IF;

        4: // At corner again, rotate B back from 90 to 0
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D21 := 1000;
            D24 := 0;
            D25 := 1000;
            IF ABS(D12 - 0) <= pos_tol AND ABS(D13) <= vel_tol THEN
                state := 5;
            END_IF;

        5: // Move a from 500 back to 200, B held at 0
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 20000;
            D21 := 1000;
            D24 := 0;
            D25 := 1000;
            IF ABS(D10 - 20000) <= pos_tol AND ABS(D11) <= vel_tol THEN
                state := 6;
            END_IF;

        6: // Completed: maintain final safe posture and assert completion
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 20000;
            D21 := 1000;
            D24 := 0;
            D25 := 1000;
            Y2 := TRUE;

    END_CASE;
END_IF;

END_PROGRAM