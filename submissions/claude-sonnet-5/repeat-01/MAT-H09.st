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
    D12 : INT;
    D13 : INT;
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

    (* internal state machines for line A / line B container handling *)
    a_state : INT := 0;
    b_state : INT := 0;

    (* swap / capping edge latches *)
    swap_trig   : R_TRIG;
    cap_a_trig  : R_TRIG;
    cap_b_trig  : R_TRIG;
    swap_latch  : BOOL := FALSE;
    cap_a_latch : BOOL := FALSE;
    cap_b_latch : BOOL := FALSE;

    (* release latches *)
    a_release_latch : BOOL := FALSE;
    b_release_latch : BOOL := FALSE;

    (* completion tracking *)
    all_cond      : BOOL := FALSE;
    complete_timer: TON;
    complete_latch: BOOL := FALSE;

    (* condition helpers *)
    swap_cond  : BOOL;
    cap_a_cond : BOOL;
    cap_b_cond : BOOL;
    rel_a_cond : BOOL;
    rel_b_cond : BOOL;

END_VAR

(* ================= Tank / Refill management ================= *)
(* refill only allowed with an actual batch present, and stop before overflow *)
Y10 := X2F AND (D0 < 1600) AND (NOT X30);

(* ================= Batch swap arbitration ================= *)
swap_cond := (D0 <= 0) AND (NOT X2F) AND (NOT Y10) AND X31 AND (NOT X30);
swap_trig(CLK := swap_cond);
IF swap_trig.Q THEN
    swap_latch := TRUE;
END_IF;
IF X30 THEN
    swap_latch := FALSE;
END_IF;
Y11 := swap_latch;

(* ================= Capping head arbitration ================= *)
cap_a_cond := X1A AND (NOT X1B) AND (NOT X2C);
cap_b_cond := X28 AND (NOT X29) AND (NOT X2C) AND (NOT cap_a_cond);

cap_a_trig(CLK := cap_a_cond);
IF cap_a_trig.Q THEN
    cap_a_latch := TRUE;
END_IF;
IF X2C THEN
    cap_a_latch := FALSE;
END_IF;
Y12 := cap_a_latch;

cap_b_trig(CLK := cap_b_cond);
IF cap_b_trig.Q THEN
    cap_b_latch := TRUE;
END_IF;
IF X2C THEN
    cap_b_latch := FALSE;
END_IF;
Y13 := cap_b_latch;

(* ================= Release arbitration (only capped, exit not full) ============ *)
rel_a_cond := X1B AND (NOT X19);
IF rel_a_cond THEN
    a_release_latch := TRUE;
END_IF;
IF X1D THEN
    a_release_latch := FALSE;
END_IF;
Y1A := a_release_latch;

rel_b_cond := X29 AND (NOT X27);
IF rel_b_cond THEN
    b_release_latch := TRUE;
END_IF;
IF X2B THEN
    b_release_latch := FALSE;
END_IF;
Y21 := b_release_latch;

(* ================= Line A container sequence ================= *)
CASE a_state OF
    0: (* IDLE - request feed if station empty, source ready, line not empty *)
        Y14 := FALSE;
        IF (NOT X10) AND X11 AND (NOT X18) THEN
            a_state := 1;
        END_IF;

    1: (* FEEDING *)
        Y14 := TRUE;
        IF X10 THEN
            Y14 := FALSE;
            a_state := 2;
        END_IF;

    2: (* CLAMP *)
        Y15 := TRUE;
        IF X14 THEN
            a_state := 3;
        END_IF;

    3: (* DOWN *)
        Y16 := TRUE;
        IF X13 THEN
            a_state := 4;
        END_IF;

    4: (* VALVE OPEN WAIT then start pump *)
        Y17 := TRUE;
        IF X16 THEN
            a_state := 5;
        END_IF;

    5: (* FILLING - pump handled below via state check *)
        IF D4 >= D5 THEN
            Y17 := FALSE;
            a_state := 6;
        END_IF;

    6: (* WAIT VALVE CLOSED *)
        IF X17 THEN
            a_state := 7;
        END_IF;

    7: (* UP *)
        Y16 := FALSE;
        IF X12 THEN
            a_state := 8;
        END_IF;

    8: (* CLAMP RELEASE *)
        Y15 := FALSE;
        IF NOT X14 THEN
            a_state := 9;
        END_IF;

    9: (* SEND TO CAP WAIT *)
        IF NOT X1A THEN
            Y19 := TRUE;
        ELSE
            Y19 := FALSE;
            a_state := 10;
        END_IF;

    10: (* LOOP BACK FOR NEXT CONTAINER *)
        Y19 := FALSE;
        a_state := 0;

    ELSE
        a_state := 0;
END_CASE;

(* pump A only runs while filling and tank has liquid to avoid depletion *)
Y18 := (a_state = 5) AND (D0 > 0);

(* ================= Line B container sequence ================= *)
CASE b_state OF
    0: (* IDLE *)
        Y1B := FALSE;
        IF (NOT X1E) AND X1F AND (NOT X26) THEN
            b_state := 1;
        END_IF;

    1: (* FEEDING *)
        Y1B := TRUE;
        IF X1E THEN
            Y1B := FALSE;
            b_state := 2;
        END_IF;

    2: (* CLAMP *)
        Y1C := TRUE;
        IF X22 THEN
            b_state := 3;
        END_IF;

    3: (* DOWN *)
        Y1D := TRUE;
        IF X21 THEN
            b_state := 4;
        END_IF;

    4: (* VALVE OPEN WAIT *)
        Y1E := TRUE;
        IF X24 THEN
            b_state := 5;
        END_IF;

    5: (* FILLING *)
        IF D9 >= D10 THEN
            Y1E := FALSE;
            b_state := 6;
        END_IF;

    6: (* WAIT VALVE CLOSED *)
        IF X25 THEN
            b_state := 7;
        END_IF;

    7: (* UP *)
        Y1D := FALSE;
        IF X20 THEN
            b_state := 8;
        END_IF;

    8: (* CLAMP RELEASE *)
        Y1C := FALSE;
        IF NOT X22 THEN
            b_state := 9;
        END_IF;

    9: (* SEND TO CAP WAIT *)
        IF NOT X28 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
            b_state := 10;
        END_IF;

    10: (* LOOP BACK *)
        Y20 := FALSE;
        b_state := 0;

    ELSE
        b_state := 0;
END_CASE;

Y1F := (b_state = 5) AND (D0 > 0);

(* ================= Completion evaluation ================= *)
all_cond := (D3 = 6)
            AND X17 AND X25          (* both valves closed *)
            AND X12 AND X20          (* both nozzles at top *)
            AND (NOT X2C)            (* capping head stopped *)
            AND (NOT X30)            (* no exchange in progress *)
            AND (NOT Y10)            (* replenishment stopped *)
            AND (NOT Y18) AND (NOT Y1F); (* pumps stopped *)

complete_timer(IN := all_cond, PT := T#500ms);

IF complete_timer.Q THEN
    complete_latch := TRUE;
END_IF;

Y22 := complete_latch;

END_PROGRAM