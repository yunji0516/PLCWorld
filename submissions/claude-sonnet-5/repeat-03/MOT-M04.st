PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;

    (* internal variables *)
    a_pos : REAL;
    a_vel : REAL;
    a_target : REAL;
    b_pos : REAL;
    b_vel : REAL;
    b_target : REAL;
    c_pos : REAL;
    c_vel : REAL;
    c_target : REAL;

    err_b : REAL;
    accel_b : REAL;
    wn : REAL := 35.0;
    zeta : REAL := 1.0;

    stable : BOOL;
    stableTimer : TON;
    y2_latch : BOOL;
END_VAR

(* --- convert scaled I/O to physical units --- *)
a_pos    := INT_TO_REAL(D11) * 0.01;
a_vel    := INT_TO_REAL(D12) * 0.01;
a_target := INT_TO_REAL(D10) * 0.01;
b_pos    := INT_TO_REAL(D13) * 0.01;
b_vel    := INT_TO_REAL(D14) * 0.01;
b_target := INT_TO_REAL(D17) * 0.01;
c_pos    := INT_TO_REAL(D15) * 0.01;
c_vel    := INT_TO_REAL(D16) * 0.01;
c_target := INT_TO_REAL(D18) * 0.01;

IF X10 THEN
    (* hoist: pass requested wire length target through, clamped to permitted command range *)
    D20 := LIMIT(60000, D10, 160000);
    Y20 := TRUE;

    (* trolley acceleration command via PD law, feedforward speed = 0 (final stop) *)
    err_b := b_target - b_pos;
    accel_b := (wn * wn * err_b) + (2.0 * zeta * wn * (0.0 - b_vel));

    (* clamp to permitted command range converted to native units (mm/s^2) *)
    IF accel_b > 4000.0 THEN
        accel_b := 4000.0;
    ELSIF accel_b < -4000.0 THEN
        accel_b := -4000.0;
    END_IF;

    D21 := DINT(accel_b * 100.0);
    D21 := LIMIT(-400000, D21, 400000);
ELSE
    (* not yet requested: hold present position, no motion, no acceleration *)
    D20 := D11;
    Y20 := FALSE;
    D21 := 0;
END_IF;

(* --- completion / stability check --- *)
stable := X10
    AND (ABS(a_pos - a_target) <= 1.0)
    AND (ABS(b_pos - b_target) <= 1.0)
    AND (ABS(c_pos - c_target) <= 0.2)
    AND (ABS(a_vel) <= 1.0)
    AND (ABS(b_vel) <= 1.0)
    AND (ABS(c_vel) <= 1.0);

stableTimer(IN := stable, PT := T#30ms);

IF stableTimer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM