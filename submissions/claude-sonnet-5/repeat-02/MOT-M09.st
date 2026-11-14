PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    state       : INT := 0;
    started     : BOOL := FALSE;

    (* Scaled fixed targets (position * 100) *)
    A_LOCK      : DINT := 10000; (* 100 mm *)
    BC_LOCK     : DINT := 6000;  (* 60 mm *)
    ZERO_TGT    : DINT := 0;
    D_SAFE_LIM  : DINT := 500;   (* 5 mm * 100 : below this D is considered "retracted enough" *)

    POS_TOL     : DINT := 20;    (* 0.2 mm * 100 *)
    VEL_TOL     : DINT := 100;   (* 1 mm/s * 100 *)

    (* Arrival flags *)
    arr_a_lock  : BOOL;
    arr_bc_lock : BOOL;
    arr_d_depth : BOOL;
    arr_bc_zero : BOOL;
    arr_a_zero  : BOOL;
    all_zero_ok : BOOL;

    ton_hold    : TON;
    y2_latch    : BOOL := FALSE;
END_VAR

(* ---- Arrival evaluations ---- *)
arr_a_lock  := (ABS(D10 - A_LOCK) <= POS_TOL) AND (ABS(D11) <= VEL_TOL);
arr_bc_lock := (ABS(D12 - BC_LOCK) <= POS_TOL) AND (ABS(D13) <= VEL_TOL)
           AND (ABS(D14 - BC_LOCK) <= POS_TOL) AND (ABS(D15) <= VEL_TOL);
arr_d_depth := (ABS(D16 - D101) <= POS_TOL) AND (ABS(D17) <= VEL_TOL);
arr_bc_zero := (ABS(D12 - ZERO_TGT) <= POS_TOL) AND (ABS(D13) <= VEL_TOL)
           AND (ABS(D14 - ZERO_TGT) <= POS_TOL) AND (ABS(D15) <= VEL_TOL);
arr_a_zero  := (ABS(D10 - ZERO_TGT) <= POS_TOL) AND (ABS(D11) <= VEL_TOL);

all_zero_ok := arr_a_zero AND arr_bc_zero
           AND (ABS(D16 - ZERO_TGT) <= POS_TOL) AND (ABS(D17) <= VEL_TOL);

(* ---- Latch start approval ---- *)
IF X0 THEN
    started := TRUE;
END_IF;

(* ---- Default / preparing outputs (safe values, may be overwritten below) ---- *)
D21 := 1000;
D25 := 1000;
D29 := 1000;
D33 := 1000;

CASE state OF

0: (* IDLE : wait for start, enables OFF, may prepare targets *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    D20 := A_LOCK;
    D24 := BC_LOCK;
    D28 := BC_LOCK;
    D32 := D101;

    IF started THEN
        state := 1;
    END_IF;

1: (* Move A to locked posture *)
    Y20 := TRUE;
    D20 := A_LOCK;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    D24 := BC_LOCK;
    D28 := BC_LOCK;
    D32 := D101;

    IF arr_a_lock THEN
        state := 2;
    END_IF;

2: (* Move B and C in to lock, keep A locked *)
    Y20 := TRUE;
    D20 := A_LOCK;
    Y21 := TRUE;
    D24 := BC_LOCK;
    Y22 := TRUE;
    D28 := BC_LOCK;
    Y23 := FALSE;
    D32 := D101;

    IF arr_bc_lock THEN
        state := 3;
    END_IF;

3: (* Move D in to depth, keep A/B/C locked *)
    Y20 := TRUE;
    D20 := A_LOCK;
    Y21 := TRUE;
    D24 := BC_LOCK;
    Y22 := TRUE;
    D28 := BC_LOCK;
    Y23 := TRUE;
    D32 := D101;

    IF arr_d_depth THEN
        state := 4;
    END_IF;

4: (* Internal access reached; retract D while keeping A/B/C locked (D>5 requires lock kept) *)
    Y20 := TRUE;
    D20 := A_LOCK;
    Y21 := TRUE;
    D24 := BC_LOCK;
    Y22 := TRUE;
    D28 := BC_LOCK;
    Y23 := TRUE;
    D32 := ZERO_TGT;

    IF D16 <= D_SAFE_LIM THEN
        state := 5;
    END_IF;

5: (* D retracted enough; retract B and C, keep A locked *)
    Y20 := TRUE;
    D20 := A_LOCK;
    Y21 := TRUE;
    D24 := ZERO_TGT;
    Y22 := TRUE;
    D28 := ZERO_TGT;
    Y23 := TRUE;
    D32 := ZERO_TGT;

    IF arr_bc_zero THEN
        state := 6;
    END_IF;

6: (* Retract A to origin *)
    Y20 := TRUE;
    D20 := ZERO_TGT;
    Y21 := TRUE;
    D24 := ZERO_TGT;
    Y22 := TRUE;
    D28 := ZERO_TGT;
    Y23 := TRUE;
    D32 := ZERO_TGT;

    IF arr_a_zero THEN
        state := 7;
    END_IF;

7: (* All axes retracted to origin; disable actuators (except completion) *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    D20 := ZERO_TGT;
    D24 := ZERO_TGT;
    D28 := ZERO_TGT;
    D32 := ZERO_TGT;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

END_CASE;

(* ---- Completion assertion: hold all-zero condition for 100 ms, then latch Y2 ---- *)
ton_hold(IN := all_zero_ok, PT := T#100ms);

IF ton_hold.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM