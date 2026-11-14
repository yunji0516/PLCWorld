PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    active     : BOOL := FALSE;
    target     : DINT := 0;
    err_abs    : DINT;
    speed_abs  : DINT;
    stable_cond: BOOL;
    stab_timer : TON;
    y2_latch   : BOOL := FALSE;
    cmd_min    : DINT := -200000;
    cmd_max    : DINT := 200000;
END_VAR

(* Accept request only once X10 is TRUE; latch target angle *)
IF NOT active AND X10 THEN
    active := TRUE;
    target := D10;
END_IF;

(* Publish command / activation only after acceptance *)
IF active THEN
    Y20 := TRUE;

    IF target > cmd_max THEN
        D20 := cmd_max;
    ELSIF target < cmd_min THEN
        D20 := cmd_min;
    ELSE
        D20 := target;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* Completion evaluation: angle error <=0.2 deg (<=20 raw), speed <=1 deg/s (<=100 raw) *)
err_abs   := ABS(D10 - D11);
speed_abs := ABS(D12);

stable_cond := active AND (err_abs <= 20) AND (speed_abs <= 100);

stab_timer(IN := stable_cond, PT := T#30ms);

IF stab_timer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM