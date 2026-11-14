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

    (* Internal state *)
    step        : INT := 0;
    started     : BOOL := FALSE;
    port1_done  : BOOL := FALSE;
    port2_done  : BOOL := FALSE;
    home_done   : BOOL := FALSE;

    pos_tol     : DINT := 20;    (* 0.2 mm * 100 *)
    vel_tol     : DINT := 100;   (* 1 mm/s * 100 *)
    transit_b   : DINT := 12000; (* 120.00 mm * 100, safe height above deck (>=100) *)
    max_rate    : DINT := 1000;
END_VAR

IF NOT started THEN
    IF X0 THEN
        started := TRUE;

        (* Enable only after start request, per safety condition *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;

        (* Step 1: raise B to transit height, hold A=0, C=0 *)
        D20 := 0;
        D21 := max_rate;
        D24 := transit_b;
        D25 := max_rate;
        D28 := 0;
        D29 := max_rate;

        step := 1;
    END_IF;
ELSE
    CASE step OF

        1: (* raising B to transit height *)
            IF ABS(D12 - transit_b) <= pos_tol AND ABS(D13) <= vel_tol THEN
                D20 := D101; (* move A to first port, at safe height *)
                step := 2;
            END_IF;

        2: (* A moving to first, B held at transit height *)
            IF ABS(D10 - D101) <= pos_tol AND ABS(D11) <= vel_tol AND
               ABS(D12 - transit_b) <= pos_tol AND ABS(D13) <= vel_tol THEN
                D24 := 0; (* lower B into first opening *)
                step := 3;
            END_IF;

        3: (* lowering B to 0 : first port arrival *)
            IF ABS(D12 - 0) <= pos_tol AND ABS(D13) <= vel_tol AND
               ABS(D10 - D101) <= pos_tol AND ABS(D11) <= vel_tol AND
               ABS(D14 - 0) <= pos_tol AND ABS(D15) <= vel_tol THEN
                port1_done := TRUE;
                D24 := transit_b; (* raise back up for next transit *)
                step := 4;
            END_IF;

        4: (* raising B back to transit height after port1 *)
            IF ABS(D12 - transit_b) <= pos_tol AND ABS(D13) <= vel_tol THEN
                D20 := D102; (* move A to second port *)
                D28 := D104; (* move C to reach, simultaneous transfer at safe height *)
                step := 5;
            END_IF;

        5: (* A and C moving simultaneously, B held at transit height *)
            IF ABS(D10 - D102) <= pos_tol AND ABS(D11) <= vel_tol AND
               ABS(D14 - D104) <= pos_tol AND ABS(D15) <= vel_tol AND
               ABS(D12 - transit_b) <= pos_tol AND ABS(D13) <= vel_tol THEN
                D24 := D103; (* lower B into second opening to depth *)
                step := 6;
            END_IF;

        6: (* lowering B to depth : second port arrival *)
            IF ABS(D12 - D103) <= pos_tol AND ABS(D13) <= vel_tol AND
               ABS(D10 - D102) <= pos_tol AND ABS(D11) <= vel_tol AND
               ABS(D14 - D104) <= pos_tol AND ABS(D15) <= vel_tol THEN
                port2_done := TRUE;
                D24 := transit_b; (* raise back up for return transit *)
                step := 7;
            END_IF;

        7: (* raising B back to transit height after port2 *)
            IF ABS(D12 - transit_b) <= pos_tol AND ABS(D13) <= vel_tol THEN
                D20 := 0; (* return A to 0 *)
                D28 := 0; (* return C to 0, simultaneous at safe height *)
                step := 8;
            END_IF;

        8: (* A and C returning to 0, B held at transit height *)
            IF ABS(D10 - 0) <= pos_tol AND ABS(D11) <= vel_tol AND
               ABS(D14 - 0) <= pos_tol AND ABS(D15) <= vel_tol AND
               ABS(D12 - transit_b) <= pos_tol AND ABS(D13) <= vel_tol THEN
                D24 := 0; (* lower B to 0 : final home *)
                step := 9;
            END_IF;

        9: (* lowering B to 0 : final home arrival *)
            IF ABS(D12 - 0) <= pos_tol AND ABS(D13) <= vel_tol AND
               ABS(D10 - 0) <= pos_tol AND ABS(D11) <= vel_tol AND
               ABS(D14 - 0) <= pos_tol AND ABS(D15) <= vel_tol THEN
                home_done := TRUE;
                step := 10;
            END_IF;

        10: (* maintain home, assert completion once both ports achieved and home reached *)
            IF port1_done AND port2_done AND home_done THEN
                Y2 := TRUE;
            END_IF;

        ELSE
            ;
    END_CASE;
END_IF;

END_PROGRAM