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

    (* Internal state / helper variables *)
    start_latch    : BOOL := FALSE;
    startTrig      : R_TRIG;

    form_state     : INT := 0;
    transfer_state : INT := 0;
    wrap_state     : INT := 0;

    bundles_done   : INT := 0;
    need_swap      : BOOL := FALSE;
    swapBusyPrevVal: BOOL := FALSE;

    cut_tmr        : TON;
    tape_tmr       : TON;
    prep_tmr       : TON;
    complete_tmr   : TON;

    complete_done  : BOOL := FALSE;
    comp_cond      : BOOL := FALSE;
END_VAR

(* ---------------- start latch ---------------- *)
startTrig(CLK := X0);
IF startTrig.Q THEN
    start_latch := TRUE;
END_IF;

(* ---------------- FORMING STATION FSM ---------------- *)
IF start_latch THEN
    CASE form_state OF

    0: (* FEED_INDEX *)
        Y1D := X25;
        Y1C := X25 AND X28;
        Y1F := FALSE;
        IF (D9 < D10) AND X28 AND NOT X27 THEN
            Y1E := TRUE;
        ELSE
            Y1E := FALSE;
        END_IF;
        IF D9 >= D10 THEN
            form_state := 1;
        END_IF;

    1: (* ALIGN_WAIT *)
        Y1E := FALSE;
        Y1C := FALSE;
        Y1D := X25;
        Y1F := TRUE;
        IF X29 THEN
            form_state := 2;
        END_IF;

    2: (* GRIP *)
        Y20 := TRUE;
        IF X2A AND X2D AND X2E AND X29 THEN
            form_state := 3;
        END_IF;

    3: (* LIFT *)
        Y21 := TRUE;
        IF X2C THEN
            form_state := 4;
        END_IF;

    4: (* TO_SUPPLY *)
        IF X30 THEN
            Y22 := TRUE;
        END_IF;
        IF X2F THEN
            form_state := 5;
        END_IF;

    5: (* RELEASE_GRIP *)
        Y20 := FALSE;
        IF X2B THEN
            form_state := 6;
        END_IF;

    6: (* LOWER *)
        Y21 := FALSE;
        IF X2D THEN
            form_state := 7;
        END_IF;

    7: (* RETRACT *)
        Y22 := FALSE;
        IF X2E THEN
            form_state := 8;
        END_IF;

    8: (* RESET_ALIGN *)
        Y1F := FALSE;
        form_state := 0;

    ELSE
        form_state := 0;
    END_CASE;
ELSE
    Y1D := FALSE;
    Y1C := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

(* ---------------- TRANSFER (GRIPPER) FSM ---------------- *)
IF start_latch THEN
    CASE transfer_state OF

    0: (* CHECK priority: discharge finished bundle first *)
        IF X22 AND X19 THEN
            transfer_state := 10;
        ELSE
            transfer_state := 1;
        END_IF;

    1: (* GO_SOURCE *)
        Y13 := TRUE;
        IF X12 THEN
            Y13 := FALSE;
            transfer_state := 2;
        END_IF;

    2: (* WAIT_GRIP_COND - only close on actual bundle at pickup pose *)
        IF X10 AND X11 AND X12 THEN
            Y10 := TRUE;
            transfer_state := 3;
        END_IF;

    3: (* WAIT_GRIPPED *)
        IF X16 THEN
            transfer_state := 4;
        END_IF;

    4: (* TOWRAP_MOVE - do not carry into occupied chuck *)
        IF NOT X19 THEN
            Y14 := TRUE;
            IF X13 THEN
                Y14 := FALSE;
                transfer_state := 5;
            END_IF;
        ELSE
            Y14 := FALSE;
        END_IF;

    5: (* CLAMP_NEW - clamp before releasing gripper (avoid loss of support) *)
        IF X11 THEN
            Y11 := TRUE;
        END_IF;
        IF X19 THEN
            Y10 := FALSE;
            transfer_state := 6;
        END_IF;

    6: (* WAIT_OPEN *)
        IF X17 THEN
            transfer_state := 0;
        END_IF;

    10: (* DISCHARGE_APPROACH - chuck still gripping *)
        Y14 := TRUE;
        IF X13 THEN
            transfer_state := 11;
        END_IF;

    11: (* DISCHARGE_GRIP *)
        Y10 := TRUE;
        IF X16 THEN
            transfer_state := 12;
        END_IF;

    12: (* CHUCK_RELEASE - only after grip confirmed *)
        Y11 := FALSE;
        IF X1A THEN
            transfer_state := 13;
        END_IF;

    13: (* WAIT_EXIT_COND *)
        IF (NOT X19) AND X1A AND X22 AND X23 THEN
            Y15 := TRUE;
            transfer_state := 14;
        ELSE
            Y15 := FALSE;
        END_IF;

    14: (* MOVE_EXIT *)
        Y15 := TRUE;
        IF X14 THEN
            transfer_state := 15;
        END_IF;

    15: (* PLACE *)
        Y10 := FALSE;
        IF X17 THEN
            Y15 := FALSE;
            bundles_done := bundles_done + 1;
            transfer_state := 0;
        END_IF;

    ELSE
        transfer_state := 0;
    END_CASE;
ELSE
    Y10 := FALSE;
    Y11 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
END_IF;

(* ---------------- WRAP / TAPE / CUT FSM ---------------- *)
IF start_latch THEN
    CASE wrap_state OF

    0: (* IDLE *)
        Y16 := FALSE;
        Y12 := FALSE;
        IF X19 THEN
            wrap_state := 1;
        END_IF;

    1: (* WRAPPING *)
        Y12 := TRUE;
        need_swap := (D4 < (D3 - D2)) AND (D3 > D2);
        IF need_swap THEN
            Y16 := FALSE;
            wrap_state := 2;
        ELSIF D2 >= D3 THEN
            Y16 := FALSE;
            wrap_state := 3;
        ELSE
            IF X19 AND X1B AND X18 THEN
                Y16 := TRUE;
            ELSE
                Y16 := FALSE;
            END_IF;
        END_IF;

    2: (* SWAP - reel exchange / splice *)
        Y12 := TRUE;
        IF X19 AND X1B AND X18 AND NOT X15 THEN
            Y17 := TRUE;
        END_IF;
        IF swapBusyPrevVal AND (NOT X1D) THEN
            Y17 := FALSE;
            wrap_state := 1;
        END_IF;
        swapBusyPrevVal := X1D;

    3: (* TAPE_PREP *)
        Y12 := TRUE;
        D200 := D6;
        Y18 := TRUE;
        prep_tmr(IN := TRUE, PT := T#8S);
        IF X20 THEN
            Y18 := FALSE;
            wrap_state := 4;
        END_IF;

    4: (* TAPE_APPLY *)
        Y12 := TRUE;
        IF (D5 = D0) AND (D2 >= D3) AND X19 THEN
            Y19 := TRUE;
        ELSE
            Y19 := FALSE;
        END_IF;
        tape_tmr(IN := Y19, PT := T#800MS);
        IF X21 THEN
            Y19 := FALSE;
            wrap_state := 5;
        END_IF;

    5: (* CUT *)
        Y12 := TRUE;
        IF X19 AND X1B AND (D2 >= D3) AND X21 THEN
            Y1A := TRUE;
        END_IF;
        cut_tmr(IN := Y1A, PT := T#800MS);
        IF X22 THEN
            Y1A := FALSE;
            wrap_state := 6;
        END_IF;

    6: (* DONE - wait until chuck emptied by discharge *)
        Y12 := FALSE;
        IF NOT X19 THEN
            wrap_state := 0;
        END_IF;

    ELSE
        wrap_state := 0;
    END_CASE;
ELSE
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y1A := FALSE;
    Y12 := FALSE;
END_IF;

(* ---------------- SOURCE BELT / HEAD MOVEMENT ---------------- *)
Y23 := start_latch AND X32 AND X2C AND X18 AND NOT X15 AND NOT Y13 AND NOT Y14 AND NOT Y15;
Y24 := start_latch AND X10 AND X33;

(* ---------------- COMPLETION LOGIC ---------------- *)
comp_cond := (bundles_done >= 3)
             AND NOT X15 AND X17 AND NOT X16 AND NOT X19
             AND NOT Y10 AND NOT Y11 AND NOT Y13 AND NOT Y14 AND NOT Y15
             AND NOT Y16 AND NOT Y17 AND NOT Y18 AND NOT Y19 AND NOT Y1A
             AND NOT Y20
             AND (form_state = 0);

complete_tmr(IN := comp_cond, PT := T#500MS);
IF complete_tmr.Q THEN
    complete_done := TRUE;
END_IF;

Y1B := complete_done;

END_PROGRAM