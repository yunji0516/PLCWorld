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

    (* Internal state *)
    step : INT := 0;
    started : BOOL := FALSE;
    y2_latch : BOOL := FALSE;

    (* Tolerances (physical value * 100 = raw scale) *)
    POS_TOL : DINT := 20;   (* 0.2 mm *)
    VEL_TOL : DINT := 100;  (* 1 mm/s *)

    (* Fixed command values in raw (*100) scale *)
    RATE_FULL : DINT := 1000;
    OPEN_POS  : DINT := 10000; (* 100 mm *)
    DOCK_POS  : DINT := 7000;  (* 70 mm *)
    ZERO_POS  : DINT := 0;

    a_arrived : BOOL;
    b_arrived : BOOL;
    c_arrived : BOOL;
    d_arrived : BOOL;
    e_arrived : BOOL;

    stab_timer : TON;
END_VAR

(* Arrival checks: current commanded target register vs actual position/velocity *)
a_arrived := (ABS(D10 - D20) <= POS_TOL) AND (ABS(D11) <= VEL_TOL);
b_arrived := (ABS(D12 - D24) <= POS_TOL) AND (ABS(D13) <= VEL_TOL);
c_arrived := (ABS(D14 - D28) <= POS_TOL) AND (ABS(D15) <= VEL_TOL);
d_arrived := (ABS(D16 - D32) <= POS_TOL) AND (ABS(D17) <= VEL_TOL);
e_arrived := (ABS(D18 - D36) <= POS_TOL) AND (ABS(D19) <= VEL_TOL);

CASE step OF

0: (* Idle - wait for start request before any enable *)
    IF X0 THEN
        started := TRUE;
    END_IF;

    IF started THEN
        (* Open A/B vertical plates first to give clearance for C *)
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := OPEN_POS;
        D21 := RATE_FULL;
        D24 := OPEN_POS;
        D25 := RATE_FULL;
        step := 1;
    END_IF;

1: (* Wait for both plates open, then move C (transfer jig) to requested target *)
    IF a_arrived AND b_arrived THEN
        Y22 := TRUE;
        D28 := D101;
        D29 := RATE_FULL;
        step := 2;
    END_IF;

2: (* Wait for C at target, then dock D (support) at 70 *)
    IF c_arrived THEN
        Y23 := TRUE;
        D32 := DOCK_POS;
        D33 := RATE_FULL;
        step := 3;
    END_IF;

3: (* Wait for D docked, then lower E (tool) to requested stroke *)
    IF d_arrived THEN
        Y24 := TRUE;
        D36 := D102;
        D37 := RATE_FULL;
        step := 4;
    END_IF;

4: (* Wait for E at stroke, then retract E to 0. While retracting through the
      hole (E > 167.5 mm) C and D targets remain unchanged (target, 70). *)
    IF e_arrived THEN
        D36 := ZERO_POS;
        step := 5;
    END_IF;

5: (* Wait for E fully retracted to 0 before releasing D and C *)
    IF e_arrived THEN
        D32 := ZERO_POS;
        step := 6;
    END_IF;

6: (* Wait for D retracted to 0, then retract the transfer jig C to 0 *)
    IF d_arrived THEN
        D28 := ZERO_POS;
        step := 7;
    END_IF;

7: (* Wait for C retracted to 0, then close A/B plates back to 0 *)
    IF c_arrived THEN
        D20 := ZERO_POS;
        D24 := ZERO_POS;
        step := 8;
    END_IF;

8: (* Wait for plates closed to 0 - all axes now commanded to 0 *)
    IF a_arrived AND b_arrived THEN
        step := 9;
    END_IF;

9: (* Hold all axes at 0; assert completion after 100 ms continuous stop-arrival *)
    stab_timer(IN := a_arrived AND b_arrived AND c_arrived AND d_arrived AND e_arrived,
               PT := T#100ms);
    IF stab_timer.Q THEN
        y2_latch := TRUE;
    END_IF;

ELSE
    step := 0;

END_CASE;

Y2 := y2_latch;

END_PROGRAM