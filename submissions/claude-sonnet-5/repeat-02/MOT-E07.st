PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    request_accepted : BOOL := FALSE;
    d20_cmd : DINT := 0;
    ratio_r : REAL := 0.0;
    velS : REAL := 0.0;
    velU : REAL := 0.0;
    velErr : REAL := 0.0;
    phaseErr : REAL := 0.0;
    stable_timer : TON;
    cmd_max : DINT := 200000;
    cmd_min : DINT := -200000;
END_VAR

(* Latch the request once X10 is observed true *)
IF X10 THEN
    request_accepted := TRUE;
END_IF;

(* Activate the synchronization function only after request acceptance *)
IF request_accepted THEN
    Y20 := TRUE;
    d20_cmd := D10;
ELSE
    Y20 := FALSE;
    d20_cmd := 0;
END_IF;

(* Clamp the gear ratio command to permitted raw bounds *)
IF d20_cmd > cmd_max THEN
    d20_cmd := cmd_max;
ELSIF d20_cmd < cmd_min THEN
    d20_cmd := cmd_min;
END_IF;

D20 := d20_cmd;

(* Compute physical quantities for completion check *)
velS := INT_TO_REAL(D12) * 0.01;
velU := INT_TO_REAL(D14) * 0.01;
ratio_r := INT_TO_REAL(D10) * 0.001;
velErr := ABS(velS - ratio_r * velU);
phaseErr := ABS(INT_TO_REAL(D17) * 0.01);

(* Stability timer: requires request active and both errors within limits *)
stable_timer(IN := request_accepted AND (phaseErr <= 0.3) AND (velErr <= 2.0), PT := T#30ms);

(* Once stability has been maintained for 30 ms, latch the result flag TRUE *)
IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM