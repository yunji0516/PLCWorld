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
    D18 : DINT;
    D19 : DINT;
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
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    D36 : DINT;
    D37 : DINT;
    Y24 : BOOL;
    Y2 : BOOL;

    (* Internal state machine *)
    state       : INT := 0;
    POS_TOL     : DINT := 20;   (* 0.2 mm * 100 *)
    VEL_TOL     : DINT := 100;  (* 1 mm/s * 100 *)
    FULL_RATE   : DINT := 1000;

    ab_open_val    : DINT := 10000; (* 100 mm * 100 *)
    d_dock_val     : DINT := 7000;  (* 70 mm * 100 *)

    target_req     : DINT;  (* latched request_target *)
    stroke_req     : DINT;  (* latched request_stroke *)
END_VAR

(* Latch the requests once, so they remain stable through the sequence *)
IF (target_req = 0) AND (D101 <> 0) THEN
    target_req := D101;
END_IF;
IF (stroke_req = 0) AND (D102 <> 0) THEN
    stroke_req := D102;
END_IF;

CASE state OF

0: (* Wait for start request - no enables active yet *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    D20 := 0; D21 := 0;
    D24 := 0; D25 := 0;
    D28 := 0; D29 := 0;
    D32 := 0; D33 := 0;
    D36 := 0; D37 := 0;
    IF X0 THEN
        state := 1;
    END_IF;

1: (* Open A/B plates fully to create clearance for the transfer jig *)
    Y20 := TRUE;
    Y21 := TRUE;
    D20 := ab_open_val;
    D21 := FULL_RATE;
    D24 := ab_open_val;
    D25 := FULL_RATE;
    IF (ABS(D10 - ab_open_val) <= POS_TOL) AND (ABS(D11) <= VEL_TOL) AND
       (ABS(D12 - ab_open_val) <= POS_TOL) AND (ABS(D13) <= VEL_TOL) THEN
        state := 2;
    END_IF;

2: (* Move transfer jig C to the requested target *)
    Y22 := TRUE;
    D28 := target_req;
    D29 := FULL_RATE;
    IF (ABS(D14 - target_req) <= POS_TOL) AND (ABS(D15) <= VEL_TOL) THEN
        state := 3;
    END_IF;

3: (* Dock lower support D at 70 mm *)
    Y23 := TRUE;
    D32 := d_dock_val;
    D33 := FULL_RATE;
    IF (ABS(D16 - d_dock_val) <= POS_TOL) AND (ABS(D17) <= VEL_TOL) THEN
        state := 4;
    END_IF;

4: (* Lower internal tool E to the requested stroke, through the jig hole *)
    Y24 := TRUE;
    D36 := stroke_req;
    D37 := FULL_RATE;
    IF (ABS(D18 - stroke_req) <= POS_TOL) AND (ABS(D19) <= VEL_TOL) THEN
        state := 5;
    END_IF;

5: (* Retract E back to 0; C and D remain untouched (held at target/70) *)
    D36 := 0;
    D37 := FULL_RATE;
    IF (ABS(D18 - 0) <= POS_TOL) AND (ABS(D19) <= VEL_TOL) THEN
        state := 6;
    END_IF;

6: (* Undock lower support D back to 0 *)
    D32 := 0;
    D33 := FULL_RATE;
    IF (ABS(D16 - 0) <= POS_TOL) AND (ABS(D17) <= VEL_TOL) THEN
        state := 7;
    END_IF;

7: (* Retract transfer jig C back to 0 *)
    D28 := 0;
    D29 := FULL_RATE;
    IF (ABS(D14 - 0) <= POS_TOL) AND (ABS(D15) <= VEL_TOL) THEN
        state := 8;
    END_IF;

8: (* Close A/B plates back to 0 *)
    D20 := 0;
    D21 := FULL_RATE;
    D24 := 0;
    D25 := FULL_RATE;
    IF (ABS(D10 - 0) <= POS_TOL) AND (ABS(D11) <= VEL_TOL) AND
       (ABS(D12 - 0) <= POS_TOL) AND (ABS(D13) <= VEL_TOL) THEN
        state := 9;
    END_IF;

9: (* All axes back at 0: hold and assert completion *)
    D20 := 0; D24 := 0; D28 := 0; D32 := 0; D36 := 0;
    D21 := FULL_RATE; D25 := FULL_RATE; D29 := FULL_RATE; D33 := FULL_RATE; D37 := FULL_RATE;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM