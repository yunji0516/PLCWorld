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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;

    (* internal state *)
    state        : INT := 0;
    roll_count   : INT := 1;
    active_roll  : BOOL := FALSE;
    a_was_accepted : BOOL := FALSE;
    b_was_accepted : BOOL := FALSE;

    roll_id_1 : INT := 0;
    roll_id_2 : INT := 0;
    roll_id_3 : INT := 0;

    release_timer : TON;
END_VAR

CASE state OF

0: (* wait for start command *)
    IF X0 THEN
        state := 1;
    END_IF;

(* ---------- leader / leading-end preparation ---------- *)
1: (* pulse accept_a *)
    IF X10 AND NOT a_was_accepted THEN
        Y10 := TRUE;
        a_was_accepted := TRUE;
        state := 2;
    END_IF;
2:
    Y10 := FALSE;
    state := 3;
3:
    IF X12 THEN
        state := 4;
    END_IF;

4: (* pulse accept_b *)
    IF X11 AND NOT b_was_accepted THEN
        Y11 := TRUE;
        b_was_accepted := TRUE;
        state := 5;
    END_IF;
5:
    Y11 := FALSE;
    state := 6;
6:
    IF X13 THEN
        state := 7;
    END_IF;

7: (* hold A *)
    Y12 := TRUE;
    state := 8;
8:
    IF X14 THEN
        state := 9;
    END_IF;

9: (* jog B toward origin, only if B prepared, not held, no active roll *)
    IF X13 AND NOT X15 AND NOT active_roll THEN
        Y14 := TRUE;
        state := 10;
    END_IF;
10:
    IF ABS(D2 - D0) <= 2 THEN
        Y14 := FALSE;
        state := 11;
    END_IF;

11: (* hold B *)
    Y13 := TRUE;
    state := 12;
12:
    IF X15 THEN
        state := 13;
    END_IF;

13: (* trim_b rising edge, only if B held and blade not busy *)
    IF X15 THEN
        Y15 := TRUE;
        state := 14;
    END_IF;
14:
    Y15 := FALSE;
    state := 15;
15:
    IF X16 THEN
        state := 16;
    END_IF;

16: (* ack_trim only after trim_received *)
    IF X17 THEN
        Y16 := TRUE;
        state := 17;
    END_IF;
17:
    Y16 := FALSE;
    roll_count := 1;
    state := 90;

(* ---------- per roll core feed ---------- *)
90:
    IF X2C THEN
        Y23 := TRUE;
        state := 91;
    END_IF;
91:
    IF X2D THEN
        Y23 := FALSE;
        state := 92;
    END_IF;
92:
    Y24 := TRUE;
    state := 93;
93:
    IF X2E THEN
        state := 100;
    END_IF;

(* ---------- accept roll / core ---------- *)
100:
    IF X2D AND X2E AND X1D AND NOT active_roll AND (roll_count <= 3) AND X12 AND X13 THEN
        Y17 := TRUE;
        active_roll := TRUE;
        state := 101;
    END_IF;
101:
    Y17 := FALSE;
    state := 102;
102:
    IF X18 AND X19 THEN
        state := 103;
    END_IF;

(* ---------- mandrel takes over shaft support ---------- *)
103:
    IF active_roll AND NOT X1A THEN
        Y1F := TRUE;
        state := 104;
    END_IF;
104:
    IF X1E THEN
        Y1F := FALSE;
        state := 105;
    END_IF;

105: (* loading support descends *)
    Y1B := TRUE;
    state := 106;
106:
    IF X1F THEN
        state := 107;
    END_IF;

107: (* nip contact *)
    Y18 := TRUE;
    Y19 := TRUE;
    state := 108;
108:
    IF X1B AND X1C THEN
        state := 109;
    END_IF;

109: (* release holds before winding *)
    Y12 := FALSE;
    Y13 := FALSE;
    state := 110;
110:
    IF X24 THEN
        state := 111;
    END_IF;

111: (* wind main length *)
    IF active_roll AND X1E AND X1B AND X1C AND X24 THEN
        Y1A := TRUE;
        state := 112;
    END_IF;
112:
    IF ABS(D5 - D4) <= 2 THEN
        Y1A := FALSE;
        state := 113;
    END_IF;

113: (* re-contact holders before cutting *)
    Y12 := TRUE;
    Y13 := TRUE;
    state := 114;
114:
    IF X14 AND X15 THEN
        state := 115;
    END_IF;

115: (* cut A *)
    IF X14 THEN
        Y1C := TRUE;
        state := 116;
    END_IF;
116:
    Y1C := FALSE;
    state := 117;
117:
    IF X29 THEN
        state := 118;
    END_IF;

118: (* cut B, 80mm apart in device timing *)
    IF X15 THEN
        Y1D := TRUE;
        state := 119;
    END_IF;
119:
    Y1D := FALSE;
    state := 120;
120:
    IF X27 AND X28 THEN
        state := 121;
    END_IF;

121: (* wind separated tail to end without new supply *)
    IF active_roll AND X1E THEN
        Y1A := TRUE;
        state := 122;
    END_IF;
122:
    IF X26 THEN
        Y1A := FALSE;
        state := 123;
    END_IF;

123: (* release holds fully - both connections released *)
    Y12 := FALSE;
    Y13 := FALSE;
    state := 124;
124:
    IF X24 THEN
        state := 125;
    END_IF;

(* ---------- taping ---------- *)
125:
    IF D9 >= 80 THEN
        Y25 := TRUE;
        state := 126;
    END_IF;
126:
    IF X2F THEN
        state := 127;
    END_IF;
127:
    Y26 := TRUE;
    state := 128;
128:
    IF X30 THEN
        state := 129;
    END_IF;
129: (* tape_cut requires prepared 80mm + actual hold contact *)
    IF X2F AND X30 THEN
        Y27 := TRUE;
        state := 130;
    END_IF;
130:
    Y27 := FALSE;
    state := 131;
131:
    IF X31 THEN
        state := 132;
    END_IF;
132: (* tape_apply guarded against every unsafe condition *)
    IF (NOT X32) AND active_roll AND X1E AND (ABS(D5 - D4) <= 2)
       AND X26 AND (D7 = 0) AND (NOT Y1A) AND X30 AND X31 AND (D9 >= 80) THEN
        Y28 := TRUE;
        state := 133;
    END_IF;
133:
    Y28 := FALSE;
    state := 134;
134:
    IF X33 THEN
        state := 135;
    END_IF;

(* ---------- mandrel retract, only with connections released + support ---------- *)
135:
    IF X24 AND X1F AND X33 AND (NOT X32) AND (D7 = 0) THEN
        Y1E := TRUE;
        state := 136;
    END_IF;
136:
    IF X1D THEN
        Y1E := FALSE;
        state := 137;
    END_IF;

(* ---------- eject ---------- *)
137:
    IF X1D AND X1F THEN
        Y20 := TRUE;
        state := 138;
    END_IF;
138:
    Y20 := FALSE;
    state := 139;
139:
    IF X20 THEN
        Y1B := FALSE;
        state := 140;
    END_IF;
140:
    IF X22 THEN
        state := 141;
    END_IF;
141:
    IF X22 THEN
        Y21 := TRUE;
        state := 142;
    END_IF;
142:
    Y21 := FALSE;
    state := 143;

143: (* export via side pusher after exit_clear + receiver_ready *)
    IF X34 AND X35 THEN
        Y29 := TRUE;
        state := 144;
    END_IF;
144:
    release_timer(IN := TRUE, PT := T#1000ms);
    IF release_timer.Q THEN
        Y29 := FALSE;
        release_timer(IN := FALSE, PT := T#1000ms);
        state := 145;
    END_IF;
145:
    IF X34 THEN
        state := 146;
    END_IF;

146: (* roll finished, record id, reset cycle outputs, loop or finish *)
    IF roll_count = 1 THEN
        roll_id_1 := D3;
    ELSIF roll_count = 2 THEN
        roll_id_2 := D3;
    ELSIF roll_count = 3 THEN
        roll_id_3 := D3;
    END_IF;

    active_roll := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y1F := FALSE;
    Y1E := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;
    Y28 := FALSE;
    Y29 := FALSE;

    IF roll_count < 3 THEN
        roll_count := roll_count + 1;
        state := 90;
    ELSE
        state := 200;
    END_IF;

200:
    IF X23 THEN
        state := 201;
    END_IF;

201: (* completion claim, maintained; all process actuators remain off *)
    Y22 := TRUE;
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
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;
    Y28 := FALSE;
    Y29 := FALSE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM