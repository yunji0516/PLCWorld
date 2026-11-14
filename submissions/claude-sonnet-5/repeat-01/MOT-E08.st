PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    req_trig     : R_TRIG;
    active       : BOOL := FALSE;
    stable_timer : TON;
    maintain_timer : TON;
    pos_err      : DINT;
    vel_err      : DINT;
    error_ok     : BOOL;
    cmd_pos      : DINT;
    cmd_vel      : DINT;
    pos_tol      : DINT := 30;   (* 0.3 mm * 100 *)
    vel_tol      : DINT := 200;  (* 2 mm/s * 100 *)
    cmd_min      : DINT := -200000;
    cmd_max      : DINT := 200000;
END_VAR

(* Latch activation on first accepted request *)
req_trig(CLK := X10);
IF req_trig.Q THEN
    active := TRUE;
END_IF;

IF active THEN
    Y20 := TRUE;

    (* Command: position target = master(U) position + requested interval,
       feedforward velocity = master(U) velocity *)
    cmd_pos := D13 + D10;
    cmd_vel := D14;

    D20 := LIMIT(cmd_min, cmd_pos, cmd_max);
    D21 := LIMIT(cmd_min, cmd_vel, cmd_max);

    (* Following error: controlled axis (S) vs. target *)
    pos_err := D11 - (D13 + D10);
    vel_err := D12 - D14;

    error_ok := (ABS(pos_err) <= pos_tol) AND (ABS(vel_err) <= vel_tol);
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    error_ok := FALSE;
END_IF;

(* Require the error condition to hold continuously for 30 ms *)
stable_timer(IN := active AND error_ok, PT := T#30ms);
IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

(* Post-claim maintenance / observation window tracking *)
maintain_timer(IN := Y2, PT := T#250ms);

END_PROGRAM