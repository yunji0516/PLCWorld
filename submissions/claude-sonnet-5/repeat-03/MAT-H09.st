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

    (* ---- internal state ---- *)
    aState : INT := 0;
    bState : INT := 0;
    a_count : INT := 0;
    b_count : INT := 0;

    tank_low_margin : INT := 20; (* 2.0 mL in 0.1 mL units, guard against depletion *)

    desire_a : BOOL;
    desire_b : BOOL;

    capA_trig : R_TRIG;
    capB_trig : R_TRIG;
    swap_trig : R_TRIG;

    swap_desire : BOOL;

    completion_ready : BOOL;
    complete_timer : TON;
    done_latch : BOOL := FALSE;
END_VAR

(* =========================================================
   TANK / BATCH / SWAP MANAGEMENT
   ========================================================= *)

(* Refill only from a ready batch, never overfilling the tank,
   never running while swapping. *)
IF X2F AND (D1 > 0) AND (D0 < 1600) AND NOT X30 THEN
    Y10 := TRUE;
ELSE
    Y10 := FALSE;
END_IF;

(* Swap only when the current batch is fully empty, no refill
   in progress, swap idle, and another batch is available. *)
swap_desire := (NOT X2F) AND (D1 <= 0) AND X31 AND (NOT Y10) AND (NOT X30);
swap_trig(CLK := swap_desire);
Y11 := swap_trig.Q;

(* =========================================================
   LINE A SEQUENCER
   States:
   0 idle / wait start
   1 feeding front container to station
   2 clamping
   3 lowering nozzle (down)
   4 opening valve
   5 filling (pump running)
   6 closing valve
   7 raising nozzle (up)
   8 releasing clamp
   9 sending to cap-wait position
   10 waiting for capping to finish
   11 releasing capped container to exit
   12 line done (3 containers processed)
   ========================================================= *)

CASE aState OF
    0:
        IF X0 THEN
            aState := 1;
        END_IF;
    1:
        IF X10 THEN
            aState := 2;
        END_IF;
    2:
        IF X14 THEN
            aState := 3;
        END_IF;
    3:
        IF X13 THEN
            aState := 4;
        END_IF;
    4:
        IF X16 THEN
            aState := 5;
        END_IF;
    5:
        IF D4 >= D5 THEN
            aState := 6;
        END_IF;
    6:
        IF X17 THEN
            aState := 7;
        END_IF;
    7:
        IF X12 THEN
            aState := 8;
        END_IF;
    8:
        IF NOT X14 THEN
            aState := 9;
        END_IF;
    9:
        IF X1A THEN
            aState := 10;
        END_IF;
    10:
        IF X1B THEN
            aState := 11;
        END_IF;
    11:
        IF NOT X1B THEN
            a_count := a_count + 1;
            IF a_count < 3 THEN
                aState := 1;
            ELSE
                aState := 12;
            END_IF;
        END_IF;
    12:
        ; (* line finished, remain idle *)
    ELSE
        aState := 0;
END_CASE;

(* Combinational outputs for line A, derived purely from state
   so that no stale ON condition survives a state change. *)
Y14 := (aState = 1) AND (NOT X10) AND X11;
Y15 := (aState >= 2) AND (aState <= 7);
Y16 := (aState >= 3) AND (aState <= 6);
Y17 := (aState = 4) OR (aState = 5);
Y18 := (aState = 5) AND (D4 < D5) AND (D0 > tank_low_margin);
Y19 := (aState = 9) AND (NOT X1A);
Y1A := (aState = 11) AND (NOT X19);

(* =========================================================
   LINE B SEQUENCER (mirrors line A)
   ========================================================= *)

CASE bState OF
    0:
        IF X0 THEN
            bState := 1;
        END_IF;
    1:
        IF X1E THEN
            bState := 2;
        END_IF;
    2:
        IF X22 THEN
            bState := 3;
        END_IF;
    3:
        IF X21 THEN
            bState := 4;
        END_IF;
    4:
        IF X24 THEN
            bState := 5;
        END_IF;
    5:
        IF D9 >= D10 THEN
            bState := 6;
        END_IF;
    6:
        IF X25 THEN
            bState := 7;
        END_IF;
    7:
        IF X20 THEN
            bState := 8;
        END_IF;
    8:
        IF NOT X22 THEN
            bState := 9;
        END_IF;
    9:
        IF X28 THEN
            bState := 10;
        END_IF;
    10:
        IF X29 THEN
            bState := 11;
        END_IF;
    11:
        IF NOT X29 THEN
            b_count := b_count + 1;
            IF b_count < 3 THEN
                bState := 1;
            ELSE
                bState := 12;
            END_IF;
        END_IF;
    12:
        ; (* line finished, remain idle *)
    ELSE
        bState := 0;
END_CASE;

Y1B := (bState = 1) AND (NOT X1E) AND X1F;
Y1C := (bState >= 2) AND (bState <= 7);
Y1D := (bState >= 3) AND (bState <= 6);
Y1E := (bState = 4) OR (bState = 5);
Y1F := (bState = 5) AND (D9 < D10) AND (D0 > tank_low_margin);
Y20 := (bState = 9) AND (NOT X28);
Y21 := (bState = 11) AND (NOT X27);

(* =========================================================
   SHARED CAPPING HEAD ARBITRATION
   Priority given to line A when both request simultaneously.
   ========================================================= *)

desire_a := X1A AND (NOT X1B) AND (NOT X2C);
desire_b := X28 AND (NOT X29) AND (NOT X2C) AND (NOT desire_a);

capA_trig(CLK := desire_a);
capB_trig(CLK := desire_b);

Y12 := capA_trig.Q;
Y13 := capB_trig.Q;

(* =========================================================
   COMPLETION
   ========================================================= *)

completion_ready := X32
    AND (NOT Y18) AND (NOT Y1F)
    AND (NOT Y10)
    AND (NOT Y17) AND (NOT Y1E)
    AND (NOT Y16) AND (NOT Y1D)
    AND X12 AND X20
    AND (NOT Y11) AND (NOT X30)
    AND (NOT X2C) AND (NOT Y12) AND (NOT Y13);

complete_timer(IN := completion_ready, PT := T#500ms);

IF complete_timer.Q THEN
    done_latch := TRUE;
END_IF;

Y22 := done_latch;

END_PROGRAM