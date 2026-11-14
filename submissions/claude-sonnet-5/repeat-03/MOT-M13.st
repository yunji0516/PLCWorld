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
    D102 : DINT;
    D103 : DINT;
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

    (* internal *)
    started : BOOL := FALSE;
    state : INT := 0;

    a_arr_120 : BOOL;
    a_arr_100 : BOOL;
    a_arr_0   : BOOL;
    b_arr_ang : BOOL;
    b_arr_0   : BOOL;
    c_arr_tgt : BOOL;
    c_arr_0   : BOOL;
    d_arr_rcv : BOOL;
    d_arr_0   : BOOL;

    dock_cond : BOOL;
    dock_timer : TON;
    completion_latch : BOOL := FALSE;

    postol : DINT := 20;   (* 0.2 * 100 *)
    spdtol : DINT := 100;  (* 1 * 100 *)
END_VAR

(* latch that start has been requested at least once *)
started := started OR X0;

(* --- arrival checks (raw units, already *100) --- *)
a_arr_120 := (ABS(D10 - 12000) <= postol) AND (ABS(D11) <= spdtol);
a_arr_100 := (ABS(D10 - 10000) <= postol) AND (ABS(D11) <= spdtol);
a_arr_0   := (ABS(D10 - 0)     <= postol) AND (ABS(D11) <= spdtol);

b_arr_ang := (ABS(D12 - D101) <= postol) AND (ABS(D13) <= spdtol);
b_arr_0   := (ABS(D12 - 0)    <= postol) AND (ABS(D13) <= spdtol);

c_arr_tgt := (ABS(D14 - D102) <= postol) AND (ABS(D15) <= spdtol);
c_arr_0   := (ABS(D14 - 0)    <= postol) AND (ABS(D15) <= spdtol);

d_arr_rcv := (ABS(D16 - D103) <= postol) AND (ABS(D17) <= spdtol);
d_arr_0   := (ABS(D16 - 0)    <= postol) AND (ABS(D17) <= spdtol);

(* --- enable gating: never enable before start request --- *)
IF started THEN
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := TRUE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

(* --- sequencing state machine --- *)
CASE state OF

0: (* IDLE : prepare safe default targets, do not move *)
    D20 := 0;   D21 := 1000;
    D24 := 0;   D25 := 1000;
    D28 := 0;   D29 := 1000;
    D32 := 0;   D33 := 1000;
    IF started THEN
        state := 1;
    END_IF;

1: (* MOVE_AB : bring A to 120, B to angle, prep D toward receive, hold C near 0 *)
    D20 := 12000; D21 := 1000;
    D24 := D101;  D25 := 1000;
    D28 := 0;     D29 := 1000;
    D32 := D103;  D33 := 1000;
    IF a_arr_120 AND b_arr_ang THEN
        state := 2;
    END_IF;

2: (* MOVE_C : pass through opening to target, keep A,B, continue D prep *)
    D20 := 12000; D21 := 1000;
    D24 := D101;  D25 := 1000;
    D28 := D102;  D29 := 1000;
    D32 := D103;  D33 := 1000;
    IF a_arr_120 AND b_arr_ang AND c_arr_tgt AND d_arr_rcv THEN
        state := 3;
    END_IF;

3: (* DOCK : lower A to 100, hold B,C,D at receive *)
    D20 := 10000; D21 := 1000;
    D24 := D101;  D25 := 1000;
    D28 := D102;  D29 := 1000;
    D32 := D103;  D33 := 1000;

    dock_cond := a_arr_100 AND b_arr_ang AND c_arr_tgt AND d_arr_rcv;
    dock_timer(IN := dock_cond, PT := T#100ms);
    IF dock_timer.Q THEN
        completion_latch := TRUE;
        state := 4;
    END_IF;

4: (* RAISE_A : leave support, raise A back to 120, hold B,C,D *)
    D20 := 12000; D21 := 1000;
    D24 := D101;  D25 := 1000;
    D28 := D102;  D29 := 1000;
    D32 := D103;  D33 := 1000;
    IF a_arr_120 THEN
        state := 5;
    END_IF;

5: (* RETRACT_C : retract C to 0, keep A at 120, hold B,D *)
    D20 := 12000; D21 := 1000;
    D24 := D101;  D25 := 1000;
    D28 := 0;     D29 := 1000;
    D32 := D103;  D33 := 1000;
    IF c_arr_0 THEN
        state := 6;
    END_IF;

6: (* ZERO_ALL : bring A,B,D to 0 (C already 0) *)
    D20 := 0; D21 := 1000;
    D24 := 0; D25 := 1000;
    D28 := 0; D29 := 1000;
    D32 := 0; D33 := 1000;
    IF a_arr_0 AND b_arr_0 AND d_arr_0 THEN
        state := 7;
    END_IF;

7: (* DONE : hold all at zero *)
    D20 := 0; D21 := 1000;
    D24 := 0; D25 := 1000;
    D28 := 0; D29 := 1000;
    D32 := 0; D33 := 1000;

ELSE
    state := 0;

END_CASE;

Y2 := completion_latch;

END_PROGRAM