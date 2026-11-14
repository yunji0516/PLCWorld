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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
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
    Y1F : BOOL;
    
    edge_pitch : R_TRIG;
    edge_exit : R_TRIG;
    edge_rec_done : R_TRIG;
    edge_waste : R_TRIG;
    edge_empty_core : R_TRIG;
    edge_rec_avail : R_TRIG;
    
    timer_cut_delay : TON;
    timer_edge_hold : TON;
    timer_thread : TON;
    timer_complete : TON;
    
    state : INT := 0;
    pitch_processed : INT := 0;
    rec_batch : INT := 0;
    rec_ack_done : BOOL := FALSE;
    in_waste_exchange : BOOL := FALSE;
END_VAR

edge_pitch(CLK := X10);
edge_exit(CLK := X1A);
edge_rec_done(CLK := X1D);
edge_waste(CLK := X21);
edge_empty_core(CLK := X25);
edge_rec_avail(CLK := X1B);

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
Y21 := FALSE;
Y22 : BOOL := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
D200 := 0;

CASE state OF
0: (* IDLE - wait for start *)
    IF X0 THEN
        state := 10;
    END_IF;

10: (* ACCEPT_PITCH *)
    IF edge_pitch.Q AND pitch_processed < 6 AND NOT X18 THEN
        Y10 := TRUE;
        state := 20;
    END_IF;

20: (* FEED *)
    Y10 := FALSE;
    Y11 := TRUE;
    IF NOT X11 AND D2 >= 300 THEN
        Y11 := FALSE;
        pitch_processed := pitch_processed + 1;
        state := 30;
    END_IF;

30: (* CLAMP *)
    Y12 := TRUE;
    timer_cut_delay(IN := TRUE, PT := T#2s);
    IF timer_cut_delay.Q THEN
        state := 40;
    END_IF;

40: (* CUT *)
    D200 := 15;
    Y13 := TRUE;
    timer_cut_delay(IN := FALSE);
    state := 41;

41: (* CUT_RELEASE *)
    Y13 := FALSE;
    D200 := 0;
    IF X14 AND NOT X18 THEN
        state := 50;
    END_IF;

50: (* PICKUP *)
    Y14 := TRUE;
    IF X16 THEN
        state := 60;
    END_IF;

60: (* BED_LOW *)
    Y15 := TRUE;
    IF X17 THEN
        state := 70;
    END_IF;

70: (* WAIT_HEAD_RETURN *)
    Y14 := FALSE;
    Y15 := FALSE;
    IF NOT X18 THEN
        state := 80;
    END_IF;

80: (* TRANSFER *)
    Y16 := TRUE;
    IF X1A AND NOT X18 THEN
        Y1A := TRUE;
        state := 81;
    END_IF;

81: (* TRANSFER_ACK_WAIT *)
    Y1A := FALSE;
    Y16 := FALSE;
    IF NOT X18 THEN
        state := 90;
    END_IF;

90: (* RECOVERY_OR_COMPLETE *)
    IF in_waste_exchange THEN
        in_waste_exchange := FALSE;
    END_IF;
    
    IF X21 AND pitch_processed > 0 THEN
        in_waste_exchange := TRUE;
        state := 300;
    ELSIF X1B AND rec_batch < 4 THEN
        state := 100;
    ELSIF pitch_processed >= 6 AND rec_batch >= 4 THEN
        state := 200;
    END_IF;

100: (* RECOVERY_ACCEPT *)
    Y17 := TRUE;
    Y18 := TRUE;
    state := 110;

110: (* RECOVERY_ACTIVE *)
    Y17 := FALSE;
    IF edge_rec_done.Q THEN
        Y19 := TRUE;
        state := 120;
    END_IF;

120: (* RECOVERY_ACK *)
    Y19 := FALSE;
    rec_batch := rec_batch + 1;
    state := 90;

300: (* WASTE_HOLD *)
    Y18 := FALSE;
    Y17 := FALSE;
    Y1C := TRUE;
    timer_edge_hold(IN := TRUE, PT := T#0.3s);
    IF timer_edge_hold.Q THEN
        state := 310;
    END_IF;

310: (* CUT_EDGES *)
    Y1D := TRUE;
    Y1E := TRUE;
    IF X23 THEN
        Y1D := FALSE;
        Y1E := FALSE;
        state := 320;
    END_IF;

320: (* UNLOAD_REEL *)
    Y1F := TRUE;
    IF NOT X24 THEN
        Y1F := FALSE;
        state := 330;
    END_IF;

330: (* WAIT_EMPTY_CORE *)
    IF edge_empty_core.Q OR X25 THEN
        state := 340;
    END_IF;

340: (* LOAD_CORE *)
    Y20 := TRUE;
    IF X26 THEN
        Y20 := FALSE;
        state := 350;
    END_IF;

350: (* THREAD_LEFT *)
    Y21 := TRUE;
    timer_thread(IN := TRUE, PT := T#1500ms);
    IF X27 OR timer_thread.Q THEN
        Y21 := FALSE;
        state := 360;
    END_IF;

360: (* THREAD_RIGHT *)
    Y22 := TRUE;
    timer_thread(IN := TRUE, PT := T#1500ms);
    IF X28 OR timer_thread.Q THEN
        Y22 := FALSE;
        state := 370;
    END_IF;

370: (* RECONNECT *)
    Y1C := FALSE;
    in_waste_exchange := FALSE;
    state := 90;

200: (* COMPLETE *)
    timer_complete(IN := TRUE, PT := T#500ms);
    IF timer_complete.Q THEN
        Y1B := TRUE;
    END_IF;

END_CASE;

END_PROGRAM