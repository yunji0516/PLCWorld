PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    captured : BOOL := FALSE;
    angle_raw : DINT;
    target_raw : DINT;
    receive_raw : DINT;

    a_arr : BOOL;
    b_arr : BOOL;
    c_arr : BOOL;
    d_arr : BOOL;
    dock_ok : BOOL;

    hold_tmr : TON;

    pos_tol : DINT := 20;
    vel_tol : DINT := 100;
END_VAR

(* capture requests once X0 is granted; also gates enable-before-start safety *)
IF (NOT captured) AND X0 THEN
    angle_raw := D101;
    target_raw := D102;
    receive_raw := D103;
    captured := TRUE;
    state := 1;
END_IF;

CASE state OF

0:
    (* idle: no enable before X0 request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    D20 := 0; D21 := 0;
    D24 := 0; D25 := 0;
    D28 := 0; D29 := 0;
    D32 := 0; D33 := 0;

1: (* A to 120, B to angle, D to receive (parallel prep) *)
    Y20 := TRUE; D20 := 12000; D21 := 1000;
    Y21 := TRUE; D24 := angle_raw; D25 := 1000;
    Y23 := TRUE; D32 := receive_raw; D33 := 1000;
    Y22 := FALSE; D28 := 0; D29 := 1000;

    a_arr := (ABS(D10 - 12000) <= pos_tol) AND (ABS(D11) <= vel_tol);
    b_arr := (ABS(D12 - angle_raw) <= pos_tol) AND (ABS(D13) <= vel_tol);

    IF a_arr AND b_arr THEN
        state := 2;
    END_IF;

2: (* move C through opening to target, keep A/B/D *)
    Y20 := TRUE; D20 := 12000; D21 := 1000;
    Y21 := TRUE; D24 := angle_raw; D25 := 1000;
    Y23 := TRUE; D32 := receive_raw; D33 := 1000;
    Y22 := TRUE; D28 := target_raw; D29 := 1000;

    c_arr := (ABS(D14 - target_raw) <= pos_tol) AND (ABS(D15) <= vel_tol);
    d_arr := (ABS(D16 - receive_raw) <= pos_tol) AND (ABS(D17) <= vel_tol);

    IF c_arr AND d_arr THEN
        state := 3;
    END_IF;

3: (* lower A to 100 to dock; D must stay at receive *)
    Y20 := TRUE; D20 := 10000; D21 := 1000;
    Y21 := TRUE; D24 := angle_raw; D25 := 1000;
    Y22 := TRUE; D28 := target_raw; D29 := 1000;
    Y23 := TRUE; D32 := receive_raw; D33 := 1000;

    a_arr := (ABS(D10 - 10000) <= pos_tol) AND (ABS(D11) <= vel_tol);
    b_arr := (ABS(D12 - angle_raw) <= pos_tol) AND (ABS(D13) <= vel_tol);
    c_arr := (ABS(D14 - target_raw) <= pos_tol) AND (ABS(D15) <= vel_tol);
    d_arr := (ABS(D16 - receive_raw) <= pos_tol) AND (ABS(D17) <= vel_tol);

    IF a_arr AND b_arr AND c_arr AND d_arr THEN
        state := 4;
        Y2 := TRUE;
    END_IF;

4: (* hold docking state for maintenance duration *)
    Y20 := TRUE; D20 := 10000; D21 := 1000;
    Y21 := TRUE; D24 := angle_raw; D25 := 1000;
    Y22 := TRUE; D28 := target_raw; D29 := 1000;
    Y23 := TRUE; D32 := receive_raw; D33 := 1000;
    Y2 := TRUE;

    a_arr := (ABS(D10 - 10000) <= pos_tol) AND (ABS(D11) <= vel_tol);
    b_arr := (ABS(D12 - angle_raw) <= pos_tol) AND (ABS(D13) <= vel_tol);
    c_arr := (ABS(D14 - target_raw) <= pos_tol) AND (ABS(D15) <= vel_tol);
    d_arr := (ABS(D16 - receive_raw) <= pos_tol) AND (ABS(D17) <= vel_tol);
    dock_ok := a_arr AND b_arr AND c_arr AND d_arr;

    hold_tmr(IN := dock_ok, PT := T#100ms);

    IF hold_tmr.Q THEN
        state := 5;
    END_IF;

5: (* leave support: raise A to 120 *)
    Y20 := TRUE; D20 := 12000; D21 := 1000;
    Y21 := TRUE; D24 := angle_raw; D25 := 1000;
    Y22 := TRUE; D28 := target_raw; D29 := 1000;
    Y23 := TRUE; D32 := receive_raw; D33 := 1000;
    Y2 := TRUE;

    a_arr := (ABS(D10 - 12000) <= pos_tol) AND (ABS(D11) <= vel_tol);

    IF a_arr THEN
        state := 6;
    END_IF;

6: (* retrieve C back to 0 (A already >=115, safe to move away) *)
    Y20 := TRUE; D20 := 12000; D21 := 1000;
    Y21 := TRUE; D24 := angle_raw; D25 := 1000;
    Y22 := TRUE; D28 := 0; D29 := 1000;
    Y23 := TRUE; D32 := receive_raw; D33 := 1000;
    Y2 := TRUE;

    c_arr := (ABS(D14 - 0) <= pos_tol) AND (ABS(D15) <= vel_tol);

    IF c_arr THEN
        state := 7;
    END_IF;

7: (* return all axes to 0 *)
    Y20 := TRUE; D20 := 0; D21 := 1000;
    Y21 := TRUE; D24 := 0; D25 := 1000;
    Y22 := TRUE; D28 := 0; D29 := 1000;
    Y23 := TRUE; D32 := 0; D33 := 1000;
    Y2 := TRUE;

    a_arr := (ABS(D10 - 0) <= pos_tol) AND (ABS(D11) <= vel_tol);
    b_arr := (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol);
    c_arr := (ABS(D14 - 0) <= pos_tol) AND (ABS(D15) <= vel_tol);
    d_arr := (ABS(D16 - 0) <= pos_tol) AND (ABS(D17) <= vel_tol);

    IF a_arr AND b_arr AND c_arr AND d_arr THEN
        state := 8;
    END_IF;

8: (* done: hold at zero *)
    Y20 := TRUE; D20 := 0; D21 := 1000;
    Y21 := TRUE; D24 := 0; D25 := 1000;
    Y22 := TRUE; D28 := 0; D29 := 1000;
    Y23 := TRUE; D32 := 0; D33 := 1000;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM