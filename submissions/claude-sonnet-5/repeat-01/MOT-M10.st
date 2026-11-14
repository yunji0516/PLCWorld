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
    target_s_raw : DINT := 84000;
    pos_tol : DINT := 20;   (* 0.2 mm/deg * 100 scale *)
    vel_tol : DINT := 100;  (* 1.0 mm/s or deg/s * 100 scale *)
END_VAR

CASE state OF

0: (* Wait for start request. Prepare safe targets, keep axes disabled. *)
    Y20 := FALSE;
    Y21 := FALSE;
    D20 := 20000; (* s = 200 mm *)
    D21 := 1000;
    D24 := 0;     (* B = 0 deg *)
    D25 := 1000;
    Y2 := FALSE;
    IF X0 THEN
        Y20 := TRUE;
        Y21 := TRUE;
        state := 10;
    END_IF;

10: (* Move progress s from 200 to the corner s=500, keep B=0 *)
    D20 := 50000;
    D21 := 1000;
    D24 := 0;
    D25 := 1000;
    IF ABS(D10 - 50000) <= pos_tol AND ABS(D11) <= vel_tol AND
       ABS(D12 - 0) <= pos_tol AND ABS(D13) <= vel_tol THEN
        state := 20;
    END_IF;

20: (* Stopped at corner: rotate head to B=90 in the rotation space *)
    D20 := 50000;
    D21 := 1000;
    D24 := 9000;
    D25 := 1000;
    IF ABS(D10 - 50000) <= pos_tol AND ABS(D11) <= vel_tol AND
       ABS(D12 - 9000) <= pos_tol AND ABS(D13) <= vel_tol THEN
        target_s_raw := D101;
        state := 30;
    END_IF;

30: (* Move up the vertical corridor to the requested s, B held at 90 *)
    D20 := target_s_raw;
    D21 := 1000;
    D24 := 9000;
    D25 := 1000;
    IF ABS(D10 - target_s_raw) <= pos_tol AND ABS(D11) <= vel_tol AND
       ABS(D12 - 9000) <= pos_tol AND ABS(D13) <= vel_tol THEN
        state := 40;
    END_IF;

40: (* Return down the vertical corridor back to the corner s=500 *)
    D20 := 50000;
    D21 := 1000;
    D24 := 9000;
    D25 := 1000;
    IF ABS(D10 - 50000) <= pos_tol AND ABS(D11) <= vel_tol AND
       ABS(D12 - 9000) <= pos_tol AND ABS(D13) <= vel_tol THEN
        state := 50;
    END_IF;

50: (* Stopped at corner: rotate head back to B=0 for the horizontal corridor *)
    D20 := 50000;
    D21 := 1000;
    D24 := 0;
    D25 := 1000;
    IF ABS(D10 - 50000) <= pos_tol AND ABS(D11) <= vel_tol AND
       ABS(D12 - 0) <= pos_tol AND ABS(D13) <= vel_tol THEN
        state := 60;
    END_IF;

60: (* Move progress s back to 200, B held at 0 *)
    D20 := 20000;
    D21 := 1000;
    D24 := 0;
    D25 := 1000;
    IF ABS(D10 - 20000) <= pos_tol AND ABS(D11) <= vel_tol AND
       ABS(D12 - 0) <= pos_tol AND ABS(D13) <= vel_tol THEN
        state := 70;
    END_IF;

70: (* Final position reached: hold and assert completion *)
    D20 := 20000;
    D21 := 1000;
    D24 := 0;
    D25 := 1000;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM