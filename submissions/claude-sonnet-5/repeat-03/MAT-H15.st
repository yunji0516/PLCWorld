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
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal state *)
    Step : INT := 0;
    want_side : INT := 0;
    want_kind : INT := 0;
    snap_count : INT := 0;
    current_count : INT := 0;

    a_lift_done : BOOL := FALSE;
    a_shipped : BOOL := FALSE;
    b_lift_done : BOOL := FALSE;
    b_shipped : BOOL := FALSE;

    support_a_target : INT := 850;
    support_b_target : INT := 850;

    stable_cond : BOOL := FALSE;
    Complete_Latched : BOOL := FALSE;
    complete_timer : TON;
END_VAR

(* ---------- continuous support height control ---------- *)
IF a_shipped THEN
    support_a_target := 850;
ELSIF a_lift_done THEN
    support_a_target := 780;
ELSIF X1F THEN
    support_a_target := 850;
ELSIF X1D THEN
    support_a_target := 780;
ELSE
    support_a_target := 850;
END_IF;

IF b_shipped THEN
    support_b_target := 850;
ELSIF b_lift_done THEN
    support_b_target := 780;
ELSIF X20 THEN
    support_b_target := 850;
ELSIF X1E THEN
    support_b_target := 780;
ELSE
    support_b_target := 850;
END_IF;

D203 := support_a_target;
D204 := support_b_target;

Y14 := (support_a_target = 850 AND NOT X21) OR (support_a_target = 780 AND NOT X23);
Y15 := (support_b_target = 850 AND NOT X22) OR (support_b_target = 780 AND NOT X24);

(* ---------- main sequential logic ---------- *)
CASE Step OF

0: (* wait start *)
    IF X0 THEN
        Step := 10;
    END_IF;

10: Y10 := TRUE; Step := 11;
11: Y10 := FALSE; Step := 12;
12: Y11 := TRUE; Step := 13;
13: Y11 := FALSE; Step := 14;
14:
    IF X1D AND X1E THEN
        Step := 20;
    END_IF;

(* ---- pallet supply for A ---- *)
20:
    IF X28 THEN
        Step := 30;
    ELSIF X27 THEN
        D201 := 1;
        Y1C := TRUE;
        Step := 21;
    END_IF;
21: Y1C := FALSE; Step := 22;
22:
    IF X2A THEN
        Y1D := TRUE;
        Step := 23;
    END_IF;
23: Y1D := FALSE; Step := 24;
24:
    IF X2B THEN
        D201 := 1;
        Y1E := TRUE;
        Step := 25;
    END_IF;
25: Y1E := FALSE; Step := 26;
26:
    IF X2C THEN
        Y1F := TRUE;
        Step := 27;
    END_IF;
27: Y1F := FALSE; Step := 28;
28:
    IF X18 THEN
        Step := 30;
    END_IF;

(* ---- pallet supply for B ---- *)
30:
    IF X29 THEN
        Step := 40;
    ELSIF X27 THEN
        D201 := 2;
        Y1C := TRUE;
        Step := 31;
    END_IF;
31: Y1C := FALSE; Step := 32;
32:
    IF X2A THEN
        Y1D := TRUE;
        Step := 33;
    END_IF;
33: Y1D := FALSE; Step := 34;
34:
    IF X2B THEN
        D201 := 2;
        Y1E := TRUE;
        Step := 35;
    END_IF;
35: Y1E := FALSE; Step := 36;
36:
    IF X2C THEN
        Y1F := TRUE;
        Step := 37;
    END_IF;
37: Y1F := FALSE; Step := 38;
38:
    IF X18 THEN
        Step := 40;
    END_IF;

(* ---- stacking loop ---- *)
40:
    IF X1D AND (NOT X1F) AND (((D7 = 1) AND X10) OR ((D7 = 2) AND X11)) THEN
        want_side := 1;
        want_kind := D7;
        D200 := want_kind;
        Y12 := TRUE;
        Step := 41;
    ELSIF X1E AND (NOT X20) AND (((D8 = 1) AND X10) OR ((D8 = 2) AND X11)) THEN
        want_side := 2;
        want_kind := D8;
        D200 := want_kind;
        Y12 := TRUE;
        Step := 41;
    ELSIF ((NOT X1D) OR X1F) AND ((NOT X1E) OR X20) THEN
        Step := 60;
    END_IF;

41: Y12 := FALSE; Step := 42;
42:
    IF X13 THEN
        Step := 43;
    END_IF;
43:
    IF (want_side = 1 AND X25) OR (want_side = 2 AND X26) THEN
        D201 := want_side;
        IF want_side = 1 THEN
            D202 := D9;
            snap_count := D11;
        ELSE
            D202 := D10;
            snap_count := D12;
        END_IF;
        Y13 := TRUE;
        Step := 44;
    END_IF;
44: Y13 := FALSE; Step := 45;
45:
    current_count := SEL(want_side = 2, D11, D12);
    IF current_count <> snap_count THEN
        Step := 40;
    END_IF;

(* ---- shipping phase ---- *)
60:
    IF X1F AND X20 AND X21 AND X22 THEN
        Step := 70;
    END_IF;

(* ship A *)
70:
    IF X21 AND (NOT X12) THEN
        D201 := 1;
        Y16 := TRUE;
        Step := 71;
    END_IF;
71: Y16 := FALSE; Step := 72;
72:
    IF X15 THEN
        Y17 := TRUE;
        Step := 73;
    END_IF;
73: Y17 := FALSE; Step := 74;
74:
    IF X16 THEN
        a_lift_done := TRUE;
        Step := 75;
    END_IF;
75:
    IF X23 THEN
        D201 := 1;
        Y18 := TRUE;
        Step := 76;
    END_IF;
76: Y18 := FALSE; Step := 77;
77:
    IF X17 THEN
        a_shipped := TRUE;
        Y19 := TRUE;
        Step := 78;
    END_IF;
78: Y19 := FALSE; Step := 79;
79:
    IF X18 THEN
        Step := 90;
    END_IF;

(* ship B *)
90:
    IF X22 AND (NOT X12) THEN
        D201 := 2;
        Y16 := TRUE;
        Step := 91;
    END_IF;
91: Y16 := FALSE; Step := 92;
92:
    IF X15 THEN
        Y17 := TRUE;
        Step := 93;
    END_IF;
93: Y17 := FALSE; Step := 94;
94:
    IF X16 THEN
        b_lift_done := TRUE;
        Step := 95;
    END_IF;
95:
    IF X24 THEN
        D201 := 2;
        Y18 := TRUE;
        Step := 96;
    END_IF;
96: Y18 := FALSE; Step := 97;
97:
    IF X17 THEN
        b_shipped := TRUE;
        Y19 := TRUE;
        Step := 98;
    END_IF;
98: Y19 := FALSE; Step := 99;
99:
    IF X18 THEN
        Step := 100;
    END_IF;

(* shared receiving transaction *)
100:
    IF X19 THEN
        Y1A := TRUE;
        Step := 101;
    END_IF;
101: Y1A := FALSE; Step := 102;

102:
    stable_cond := X1A AND X21 AND X22 AND X18 AND (NOT X12) AND
                   (NOT Y16) AND (NOT Y17) AND (NOT Y18) AND (NOT Y19) AND
                   (NOT Y1C) AND (NOT Y1D) AND (NOT Y1E) AND (NOT Y1F) AND
                   (NOT Y12) AND (NOT Y13);
    complete_timer(IN := stable_cond, PT := T#500ms);
    IF complete_timer.Q THEN
        Complete_Latched := TRUE;
    END_IF;
    Y1B := Complete_Latched;

ELSE
    Step := 0;

END_CASE;

END_PROGRAM