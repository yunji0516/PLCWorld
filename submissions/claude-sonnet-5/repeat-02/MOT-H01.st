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

    (* internal working memory *)
    active   : INT := -1;
    state0   : INT := 0;
    state1   : INT := 0;
    src0     : DINT := 0;
    src1     : DINT := 0;
    id0      : DINT := 0;
    id1      : DINT := 0;
    seq      : DINT := 0;

    cur_state    : INT := 0;
    cur_src      : DINT := 0;
    cur_loc      : DINT := 0;
    cur_served   : BOOL := FALSE;
    cur_returned : BOOL := FALSE;
    port_src     : DINT := 0;

    want_a : DINT := 0;
    want_b : DINT := 0;
    want_e : DINT := 0;
    want_f : DINT := 0;

    shuttle_ok_src   : BOOL := FALSE;
    shuttle_ok_table : BOOL := FALSE;
    fork_ok0         : BOOL := FALSE;
    fork_ok180       : BOOL := FALSE;
    slide_ok_retract : BOOL := FALSE;
    lift_ok          : BOOL := FALSE;
    lift_home_ok     : BOOL := FALSE;
    table_ok_target  : BOOL := FALSE;
    table_ok_zero    : BOOL := FALSE;

    finalReady : BOOL := FALSE;
    fin_ton : TON;

    LIFT_CONNECT   : DINT := 73250;
    FORK_RETRIEVE  : DINT := 0;
    FORK_CONNECT   : DINT := 18000;
    PORT_LIFTA     : DINT := -90000;
    PORT_LIFTB     : DINT := -35000;
    PORT_TABLE     : DINT := 85000;
    SLIDE_RETRACT  : DINT := 5000;
    POS_TOL        : DINT := 20;
    SPD_TOL        : DINT := 100;
    FORK_SAFE      : DINT := 4000;
END_VAR

(* -------- Job dispatch: pick which channel becomes active -------- *)
IF active = -1 THEN
    IF state0 = 0 AND D100 <> 0 AND D100 <> D300 AND (D104 = 1 OR D104 = 2) THEN
        active := 0; id0 := D100; src0 := D104; state0 := 1;
    ELSIF state1 = 0 AND D110 <> 0 AND D110 <> D302 AND (D114 = 1 OR D114 = 2) THEN
        active := 1; id1 := D110; src1 := D114; state1 := 1;
    END_IF;
END_IF;

(* -------- Load current job context -------- *)
IF active = 0 THEN
    cur_state := state0; cur_src := src0; cur_loc := D104; cur_served := X30; cur_returned := X32;
ELSIF active = 1 THEN
    cur_state := state1; cur_src := src1; cur_loc := D114; cur_served := X31; cur_returned := X33;
ELSE
    cur_state := 0; cur_src := 0; cur_loc := 0; cur_served := FALSE; cur_returned := FALSE;
END_IF;

(* -------- default outputs (lift home baseline) -------- *)
D208 := D150; D209 := 1000; Y22 := TRUE;
D212 := D151; D213 := 1000; Y23 := TRUE;

IF active = -1 THEN
    D200 := 0; D201 := 1000; Y20 := TRUE;
    D204 := 0; D205 := 1000; Y21 := TRUE;
    D216 := 0; D217 := 1000; Y24 := TRUE;
    D220 := SLIDE_RETRACT; D221 := 1000; Y25 := TRUE;
ELSE
    IF cur_src = 1 THEN
        port_src := PORT_LIFTA;
    ELSE
        port_src := PORT_LIFTB;
    END_IF;

    (* lift raise override during connect states *)
    IF cur_state = 1 OR cur_state = 2 OR cur_state = 3 OR cur_state = 16 OR cur_state = 17 OR cur_state = 18 OR cur_state = 19 THEN
        IF cur_src = 1 THEN
            D208 := LIFT_CONNECT;
        ELSE
            D212 := LIFT_CONNECT;
        END_IF;
    END_IF;

    (* shuttle target *)
    IF cur_state >= 1 AND cur_state <= 4 THEN
        want_a := port_src;
    ELSIF cur_state >= 5 AND cur_state <= 15 THEN
        want_a := PORT_TABLE;
    ELSIF cur_state >= 16 AND cur_state <= 20 THEN
        want_a := port_src;
    ELSE
        want_a := D10;
    END_IF;

    IF D12 <= FORK_SAFE THEN
        D200 := want_a;
    ELSE
        D200 := D10;
    END_IF;
    D201 := 1000; Y20 := TRUE;

    (* fork target *)
    IF cur_state = 2 OR cur_state = 3 OR cur_state = 6 OR cur_state = 7 OR cur_state = 13 OR cur_state = 14 OR cur_state = 17 OR cur_state = 18 THEN
        want_b := FORK_CONNECT;
    ELSE
        want_b := FORK_RETRIEVE;
    END_IF;
    D204 := want_b; D205 := 1000; Y21 := TRUE;

    (* table target *)
    IF cur_state = 9 OR cur_state = 10 OR cur_state = 11 THEN
        want_e := D94;
    ELSE
        want_e := 0;
    END_IF;
    D216 := want_e; D217 := 1000; Y24 := TRUE;

    (* slide target *)
    IF cur_state = 10 THEN
        want_f := D95;
    ELSE
        want_f := SLIDE_RETRACT;
    END_IF;
    D220 := want_f; D221 := 1000; Y25 := TRUE;
END_IF;

(* -------- arrival / readiness flags -------- *)
shuttle_ok_src   := ABS(D10 - port_src) <= POS_TOL AND ABS(D11) <= SPD_TOL;
shuttle_ok_table := ABS(D10 - PORT_TABLE) <= POS_TOL AND ABS(D11) <= SPD_TOL;
fork_ok0         := ABS(D12 - FORK_RETRIEVE) <= POS_TOL AND ABS(D13) <= SPD_TOL;
fork_ok180       := ABS(D12 - FORK_CONNECT) <= POS_TOL AND ABS(D13) <= SPD_TOL;
slide_ok_retract := ABS(D20 - SLIDE_RETRACT) <= POS_TOL AND ABS(D21) <= SPD_TOL;
table_ok_target  := ABS(D18 - D94) <= POS_TOL AND ABS(D19) <= SPD_TOL AND X53;
table_ok_zero    := ABS(D18 - 0) <= POS_TOL AND ABS(D19) <= SPD_TOL AND X56;

IF cur_src = 1 THEN
    lift_ok      := ABS(D14 - LIFT_CONNECT) <= POS_TOL AND ABS(D15) <= SPD_TOL AND X54;
    lift_home_ok := ABS(D14 - D150) <= POS_TOL AND ABS(D15) <= SPD_TOL;
ELSE
    lift_ok      := ABS(D16 - LIFT_CONNECT) <= POS_TOL AND ABS(D17) <= SPD_TOL AND X55;
    lift_home_ok := ABS(D16 - D151) <= POS_TOL AND ABS(D17) <= SPD_TOL;
END_IF;

(* -------- state transition logic -------- *)
IF active <> -1 THEN
    CASE cur_state OF
        1:
            IF shuttle_ok_src AND fork_ok0 AND lift_ok THEN
                cur_state := 2;
            END_IF;
        2:
            IF fork_ok180 AND lift_ok THEN
                seq := seq + 1;
                D80 := 1; D81 := cur_src; D82 := seq;
                cur_state := 3;
            END_IF;
        3:
            IF cur_loc = 0 THEN
                cur_state := 4;
            END_IF;
        4:
            IF fork_ok0 THEN
                cur_state := 5;
            END_IF;
        5:
            IF shuttle_ok_table AND fork_ok0 THEN
                cur_state := 6;
            END_IF;
        6:
            IF fork_ok180 AND X57 THEN
                seq := seq + 1;
                D80 := 2; D81 := 4; D82 := seq;
                cur_state := 7;
            END_IF;
        7:
            IF cur_loc = 4 THEN
                cur_state := 8;
            END_IF;
        8:
            IF fork_ok0 AND slide_ok_retract THEN
                cur_state := 9;
            END_IF;
        9:
            IF table_ok_target THEN
                cur_state := 10;
            END_IF;
        10:
            IF cur_served THEN
                cur_state := 11;
            END_IF;
        11:
            IF slide_ok_retract THEN
                cur_state := 12;
            END_IF;
        12:
            IF table_ok_zero THEN
                cur_state := 13;
            END_IF;
        13:
            IF fork_ok180 AND X56 THEN
                seq := seq + 1;
                D80 := 1; D81 := 4; D82 := seq;
                cur_state := 14;
            END_IF;
        14:
            IF cur_loc = 0 THEN
                cur_state := 15;
            END_IF;
        15:
            IF fork_ok0 THEN
                cur_state := 16;
            END_IF;
        16:
            IF shuttle_ok_src AND lift_ok THEN
                cur_state := 17;
            END_IF;
        17:
            IF fork_ok180 AND lift_ok THEN
                seq := seq + 1;
                D80 := 2; D81 := cur_src; D82 := seq;
                cur_state := 18;
            END_IF;
        18:
            IF cur_loc = cur_src THEN
                cur_state := 19;
            END_IF;
        19:
            IF fork_ok0 THEN
                cur_state := 20;
            END_IF;
        20:
            IF lift_home_ok AND cur_returned THEN
                cur_state := 21;
            END_IF;
        21:
            IF active = 0 THEN
                D300 := id0; D301 := 1; state0 := 0;
            ELSIF active = 1 THEN
                D302 := id1; D303 := 1; state1 := 0;
            END_IF;
            active := -1;
            cur_state := 0;
    END_CASE;
END_IF;

(* -------- write back progress -------- *)
IF active = 0 THEN
    state0 := cur_state;
ELSIF active = 1 THEN
    state1 := cur_state;
END_IF;

(* -------- final completion (all requests done + machine parked) -------- *)
finalReady := X51 AND active = -1 AND state0 = 0 AND state1 = 0
    AND D90 = 0 AND D91 = 0 AND D92 = 0
    AND ABS(D10 - 0) <= POS_TOL AND ABS(D11) <= SPD_TOL
    AND ABS(D12 - 0) <= POS_TOL AND ABS(D13) <= SPD_TOL
    AND ABS(D18 - 0) <= POS_TOL AND ABS(D19) <= SPD_TOL
    AND ABS(D20 - SLIDE_RETRACT) <= POS_TOL AND ABS(D21) <= SPD_TOL
    AND ABS(D14 - D150) <= POS_TOL AND ABS(D15) <= SPD_TOL
    AND ABS(D16 - D151) <= POS_TOL AND ABS(D17) <= SPD_TOL;

fin_ton(IN := finalReady, PT := T#100ms);
Y2 := fin_ton.Q;

END_PROGRAM