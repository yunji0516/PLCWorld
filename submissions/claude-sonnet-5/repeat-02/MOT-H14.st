PROGRAM Main
VAR
    D1000 : DINT;
    D1001 : DINT;
    D1004 : DINT;
    D1005 : DINT;
    D1008 : DINT;
    D1009 : DINT;
    D1012 : DINT;
    D1013 : DINT;
    D1016 : DINT;
    D1017 : DINT;
    D1020 : DINT;
    D1021 : DINT;
    D1024 : DINT;
    D1025 : DINT;
    D1028 : DINT;
    D1029 : DINT;
    D100 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    X30 : BOOL;
    X31 : BOOL;
    D120 : DINT;
    D121 : DINT;
    D122 : DINT;
    D123 : DINT;
    D124 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    D403 : DINT;
    D404 : DINT;
    X61 : BOOL;
    D406 : DINT;
    D407 : DINT;
    X62 : BOOL;
    D409 : DINT;
    D410 : DINT;
    X63 : BOOL;
    D412 : DINT;
    D413 : DINT;
    X64 : BOOL;
    D500 : DINT;
    D501 : DINT;
    D520 : DINT;
    D521 : DINT;
    D522 : DINT;
    D523 : DINT;
    D524 : DINT;
    D525 : DINT;
    D526 : DINT;
    D527 : DINT;
    X70 : BOOL;
    X71 : BOOL;
    X72 : BOOL;
    D600 : DINT;
    D601 : DINT;
    D620 : DINT;
    D621 : DINT;
    D622 : DINT;
    D623 : DINT;
    D624 : DINT;
    D625 : DINT;
    D626 : DINT;
    D627 : DINT;
    X75 : BOOL;
    X76 : BOOL;
    X77 : BOOL;
    D2000 : DINT;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL;
    D2004 : DINT;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL;
    D2008 : DINT;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL;
    D2012 : DINT;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL;
    D2016 : DINT;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL;
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
    D2024 : DINT;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL;
    D2028 : DINT;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    Y70 : BOOL;
    Y71 : BOOL;
    D700 : DINT;
    D701 : DINT;
    D702 : DINT;
    Y75 : BOOL;
    Y76 : BOOL;
    D710 : DINT;
    D711 : DINT;
    D712 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y30 : BOOL;
    Y2 : BOOL;

    (* internal *)
    state        : INT := 0;
    cur_req      : INT := 0;
    req_done     : ARRAY[0..1] OF BOOL;
    epoch_used   : ARRAY[0..1] OF DINT := [-1,-1];
    reg_valid    : ARRAY[0..1] OF BOOL;
    reg_target4  : ARRAY[0..1] OF DINT;

    cur_id         : DINT;
    cur_cancelled  : BOOL;
    cur_returned   : BOOL;
    cur_lift_is_c  : BOOL;
    cur_lift_nom   : DINT;

    fork_step : INT := 0;
    c3_step   : INT := 0;

    seq_no    : DINT := 0;

    capEdge   : R_TRIG;
    settleTmr : TON;

    y2_latch  : BOOL := FALSE;

    nominal1  : DINT := -360000;
    nominal2  : DINT := -230000;
    nominal3  : DINT := 0;
    nominal4  : DINT := 360000;
    home_lift : DINT := 15000;
    home_cell : DINT := -60000;
    tol_pos   : DINT := 20;
    tol_speed : DINT := 100;
    move_rate : DINT := 200;
    entry_lim : DINT := 4000;
END_VAR

(* ---- Safe defaults every scan: hold current position, no drive ---- *)
D2000 := D1000; D2001 := 0; D2002 := 0; Y40 := FALSE;
D2004 := D1004; D2005 := 0; D2006 := 0; Y41 := FALSE;
D2008 := D1008; D2009 := 0; D2010 := 0; Y42 := FALSE;
D2012 := D1012; D2013 := 0; D2014 := 0; Y43 := FALSE;
D2016 := D1016; D2017 := 0; D2018 := 0; Y44 := FALSE;
D2020 := D1020; D2021 := 0; D2022 := 0; Y45 := FALSE;
D2024 := D1024; D2025 := 0; D2026 := 0; Y46 := FALSE;
D2028 := D1028; D2029 := 0; D2030 := 0; Y47 := FALSE;
Y70 := FALSE; Y71 := FALSE;
Y75 := FALSE; Y76 := FALSE;
D700 := 0; D701 := 1; D702 := 500;
D710 := 0; D711 := 1; D712 := 500;
D80 := 0; D81 := 0;

CASE state OF

0: (* SELECT *)
    IF req_done[0] AND req_done[1] THEN
        state := 12;
    ELSE
        IF NOT req_done[0] THEN
            cur_req := 0;
            cur_id := D100;
            cur_cancelled := X31;
            cur_returned := X30;
            cur_lift_is_c := TRUE;
            cur_lift_nom := nominal1;
        ELSE
            cur_req := 1;
            cur_id := D120;
            cur_cancelled := X35;
            cur_returned := X34;
            cur_lift_is_c := FALSE;
            cur_lift_nom := nominal2;
        END_IF;

        IF cur_cancelled THEN
            IF cur_req = 0 THEN
                D300 := cur_id; D301 := 2;
            ELSE
                D302 := cur_id; D303 := 2;
            END_IF;
            req_done[cur_req] := TRUE;
        ELSIF cur_returned THEN
            IF cur_req = 0 THEN
                D300 := cur_id; D301 := 1;
            ELSE
                D302 := cur_id; D303 := 1;
            END_IF;
            req_done[cur_req] := TRUE;
        ELSIF cur_id <> 0 THEN
            fork_step := 0; c3_step := 0;
            state := 1;
        END_IF;
    END_IF;

1: (* MOVE_TO_LIFT *)
    IF D1004 <= entry_lim THEN
        D2000 := LIMIT(-450000, cur_lift_nom, 450000); D2001 := move_rate; D2002 := 0; Y40 := TRUE;
    ELSE
        D2000 := D1000; D2001 := 0; Y40 := FALSE;
    END_IF;
    IF ABS(D1000 - cur_lift_nom) <= tol_pos AND ABS(D1001) <= tol_speed THEN
        state := 2;
    END_IF;

2: (* LIFT_PREP *)
    IF cur_lift_is_c THEN
        D2008 := LIMIT(0, D92, 120000); D2009 := move_rate; D2010 := 0; Y42 := TRUE;
        IF ABS(D1008 - D92) <= tol_pos AND ABS(D1009) <= tol_speed THEN
            state := 3;
        END_IF;
    ELSE
        D2012 := LIMIT(0, D92, 120000); D2013 := move_rate; D2014 := 0; Y43 := TRUE;
        IF ABS(D1012 - D92) <= tol_pos AND ABS(D1013) <= tol_speed THEN
            state := 3;
        END_IF;
    END_IF;

3: (* FORK_GRAB *)
    CASE fork_step OF
        0:
            D2004 := 18000; D2005 := move_rate; D2006 := 0; Y41 := TRUE;
            IF ABS(D1004 - 18000) <= tol_pos AND ABS(D1005) <= tol_speed AND
               ((cur_lift_is_c AND X61) OR (NOT cur_lift_is_c AND X62)) THEN
                seq_no := seq_no + 1; D82 := seq_no; D80 := 1; D81 := SEL(cur_lift_is_c, 2, 1);
                fork_step := 1;
            END_IF;
        1:
            D2004 := 0; D2005 := move_rate; D2006 := 0; Y41 := TRUE;
            IF ABS(D1004 - 0) <= tol_pos AND ABS(D1005) <= tol_speed THEN
                fork_step := 0;
                state := 4;
            END_IF;
    END_CASE;

4: (* MOVE_TO_CELL3 *)
    IF D1004 <= entry_lim THEN
        D2000 := LIMIT(-450000, nominal3, 450000); D2001 := move_rate; D2002 := 0; Y40 := TRUE;
    ELSE
        D2000 := D1000; D2001 := 0; Y40 := FALSE;
    END_IF;
    IF ABS(D1000 - nominal3) <= tol_pos AND ABS(D1001) <= tol_speed THEN
        state := 5;
    END_IF;

5: (* CELL3_ALIGN *)
    CASE c3_step OF
        0:
            IF ABS(D1017) <= tol_speed AND ABS(D1021) <= tol_speed THEN
                Y70 := TRUE;
                D700 := cur_id; D701 := 1; D702 := 500;
                IF X72 THEN
                    c3_step := 1;
                END_IF;
            END_IF;
        1:
            Y70 := FALSE;
            D2016 := LIMIT(-95000, D500, 95000); D2017 := move_rate; D2018 := 0; Y44 := TRUE;
            D2020 := LIMIT(-180000, D501, 180000); D2021 := move_rate; D2022 := 0; Y45 := TRUE;
            IF ABS(D1016 - D500) <= tol_pos AND ABS(D1017) <= tol_speed AND
               ABS(D1020 - D501) <= tol_pos AND ABS(D1021) <= tol_speed THEN
                c3_step := 2;
            END_IF;
        2:
            IF X70 THEN
                c3_step := 0;
                state := 6;
            END_IF;
    END_CASE;

6: (* MOVE_TO_CELL4 *)
    IF D1004 <= entry_lim THEN
        D2000 := LIMIT(-450000, nominal4, 450000); D2001 := move_rate; D2002 := 0; Y40 := TRUE;
    ELSE
        D2000 := D1000; D2001 := 0; Y40 := FALSE;
    END_IF;
    IF ABS(D1000 - nominal4) <= tol_pos AND ABS(D1001) <= tol_speed THEN
        state := 7;
    END_IF;

7: (* CELL4_REGISTER *)
    IF D91 <> epoch_used[cur_req] THEN
        epoch_used[cur_req] := D91;
        reg_valid[cur_req] := FALSE;
    END_IF;
    D710 := cur_id; D711 := 1; D712 := 500;

    capEdge(CLK := (D623 = 1) AND (D622 = cur_id) AND (D624 = D91));
    IF capEdge.Q THEN
        reg_target4[cur_req] := D1024 + 25000;
        reg_valid[cur_req] := TRUE;
    END_IF;

    IF reg_valid[cur_req] THEN
        D2024 := LIMIT(-95000, reg_target4[cur_req], 95000); D2025 := move_rate; D2026 := 0; Y46 := TRUE;
        D2028 := LIMIT(-95000, reg_target4[cur_req], 95000); D2029 := move_rate; D2030 := 0; Y47 := TRUE;
        IF ABS(D1024 - reg_target4[cur_req]) <= tol_pos AND ABS(D1025) <= tol_speed AND
           ABS(D1028 - reg_target4[cur_req]) <= tol_pos AND ABS(D1029) <= tol_speed THEN
            settleTmr(IN := TRUE, PT := T#30ms);
            IF settleTmr.Q AND X75 THEN
                settleTmr(IN := FALSE, PT := T#30ms);
                state := 8;
            END_IF;
        ELSE
            settleTmr(IN := FALSE, PT := T#30ms);
        END_IF;
    ELSE
        D2024 := D1024; D2025 := 0; Y46 := TRUE;
        D2028 := D1028; D2029 := 0; Y47 := TRUE;
        settleTmr(IN := FALSE, PT := T#30ms);
    END_IF;

8: (* MOVE_BACK_TO_LIFT *)
    IF D1004 <= entry_lim THEN
        D2000 := LIMIT(-450000, cur_lift_nom, 450000); D2001 := move_rate; D2002 := 0; Y40 := TRUE;
    ELSE
        D2000 := D1000; D2001 := 0; Y40 := FALSE;
    END_IF;
    IF ABS(D1000 - cur_lift_nom) <= tol_pos AND ABS(D1001) <= tol_speed THEN
        fork_step := 0;
        state := 9;
    END_IF;

9: (* FORK_PLACE *)
    CASE fork_step OF
        0:
            D2004 := 18000; D2005 := move_rate; D2006 := 0; Y41 := TRUE;
            IF ABS(D1004 - 18000) <= tol_pos AND ABS(D1005) <= tol_speed AND
               ((cur_lift_is_c AND X61) OR (NOT cur_lift_is_c AND X62)) THEN
                seq_no := seq_no + 1; D82 := seq_no; D80 := 2; D81 := SEL(cur_lift_is_c, 2, 1);
                fork_step := 1;
            END_IF;
        1:
            D2004 := 0; D2005 := move_rate; D2006 := 0; Y41 := TRUE;
            IF ABS(D1004 - 0) <= tol_pos AND ABS(D1005) <= tol_speed THEN
                fork_step := 0;
                state := 10;
            END_IF;
    END_CASE;

10: (* LOWER_LIFT *)
    IF cur_lift_is_c THEN
        D2008 := LIMIT(0, home_lift, 120000); D2009 := move_rate; D2010 := 0; Y42 := TRUE;
        IF ABS(D1008 - home_lift) <= tol_pos AND ABS(D1009) <= tol_speed THEN
            state := 11;
        END_IF;
    ELSE
        D2012 := LIMIT(0, home_lift, 120000); D2013 := move_rate; D2014 := 0; Y43 := TRUE;
        IF ABS(D1012 - home_lift) <= tol_pos AND ABS(D1013) <= tol_speed THEN
            state := 11;
        END_IF;
    END_IF;

11: (* RESPOND *)
    IF cur_req = 0 THEN
        D300 := cur_id; D301 := 1;
    ELSE
        D302 := cur_id; D303 := 1;
    END_IF;
    req_done[cur_req] := TRUE;
    state := 0;

12: (* FINALIZE: return everything to final rest posture *)
    D2000 := 0; D2001 := move_rate; D2002 := 0; Y40 := TRUE;
    D2004 := 0; D2005 := move_rate; D2006 := 0; Y41 := TRUE;
    D2008 := LIMIT(0, home_lift, 120000); D2009 := move_rate; D2010 := 0; Y42 := TRUE;
    D2012 := LIMIT(0, home_lift, 120000); D2013 := move_rate; D2014 := 0; Y43 := TRUE;
    D2016 := home_cell; D2017 := 0; D2018 := 0; Y44 := FALSE;
    D2020 := home_cell; D2021 := 0; D2022 := 0; Y45 := FALSE;
    D2024 := home_cell; D2025 := 0; D2026 := 0; Y46 := FALSE;
    D2028 := home_cell; D2029 := 0; D2030 := 0; Y47 := FALSE;

    IF ABS(D1000 - 0) <= tol_pos AND ABS(D1001) <= tol_speed AND
       ABS(D1004 - 0) <= tol_pos AND ABS(D1005) <= tol_speed AND
       ABS(D1008 - home_lift) <= tol_pos AND ABS(D1009) <= tol_speed AND
       ABS(D1012 - home_lift) <= tol_pos AND ABS(D1013) <= tol_speed AND
       ABS(D1016 - home_cell) <= tol_pos AND ABS(D1020 - home_cell) <= tol_pos AND
       ABS(D1024 - home_cell) <= tol_pos AND ABS(D1028 - home_cell) <= tol_pos THEN
        Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
        state := 13;
    END_IF;

13: (* COMPLETE_HOLD *)
    y2_latch := TRUE;
    Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE;
    D2001 := 0; D2005 := 0; D2009 := 0; D2013 := 0;
    D2017 := 0; D2021 := 0; D2025 := 0; D2029 := 0;

END_CASE;

Y30 := NOT Y40;
Y2  := y2_latch;

END_PROGRAM