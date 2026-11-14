PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    (* internal *)
    request_active : BOOL := FALSE;
    head_target    : DINT := 0;   (* latched requested head position, x0.01 deg *)
    cw_target      : DINT := 0;   (* latched requested counterweight position, x0.01 mm *)
    phase          : INT := 0;    (* 0 idle, 1 moving, 2 braking, 3 holding/complete *)

    pos_tol        : DINT := 20;  (* 0.2 unit -> x0.01 scaling = 20 *)
    spd_tol        : DINT := 100; (* 1 unit/s -> x0.01 scaling = 100 *)

    stable_timer   : TON;
END_VAR

(* Latch the work request the first time it appears while idle *)
IF X10 AND NOT request_active THEN
    request_active := TRUE;
    head_target := D10;
    cw_target   := D17;
    phase := 1;
END_IF;

CASE phase OF

0: (* Idle - no request yet *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D20 := 0;
    D21 := 0;
    D22 := 0;

1: (* Moving both axes toward the latched targets, brake released *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    D20 := head_target;
    D21 := cw_target;
    D22 := 0;

    IF ABS(D11 - head_target) <= pos_tol AND ABS(D12) <= spd_tol AND
       ABS(D13 - cw_target)   <= pos_tol AND ABS(D14) <= spd_tol THEN
        phase := 2;
    END_IF;

2: (* Settled: engage the friction brake while still holding the head with torque *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    D20 := head_target;
    D21 := cw_target;
    D22 := 0;

    IF X11 THEN
        (* Brake is fully engaged: safe to release head torque now *)
        Y20 := FALSE;
        phase := 3;
    END_IF;

3: (* Holding: brake engaged, head torque released, balance drive may be maintained *)
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := TRUE;
    D20 := head_target;
    D21 := cw_target;
    D22 := 0;

    IF ABS(D11 - head_target) <= pos_tol AND ABS(D12) <= spd_tol AND
       ABS(D13 - cw_target)   <= pos_tol AND ABS(D14) <= spd_tol AND X11 THEN
        stable_timer(IN := TRUE, PT := T#30ms);
    ELSE
        stable_timer(IN := FALSE, PT := T#30ms);
    END_IF;

    IF stable_timer.Q THEN
        Y2 := TRUE;
    END_IF;

ELSE
    ;

END_CASE;

END_PROGRAM