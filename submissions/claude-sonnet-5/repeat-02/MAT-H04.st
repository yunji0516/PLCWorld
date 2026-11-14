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

    (* internal *)
    step        : INT := 0;
    pair_id     : INT := 0;
    completed_count : INT := 0;
    mask_bit    : INT;
    avail       : BOOL;

    start_trig  : R_TRIG;
    sep_timer   : TON;
    fix_timer   : TON;
    complete_timer : TON;
END_VAR

(* ---------- default reset of pulse-type outputs each scan ---------- *)
Y10 := FALSE;
Y11 := FALSE;
Y15 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1C := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y1B := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y16 := FALSE;
Y17 := FALSE;

start_trig(CLK := X0);

(* ---------- timers, called every scan with condition on step ---------- *)
sep_timer(IN := (step = 2), PT := T#250ms);
fix_timer(IN := (step = 19), PT := T#500ms);
complete_timer(IN := (step = 23), PT := T#500ms);

CASE step OF

0: (* IDLE *)
    IF start_trig.Q THEN
        step := 1;
    END_IF;

1: (* WAIT_LEAD *)
    IF X10 THEN
        IF X20 THEN
            step := 2;
        ELSIF X23 AND NOT X21 THEN
            step := 5;
        END_IF;
    END_IF;

2: (* SEP_HOLD - separator_hold engaged for 0.25s *)
    IF sep_timer.Q THEN
        step := 3;
    END_IF;

3: (* SEP_TRIGGER - pulse separate *)
    Y1C := TRUE;
    step := 4;

4: (* SEP_WAIT - wait separation complete, single sheet confirmed *)
    IF (NOT X21) AND X23 THEN
        step := 5;
    END_IF;

5: (* ACCEPT_POUCH_TRIG *)
    IF (NOT X21) AND X23 THEN
        Y10 := TRUE;
        step := 6;
    END_IF;

6: (* ACCEPT_POUCH_WAIT *)
    IF X11 THEN
        step := 7;
    END_IF;

7: (* TRANSFER_TRIG *)
    Y15 := TRUE;
    step := 8;

8: (* TRANSFER_WAIT *)
    IF X13 THEN
        step := 9;
    END_IF;

9: (* VACUUM_ON *)
    IF X1A AND X1B THEN
        step := 10;
    END_IF;

10: (* OPEN_ON *)
    IF X1C AND X1A AND X1B THEN
        pair_id := D0;
        step := 11;
    END_IF;

11: (* CONTENT_SELECT *)
    IF pair_id >= 1 AND pair_id <= 4 THEN
        mask_bit := SHR(D4, pair_id - 1);
        avail := (mask_bit - (mask_bit / 2) * 2) = 1;
        IF avail THEN
            D200 := pair_id;
            Y11 := TRUE;
            step := 12;
        END_IF;
    END_IF;

12: (* CONTENT_WAIT *)
    IF X15 AND (D2 = pair_id) THEN
        step := 13;
    END_IF;

13: (* ALIGN_ON *)
    IF X24 THEN
        step := 14;
    END_IF;

14: (* ALIGN_RELEASE - open the stoppers, wait clear *)
    IF X25 THEN
        step := 15;
    END_IF;

15: (* PRECHECK before insert *)
    IF X13 AND X1A AND X1B AND X1C AND X24 AND X25
       AND (D0 = pair_id) AND (D2 = pair_id) THEN
        step := 16;
    END_IF;

16: (* INSERT_ON *)
    IF X19 AND X18 THEN
        step := 17;
    END_IF;

17: (* RETRACT_ON *)
    IF X17 THEN
        step := 18;
    END_IF;

18: (* RELEASE_WAIT *)
    IF X19 AND X17 AND (NOT X14) AND X1D THEN
        Y18 := TRUE;
        step := 19;
    END_IF;

19: (* FIX_CLOSE - lower opening upper wall for 0.5s *)
    IF fix_timer.Q THEN
        step := 20;
    END_IF;

20: (* ACK_EXIT_TRIG *)
    Y19 := TRUE;
    step := 21;

21: (* ACK_EXIT_WAIT *)
    IF X1E THEN
        completed_count := completed_count + 1;
        pair_id := 0;
        D200 := 0;
        IF completed_count >= 4 THEN
            step := 22;
        ELSE
            step := 1;
        END_IF;
    END_IF;

22: (* WAIT_ALL_DONE - shuttle / pickup / pusher home *)
    IF X1F AND X17 AND (NOT X12) AND (NOT X14) THEN
        step := 23;
    END_IF;

23: (* COMPLETE declared, maintain for 0.5s *)
    IF complete_timer.Q THEN
        step := 24;
    END_IF;

24: (* DONE - maintain completed state *)
    ; (* stay here *)

ELSE
    step := 0;

END_CASE;

(* ---------- level-type outputs derived from current step ---------- *)
IF step >= 2 AND step <= 4 THEN
    Y1B := TRUE;
END_IF;

IF step >= 9 AND step <= 18 THEN
    Y12 := TRUE;
    Y13 := TRUE;
END_IF;

IF step >= 10 AND step <= 18 THEN
    Y14 := TRUE;
END_IF;

IF step = 13 THEN
    Y1D := TRUE;
    Y1E := TRUE;
END_IF;

IF step = 16 THEN
    Y16 := TRUE;
END_IF;

IF step = 17 THEN
    Y17 := TRUE;
END_IF;

IF step >= 23 THEN
    Y1A := TRUE;
END_IF;

END_PROGRAM