PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal state machines *)
    state_transfer : INT := 0;
    state_form     : INT := 0;
    bundle_count   : INT := 0;

    (* helper flags *)
    gripper_moving   : BOOL;
    target_reached   : BOOL;
    swap_needed      : BOOL;
    apply_ok         : BOOL;
    cut_cond         : BOOL;
    wrap_cond        : BOOL;
    index_cond       : BOOL;
    swap_active      : BOOL := FALSE;

    (* timers / edges *)
    cut_timer  : TON;
    tape_timer : TON;
    idx_trig   : R_TRIG;
END_VAR

(* ---------------- default output reset (recomputed every scan) ---------------- *)
Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;

(* ---------------- shared conditions ---------------- *)
gripper_moving := X15 OR (state_transfer = 0) OR (state_transfer = 2) OR (state_transfer = 11) OR (state_transfer = 13);
target_reached := (D4 >= D3) AND (D4 <= D3 + 4);
swap_needed    := (NOT X1C) AND X1E;
apply_ok       := (D5 = D0) AND target_reached AND X19 AND X20;

(* ================= FORMING STATION ================= *)

(* stop plate & unit feed *)
Y1D := X25;
Y1C := X25 AND X28 AND (NOT gripper_moving) AND (NOT Y23);

(* alignment plates *)
Y1F := (D9 >= D3) AND (NOT X2A);

(* index request: item at entry, capacity available, plates released, not busy, no other movement *)
index_cond := (NOT X28) AND (D9 < D3) AND (NOT Y1F) AND (NOT X27) AND (NOT gripper_moving) AND (NOT Y23);
idx_trig(CLK := index_cond);
Y1E := idx_trig.Q;

CASE state_form OF

0: (* wait for alignment *)
    IF X29 THEN
        state_form := 1;
    END_IF;

1: (* close forming grip *)
    Y20 := TRUE;
    IF X2A THEN
        state_form := 2;
    END_IF;

2: (* lift forming head *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF X2C THEN
        state_form := 3;
    END_IF;

3: (* move to supply, only if supply transfer space is free *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF X30 THEN
        Y22 := TRUE;
    END_IF;
    IF X2F THEN
        state_form := 4;
    END_IF;

4: (* lower at supply *)
    Y20 := TRUE;
    Y22 := TRUE;
    IF X2D THEN
        state_form := 5;
    END_IF;

5: (* open grip to release bundle to supply *)
    Y22 := TRUE;
    Y20 := FALSE;
    IF X2B THEN
        state_form := 6;
    END_IF;

6: (* return to table *)
    Y22 := FALSE;
    IF X2E THEN
        state_form := 0;
    END_IF;

ELSE
    state_form := 0;
END_CASE;

(* supply belt advance: only when both heads risen, feed clear, no conflicting movement, no index in progress *)
Y23 := X32 AND X2C AND (NOT X2D) AND (NOT Y24) AND (NOT gripper_moving) AND (NOT Y1E);

(* transfer head at supply lowers after source_ready & at pickup *)
Y24 := X10 AND X33;

(* ================= TRANSFER / WRAP / TAPE / CUT / EXIT ================= *)

CASE state_transfer OF

0: (* travel to source pickup *)
    Y13 := TRUE;
    IF X12 AND X10 AND X11 THEN
        state_transfer := 1;
    END_IF;

1: (* grip bundle at source *)
    Y13 := TRUE;
    Y10 := TRUE;
    IF X16 AND (NOT X17) THEN
        state_transfer := 2;
    END_IF;

2: (* deliver to wrap chuck *)
    Y14 := TRUE;
    Y10 := TRUE;
    IF X13 AND X11 THEN
        state_transfer := 3;
    END_IF;

3: (* chuck clamps bundle before releasing gripper *)
    Y14 := TRUE;
    Y10 := TRUE;
    Y11 := TRUE;
    IF X19 THEN
        state_transfer := 4;
    END_IF;

4: (* release gripper only after chuck confirmed clamped *)
    Y14 := TRUE;
    Y11 := TRUE;
    Y10 := FALSE;
    IF X17 THEN
        state_transfer := 5;
    END_IF;

5: (* retract gripper clear of rotation area, engage film holder *)
    Y11 := TRUE;
    Y12 := TRUE;
    IF X18 THEN
        state_transfer := 6;
    END_IF;

6: (* wrapping *)
    Y11 := TRUE;
    Y12 := TRUE;
    wrap_cond := X19 AND X1B AND X18 AND X1C AND (NOT X1D) AND (D4 < D3);
    Y16 := wrap_cond;
    IF D4 >= D3 THEN
        Y16 := FALSE;
        state_transfer := 7;
    END_IF;

7: (* reel exchange / splice request if needed *)
    Y11 := TRUE;
    Y12 := TRUE;
    IF swap_needed THEN
        Y17 := TRUE;
        IF X1D THEN
            swap_active := TRUE;
        END_IF;
        IF swap_active AND (NOT X1D) THEN
            Y17 := FALSE;
            swap_active := FALSE;
            state_transfer := 8;
        END_IF;
    ELSE
        Y17 := FALSE;
        state_transfer := 8;
    END_IF;

8: (* prepare tape of arrived order *)
    Y11 := TRUE;
    Y12 := TRUE;
    D200 := D6;
    Y18 := TRUE;
    IF X20 THEN
        Y18 := FALSE;
        state_transfer := 9;
    END_IF;

9: (* apply tape *)
    Y11 := TRUE;
    Y12 := TRUE;
    IF apply_ok THEN
        Y19 := TRUE;
        tape_timer(IN := TRUE, PT := T#800ms);
    ELSE
        Y19 := FALSE;
        tape_timer(IN := FALSE, PT := T#800ms);
    END_IF;
    IF X21 THEN
        Y19 := FALSE;
        state_transfer := 10;
    END_IF;

10: (* cut film *)
    Y11 := TRUE;
    Y12 := TRUE;
    cut_cond := X19 AND X1B AND target_reached AND X21 AND (NOT Y16);
    IF cut_cond THEN
        Y1A := TRUE;
        cut_timer(IN := TRUE, PT := T#800ms);
    ELSE
        Y1A := FALSE;
        cut_timer(IN := FALSE, PT := T#800ms);
    END_IF;
    IF cut_timer.Q AND X22 THEN
        Y1A := FALSE;
        state_transfer := 11;
    END_IF;

11: (* re-grip wrapped bundle while chuck still clamping *)
    Y11 := TRUE;
    Y12 := TRUE;
    Y14 := TRUE;
    IF X13 AND X19 THEN
        Y10 := TRUE;
        IF X16 THEN
            state_transfer := 12;
        END_IF;
    END_IF;

12: (* release chuck only after gripper holds and film separated *)
    Y10 := TRUE;
    Y14 := TRUE;
    Y11 := FALSE;
    IF X1A AND X22 AND X23 THEN
        state_transfer := 13;
    END_IF;

13: (* travel to exit *)
    Y10 := TRUE;
    Y15 := TRUE;
    IF X14 THEN
        state_transfer := 14;
    END_IF;

14: (* place bundle at exit *)
    Y15 := TRUE;
    Y10 := FALSE;
    IF X17 THEN
        Y15 := FALSE;
        bundle_count := bundle_count + 1;
        IF bundle_count >= 3 THEN
            state_transfer := 16;
        ELSE
            state_transfer := 0;
        END_IF;
    END_IF;

16: (* all bundles processed and delivered *)
    Y1B := TRUE;
    Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
    Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;

ELSE
    state_transfer := 0;
END_CASE;

END_PROGRAM