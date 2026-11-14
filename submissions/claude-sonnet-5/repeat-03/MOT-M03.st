PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    requestActive : BOOL;
    initialized   : BOOL;
    ref_pos       : REAL;      (* running reference position for S, mm *)
    s_pos         : REAL;
    s_spd         : REAL;
    u_pos         : REAL;
    u_spd         : REAL;
    pos_err       : REAL;
    spd_err       : REAL;
    desired_speed : REAL;
    aligned       : BOOL;
    fork_cmd      : BOOL;      (* latched: fork commanded/retained extended *)
    result_now    : BOOL;
    claimed       : BOOL;      (* latched: task completion claimed *)

    dt            : REAL := 0.01;    (* scan period in seconds *)
    kp            : REAL := 6.0;     (* catch-up gain *)
    max_cmd_speed : REAL := 300.0;   (* permitted feedforward command cap, mm/s *)

    align_timer  : TON;
    result_timer : TON;
END_VAR

(* Convert scaled DINT feedback (0.01 physical-unit scale) to physical units *)
s_pos := INT_TO_REAL(D11) / 100.0;
s_spd := INT_TO_REAL(D12) / 100.0;
u_pos := INT_TO_REAL(D13) / 100.0;
u_spd := INT_TO_REAL(D14) / 100.0;

IF X10 THEN
    requestActive := TRUE;
END_IF;

IF requestActive THEN
    Y20 := TRUE;

    IF NOT initialized THEN
        ref_pos := s_pos;
        initialized := TRUE;
    END_IF;

    pos_err := u_pos - s_pos;
    spd_err := u_spd - s_spd;

    (* Feedforward matches leader speed, plus proportional catch-up on position gap *)
    desired_speed := u_spd + kp * pos_err;
    IF desired_speed > max_cmd_speed THEN
        desired_speed := max_cmd_speed;
    ELSIF desired_speed < -max_cmd_speed THEN
        desired_speed := -max_cmd_speed;
    END_IF;

    ref_pos := ref_pos + desired_speed * dt;

    D20 := DINT(ROUND(ref_pos * 100.0));
    D21 := DINT(ROUND(desired_speed * 100.0));

    aligned := (ABS(pos_err) <= 0.20) AND (ABS(spd_err) <= 1.0);

    (* Require alignment stable for the axis settling time before extending the fork *)
    align_timer(IN := aligned, PT := T#30ms);
    IF align_timer.Q THEN
        fork_cmd := TRUE;
    END_IF;

    Y21 := fork_cmd;

    (* Actual result: fork fully inserted while alignment is maintained *)
    result_now := fork_cmd AND X11 AND aligned;

    result_timer(IN := result_now, PT := T#30ms);
    IF result_timer.Q THEN
        claimed := TRUE;
    END_IF;

    Y2 := claimed;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    D20 := D11;
    D21 := 0;
END_IF;

END_PROGRAM