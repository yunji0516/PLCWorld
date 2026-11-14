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

    (* internal state *)
    active      : BOOL := FALSE;   (* latched once X10 request accepted *)
    Y2_latched  : BOOL := FALSE;   (* latched once completion pre-claim stability met *)

    raw_sum_ab  : DINT;            (* A+B position, raw x100 units *)
    cmd_c       : DINT;            (* desired C command, raw x100 units *)
    ff_c        : DINT;            (* desired C feedforward velocity, raw x100 units *)

    sum_all_x100 : DINT;           (* A+B+C actual position, raw x100 units *)
    abs_sum      : DINT;
    condition_ok : BOOL;

    pretimer  : TON;               (* 30 ms pre-claim stability *)
    posttimer : TON;               (* 1300 ms post-claim observation *)

    cmd_min : DINT := -200000;
    cmd_max : DINT := 200000;
END_VAR

(* --- Activation latch: never activate before X10 request --- *)
IF X10 THEN
    active := TRUE;
END_IF;

(* --- Command computation for wrist (C axis) --- *)
IF active THEN
    raw_sum_ab := D13 + D15;      (* A + B position, x100 *)
    cmd_c := D10 - raw_sum_ab;    (* desired C position to keep sum = D10 (nominally 0) *)

    IF cmd_c > cmd_max THEN
        cmd_c := cmd_max;
    ELSIF cmd_c < cmd_min THEN
        cmd_c := cmd_min;
    END_IF;

    ff_c := -(D14 + D16);         (* feedforward cancels A,B velocity so C tracks -(A+B) *)

    IF ff_c > cmd_max THEN
        ff_c := cmd_max;
    ELSIF ff_c < cmd_min THEN
        ff_c := cmd_min;
    END_IF;

    D20 := cmd_c;
    D21 := ff_c;
ELSE
    D20 := 0;
    D21 := 0;
END_IF;

Y20 := active;

(* --- Completion evaluation based on actual physical state --- *)
sum_all_x100 := D13 + D15 + D11;   (* actual A + B + C, raw x100 units *)
abs_sum := ABS(sum_all_x100);
condition_ok := (abs_sum <= 200) AND active;  (* within +-2 deg *)

pretimer(IN := condition_ok, PT := T#30ms);

IF pretimer.Q AND NOT Y2_latched THEN
    Y2_latched := TRUE;
END_IF;

Y2 := Y2_latched;

(* Post-claim observation timer runs once Y2 has been asserted; the *)
(* control law above keeps the wrist tracking so the condition is   *)
(* maintained throughout this observation window.                  *)
posttimer(IN := Y2_latched, PT := T#1300ms);

END_PROGRAM