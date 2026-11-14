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
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    stability_timer : TON;
    wrist_target : DINT;
    wrist_ff : DINT;
    sum_raw : DINT;
    stable : BOOL;
END_VAR

(* Compute sum of all three joint positions in raw units (deg x0.01) *)
sum_raw := D13 + D15 + D11;

(* Stability: |A + B + C| <= 200 raw units corresponds to +/- 2 degrees *)
stable := (ABS(sum_raw) <= 200);

(* Accumulate stability time using TON; resets when sum exits band *)
stability_timer(IN := stable, PT := T#30ms);

(* Compute wrist position target to maintain A + B + C = 0: C = -(A + B) *)
wrist_target := -(D13 + D15);

(* Clamp wrist position command to permitted range [-200000, 200000] *)
IF wrist_target > 200000 THEN
    wrist_target := 200000;
ELSIF wrist_target < -200000 THEN
    wrist_target := -200000;
END_IF;

(* Compute wrist feedforward velocity: -(shoulder velocity + elbow velocity) *)
wrist_ff := -(D14 + D16);

(* Clamp wrist feedforward command to permitted range [-200000, 200000] *)
IF wrist_ff > 200000 THEN
    wrist_ff := 200000;
ELSIF wrist_ff < -200000 THEN
    wrist_ff := -200000;
END_IF;

(* Activate function only after X10 request is accepted *)
IF X10 THEN
    Y20 := TRUE;
    (* Issue wrist commands to maintain tool orientation at 0 *)
    D20 := wrist_target;
    D21 := wrist_ff;
ELSE
    Y20 := FALSE;
END_IF;

(* Assert Y2 after 30ms pre-claim stability, then maintain through 1300ms observation *)
IF stability_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM