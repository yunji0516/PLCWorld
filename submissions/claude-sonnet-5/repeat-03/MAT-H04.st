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
    pkg_count   : INT := 0;
    target_id   : INT := 0;
    started     : BOOL := FALSE;

    start_trig  : R_TRIG;
    sep_timer   : TON;
    complete_timer : TON;
END_VAR

(* ---------- start latch ---------- *)
start_trig(CLK := X0);
IF start_trig.Q THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    (* keep everything safe until start requested *)
    Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
    Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
    Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
ELSE

CASE step OF

(* ---- 0 : wait (kept for symmetry, immediately proceed) ---- *)
0:
    step := 1;

(* ---- 1 : decide whether separation of stacked sheets is needed ---- *)
1:
    IF X20 THEN
        step := 2;
    ELSE
        step := 9;
    END_IF;

(* ---- separation sequence : lower hold engaged throughout ---- *)
2:
    Y1B := TRUE;              (* separator_hold ON *)
    sep_timer(IN := TRUE, PT := T#250ms);
    step := 3;

3:
    sep_timer(IN := TRUE, PT := T#250ms);
    IF sep_timer.Q THEN
        step := 4;
    END_IF;

4:
    sep_timer(IN := TRUE, PT := T#250ms);
    IF (NOT X21) THEN
        Y1C := TRUE;           (* separate rising edge *)
        step := 5;
    END_IF;

5:
    Y1C := FALSE;
    step := 6;

6:
    IF X21 THEN
        step := 7;
    END_IF;

7:
    IF (NOT X21) AND X23 THEN
        step := 8;
    END_IF;

8:
    Y1B := FALSE;              (* release lower hold, separation done *)
    step := 9;

(* ---- accept pouch : only when single sheet and separator idle ---- *)
9:
    IF X10 AND X23 AND (NOT X21) THEN
        Y10 := TRUE;
        step := 10;
    END_IF;

10:
    Y10 := FALSE;
    step := 11;

11:
    IF X11 AND (NOT X12) THEN
        step := 12;
    END_IF;

(* ---- transfer pouch to insertion position (level output) ---- *)
12:
    Y15 := TRUE;
    step := 13;

13:
    IF X13 AND (NOT X12) THEN
        step := 14;
    END_IF;

(* ---- open pouch : hold both walls ---- *)
14:
    Y12 := TRUE;
    Y13 := TRUE;
    Y14 := TRUE;
    step := 15;

15:
    IF X1A AND X1B AND X1C THEN
        step := 16;
    END_IF;

(* ---- select matching content by actual pouch id ---- *)
16:
    target_id := D0;
    D200 := target_id;
    step := 17;

17:
    IF target_id > 0 THEN
        Y11 := TRUE;
        step := 18;
    END_IF;

18:
    Y11 := FALSE;
    step := 19;

19:
    IF X15 AND (D2 = target_id) AND (NOT X14) THEN
        step := 20;
    END_IF;

(* ---- align content on both axes ---- *)
20:
    Y1D := TRUE;
    Y1E := TRUE;
    step := 21;

21:
    IF X24 THEN
        step := 22;
    END_IF;

22:
    Y1D := FALSE;
    Y1E := FALSE;
    step := 23;

23:
    IF X25 THEN
        step := 24;
    END_IF;

(* ---- insert content, only when all interlocks satisfied ---- *)
24:
    IF X13 AND X1A AND X1B AND X24 AND X25 AND (D2 = target_id) THEN
        Y16 := TRUE;
        step := 25;
    END_IF;

25:
    IF X18 THEN
        step := 26;
    END_IF;

26:
    IF X19 THEN
        Y16 := FALSE;
        step := 27;
    END_IF;

27:
    IF X17 THEN
        step := 28;
    END_IF;

(* ---- release finished package ---- *)
28:
    IF X19 AND X17 AND (NOT X14) AND X1D THEN
        Y18 := TRUE;
        step := 29;
    END_IF;

29:
    Y18 := FALSE;
    step := 30;

30:
    IF X1E THEN
        step := 31;
    END_IF;

31:
    Y19 := TRUE;
    step := 32;

32:
    Y19 := FALSE;
    step := 33;

33:
    IF (NOT X1E) THEN
        step := 34;
    END_IF;

(* ---- return support / heads to empty positions ---- *)
34:
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y17 := TRUE;
    step := 35;

35:
    IF (NOT X13) AND X17 THEN
        step := 36;
    END_IF;

36:
    Y17 := FALSE;
    pkg_count := pkg_count + 1;
    IF pkg_count < 4 THEN
        step := 1;
    ELSE
        step := 40;
    END_IF;

(* ---- finalize : ensure everything home before declaring complete ---- *)
40:
    Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
    Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
    Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
    step := 41;

41:
    Y1A := TRUE;
    complete_timer(IN := TRUE, PT := T#500ms);
    step := 42;

42:
    complete_timer(IN := TRUE, PT := T#500ms);
    Y1A := TRUE;
    (* maintain completed state; all actuator outputs remain off except complete *)
    Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
    Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
    Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;

ELSE
    step := 0;

END_CASE;

END_IF;

END_PROGRAM