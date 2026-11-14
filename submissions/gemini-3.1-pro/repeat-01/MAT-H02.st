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
    Y20 : BOOL;
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
    D16 : INT;
    D200 : INT;
    D201 : INT;
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

    deck_state : INT := 0;
    next_op : INT := 0;
    a_state : INT := 0;
    b_state : INT := 0;
    box_state : INT := 0;
    pack_state : INT := 0;
    
    dock_req : BOOL := FALSE;
    load_req : BOOL := FALSE;
    unload_req : BOOL := FALSE;
    accept_a_req : BOOL := FALSE;
    accept_b_req : BOOL := FALSE;
    close_a_req : BOOL := FALSE;
    close_b_req : BOOL := FALSE;
    release_a_req : BOOL := FALSE;
    release_b_req : BOOL := FALSE;
    ack_a_req : BOOL := FALSE;
    ack_b_req : BOOL := FALSE;
    dispatch_req : BOOL := FALSE;
    pack_a_req : BOOL := FALSE;
    pack_b_req : BOOL := FALSE;
    
    a_pack_started : BOOL := FALSE;
    b_pack_started : BOOL := FALSE;
    boxes_dispatched : INT := 0;
    
    dock_trig : R_TRIG;
    load_trig : R_TRIG;
    unload_trig : R_TRIG;
    accept_a_trig : R_TRIG;
    accept_b_trig : R_TRIG;
    close_a_trig : R_TRIG;
    close_b_trig : R_TRIG;
    release_a_trig : R_TRIG;
    release_b_trig : R_TRIG;
    ack_a_trig : R_TRIG;
    ack_b_trig : R_TRIG;
    dispatch_trig : R_TRIG;
    pack_a_trig : R_TRIG;
    pack_b_trig : R_TRIG;
    
    deck_wait_timer : TON;
    clamp_timer : TON;
    pack_wait_timer : TON;
END_VAR

(* ---------------- DECK LOGIC ---------------- *)
CASE deck_state OF
0:
    dock_req := FALSE;
    load_req := FALSE;
    unload_req := FALSE;
    deck_wait_timer(IN := FALSE, PT := T#50ms);
    
    IF D2 > 0 THEN // Deck loaded
        IF X15 AND D13 < 2 AND D11 = D2 THEN
            D200 := 4;
            D201 := D9; // a_generation
            next_op := 2; // unload
            deck_state := 5;
        ELSIF X16 AND D14 < 2 AND D12 = D2 THEN
            D200 := 5;
            D201 := D10; // b_generation
            next_op := 2;
            deck_state := 5;
        ELSIF D6 = 0 THEN // storage 0 empty
            D200 := 2;
            next_op := 2;
            deck_state := 5;
        ELSIF D8 = 0 THEN // storage 1 empty
            D200 := 3;
            next_op := 2;
            deck_state := 5;
        END_IF;
    ELSE // Deck empty
        IF D6 > 0 AND ((X15 AND D13 < 2 AND D11 = D6) OR (X16 AND D14 < 2 AND D12 = D6)) THEN
            D200 := 2;
            next_op := 1; // load
            deck_state := 5;
        ELSIF D8 > 0 AND ((X15 AND D13 < 2 AND D11 = D8) OR (X16 AND D14 < 2 AND D12 = D8)) THEN
            D200 := 3;
            next_op := 1; // load
            deck_state := 5;
        ELSIF X10 AND D4 > 0 THEN // Inbound ready
            IF (X15 AND D13 < 2 AND D11 = D4) OR (X16 AND D14 < 2 AND D12 = D4) OR D6 = 0 OR D8 = 0 THEN
                D200 := 1;
                next_op := 1; // load
                deck_state := 5;
            END_IF;
        END_IF;
    END_IF;

5:
    dock_req := TRUE;
    deck_wait_timer(IN := TRUE, PT := T#50ms);
    IF deck_wait_timer.Q AND D0 = D200 AND NOT X11 THEN
        deck_state := 10;
    END_IF;

10:
    dock_req := FALSE;
    deck_wait_timer(IN := FALSE, PT := T#50ms);
    IF next_op = 1 THEN
        load_req := TRUE;
        deck_state := 20;
    ELSE
        unload_req := TRUE;
        deck_state := 30;
    END_IF;

20:
    load_req := FALSE;
    deck_wait_timer(IN := TRUE, PT := T#50ms);
    IF deck_wait_timer.Q AND D2 > 0 AND X12 AND NOT X11 THEN
        deck_wait_timer(IN := FALSE, PT := T#50ms);
        deck_state := 0;
    END_IF;

30:
    unload_req := FALSE;
    deck_wait_timer(IN := TRUE, PT := T#50ms);
    IF deck_wait_timer.Q AND D2 = 0 AND NOT X11 THEN
        deck_wait_timer(IN := FALSE, PT := T#50ms);
        deck_state := 0;
    END_IF;
END_CASE;


(* ---------------- ORDER A LOGIC ---------------- *)
CASE a_state OF
0:
    IF X13 THEN 
        accept_a_req := TRUE; 
        a_state := 10; 
    END_IF;
10:
    accept_a_req := FALSE;
    IF X15 THEN a_state := 20; END_IF;
20:
    IF D13 = 2 THEN 
        close_a_req := TRUE; 
        a_state := 30; 
    END_IF;
30:
    close_a_req := FALSE;
    IF X17 THEN a_state := 40; END_IF;
40:
    IF X19 THEN 
        release_a_req := TRUE; 
        a_state := 50; 
    END_IF;
50:
    release_a_req := FALSE;
    IF X1B THEN a_state := 60; END_IF;
60:
    IF X22 THEN 
        ack_a_req := TRUE; 
        a_state := 70; 
    END_IF;
70:
    ack_a_req := FALSE;
    IF NOT X15 THEN
        a_state := 0;
    ELSIF NOT X22 THEN
        a_state := 20;
    END_IF;
END_CASE;


(* ---------------- ORDER B LOGIC ---------------- *)
CASE b_state OF
0:
    IF X14 THEN 
        accept_b_req := TRUE; 
        b_state := 10; 
    END_IF;
10:
    accept_b_req := FALSE;
    IF X16 THEN b_state := 20; END_IF;
20:
    IF D14 = 2 THEN 
        close_b_req := TRUE; 
        b_state := 30; 
    END_IF;
30:
    close_b_req := FALSE;
    IF X18 THEN b_state := 40; END_IF;
40:
    IF X1A THEN 
        release_b_req := TRUE; 
        b_state := 50; 
    END_IF;
50:
    release_b_req := FALSE;
    IF X1C THEN b_state := 60; END_IF;
60:
    IF X23 THEN 
        ack_b_req := TRUE; 
        b_state := 70; 
    END_IF;
70:
    ack_b_req := FALSE;
    IF NOT X16 THEN
        b_state := 0;
    ELSIF NOT X23 THEN
        b_state := 20;
    END_IF;
END_CASE;


(* ---------------- BOX & PACKING LOGIC ---------------- *)
CASE box_state OF
0:
    a_pack_started := FALSE;
    b_pack_started := FALSE;
    IF X1F THEN box_state := 10; END_IF;
10:
    clamp_timer(IN := TRUE, PT := T#300ms);
    IF clamp_timer.Q THEN box_state := 20; END_IF;
20:
    clamp_timer(IN := FALSE, PT := T#300ms);
    IF X24 THEN box_state := 30; END_IF;
30:
    IF NOT X20 AND X25 THEN
        dispatch_req := TRUE;
        box_state := 40;
    END_IF;
40:
    dispatch_req := FALSE;
    IF NOT X1F THEN 
        box_state := 0; 
        boxes_dispatched := boxes_dispatched + 1;
    END_IF;
END_CASE;

Y1C := (box_state = 0);
Y1D := (box_state = 10 OR box_state = 20);

CASE pack_state OF
0:
    pack_wait_timer(IN := FALSE, PT := T#200ms);
    IF a_state = 60 AND D16 = D9 AND X1B AND box_state = 20 AND NOT X21 AND NOT a_pack_started THEN
        pack_a_req := TRUE;
        a_pack_started := TRUE;
        pack_state := 10;
    ELSIF b_state = 60 AND D16 = D10 AND X1C AND box_state = 20 AND NOT X21 AND NOT b_pack_started THEN
        pack_b_req := TRUE;
        b_pack_started := TRUE;
        pack_state := 20;
    END_IF;
10:
    pack_a_req := FALSE;
    pack_wait_timer(IN := TRUE, PT := T#200ms);
    IF X21 THEN
        pack_state := 30;
    ELSIF pack_wait_timer.Q THEN
        pack_state := 0;
    END_IF;
20:
    pack_b_req := FALSE;
    pack_wait_timer(IN := TRUE, PT := T#200ms);
    IF X21 THEN
        pack_state := 30;
    ELSIF pack_wait_timer.Q THEN
        pack_state := 0;
    END_IF;
30:
    pack_wait_timer(IN := FALSE, PT := T#200ms);
    IF NOT X21 THEN pack_state := 0; END_IF;
END_CASE;


(* ---------------- OUTPUT ASSIGNMENTS ---------------- *)
dock_trig(CLK := dock_req);
Y10 := dock_trig.Q;

load_trig(CLK := load_req);
Y11 := load_trig.Q;

unload_trig(CLK := unload_req);
Y12 := unload_trig.Q;

accept_a_trig(CLK := accept_a_req);
Y13 := accept_a_trig.Q;

accept_b_trig(CLK := accept_b_req);
Y14 := accept_b_trig.Q;

close_a_trig(CLK := close_a_req);
Y15 := close_a_trig.Q;

close_b_trig(CLK := close_b_req);
Y16 := close_b_trig.Q;

release_a_trig(CLK := release_a_req);
Y17 := release_a_trig.Q;

release_b_trig(CLK := release_b_req);
Y18 := release_b_trig.Q;

ack_a_trig(CLK := ack_a_req);
Y19 := ack_a_trig.Q;

ack_b_trig(CLK := ack_b_req);
Y1A := ack_b_trig.Q;

dispatch_trig(CLK := dispatch_req);
Y20 := dispatch_trig.Q;

pack_a_trig(CLK := pack_a_req);
Y1E := pack_a_trig.Q;

pack_b_trig(CLK := pack_b_req);
Y1F := pack_b_trig.Q;

IF X1D AND D2 = 0 AND NOT X11 AND boxes_dispatched >= 2 THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM