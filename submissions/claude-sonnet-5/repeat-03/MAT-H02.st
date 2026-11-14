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
    D14 : INT;
    D15 : INT;
    D16 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* ---- internal state ---- *)
    deck_phase        : INT := 0;
    cur_src           : INT := 0;
    cur_dst           : INT := 0;
    part_counted      : BOOL := FALSE;
    parts_acquired    : INT := 0;

    slot0_occupied    : BOOL;
    slot1_occupied    : BOOL;
    slot0_match_a     : BOOL;
    slot0_match_b     : BOOL;
    slot1_match_a     : BOOL;
    slot1_match_b     : BOOL;

    a_req_trig        : R_TRIG;
    b_req_trig        : R_TRIG;
    a_pending         : BOOL := FALSE;
    b_pending         : BOOL := FALSE;
    a_requests_issued : INT := 0;
    b_requests_issued : INT := 0;

    a_close_trig      : R_TRIG;
    b_close_trig      : R_TRIG;

    a_release_trig    : R_TRIG;
    b_release_trig    : R_TRIG;
    a_orders_done     : INT := 0;
    b_orders_done     : INT := 0;

    a_pack_cond       : BOOL;
    b_pack_cond       : BOOL;
    a_pack_trig       : R_TRIG;
    b_pack_trig       : R_TRIG;
    a_pack_pending    : BOOL := FALSE;
    b_pack_pending    : BOOL := FALSE;

    a_packed_trig     : R_TRIG;
    b_packed_trig     : R_TRIG;

    box_state         : INT := 0;
    boxes_dispatched  : INT := 0;
    boxes_delivered   : INT := 0;
    exit_wait         : BOOL := FALSE;
    exit_timer        : TON;

    comp_cond         : BOOL;
    comp_timer        : TON;
    complete_latched  : BOOL := FALSE;
END_VAR

(* -------- default outputs (edge-style outputs get exactly one scan) -------- *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y20 := FALSE;
Y1A := FALSE;
Y1E := FALSE;
Y1F := FALSE;
Y1C := FALSE;

(* -------- helper conditions for storage bypass -------- *)
slot0_occupied := D6 <> 0;
slot1_occupied := D8 <> 0;
slot0_match_a  := slot0_occupied AND X15 AND (D13 < 2) AND (D6 = D11);
slot0_match_b  := slot0_occupied AND X16 AND (D14 < 2) AND (D8 = D12);
slot1_match_a  := slot1_occupied AND X15 AND (D13 < 2) AND (D8 = D11);
slot1_match_b  := slot1_occupied AND X16 AND (D14 < 2) AND (D8 = D12);
(* fix: slot1 matching must use D8 kind against slot1 seat, correct below *)
slot0_match_a  := slot0_occupied AND X15 AND (D13 < 2) AND (D6 = D11);
slot0_match_b  := slot0_occupied AND X16 AND (D14 < 2) AND (D6 = D12);
slot1_match_a  := slot1_occupied AND X15 AND (D13 < 2) AND (D8 = D11);
slot1_match_b  := slot1_occupied AND X16 AND (D14 < 2) AND (D8 = D12);

(* =========================================================
   DECK TRANSPORT STATE MACHINE
   Positions: 1=inbound, 2/3=bypass storage 0/1, 4=A, 5=B
   ========================================================= *)
CASE deck_phase OF

0: (* IDLE - decide next action *)
    IF NOT X11 THEN
        IF slot0_match_a THEN
            cur_src := 2; cur_dst := 4; deck_phase := 1;
        ELSIF slot0_match_b THEN
            cur_src := 2; cur_dst := 5; deck_phase := 1;
        ELSIF slot1_match_a THEN
            cur_src := 3; cur_dst := 4; deck_phase := 1;
        ELSIF slot1_match_b THEN
            cur_src := 3; cur_dst := 5; deck_phase := 1;
        ELSIF X10 AND (X15 OR X16) AND (parts_acquired < 8) THEN
            cur_src := 1; cur_dst := 0; deck_phase := 1;
        END_IF;
    END_IF;

1: (* dock to source - issue pulse *)
    D200 := cur_src;
    Y10 := TRUE;
    deck_phase := 15;

15:
    deck_phase := 2;

2: (* wait source arrival *)
    IF (NOT X11) AND (D0 = cur_src) THEN
        deck_phase := 3;
    END_IF;

3: (* issue load *)
    part_counted := FALSE;
    Y11 := TRUE;
    deck_phase := 35;

35:
    deck_phase := 4;

4: (* wait item fully on + received *)
    IF X12 AND (D15 <> 0) THEN
        IF NOT part_counted THEN
            IF cur_src = 1 THEN
                parts_acquired := parts_acquired + 1;
            END_IF;
            part_counted := TRUE;
        END_IF;

        IF cur_dst = 0 THEN
            IF cur_src = 1 THEN
                IF X15 AND (D13 < 2) AND (D2 = D11) THEN
                    cur_dst := 4;
                ELSIF X16 AND (D14 < 2) AND (D2 = D12) THEN
                    cur_dst := 5;
                ELSIF D6 = 0 THEN
                    cur_dst := 2;
                ELSIF D8 = 0 THEN
                    cur_dst := 3;
                END_IF;
            END_IF;
        END_IF;

        IF cur_dst <> 0 THEN
            deck_phase := 6;
        END_IF;
    END_IF;

6: (* dock to destination *)
    D200 := cur_dst;
    Y10 := TRUE;
    deck_phase := 65;

65:
    deck_phase := 7;

7: (* wait destination arrival *)
    IF (NOT X11) AND (D0 = cur_dst) THEN
        deck_phase := 8;
    END_IF;

8: (* issue unload *)
    Y12 := TRUE;
    deck_phase := 85;

85:
    deck_phase := 9;

9: (* wait unload complete - item leaves deck *)
    IF NOT X12 THEN
        deck_phase := 0;
        cur_src := 0;
        cur_dst := 0;
    END_IF;

ELSE
    deck_phase := 0;

END_CASE;

(* =========================================================
   ORDER ACCEPTANCE (accept_a / accept_b) - shared D201 register
   ========================================================= *)
a_req_trig(CLK := X13);
IF a_req_trig.Q THEN
    a_pending := TRUE;
END_IF;

b_req_trig(CLK := X14);
IF b_req_trig.Q THEN
    b_pending := TRUE;
END_IF;

IF a_pending AND (a_requests_issued < 2) THEN
    D201 := a_requests_issued + 1;
    Y13 := TRUE;
    a_requests_issued := a_requests_issued + 1;
    a_pending := FALSE;
ELSIF b_pending AND (b_requests_issued < 2) THEN
    D201 := b_requests_issued + 1;
    Y14 := TRUE;
    b_requests_issued := b_requests_issued + 1;
    b_pending := FALSE;
END_IF;

(* =========================================================
   LOCAL COUPLING (close_a/close_b) after count reaches 2
   ========================================================= *)
a_close_trig(CLK := (D13 >= 2));
Y15 := a_close_trig.Q;

b_close_trig(CLK := (D14 >= 2));
Y16 := b_close_trig.Q;

(* =========================================================
   RELEASE (release_a/release_b) at out_clear when ready
   ========================================================= *)
a_release_trig(CLK := (X19 AND X17));
Y17 := a_release_trig.Q;
IF a_release_trig.Q THEN
    a_orders_done := a_orders_done + 1;
END_IF;

b_release_trig(CLK := (X1A AND X18));
Y18 := b_release_trig.Q;
IF b_release_trig.Q THEN
    b_orders_done := b_orders_done + 1;
END_IF;

(* =========================================================
   PACKING (pack_a/pack_b) - shared head, mutually exclusive
   ========================================================= *)
a_pack_cond := (D16 = D9) AND (D9 <> 0) AND (D15 <> 0) AND X17;
b_pack_cond := (D16 = D10) AND (D10 <> 0) AND (D15 <> 0) AND X18;

a_pack_trig(CLK := a_pack_cond);
IF a_pack_trig.Q THEN
    a_pack_pending := TRUE;
END_IF;

b_pack_trig(CLK := b_pack_cond);
IF b_pack_trig.Q THEN
    b_pack_pending := TRUE;
END_IF;

IF NOT X21 THEN
    IF a_pack_pending THEN
        Y1E := TRUE;
        a_pack_pending := FALSE;
    ELSIF b_pack_pending THEN
        Y1F := TRUE;
        b_pack_pending := FALSE;
    END_IF;
END_IF;

(* ack after packed confirmation *)
a_packed_trig(CLK := X22);
Y19 := a_packed_trig.Q;

b_packed_trig(CLK := X23);
Y1A := b_packed_trig.Q;

(* =========================================================
   BOX HANDLING STATE MACHINE
   ========================================================= *)
CASE box_state OF

0: (* request a box *)
    Y1C := (NOT X1F) AND (boxes_dispatched < 2);
    IF X1F THEN
        box_state := 1;
    END_IF;

1: (* clamp box *)
    Y1D := TRUE;
    IF X20 THEN
        box_state := 2;
    END_IF;

2: (* wait until both kits actually in box *)
    Y1D := TRUE;
    IF X24 THEN
        box_state := 3;
    END_IF;

3: (* release clamp, wait exit clear *)
    Y1D := FALSE;
    IF X25 THEN
        box_state := 4;
    END_IF;

4: (* issue dispatch pulse *)
    Y20 := TRUE;
    box_state := 41;

41:
    boxes_dispatched := boxes_dispatched + 1;
    exit_wait := TRUE;
    box_state := 5;

5: (* wait published receipt delay *)
    IF exit_timer.Q THEN
        boxes_delivered := boxes_delivered + 1;
        exit_wait := FALSE;
        box_state := 0;
    END_IF;

ELSE
    box_state := 0;

END_CASE;

exit_timer(IN := exit_wait, PT := T#18S);

(* =========================================================
   COMPLETION LOGIC
   ========================================================= *)
comp_cond := (parts_acquired = 8) AND (a_orders_done = 2) AND (b_orders_done = 2)
             AND (boxes_delivered = 2) AND (deck_phase = 0) AND (NOT X11)
             AND (NOT X12) AND (D2 = 0);

comp_timer(IN := comp_cond, PT := T#500MS);
IF comp_timer.Q THEN
    complete_latched := TRUE;
END_IF;

Y1B := complete_latched;

END_PROGRAM