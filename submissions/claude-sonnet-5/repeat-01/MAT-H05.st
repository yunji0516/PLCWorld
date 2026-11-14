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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal state *)
    ph : INT := 0;
    outph : INT := 0;
    outer_count : INT := 0;
    gen_count : INT := 0;
    good_shipped : INT := 0;
    rework_count : INT := 0;
    skip_insert : BOOL := FALSE;
    captured_ng : BOOL := FALSE;
    complete_latched : BOOL := FALSE;
    ton_clamp : TON;
    ton_complete : TON;
END_VAR

CASE ph OF
0:
    IF X0 THEN
        ph := 1;
    END_IF;
1:
    IF NOT X19 THEN
        Y17 := TRUE;
    ELSE
        IF X10 AND NOT X14 AND NOT X18 THEN
            Y10 := TRUE;
            ph := 2;
        END_IF;
    END_IF;
2:
    Y10 := FALSE;
    ph := 3;
3:
    IF X14 THEN
        ph := 4;
    END_IF;
4:
    IF NOT X14 THEN
        outer_count := outer_count + 1;
        gen_count := gen_count + 1;
        D200 := gen_count;
        ph := 10;
    END_IF;

(* rotate pos0 -> pos1 *)
10:
    Y17 := FALSE;
    ph := 11;
11:
    IF X1A AND X1B AND X2A THEN
        ph := 12;
    END_IF;
12:
    Y18 := TRUE;
    ph := 13;
13:
    Y18 := FALSE;
    ph := 14;
14:
    IF X18 THEN
        ph := 15;
    END_IF;
15:
    IF NOT X18 THEN
        ph := 16;
    END_IF;
16:
    Y17 := TRUE;
    ph := 17;
17:
    IF X19 THEN
        ph := 20;
    END_IF;

(* prepare/insert at pos1 *)
20:
    IF skip_insert THEN
        skip_insert := FALSE;
        ph := 30;
    ELSE
        IF X12 THEN
            Y11 := TRUE;
            ph := 21;
        END_IF;
    END_IF;
21:
    Y11 := FALSE;
    ph := 22;
22:
    IF X13 THEN
        ph := 23;
    END_IF;
23:
    IF X13 AND NOT X15 AND X19 AND NOT X18 THEN
        Y12 := TRUE;
        ph := 24;
    END_IF;
24:
    Y12 := FALSE;
    ph := 25;
25:
    IF X15 THEN
        ph := 26;
    END_IF;
26:
    IF NOT X15 AND X21 THEN
        ph := 30;
    END_IF;

(* rotate pos1 -> pos2 *)
30:
    Y17 := FALSE;
    ph := 31;
31:
    IF X1A AND X1B AND X2A THEN
        ph := 32;
    END_IF;
32:
    Y18 := TRUE;
    ph := 33;
33:
    Y18 := FALSE;
    ph := 34;
34:
    IF X18 THEN
        ph := 35;
    END_IF;
35:
    IF NOT X18 THEN
        ph := 36;
    END_IF;
36:
    Y17 := TRUE;
    ph := 37;
37:
    IF X19 THEN
        ph := 40;
    END_IF;

(* inspect at pos2 *)
40:
    D200 := gen_count;
    ph := 41;
41:
    IF NOT X16 THEN
        Y13 := TRUE;
        ph := 42;
    END_IF;
42:
    Y13 := FALSE;
    ph := 43;
43:
    IF X16 THEN
        ph := 44;
    END_IF;
44:
    IF NOT X16 AND X22 THEN
        captured_ng := X24;
        ph := 50;
    END_IF;

(* rotate pos2 -> pos3 *)
50:
    Y17 := FALSE;
    ph := 51;
51:
    IF X1A AND X1B AND X2A THEN
        ph := 52;
    END_IF;
52:
    Y18 := TRUE;
    ph := 53;
53:
    Y18 := FALSE;
    ph := 54;
54:
    IF X18 THEN
        ph := 55;
    END_IF;
55:
    IF NOT X18 THEN
        ph := 56;
    END_IF;
56:
    Y17 := TRUE;
    ph := 57;
57:
    IF X19 THEN
        ph := 60;
    END_IF;

(* decide eject or rework *)
60:
    IF captured_ng THEN
        ph := 100;
    ELSE
        ph := 70;
    END_IF;

(* eject at pos3 *)
70:
    IF NOT X20 AND NOT X17 THEN
        Y14 := TRUE;
        ph := 71;
    END_IF;
71:
    IF X1C THEN
        Y14 := FALSE;
        ph := 72;
    END_IF;
72:
    Y15 := TRUE;
    ph := 73;
73:
    IF X1B THEN
        Y15 := FALSE;
        ph := 80;
    END_IF;

(* rotate pos3 -> pos0 *)
80:
    Y17 := FALSE;
    ph := 81;
81:
    IF X1A AND X1B AND X2A THEN
        ph := 82;
    END_IF;
82:
    Y18 := TRUE;
    ph := 83;
83:
    Y18 := FALSE;
    ph := 84;
84:
    IF X18 THEN
        ph := 85;
    END_IF;
85:
    IF NOT X18 THEN
        ph := 86;
    END_IF;
86:
    Y17 := TRUE;
    ph := 87;
87:
    IF X19 THEN
        ph := 90;
    END_IF;

90:
    IF outer_count < 6 THEN
        ph := 1;
    ELSE
        ph := 999;
    END_IF;

(* rework path *)
100:
    IF NOT X25 THEN
        Y1B := TRUE;
        ph := 101;
    END_IF;
101:
    Y1B := FALSE;
    ph := 102;
102:
    IF X26 THEN
        ph := 103;
    END_IF;
103:
    Y1C := TRUE;
    ph := 104;
104:
    IF X27 AND ton_clamp.Q THEN
        ph := 105;
    END_IF;
105:
    IF NOT X25 THEN
        Y1D := TRUE;
        ph := 106;
    END_IF;
106:
    Y1D := FALSE;
    ph := 107;
107:
    IF X28 THEN
        ph := 108;
    END_IF;
108:
    IF NOT X25 THEN
        Y1E := TRUE;
        ph := 109;
    END_IF;
109:
    Y1E := FALSE;
    ph := 110;
110:
    IF X29 THEN
        ph := 111;
    END_IF;
111:
    Y1C := FALSE;
    ph := 112;
112:
    IF NOT X27 THEN
        ph := 113;
    END_IF;
113:
    IF X19 THEN
        Y1F := TRUE;
        ph := 114;
    END_IF;
114:
    Y1F := FALSE;
    ph := 115;
115:
    IF X2A THEN
        rework_count := rework_count + 1;
        skip_insert := TRUE;
        gen_count := gen_count + 1;
        D200 := gen_count;
        ph := 10;
    END_IF;

999:
    ;

ELSE
    ph := 0;
END_CASE;

ton_clamp(IN := Y1C, PT := T#300ms);

(* asynchronous exit/output handling, runs in parallel with main sequence *)
CASE outph OF
0:
    IF X20 AND X1B AND X1D THEN
        Y16 := TRUE;
        outph := 1;
    END_IF;
1:
    Y16 := FALSE;
    outph := 2;
2:
    IF X1E THEN
        Y19 := TRUE;
        outph := 3;
    END_IF;
3:
    Y19 := FALSE;
    good_shipped := good_shipped + 1;
    outph := 0;
ELSE
    outph := 0;
END_CASE;

(* completion assertion and maintenance *)
IF NOT complete_latched THEN
    IF good_shipped >= 6 AND ph = 999 AND X1B AND NOT X18 AND X19 AND X2A AND X1F THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

ton_complete(IN := complete_latched, PT := T#500ms);

Y1A := complete_latched;

END_PROGRAM