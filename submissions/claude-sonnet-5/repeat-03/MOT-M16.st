PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    step            : INT := 0;
    started         : BOOL := FALSE;
    baseline_count  : DINT := 0;

    POS_TOL         : DINT := 20;   (* 0.2 mm * 100 *)
    SPD_TOL         : DINT := 100;  (* 1 mm/s * 100 *)

    a_arrived_target : BOOL;
    b_arrived_depth  : BOOL;
    a_arrived_target2 : BOOL;
    b_arrived_zero    : BOOL;
END_VAR

(* -------- Safety: never enable before X0 request -------- *)
IF X0 THEN
    started := TRUE;
END_IF;

(* -------- Prepare targets (allowed even while disabled) -------- *)
D20 := D101;   (* A axis target = requested target, always *)
D21 := 1000;   (* full rate *)
D25 := 1000;   (* full rate *)

IF step >= 5 THEN
    D24 := 0;      (* retract B to zero after module round trip confirmed *)
ELSE
    D24 := D102;   (* hold B at requested depth while establishing / holding pose *)
END_IF;

(* -------- Enable axes only after start approval -------- *)
Y20 := started;
Y21 := started;

(* -------- Default: no request pulse unless explicitly triggered this scan -------- *)
Y30 := FALSE;

(* -------- Arrival checks -------- *)
a_arrived_target := (ABS(D10 - D101) <= POS_TOL) AND (ABS(D11) <= SPD_TOL);
b_arrived_depth  := (ABS(D12 - D102) <= POS_TOL) AND (ABS(D13) <= SPD_TOL);
b_arrived_zero   := (ABS(D12 - 0) <= POS_TOL) AND (ABS(D13) <= SPD_TOL);

CASE step OF

0: (* Waiting for start approval *)
    IF started THEN
        step := 1;
    END_IF;

1: (* Moving to the disclosed access pose : A at target, B at depth *)
    IF a_arrived_target AND b_arrived_depth THEN
        step := 2;
    END_IF;

2: (* Pose established; request module only when idle *)
    IF (NOT X34) AND a_arrived_target AND b_arrived_depth THEN
        baseline_count := D95;
        Y30 := TRUE;   (* rising-edge request pulse this scan *)
        step := 3;
    END_IF;

3: (* Request has been issued; wait for the operation to physically finish *)
    (* preserve pose; do nothing else this scan besides transition *)
    step := 4;

4: (* Waiting for confirmed completion of this module round trip *)
    IF X35 AND (D95 > baseline_count) THEN
        step := 5;
    END_IF;

5: (* Retract B to zero while keeping A at target *)
    IF a_arrived_target AND b_arrived_zero THEN
        step := 6;
    END_IF;

6: (* Final completion : A = target, B = 0 ; maintain *)
    ; (* nothing further to do, hold state *)

ELSE
    step := 0;

END_CASE;

(* -------- Completion output -------- *)
Y2 := (step = 6);

END_PROGRAM