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
    request_accepted : BOOL := FALSE;
    error_ok         : BOOL := FALSE;
    y2_latch         : BOOL := FALSE;
    done_flag        : BOOL := FALSE;
    speed_err        : DINT := 0;
    err_limit_raw    : DINT := 200; (* 2 deg/s * 100 scale *)

    stable_timer : TON;
    hold_timer   : TON;
END_VAR

(* --- Request acceptance latch: do not activate drive before this --- *)
IF NOT request_accepted AND X10 THEN
    request_accepted := TRUE;
END_IF;

(* --- Drive activation and command output --- *)
IF request_accepted THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* --- Speed error evaluation (only meaningful while active) --- *)
speed_err := D12 - D10;
IF speed_err < 0 THEN
    speed_err := -speed_err;
END_IF;

error_ok := request_accepted AND (speed_err <= err_limit_raw);

(* --- Stability timer: error must hold for 30 ms --- *)
stable_timer(IN := error_ok, PT := T#30ms);

IF stable_timer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

(* --- Post-claim maintenance hold: 250 ms observation after Y2 asserted --- *)
hold_timer(IN := (y2_latch AND error_ok), PT := T#250ms);

IF hold_timer.Q THEN
    done_flag := TRUE;
END_IF;

END_PROGRAM