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
    start_edge : R_TRIG;
    state : INT;
    target_a : DINT;
    target_b : DINT;
    target_c : DINT;
    stabilizing_timer : TON;
    completion_asserted : BOOL;
END_VAR

(* State machine states *)
(* 0 = waiting for start *)
(* 1 = move B to clearance height 100 *)
(* 2 = approach Port 1 (move A,C while B at clearance) *)
(* 3 = visit Port 1 (lower B) *)
(* 4 = wait for B at Port 1 *)
(* 5 = raise B for Port 2 transit *)
(* 6 = approach Port 2 (move A,C) *)
(* 7 = visit Port 2 (lower B to depth) *)
(* 8 = wait for B at Port 2 *)
(* 9 = raise B for return home *)
(* 10 = move all axes to home position *)
(* 11 = wait for home arrival *)
(* 12 = completion *)

VAR
    RATE : INT := 400;
    POS_TOL : INT := 20;
    VEL_TOL : INT := 100;
END_VAR

start_edge(CLK := X0);

CASE state OF
  0: (* Wait for start signal *)
    IF start_edge.Q THEN
      state := 1;
    END_IF;

  1: (* Move B to clearance height 100 *)
    target_b := 100 * 100;
    b_target := target_b;
    b_rate := RATE;
    y21 := TRUE;
    state := 2;

  2: (* Approach Port 1 - move A and C while B is at clearance *)
    target_a := D101;
    target_c := 0;
    a_target := target_a;
    c_target := target_c;
    a_rate := RATE;
    c_rate := RATE;
    y20 := TRUE;
    y22 := TRUE;
    state := 3;

  3: (* Visit Port 1 - wait for all axes arrived, then lower B *)
    IF ABS(D20 - D10) <= POS_TOL AND ABS(D12 - D12) <= POS_TOL AND ABS(D28 - D14) <= POS_TOL THEN
      IF ABS(D11) <= VEL_TOL AND ABS(D13) <= VEL_TOL AND ABS(D15) <= VEL_TOL THEN
        target_b := D103;
        b_target := target_b;
        b_rate := RATE;
        y21 := TRUE;
        state := 4;
      END_IF;
    END_IF;

  4: (* Wait for B arrival at Port 1 *)
    IF ABS(D24 - D12) <= POS_TOL AND ABS(D13) <= VEL_TOL THEN
      target_b := 100 * 100;
      b_target := target_b;
      b_rate := RATE;
      y21 := TRUE;
      state := 5;
    END_IF;

  5: (* Raise B - already raising, just transition *)
    state := 6;

  6: (* Approach Port 2 - move A to second, C to reach *)
    target_a := D102;
    target_c := D104;
    a_target := target_a;
    c_target := target_c;
    a_rate := RATE;
    c_rate := RATE;
    y20 := TRUE;
    y22 := TRUE;
    state := 7;

  7: (* Visit Port 2 - wait for A,C arrived, then lower B to depth *)
    IF ABS(D20 - D10) <= POS_TOL AND ABS(D28 - D14) <= POS_TOL THEN
      IF ABS(D11) <= VEL_TOL AND ABS(D15) <= VEL_TOL THEN
        target_b := D103;
        b_target := target_b;
        b_rate := RATE;
        y21 := TRUE;
        state := 8;
      END_IF;
    END_IF;

  8: (* Wait for B arrival at Port 2 *)
    IF ABS(D24 - D12) <= POS_TOL AND ABS(D13) <= VEL_TOL THEN
      target_b := 100 * 100;
      b_target := target_b;
      b_rate := RATE;
      y21 := TRUE;
      state := 9;
    END_IF;

  9: (* Raise B for return home - already raising, just transition *)
    state := 10;

  10: (* Return all axes to home position A=0, B=0, C=0 *)
    target_a := 0;
    target_b := 0;
    target_c := 0;
    a_target := target_a;
    b_target := target_b;
    c_target := target_c;
    a_rate := RATE;
    b_rate := RATE;
    c_rate := RATE;
    y20 := TRUE;
    y21 := TRUE;
    y22 := TRUE;
    state := 11;

  11: (* Wait for home arrival *)
    IF ABS(D20 - D10) <= POS_TOL AND ABS(D24 - D12) <= POS_TOL AND ABS(D28 - D14) <= POS_TOL THEN
      IF ABS(D11) <= VEL_TOL AND ABS(D13) <= VEL_TOL AND ABS(D15) <= VEL_TOL THEN
        y2 := TRUE;
        stabilizing_timer(IN := TRUE, PT := T#100ms);
        state := 12;
      END_IF;
    END_IF;

  12: (* Completion phase - maintain Y2 *)
    stabilizing_timer(IN := TRUE, PT := T#100ms);
    IF stabilizing_timer.Q THEN
      completion_asserted := TRUE;
      (* Y2 stays TRUE for the remainder of observation *)
    END_IF;

END_CASE;

END_PROGRAM