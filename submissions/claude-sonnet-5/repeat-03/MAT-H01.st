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
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT;
    D101 : INT;
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

    (* internal state *)
    step : INT := 0;
    cur_part : INT := 1;
    sel_A : BOOL := TRUE;
    move_seq_counter : INT := 0;
    src_pose : INT;
    cell_pose : INT;
    dest_pose : INT;
    accepted : BOOL;

    (* per-cell feedback helpers *)
    door_open_fb : BOOL;
    door_closed_fb : BOOL;
    clamp_open_fb : BOOL;
    clamp_closed_fb : BOOL;
    cell_busy_fb : BOOL;
    cell_present_fb : BOOL;
    cell_safe_fb : BOOL;
    cell_clear_fb : BOOL;
    cell_done_fb : BOOL;

    a_cycle_edge : R_TRIG;
    b_cycle_edge : R_TRIG;
    measure_edge : R_TRIG;
    outfeed_edge : R_TRIG;
END_VAR

(* ---- compute per-cell selection & feedback ---- *)
IF sel_A THEN
    src_pose := 1;
    cell_pose := 3;
    door_open_fb := X21;
    door_closed_fb := X22;
    clamp_open_fb := X23;
    clamp_closed_fb := X24;
    cell_busy_fb := X20;
    cell_present_fb := X27;
    cell_safe_fb := X26;
    cell_clear_fb := X25;
    cell_done_fb := X1F;
ELSE
    src_pose := 2;
    cell_pose := 4;
    door_open_fb := X2C;
    door_closed_fb := X2D;
    clamp_open_fb := X2E;
    clamp_closed_fb := X2F;
    cell_busy_fb := X2B;
    cell_present_fb := X32;
    cell_safe_fb := X31;
    cell_clear_fb := X30;
    cell_done_fb := X2A;
END_IF;

(* ---- edge-pulsed commands, updated every scan ---- *)
a_cycle_edge(CLK := (step = 118) AND sel_A);
b_cycle_edge(CLK := (step = 118) AND (NOT sel_A));
measure_edge(CLK := (step = 138));
outfeed_edge(CLK := (step = 151) AND accepted);

Y19 := a_cycle_edge.Q;
Y1E := b_cycle_edge.Q;
Y12 := measure_edge.Q;
Y13 := outfeed_edge.Q;

(* ---- main sequencer ---- *)
CASE step OF

0:
    IF X0 THEN
        cur_part := 1;
        sel_A := TRUE;
        step := 100;
    END_IF;

(* --- pick raw part from source --- *)
100:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := src_pose;
    step := 101;
101:
    IF (NOT X10) AND (D0 = src_pose) THEN
        step := 102;
    END_IF;

102:
    Y11 := FALSE;
    Y10 := TRUE;
    step := 103;
103:
    IF X12 AND X13 THEN
        step := 104;
    END_IF;

(* --- open door of target cell --- *)
104:
    IF sel_A THEN
        Y15 := TRUE; Y16 := FALSE;
    ELSE
        Y1A := TRUE; Y1B := FALSE;
    END_IF;
    step := 105;
105:
    IF door_open_fb THEN
        IF sel_A THEN Y15 := FALSE; ELSE Y1A := FALSE; END_IF;
        step := 106;
    END_IF;

(* --- open clamp of target cell --- *)
106:
    IF sel_A THEN
        Y18 := TRUE; Y17 := FALSE;
    ELSE
        Y1D := TRUE; Y1C := FALSE;
    END_IF;
    step := 107;
107:
    IF clamp_open_fb AND cell_safe_fb THEN
        IF sel_A THEN Y18 := FALSE; ELSE Y1D := FALSE; END_IF;
        step := 108;
    END_IF;

(* --- move into cell and load part --- *)
108:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := cell_pose;
    step := 109;
109:
    IF (NOT X10) AND (D0 = cell_pose) THEN
        step := 110;
    END_IF;

110:
    Y10 := FALSE;
    Y11 := TRUE;
    step := 111;
111:
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 112;
    END_IF;

(* --- retrieve robot before closing door --- *)
112:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := 0;
    step := 113;
113:
    IF (NOT X10) AND (D0 = 0) AND cell_clear_fb THEN
        step := 114;
    END_IF;

(* --- close door --- *)
114:
    IF sel_A THEN
        Y16 := TRUE; Y15 := FALSE;
    ELSE
        Y1B := TRUE; Y1A := FALSE;
    END_IF;
    step := 115;
115:
    IF door_closed_fb THEN
        IF sel_A THEN Y16 := FALSE; ELSE Y1B := FALSE; END_IF;
        step := 116;
    END_IF;

(* --- close clamp --- *)
116:
    IF sel_A THEN
        Y17 := TRUE; Y18 := FALSE;
    ELSE
        Y1C := TRUE; Y1D := FALSE;
    END_IF;
    step := 117;
117:
    IF clamp_closed_fb AND cell_present_fb AND (NOT cell_busy_fb) THEN
        IF sel_A THEN Y17 := FALSE; ELSE Y1C := FALSE; END_IF;
        step := 118;
    END_IF;

(* --- start machining cycle (pulse fired above) --- *)
118:
    step := 120;

120:
    IF cell_done_fb THEN
        step := 122;
    END_IF;

(* --- open clamp to unload --- *)
122:
    IF sel_A THEN
        Y18 := TRUE; Y17 := FALSE;
    ELSE
        Y1D := TRUE; Y1C := FALSE;
    END_IF;
    step := 123;
123:
    IF clamp_open_fb THEN
        IF sel_A THEN Y18 := FALSE; ELSE Y1D := FALSE; END_IF;
        step := 124;
    END_IF;

(* --- open door to unload --- *)
124:
    IF sel_A THEN
        Y15 := TRUE; Y16 := FALSE;
    ELSE
        Y1A := TRUE; Y1B := FALSE;
    END_IF;
    step := 125;
125:
    IF door_open_fb AND cell_safe_fb THEN
        IF sel_A THEN Y15 := FALSE; ELSE Y1A := FALSE; END_IF;
        step := 126;
    END_IF;

(* --- move in and pick finished part --- *)
126:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := cell_pose;
    step := 127;
127:
    IF (NOT X10) AND (D0 = cell_pose) THEN
        step := 128;
    END_IF;

128:
    Y11 := FALSE;
    Y10 := TRUE;
    step := 129;
129:
    IF X12 AND X13 THEN
        step := 130;
    END_IF;

(* --- move to inspection and place part --- *)
130:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := 5;
    step := 131;
131:
    IF (NOT X10) AND (D0 = 5) THEN
        step := 132;
    END_IF;

132:
    IF NOT X14 THEN
        step := 134;
    END_IF;

134:
    Y10 := FALSE;
    Y11 := TRUE;
    step := 135;
135:
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 136;
    END_IF;

(* --- retrieve robot before starting inspection --- *)
136:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := 0;
    step := 137;
137:
    IF (NOT X10) AND (D0 = 0) THEN
        step := 138;
    END_IF;

(* --- start measurement (pulse fired above) --- *)
138:
    step := 140;

140:
    IF X16 THEN
        step := 142;
    END_IF;

(* --- decide accept/reject and target --- *)
142:
    accepted := (D4 >= 5800) AND (D4 <= 6200) AND (D5 >= 5800) AND (D5 <= 6200);
    IF accepted THEN
        dest_pose := 7;
    ELSE
        IF NOT X34 THEN
            dest_pose := 8;
        ELSIF NOT X35 THEN
            dest_pose := 9;
        ELSIF NOT X36 THEN
            dest_pose := 10;
        ELSE
            dest_pose := 11;
        END_IF;
    END_IF;
    step := 143;

(* --- go pick measured part --- *)
143:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := 5;
    step := 144;
144:
    IF (NOT X10) AND (D0 = 5) THEN
        step := 145;
    END_IF;

145:
    Y11 := FALSE;
    Y10 := TRUE;
    step := 146;
146:
    IF X12 AND X13 THEN
        step := 147;
    END_IF;

(* --- deliver to destination --- *)
147:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := dest_pose;
    step := 148;
148:
    IF (NOT X10) AND (D0 = dest_pose) AND ((NOT accepted) OR X19) THEN
        step := 149;
    END_IF;

149:
    Y10 := FALSE;
    Y11 := TRUE;
    step := 150;
150:
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 151;
    END_IF;

(* --- convey away if accepted (pulse fired above) --- *)
151:
    IF accepted THEN
        step := 152;
    ELSE
        step := 160;
    END_IF;

152:
    IF X19 THEN
        step := 160;
    END_IF;

(* --- return robot home --- *)
160:
    move_seq_counter := move_seq_counter + 1;
    D101 := move_seq_counter;
    D100 := 0;
    step := 161;
161:
    IF (NOT X10) AND (D0 = 0) THEN
        step := 162;
    END_IF;

162:
    cur_part := cur_part + 1;
    IF cur_part > 4 THEN
        step := 999;
    ELSE
        IF cur_part <= 2 THEN
            sel_A := TRUE;
        ELSE
            sel_A := FALSE;
        END_IF;
        step := 100;
    END_IF;

999:
    Y14 := TRUE;

END_CASE;

END_PROGRAM