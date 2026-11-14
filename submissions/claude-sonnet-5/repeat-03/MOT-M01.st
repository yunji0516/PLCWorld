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
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    state      : INT := 0;
    req_cnt    : INT := 0;
    target_A   : DINT;
    target_B   : DINT;

    pos_tol    : DINT := 20;   (* 0.2 mm in 0.01 mm units *)
    spd_tol    : DINT := 100;  (* 1 mm/s in 0.01 mm/s units *)
    raise_v    : DINT := 40000; (* 400.00 mm *)
    zero_v     : DINT := 0;

    a_ok       : BOOL;
    b_ok       : BOOL;
    v_ok       : BOOL;
    all_ok     : BOOL;

    elev_settle  : TON;
    xy_settle    : TON;
    lower_settle : TON;
    final_settle : TON;
END_VAR

(* Debounce the incoming single task request: must be held for 5 consecutive scans *)
IF X10 THEN
    req_cnt := req_cnt + 1;
ELSE
    req_cnt := 0;
END_IF;

CASE state OF

0: (* IDLE - do not activate motion before request acceptance *)
    D20 := D11;
    D21 := D14;
    D22 := D16;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y2  := FALSE;

    IF req_cnt >= 5 THEN
        target_A := D10;
        target_B := D13;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        state := 1;
    END_IF;

1: (* RAISE A to secure vertical clearance before crossing paths *)
    D20 := D11; (* hold current A horizontal position, do not cross yet *)
    D21 := D14; (* hold current B horizontal position *)
    D22 := raise_v;

    v_ok := (ABS(D16 - raise_v) <= pos_tol) AND (ABS(D17) <= spd_tol);
    elev_settle(IN := v_ok, PT := T#30ms);

    IF elev_settle.Q THEN
        state := 2;
    END_IF;

2: (* SWAP: move A and B horizontally to opposite sides while A is elevated *)
    D20 := target_A;
    D21 := target_B;
    D22 := raise_v; (* keep A elevated during the horizontal crossing *)

    a_ok := (ABS(D11 - target_A) <= pos_tol) AND (ABS(D12) <= spd_tol);
    b_ok := (ABS(D14 - target_B) <= pos_tol) AND (ABS(D15) <= spd_tol);
    xy_settle(IN := a_ok AND b_ok, PT := T#30ms);

    IF xy_settle.Q THEN
        state := 3;
    END_IF;

3: (* LOWER A back to working height after crossing is complete *)
    D20 := target_A;
    D21 := target_B;
    D22 := zero_v;

    v_ok := (ABS(D16 - zero_v) <= pos_tol) AND (ABS(D17) <= spd_tol);
    lower_settle(IN := v_ok, PT := T#30ms);

    IF lower_settle.Q THEN
        state := 4;
    END_IF;

4: (* DONE - maintain final commands and confirm stable completion *)
    D20 := target_A;
    D21 := target_B;
    D22 := zero_v;

    a_ok := (ABS(D11 - target_A) <= pos_tol) AND (ABS(D12) <= spd_tol);
    b_ok := (ABS(D14 - target_B) <= pos_tol) AND (ABS(D15) <= spd_tol);
    v_ok := (ABS(D16 - zero_v) <= pos_tol) AND (ABS(D17) <= spd_tol);
    all_ok := a_ok AND b_ok AND v_ok;

    final_settle(IN := all_ok, PT := T#100ms);

    IF final_settle.Q THEN
        Y2 := TRUE;
    END_IF;

ELSE
    state := 0;

END_CASE;

END_PROGRAM