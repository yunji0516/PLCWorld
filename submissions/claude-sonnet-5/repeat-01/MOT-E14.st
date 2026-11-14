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
    D20 : DINT;
    Y2  : BOOL;

    (* Internal state *)
    accepted   : BOOL := FALSE;
    captured   : BOOL := FALSE;
    x0         : REAL := 0.0;

    req_edge   : R_TRIG;

    (* scaled measurements *)
    x_pos      : REAL;
    x_vel      : REAL;
    theta      : REAL;
    theta_dot  : REAL;
    target     : REAL;
    e_pos      : REAL;

    (* control gains *)
    Kp : REAL := 10.0;
    Kd : REAL := 8.0;

    accel_cmd  : REAL;
    accel_lim  : REAL := 1800.0;
    cmd_raw    : DINT;
    cmd_max    : DINT := 200000;
    cmd_min    : DINT := -200000;

    (* completion tracking *)
    cond_ok       : BOOL := FALSE;
    stable_timer  : TON;
    y2_latch      : BOOL := FALSE;

END_VAR

(* ---- Edge detect the request acceptance ---- *)
req_edge(CLK := X10);

IF req_edge.Q AND NOT accepted THEN
    accepted := TRUE;
    x0 := DINT_TO_REAL_HELPER := 0.0; (* placeholder never used *)
END_IF;

END_PROGRAM