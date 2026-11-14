PROGRAM Main
VAR
    src_edge : R_TRIG;
    exit_clear_edge : R_TRIG;
    exit_recv_edge : R_TRIG;
    comp_timer : TON;
    
    st1 : INT := 0;
    st2 : INT := 17;
    pos1 : INT := 0;
    pos2 : INT := 4;
    gen1 : INT;
    gen2 : INT;
    insp1 : BOOL := FALSE;
    insp2 : BOOL := FALSE;
    
    p_admit : BOOL := FALSE;
    p_inspect : BOOL := FALSE;
    p_detach : BOOL := FALSE;
    p_move : BOOL := FALSE;
    p_ack : BOOL := FALSE;
    p_lup : BOOL := FALSE;
    p_ldn : BOOL := FALSE;
    p_rup : BOOL := FALSE;
    p_rdn : BOOL := FALSE;
    
    tgt_jig : INT;
    tgt_pos : INT;
    out_gen : INT;
    done_cnt : INT := 0;
    compl : BOOL := FALSE;
    
    f1_up : BOOL := FALSE;
    f1_dn : BOOL := FALSE;
    f2_up : BOOL := FALSE;
    f2_dn : BOOL := FALSE;
END_VAR

src_edge(CLK := X10);
exit_clear_edge(CLK := X15);
exit_recv_edge(CLK := X16);

IF exit_recv_edge.Q THEN
    p_ack := TRUE;
    done_cnt := done_cnt + 1;
END_IF;

IF p_admit THEN p_admit := FALSE; END_IF;
IF p_inspect THEN p_inspect := FALSE; END_IF;
IF p_detach THEN p_detach := FALSE; END_IF;
IF p_move THEN p_move := FALSE; END_IF;
IF p_ack THEN p_ack := FALSE; END_IF;
IF p_lup THEN p_lup := FALSE; END_IF;
IF p_ldn THEN p_ldn := FALSE; END_IF;
IF p_rup THEN p_rup := FALSE; END_IF;
IF p_rdn THEN p_rdn := FALSE; END_IF;

CASE st1 OF
    0: IF src_edge.Q AND NOT f1_up THEN p_lup := TRUE; f1_up := TRUE; END_IF;
       IF src_edge.Q THEN p_admit := TRUE; st1 := 1; END_IF;
    1: IF NOT X12 THEN st1 := 2; END_IF;
    2: IF NOT X11 AND NOT p_move THEN tgt_jig := 101; tgt_pos := 1; p_move := TRUE;
          IF NOT f1_dn THEN p_ldn := TRUE; f1_dn := TRUE; END_IF; st1 := 3; END_IF;
    3: IF NOT X11 THEN pos1 := 1; st1 := 4; END_IF;
    4: IF D6 > 0 AND NOT X14 AND NOT insp1 THEN gen1 := D8; p_inspect := TRUE; out_gen := gen1; insp1 := TRUE; st1 := 5; END_IF;
    5: IF NOT X14 THEN st1 := 6; END_IF;
    6: IF NOT X11 AND NOT p_move THEN tgt_jig := 101; tgt_pos := 2; p_move := TRUE; st1 := 7; END_IF;
    7: IF NOT X11 THEN pos1 := 2; st1 := 8; END_IF;
    8: IF X15 AND insp1 AND NOT X13 THEN p_detach := TRUE; st1 := 9; END_IF;
    9: IF NOT X13 THEN insp1 := FALSE; st1 := 10; END_IF;
    10: IF NOT X11 AND NOT p_move THEN tgt_jig := 101; tgt_pos := 3; p_move := TRUE; st1 := 11; END_IF;
    11: IF NOT X11 THEN pos1 := 3; st1 := 12; END_IF;
    12: IF NOT f2_up THEN p_rup := TRUE; f2_up := TRUE; END_IF; st1 := 13;
    13: IF NOT X11 AND NOT p_move THEN tgt_jig := 101; tgt_pos := 4; p_move := TRUE; st1 := 14; END_IF;
    14: IF NOT X11 THEN pos1 := 4; st1 := 15; END_IF;
    15: IF NOT f2_dn THEN p_rdn := TRUE; f2_dn := TRUE; END_IF; st1 := 16;
    16: IF NOT X11 AND NOT p_move THEN tgt_jig := 101; tgt_pos := 0; p_move := TRUE;
          f1_up := FALSE; f1_dn := FALSE; f2_up := FALSE; f2_dn := FALSE; st1 := 17; END_IF;
    17: IF NOT X11 THEN pos1 := 0; st1 := 0; END_IF;
END_CASE;

CASE st2 OF
    17: IF NOT X11 AND NOT p_move THEN tgt_jig := 102; tgt_pos := 0; p_move := TRUE; st2 := 18; END_IF;
    18: IF NOT X11 THEN pos2 := 0; st2 := 0; END_IF;
    0: IF src_edge.Q AND NOT f1_up THEN p_lup := TRUE; f1_up := TRUE; END_IF;
       IF src_edge.Q THEN p_admit := TRUE; st2 := 1; END_IF;
    1: IF NOT X12 THEN st2 := 2; END_IF;
    2: IF NOT X11 AND NOT p_move THEN tgt_jig := 102; tgt_pos := 1; p_move := TRUE;
          IF NOT f1_dn THEN p_ldn := TRUE; f1_dn := TRUE; END_IF; st2 := 3; END_IF;
    3: IF NOT X11 THEN pos2 := 1; st2 := 4; END_IF;
    4: IF D6 > 0 AND NOT X14 AND NOT insp2 THEN gen2 := D8; p_inspect := TRUE; out_gen := gen2; insp2 := TRUE; st2 := 5; END_IF;
    5: IF NOT X14 THEN st2 := 6; END_IF;
    6: IF NOT X11 AND NOT p_move THEN tgt_jig := 102; tgt_pos := 2; p_move := TRUE; st2 := 7; END_IF;
    7: IF NOT X11 THEN pos2 := 2; st2 := 8; END_IF;
    8: IF X15 AND insp2 AND NOT X13 THEN p_detach := TRUE; st2 := 9; END_IF;
    9: IF NOT X13 THEN insp2 := FALSE; st2 := 10; END_IF;
    10: IF NOT X11 AND NOT p_move THEN tgt_jig := 102; tgt_pos := 3; p_move := TRUE; st2 := 11; END_IF;
    11: IF NOT X11 THEN pos2 := 3; st2 := 12; END_IF;
    12: IF NOT f2_up THEN p_rup := TRUE; f2_up := TRUE; END_IF; st2 := 13;
    13: IF NOT X11 AND NOT p_move THEN tgt_jig := 102; tgt_pos := 4; p_move := TRUE; st2 := 14; END_IF;
    14: IF NOT X11 THEN pos2 := 4; st2 := 15; END_IF;
    15: IF NOT f2_dn THEN p_rdn := TRUE; f2_dn := TRUE; END_IF; st2 := 16;
    16: IF NOT X11 AND NOT p_move THEN tgt_jig := 102; tgt_pos := 0; p_move := TRUE;
          f1_up := FALSE; f1_dn := FALSE; f2_up := FALSE; f2_dn := FALSE; st2 := 17; END_IF;
END_CASE;

IF done_cnt >= 6 AND st1 = 0 AND st2 = 0 AND NOT X11 AND NOT X12 AND NOT X13 AND NOT X14 THEN
    compl := TRUE;
    comp_timer(IN := TRUE, PT := T#500ms);
ELSE
    compl := FALSE;
    comp_timer(IN := FALSE, PT := T#500ms);
END_IF;

Y10 := p_admit;
Y11 := p_inspect;
Y12 := p_detach;
Y13 := p_move;
Y14 := p_lup;
Y15 := p_ldn;
Y16 := p_rup;
Y17 := p_rdn;
Y18 := p_ack;
Y19 := compl;
D200 := tgt_jig;
D201 := tgt_pos;
D202 := out_gen;

END_PROGRAM