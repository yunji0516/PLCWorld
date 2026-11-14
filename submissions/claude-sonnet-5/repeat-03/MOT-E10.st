PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    req_edge     : R_TRIG;
    req_latched  : BOOL;
    stable_timer : TON;
    cond         : BOOL;
    cmd          : DINT;
    cmd_min      : DINT := -200000;
    cmd_max      : DINT := 200000;
    err_limit    : DINT := 20;   (* 0.2 deg * 0.01 scale = 20 raw *)
    spd_limit    : DINT := 100;  (* 1 deg/s * 0.01 scale = 100 raw *)
END_VAR

(* Detect first acceptance of the function request *)
req_edge(CLK := X10);
IF req_edge.Q THEN
    req_latched := TRUE;
END_IF;

(* Activation / command output logic *)
IF req_latched THEN
    Y20 := TRUE;

    cmd := D10;
    IF cmd > cmd_max THEN
        cmd := cmd_max;
    ELSIF cmd < cmd_min THEN
        cmd := cmd_min;
    END_IF;

    D20 := cmd;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* Completion detection: angle error <=0.2 deg, speed <=1 deg/s *)
cond := (ABS(D10 - D11) <= err_limit) AND (ABS(D12) <= spd_limit);

stable_timer(IN := cond, PT := T#30ms);

IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM