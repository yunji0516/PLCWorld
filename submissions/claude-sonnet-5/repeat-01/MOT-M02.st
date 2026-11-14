PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    step : INT := 0;
    start_accepted : BOOL := FALSE;

    target_ab : DINT;
    enable_ab : BOOL;
    c_target_v : DINT;
    enable_c : BOOL;
    latch_eng_cmd : BOOL;
    latch_rel_cmd : BOOL;

    diff_ab : DINT;
    korr : DINT;
    a_rate_calc : DINT;
    b_rate_calc : DINT;

    pos_tol : DINT := 20;   (* 0.2 mm * 100 *)
    vel_tol : DINT := 100;  (* 1 mm/s * 100 *)
END_VAR

(* latch start acceptance - once accepted, stays accepted *)
IF X0 THEN
    start_accepted := TRUE;
END_IF;

IF NOT start_accepted THEN
    (* never enable any commanded axis before start acceptance *)
    D20 := 0; D21 := 0; Y20 := FALSE;
    D24 := 0; D25 := 0; Y21 := FALSE;
    D28 := 0; D29 := 0; Y22 := FALSE;
    Y30 := FALSE; Y31 := FALSE;
    Y2 := FALSE;
ELSE
    CASE step OF
        0: (* move A/B to requested dock *)
            target_ab := D101;
            enable_ab := TRUE;
            c_target_v := D102;
            enable_c := FALSE;
            latch_eng_cmd := FALSE;
            latch_rel_cmd := FALSE;
            IF X4 THEN
                step := 1;
            END_IF;

        1: (* engage latch, hold beam at dock *)
            target_ab := D101;
            enable_ab := TRUE;
            c_target_v := D102;
            enable_c := FALSE;
            latch_eng_cmd := TRUE;
            latch_rel_cmd := FALSE;
            IF X2 AND NOT X3 THEN
                step := 2;
            END_IF;

        2: (* rails connected, transfer cart to park *)
            target_ab := D101;
            enable_ab := TRUE;
            c_target_v := D102;
            enable_c := TRUE;
            latch_eng_cmd := TRUE;
            latch_rel_cmd := FALSE;
            IF (ABS(D14 - D102) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
                step := 3;
            END_IF;

        3: (* cart parked, release latch *)
            target_ab := D101;
            enable_ab := TRUE;
            c_target_v := D102;
            enable_c := TRUE;
            latch_eng_cmd := FALSE;
            latch_rel_cmd := TRUE;
            IF X1 AND NOT X2 THEN
                step := 4;
            END_IF;

        4: (* return empty beam to origin *)
            target_ab := 0;
            enable_ab := TRUE;
            c_target_v := D102;
            enable_c := TRUE;
            latch_eng_cmd := FALSE;
            latch_rel_cmd := FALSE;
            IF (ABS(D10 - 0) <= pos_tol) AND (ABS(D11) <= vel_tol) AND
               (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
                step := 5;
            END_IF;

        5: (* done - actuators off except completion output *)
            target_ab := 0;
            enable_ab := FALSE;
            c_target_v := D102;
            enable_c := FALSE;
            latch_eng_cmd := FALSE;
            latch_rel_cmd := FALSE;

    END_CASE;

    (* proportional synchronization to keep |A-B| within safety limit *)
    diff_ab := D10 - D12;
    korr := diff_ab / 2;
    a_rate_calc := 1000 - korr;
    b_rate_calc := 1000 + korr;

    IF a_rate_calc > 1000 THEN
        a_rate_calc := 1000;
    ELSIF a_rate_calc < 0 THEN
        a_rate_calc := 0;
    END_IF;

    IF b_rate_calc > 1000 THEN
        b_rate_calc := 1000;
    ELSIF b_rate_calc < 0 THEN
        b_rate_calc := 0;
    END_IF;

    D20 := target_ab;
    D24 := target_ab;
    D21 := a_rate_calc;
    D25 := b_rate_calc;
    Y20 := enable_ab;
    Y21 := enable_ab;

    D28 := c_target_v;
    D29 := 1000;
    Y22 := enable_c;

    Y30 := latch_eng_cmd;
    Y31 := latch_rel_cmd;

    IF step = 5 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM