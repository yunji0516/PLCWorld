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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
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

    (* internal state *)
    step        : INT := 0;
    pair_id     : INT := 0;
    pkg_count   : INT := 0;
    maskBit     : BOOL := FALSE;

    condFlag_content : BOOL := FALSE;
    condFlag_release : BOOL := FALSE;

    sep_ton      : TON;
    edge_separate : R_TRIG;
    edge_accept   : R_TRIG;
    edge_transfer : R_TRIG;
    edge_content  : R_TRIG;
    edge_release  : R_TRIG;
    edge_ack      : R_TRIG;
END_VAR

(* ---- bit test of available_mask for current pair id ---- *)
maskBit := FALSE;
CASE pair_id OF
    1: maskBit := (D4 MOD 2) = 1;
    2: maskBit := ((D4 / 2) MOD 2) = 1;
    3: maskBit := ((D4 / 4) MOD 2) = 1;
    4: maskBit := ((D4 / 8) MOD 2) = 1;
END_CASE;

(* ---- trigger conditions computed from CURRENT step (before transition) ---- *)
condFlag_content := (step = 10) AND (D2 = 0) AND X15 AND (NOT X14) AND maskBit;
condFlag_release := (step = 17) AND X19 AND X17 AND (NOT X14) AND X1D;

(* ---- edge / timer function blocks ---- *)
edge_separate(CLK := (step = 3));
edge_accept(CLK := (step = 4));
edge_transfer(CLK := (step = 6));
edge_content(CLK := condFlag_content);
edge_release(CLK := condFlag_release);
edge_ack(CLK := (step = 19));

sep_ton(IN := (step = 2), PT := T#250ms);

(* ---- pulse outputs (rising edge actions) ---- *)
Y1C := edge_separate.Q;
Y10 := edge_accept.Q;
Y15 := edge_transfer.Q;
Y11 := edge_content.Q;
Y18 := edge_release.Q;
Y19 := edge_ack.Q;

(* ---- level outputs based on step ranges ---- *)
Y1B := (step = 2) OR (step = 3);
Y12 := (step >= 8) AND (step <= 19);
Y13 := (step >= 8) AND (step <= 19);
Y14 := (step >= 9) AND (step <= 19);
Y1D := (step = 12);
Y1E := (step = 12);
Y16 := (step = 14) AND X13 AND X24 AND X25 AND X1A AND X1B AND X1C;
Y17 := (step = 15);
Y1A := (step = 23);

D200 := pair_id;

(* ---- state machine transitions ---- *)
CASE step OF

0: (* wait start *)
    IF X0 THEN
        step := 1;
    END_IF;

1: (* wait pouch ready, decide separation need *)
    IF X10 THEN
        IF X20 AND (NOT X21) THEN
            step := 2;
        ELSIF X23 AND (NOT X21) THEN
            step := 4;
        END_IF;
    END_IF;

2: (* separator hold engaged, wait 0.25s *)
    IF sep_ton.Q THEN
        step := 3;
    END_IF;

3: (* separate pulse fired above; wait separation confirmed *)
    IF X23 AND (NOT X21) THEN
        step := 4;
    END_IF;

4: (* accept_pouch pulse fired above; advance *)
    step := 5;

5: (* wait pouch loaded, capture pair id *)
    IF X11 THEN
        pair_id := D0;
        step := 6;
    END_IF;

6: (* transfer_pouch pulse fired above; advance *)
    step := 7;

7: (* wait docked *)
    IF X13 THEN
        step := 8;
    END_IF;

8: (* wait both walls held *)
    IF X1A AND X1B THEN
        step := 9;
    END_IF;

9: (* wait aperture open *)
    IF X1C THEN
        step := 10;
    END_IF;

10: (* accept_content pulse fired above (gated by condFlag_content) *)
    IF edge_content.Q THEN
        step := 11;
    END_IF;

11: (* wait content actually loaded and matched to pair *)
    IF (D2 = pair_id) AND (NOT X14) THEN
        step := 12;
    END_IF;

12: (* align stoppers closing, wait aligned *)
    IF X24 THEN
        step := 13;
    END_IF;

13: (* stoppers retracting, wait clear *)
    IF X25 THEN
        step := 14;
    END_IF;

14: (* insert while safety preconditions hold, wait insert_end *)
    IF X18 THEN
        step := 15;
    END_IF;

15: (* retract pusher, wait home *)
    IF X17 THEN
        step := 16;
    END_IF;

16: (* wait contained *)
    IF X19 THEN
        step := 17;
    END_IF;

17: (* release pulse fired above (gated by condFlag_release) *)
    IF edge_release.Q THEN
        step := 18;
    END_IF;

18: (* wait exit received *)
    IF X1E THEN
        step := 19;
    END_IF;

19: (* ack_exit pulse fired above; advance to cleanup *)
    step := 20;

20: (* cleanup: vacuum/open already released by range logic; wait support empty *)
    IF (NOT X13) AND (NOT X12) THEN
        step := 21;
    END_IF;

21: (* loop bookkeeping *)
    pkg_count := pkg_count + 1;
    IF pkg_count < 4 THEN
        step := 1;
    ELSE
        step := 22;
    END_IF;

22: (* wait for all subsystems home *)
    IF X1F THEN
        step := 23;
    END_IF;

23: (* completion latched and maintained *)
    ;

ELSE
    step := 0;
END_CASE;

END_PROGRAM