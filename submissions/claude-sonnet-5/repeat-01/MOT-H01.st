PROGRAM Main
VAR
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D20 : DINT;
    D21 : DINT;
    D100 : DINT;
    X30 : BOOL;
    X32 : BOOL;
    D104 : DINT;
    D103 : DINT;
    D110 : DINT;
    X31 : BOOL;
    X33 : BOOL;
    D114 : DINT;
    D113 : DINT;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    D93 : DINT;
    D94 : DINT;
    D95 : DINT;
    D96 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    X54 : BOOL;
    X55 : BOOL;
    X56 : BOOL;
    X57 : BOOL;
    D150 : DINT;
    D151 : DINT;
    D200 : DINT;
    D201 : DINT;
    Y20 : BOOL;
    D204 : DINT;
    D205 : DINT;
    Y21 : BOOL;
    D208 : DINT;
    D209 : DINT;
    Y22 : BOOL;
    D212 : DINT;
    D213 : DINT;
    Y23 : BOOL;
    D216 : DINT;
    D217 : DINT;
    Y24 : BOOL;
    D220 : DINT;
    D221 : DINT;
    Y25 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y2 : BOOL;

    (* internal *)
    tol_pos : DINT := 20;      (* 0.2 mm in x0.01 units *)
    tol_spd : DINT := 100;     (* 1 mm/s in x0.01 units *)
    connect_height : DINT := 73250;
    fork_retract_pos : DINT := 0;
    fork_connect_pos : DINT := 18000;
    port_a : DINT := -90000;
    port_b : DINT := -35000;
    port_standby : DINT := 15000;
    port_table : DINT := 85000;
    slide_home : DINT := 5000;
    slide_rot_limit : DINT := 50000;

    active : DINT := 0;
    cstate : DINT := 0;
    seq_ctr : DINT := 0;
    ack_id0 : DINT := 0;
    ack_id1 : DINT := 0;

    sel_port : DINT;
    sel_station : DINT;
    sel_lift_pos : DINT;
    sel_lift_vel : DINT;
    sel_home : DINT;
    sel_req_id : DINT;
    sel_loc : DINT;
    sel_ready : BOOL;
    sel_served : BOOL;
    sel_returned : BOOL;

    lift_cmd : DINT;

    a_t : DINT;
    b_t : DINT;
    e_t : DINT;
    f_t : DINT;

    cond_final : BOOL;
    final_tmr : TON;
END_VAR

(* --------- select next active request --------- *)
IF active = 0 THEN
    IF D100 <> 0 AND D100 <> ack_id0 THEN
        active := 1;
        cstate := 10;
    ELSIF D110 <> 0 AND D110 <> ack_id1 THEN
        active := 2;
        cstate := 10;
    END_IF;
END_IF;

(* --------- compute selection variables --------- *)
IF active = 1 THEN
    sel_port := port_a;
    sel_station := 1;
    sel_lift_pos := D14;
    sel_lift_vel := D15;
    sel_home := D150;
    sel_req_id := D100;
    sel_loc := D104;
    sel_ready := X54;
    sel_served := X30;
    sel_returned := X32;
ELSIF active = 2 THEN
    sel_port := port_b;
    sel_station := 2;
    sel_lift_pos := D16;
    sel_lift_vel := D17;
    sel_home := D151;
    sel_req_id := D110;
    sel_loc := D114;
    sel_ready := X55;
    sel_served := X31;
    sel_returned := X33;
ELSE
    sel_port := 0;
    sel_station := 0;
    sel_lift_pos := 0;
    sel_lift_vel := 0;
    sel_home := 0;
    sel_req_id := 0;
    sel_loc := -1;
    sel_ready := FALSE;
    sel_served := FALSE;
    sel_returned := FALSE;
END_IF;

(* default hold values *)
a_t := 0;
b_t := 0;
e_t := 0;
f_t := slide_home;

CASE cstate OF

0:
    a_t := 0; b_t := 0; e_t := 0; f_t := slide_home;

10:
    a_t := 0; b_t := 0; e_t := 0; f_t := slide_home;
    IF sel_ready THEN
        cstate := 20;
    END_IF;

20:
    a_t := sel_port; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF ABS(D10 - sel_port) <= tol_pos AND ABS(D11) <= tol_spd AND D12 <= tol_pos AND ABS(D13) <= tol_spd AND sel_ready THEN
        cstate := 30;
    END_IF;

30:
    a_t := sel_port; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    IF ABS(D12 - fork_connect_pos) <= tol_pos AND ABS(D13) <= tol_spd AND sel_ready THEN
        cstate := 40;
    END_IF;

40:
    a_t := sel_port; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    D80 := 1; D81 := sel_station; seq_ctr := seq_ctr + 1; D82 := seq_ctr;
    cstate := 45;

45:
    a_t := sel_port; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    IF sel_loc = 0 THEN
        cstate := 50;
    END_IF;

50:
    a_t := sel_port; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF D12 <= tol_pos AND ABS(D13) <= tol_spd THEN
        cstate := 60;
    END_IF;

60:
    a_t := port_table; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF ABS(D10 - port_table) <= tol_pos AND ABS(D11) <= tol_spd THEN
        cstate := 70;
    END_IF;

70:
    a_t := port_table; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    IF ABS(D12 - fork_connect_pos) <= tol_pos AND ABS(D13) <= tol_spd AND X57 THEN
        cstate := 80;
    END_IF;

80:
    a_t := port_table; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    D80 := 2; D81 := 4; seq_ctr := seq_ctr + 1; D82 := seq_ctr;
    cstate := 85;

85:
    a_t := port_table; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    IF sel_loc = 4 THEN
        cstate := 90;
    END_IF;

90:
    a_t := port_table; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF D12 <= tol_pos AND ABS(D13) <= tol_spd THEN
        cstate := 100;
    END_IF;

100:
    a_t := port_standby; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF ABS(D10 - port_standby) <= tol_pos AND ABS(D11) <= tol_spd AND D12 <= tol_pos AND D20 <= slide_rot_limit THEN
        cstate := 110;
    END_IF;

110:
    a_t := port_standby; b_t := fork_retract_pos; e_t := D94; f_t := slide_home;
    IF X53 THEN
        cstate := 120;
    END_IF;

120:
    a_t := port_standby; b_t := fork_retract_pos; e_t := D94; f_t := D95;
    IF sel_served THEN
        cstate := 130;
    END_IF;

130:
    a_t := port_standby; b_t := fork_retract_pos; e_t := D94; f_t := slide_home;
    IF ABS(D20 - slide_home) <= tol_pos AND ABS(D21) <= tol_spd THEN
        cstate := 140;
    END_IF;

140:
    a_t := port_standby; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF X56 THEN
        cstate := 150;
    END_IF;

150:
    a_t := port_table; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF ABS(D10 - port_table) <= tol_pos AND ABS(D11) <= tol_spd THEN
        cstate := 160;
    END_IF;

160:
    a_t := port_table; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    IF ABS(D12 - fork_connect_pos) <= tol_pos AND ABS(D13) <= tol_spd THEN
        cstate := 170;
    END_IF;

170:
    a_t := port_table; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    D80 := 1; D81 := 4; seq_ctr := seq_ctr + 1; D82 := seq_ctr;
    cstate := 175;

175:
    a_t := port_table; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    IF sel_loc = 0 THEN
        cstate := 180;
    END_IF;

180:
    a_t := port_table; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF D12 <= tol_pos AND ABS(D13) <= tol_spd THEN
        cstate := 190;
    END_IF;

190:
    a_t := sel_port; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF ABS(D10 - sel_port) <= tol_pos AND ABS(D11) <= tol_spd AND sel_ready THEN
        cstate := 200;
    END_IF;

200:
    a_t := sel_port; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    IF ABS(D12 - fork_connect_pos) <= tol_pos AND ABS(D13) <= tol_spd AND sel_ready THEN
        cstate := 210;
    END_IF;

210:
    a_t := sel_port; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    D80 := 2; D81 := sel_station; seq_ctr := seq_ctr + 1; D82 := seq_ctr;
    cstate := 215;

215:
    a_t := sel_port; b_t := fork_connect_pos; e_t := 0; f_t := slide_home;
    IF sel_loc = sel_station THEN
        cstate := 220;
    END_IF;

220:
    a_t := sel_port; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF D12 <= tol_pos AND ABS(D13) <= tol_spd THEN
        cstate := 230;
    END_IF;

230:
    a_t := sel_port; b_t := fork_retract_pos; e_t := 0; f_t := slide_home;
    IF ABS(sel_lift_pos - sel_home) <= tol_pos AND ABS(sel_lift_vel) <= tol_spd AND sel_returned THEN
        cstate := 240;
    END_IF;

240:
    a_t := 0; b_t := 0; e_t := 0; f_t := slide_home;
    IF active = 1 THEN
        D300 := sel_req_id;
        D301 := 1;
        ack_id0 := sel_req_id;
    ELSIF active = 2 THEN
        D302 := sel_req_id;
        D303 := 1;
        ack_id1 := sel_req_id;
    END_IF;
    active := 0;
    cstate := 0;

ELSE
    cstate := 0;

END_CASE;

(* --------- lift command depending on phase --------- *)
IF cstate = 0 OR cstate >= 230 THEN
    lift_cmd := sel_home;
ELSE
    lift_cmd := connect_height;
END_IF;

Y22 := TRUE;
Y23 := TRUE;
D209 := 1000;
D213 := 1000;

IF active = 1 THEN
    D208 := lift_cmd;
    D212 := D151;
ELSIF active = 2 THEN
    D212 := lift_cmd;
    D208 := D150;
ELSE
    D208 := D150;
    D212 := D151;
END_IF;

(* --------- write shuttle/fork/table/slide outputs --------- *)
D200 := a_t; D201 := 1000; Y20 := TRUE;
D204 := b_t; D205 := 1000; Y21 := TRUE;
D216 := e_t; D217 := 1000; Y24 := TRUE;
D220 := f_t; D221 := 1000; Y25 := TRUE;

(* --------- final completion maintenance --------- *)
cond_final := X51
    AND (ABS(D10) <= tol_pos) AND (ABS(D11) <= tol_spd)
    AND (D12 <= tol_pos) AND (ABS(D13) <= tol_spd)
    AND (ABS(D18) <= tol_pos) AND (ABS(D19) <= tol_spd)
    AND (ABS(D20 - slide_home) <= tol_pos) AND (ABS(D21) <= tol_spd)
    AND (ABS(D14 - D150) <= tol_pos) AND (ABS(D15) <= tol_spd)
    AND (ABS(D16 - D151) <= tol_pos) AND (ABS(D17) <= tol_spd)
    AND (D90 = 0) AND (D91 = 0) AND (D92 = 0);

final_tmr(IN := cond_final, PT := T#100ms);

IF final_tmr.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM