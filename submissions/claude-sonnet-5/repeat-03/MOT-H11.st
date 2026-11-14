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
    D1032 : DINT;
    D1033 : DINT;
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
    D602 : DINT;
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
    D2032 : DINT;
    D2033 : DINT;
    D2034 : DINT;
    Y48 : BOOL;
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

    (* ---- internal state ---- *)
    seq_state   : INT := 0;
    cur_req     : INT := 2;   (* 0,1 = active slot ; 2 = none *)
    done0       : BOOL := FALSE;
    done1       : BOOL := FALSE;
    couple_seq  : DINT := 0;
    wLoc        : DINT := 0;
    wId         : DINT := 0;
    targetSourcePos : DINT := 0;

    (* ---- commanded targets (persist between states) ---- *)
    aCmd  : DINT := 0;
    bCmd  : DINT := 0;
    cdCmd : DINT := 40000;
    s30Cmd : DINT := 0;
    s31Cmd : DINT := 5000;
    s40Cmd : DINT := 0;
    s41Cmd : DINT := 0;
    s42Cmd : DINT := 0;

    pinTarget1 : DINT;
    pinTarget2 : DINT;

    (* ---- fixed reference values (raw = physical*100) ---- *)
    POS1 : DINT := -405000;
    POS2 : DINT := -185000;
    POS3 : DINT := 0;
    POS4 : DINT := 360000;
    HOME_A  : DINT := 0;
    HOME_B  : DINT := 0;
    HOME_CD : DINT := 40000;
    HOME_S30 : DINT := 0;
    HOME_S31 : DINT := 5000;
    HOME_S40 : DINT := 0;
    HOME_S41 : DINT := 0;
    HOME_S42 : DINT := 0;
    DOCK_H  : DINT := 95000;
    FORK_CONNECT : DINT := 18000;
    FORK_RETRIEVE : DINT := 0;
    POS_TOL : DINT := 20;
    VEL_TOL : DINT := 100;
    DRIVE_RATE : DINT := 300;

    A_MIN : DINT := -450000; A_MAX : DINT := 450000;
    B_MIN : DINT := 0; B_MAX : DINT := 18000;
    CD_MIN : DINT := 0; CD_MAX : DINT := 120000;
    S30_MIN : DINT := 0; S30_MAX : DINT := 27000;
    S31_MIN : DINT := 0; S31_MAX : DINT := 74000;
    S40_MIN : DINT := 0; S40_MAX : DINT := 27000;
    S41_MIN : DINT := 0; S41_MAX : DINT := 4000;
    S42_MIN : DINT := 0; S42_MAX : DINT := 4000;

    avail0 : BOOL;
    avail1 : BOOL;
    enabledAxes : BOOL;
    allHome : BOOL;
    readyForCompletion : BOOL;
    y2_declared : BOOL := FALSE;
    confirmed : BOOL;
    arrived_a : BOOL;
    arrived_cd : BOOL;
    arrived_b : BOOL;
    arrived_s30 : BOOL;
    arrived_s31 : BOOL;
    arrived_s40 : BOOL;
    arrived_s41 : BOOL;
    arrived_s42 : BOOL;
    cellDone3 : BOOL;
    cellDone4 : BOOL;
END_VAR

(* ============ Cancellation watchdog : redirect to abort branch ============ *)
IF (cur_req = 0 AND X31) OR (cur_req = 1 AND X35) THEN
    IF seq_state >= 1 AND seq_state <= 18 THEN
        seq_state := 30;
    END_IF;
END_IF;

(* ============ Pull request-specific fields ============ *)
IF cur_req = 0 THEN
    wLoc := D101;
    wId  := D100;
ELSIF cur_req = 1 THEN
    wLoc := D121;
    wId  := D120;
END_IF;

targetSourcePos := POS1;
IF wLoc = 2 THEN
    targetSourcePos := POS2;
END_IF;

(* ============ Main sequence ============ *)
CASE seq_state OF

0: (* IDLE - select next request by EDF *)
    avail0 := (D100 <> 0) AND NOT done0;
    avail1 := (D120 <> 0) AND NOT done1;
    IF avail0 AND avail1 THEN
        IF D103 <= D123 THEN
            cur_req := 0;
        ELSE
            cur_req := 1;
        END_IF;
        seq_state := 1;
    ELSIF avail0 THEN
        cur_req := 0;
        seq_state := 1;
    ELSIF avail1 THEN
        cur_req := 1;
        seq_state := 1;
    ELSE
        cur_req := 2;
    END_IF;

1: (* SRC_MOVE *)
    aCmd := targetSourcePos;
    cdCmd := DOCK_H;
    arrived_a := (ABS(D1000 - aCmd) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL);
    arrived_cd := (ABS(D1008 - DOCK_H) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
                  AND (ABS(D1012 - DOCK_H) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);
    IF arrived_a AND arrived_cd THEN
        seq_state := 2;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 1;
        D81 := wLoc;
    END_IF;

2: (* SRC_CONNECT *)
    bCmd := FORK_CONNECT;
    arrived_b := (ABS(D1004 - bCmd) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
    IF arrived_b THEN
        seq_state := 3;
    END_IF;

3: (* SRC_LIFT_HOME *)
    cdCmd := HOME_CD;
    arrived_cd := (ABS(D1008 - HOME_CD) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
                  AND (ABS(D1012 - HOME_CD) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);
    IF arrived_cd THEN
        seq_state := 4;
    END_IF;

4: (* SRC_DISCONNECT *)
    bCmd := FORK_RETRIEVE;
    arrived_b := (ABS(D1004 - bCmd) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
    IF arrived_b THEN
        seq_state := 5;
    END_IF;

5: (* TO_CELL3 *)
    aCmd := POS3;
    arrived_a := (ABS(D1000 - aCmd) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL);
    IF arrived_a THEN
        seq_state := 6;
    END_IF;

6: (* CELL3_ROTATE *)
    s30Cmd := LIMIT(S30_MIN, D500, S30_MAX);
    s31Cmd := HOME_S31;
    arrived_s30 := (ABS(D1016 - s30Cmd) <= POS_TOL) AND (ABS(D1017) <= VEL_TOL);
    arrived_s31 := (ABS(D1020 - s31Cmd) <= POS_TOL) AND (ABS(D1021) <= VEL_TOL);
    IF arrived_s30 AND arrived_s31 THEN
        seq_state := 7;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 2;
        D81 := 3;
    END_IF;

7: (* CELL3_APPROACH *)
    s31Cmd := LIMIT(S31_MIN, D501, S31_MAX);
    Y70 := TRUE;
    D700 := D520;
    D701 := D526;
    D702 := 500;
    arrived_s31 := (ABS(D1020 - s31Cmd) <= POS_TOL) AND (ABS(D1021) <= VEL_TOL);
    IF arrived_s31 THEN
        seq_state := 8;
    END_IF;

8: (* CELL3_WORK *)
    Y71 := TRUE;
    cellDone3 := X70 OR X71 OR X72;
    IF cellDone3 THEN
        Y71 := FALSE;
        seq_state := 9;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 1;
        D81 := 3;
    END_IF;

9: (* CELL3_RETRACT *)
    Y70 := FALSE;
    s31Cmd := HOME_S31;
    arrived_s31 := (ABS(D1020 - s31Cmd) <= POS_TOL) AND (ABS(D1021) <= VEL_TOL);
    IF arrived_s31 THEN
        seq_state := 10;
    END_IF;

10: (* TO_CELL4 *)
    aCmd := POS4;
    arrived_a := (ABS(D1000 - aCmd) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL);
    IF arrived_a THEN
        seq_state := 11;
    END_IF;

11: (* CELL4_ROTATE - both pins retracted *)
    s40Cmd := LIMIT(S40_MIN, D600, S40_MAX);
    s41Cmd := HOME_S41;
    s42Cmd := HOME_S42;
    arrived_s40 := (ABS(D1024 - s40Cmd) <= POS_TOL) AND (ABS(D1025) <= VEL_TOL);
    arrived_s41 := (ABS(D1028 - s41Cmd) <= POS_TOL) AND (ABS(D1029) <= VEL_TOL);
    arrived_s42 := (ABS(D1032 - s42Cmd) <= POS_TOL) AND (ABS(D1033) <= VEL_TOL);
    IF arrived_s40 AND arrived_s41 AND arrived_s42 THEN
        seq_state := 12;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 2;
        D81 := 4;
    END_IF;

12: (* CELL4_INSERT - select pin by lane *)
    IF D620 = 0 THEN
        pinTarget1 := LIMIT(S41_MIN, D601, S41_MAX);
        pinTarget2 := 0;
    ELSE
        pinTarget1 := 0;
        pinTarget2 := LIMIT(S42_MIN, D602, S42_MAX);
    END_IF;
    s41Cmd := pinTarget1;
    s42Cmd := pinTarget2;
    Y75 := TRUE;
    D710 := D620;
    D711 := D626;
    D712 := 500;
    arrived_s41 := (ABS(D1028 - s41Cmd) <= POS_TOL) AND (ABS(D1029) <= VEL_TOL);
    arrived_s42 := (ABS(D1032 - s42Cmd) <= POS_TOL) AND (ABS(D1033) <= VEL_TOL);
    IF arrived_s41 AND arrived_s42 THEN
        seq_state := 13;
    END_IF;

13: (* CELL4_WORK *)
    Y76 := TRUE;
    cellDone4 := X75 OR X76 OR X77;
    IF cellDone4 THEN
        Y76 := FALSE;
        seq_state := 14;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 1;
        D81 := 4;
    END_IF;

14: (* CELL4_RETRACT *)
    Y75 := FALSE;
    s41Cmd := 0;
    s42Cmd := 0;
    arrived_s41 := (ABS(D1028 - s41Cmd) <= POS_TOL) AND (ABS(D1029) <= VEL_TOL);
    arrived_s42 := (ABS(D1032 - s42Cmd) <= POS_TOL) AND (ABS(D1033) <= VEL_TOL);
    IF arrived_s41 AND arrived_s42 THEN
        seq_state := 15;
    END_IF;

15: (* TO_RETURN *)
    aCmd := targetSourcePos;
    cdCmd := DOCK_H;
    arrived_a := (ABS(D1000 - aCmd) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL);
    arrived_cd := (ABS(D1008 - DOCK_H) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
                  AND (ABS(D1012 - DOCK_H) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);
    IF arrived_a AND arrived_cd THEN
        seq_state := 16;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 2;
        D81 := wLoc;
    END_IF;

16: (* RET_CONNECT *)
    bCmd := FORK_CONNECT;
    arrived_b := (ABS(D1004 - bCmd) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
    IF arrived_b THEN
        seq_state := 17;
    END_IF;

17: (* RET_LOWER *)
    cdCmd := HOME_CD;
    arrived_cd := (ABS(D1008 - HOME_CD) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
                  AND (ABS(D1012 - HOME_CD) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);
    IF arrived_cd THEN
        seq_state := 18;
    END_IF;

18: (* RET_DISCONNECT *)
    bCmd := FORK_RETRIEVE;
    arrived_b := (ABS(D1004 - bCmd) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
    IF arrived_b THEN
        seq_state := 19;
    END_IF;

19: (* WAIT_RETURN_CONFIRM *)
    confirmed := (cur_req = 0 AND X30) OR (cur_req = 1 AND X34);
    IF confirmed THEN
        seq_state := 20;
    END_IF;

20: (* ACK - completion *)
    IF cur_req = 0 THEN
        D300 := D100;
        D301 := 1;
        done0 := TRUE;
    ELSIF cur_req = 1 THEN
        D302 := D120;
        D303 := 1;
        done1 := TRUE;
    END_IF;
    cur_req := 2;
    seq_state := 0;

30: (* ABORT_RETRACT *)
    bCmd := FORK_RETRIEVE;
    s31Cmd := HOME_S31;
    s41Cmd := 0;
    s42Cmd := 0;
    arrived_b := (ABS(D1004 - bCmd) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
    arrived_s31 := (ABS(D1020 - s31Cmd) <= POS_TOL) AND (ABS(D1021) <= VEL_TOL);
    arrived_s41 := (ABS(D1028 - s41Cmd) <= POS_TOL) AND (ABS(D1029) <= VEL_TOL);
    arrived_s42 := (ABS(D1032 - s42Cmd) <= POS_TOL) AND (ABS(D1033) <= VEL_TOL);
    IF arrived_b AND arrived_s31 AND arrived_s41 AND arrived_s42 THEN
        seq_state := 31;
    END_IF;

31: (* ABORT_TO_RETURN *)
    aCmd := targetSourcePos;
    cdCmd := DOCK_H;
    arrived_a := (ABS(D1000 - aCmd) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL);
    arrived_cd := (ABS(D1008 - DOCK_H) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
                  AND (ABS(D1012 - DOCK_H) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);
    IF arrived_a AND arrived_cd THEN
        seq_state := 32;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 2;
        D81 := wLoc;
    END_IF;

32: (* ABORT_CONNECT *)
    bCmd := FORK_CONNECT;
    arrived_b := (ABS(D1004 - bCmd) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
    IF arrived_b THEN
        seq_state := 33;
    END_IF;

33: (* ABORT_LOWER *)
    cdCmd := HOME_CD;
    arrived_cd := (ABS(D1008 - HOME_CD) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
                  AND (ABS(D1012 - HOME_CD) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);
    IF arrived_cd THEN
        seq_state := 34;
    END_IF;

34: (* ABORT_DISCONNECT *)
    bCmd := FORK_RETRIEVE;
    arrived_b := (ABS(D1004 - bCmd) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
    IF arrived_b THEN
        seq_state := 35;
    END_IF;

35: (* ABORT_WAIT_CONFIRM *)
    confirmed := (cur_req = 0 AND X30) OR (cur_req = 1 AND X34);
    IF confirmed THEN
        seq_state := 36;
    END_IF;

36: (* ABORT_ACK *)
    IF cur_req = 0 THEN
        D300 := D100;
        D301 := 2;
        done0 := TRUE;
    ELSIF cur_req = 1 THEN
        D302 := D120;
        D303 := 2;
        done1 := TRUE;
    END_IF;
    cur_req := 2;
    seq_state := 0;

ELSE
    seq_state := 0;

END_CASE;

(* ============ Output writes ============ *)
enabledAxes := (seq_state <> 0);

D2000 := LIMIT(A_MIN, aCmd, A_MAX);
D2001 := DRIVE_RATE;
D2002 := 0;
Y40 := enabledAxes;

D2004 := LIMIT(B_MIN, bCmd, B_MAX);
D2005 := DRIVE_RATE;
D2006 := 0;
Y41 := enabledAxes;

D2008 := LIMIT(CD_MIN, cdCmd, CD_MAX);
D2009 := DRIVE_RATE;
D2010 := 0;
Y42 := enabledAxes;

D2012 := LIMIT(CD_MIN, cdCmd, CD_MAX);
D2013 := DRIVE_RATE;
D2014 := 0;
Y43 := enabledAxes;

D2016 := LIMIT(S30_MIN, s30Cmd, S30_MAX);
D2017 := DRIVE_RATE;
D2018 := 0;
Y44 := enabledAxes;

D2020 := LIMIT(S31_MIN, s31Cmd, S31_MAX);
D2021 := DRIVE_RATE;
D2022 := 0;
Y45 := enabledAxes;

D2024 := LIMIT(S40_MIN, s40Cmd, S40_MAX);
D2025 := DRIVE_RATE;
D2026 := 0;
Y46 := enabledAxes;

D2028 := LIMIT(S41_MIN, s41Cmd, S41_MAX);
D2029 := DRIVE_RATE;
D2030 := 0;
Y47 := enabledAxes;

D2032 := LIMIT(S42_MIN, s42Cmd, S42_MAX);
D2033 := DRIVE_RATE;
D2034 := 0;
Y48 := enabledAxes;

Y30 := NOT enabledAxes;

(* ============ Completion logic ============ *)
allHome := (ABS(D1000 - HOME_A) <= POS_TOL)
       AND (ABS(D1004 - HOME_B) <= POS_TOL)
       AND (ABS(D1008 - HOME_CD) <= POS_TOL)
       AND (ABS(D1012 - HOME_CD) <= POS_TOL)
       AND (ABS(D1016 - HOME_S30) <= POS_TOL)
       AND (ABS(D1020 - HOME_S31) <= POS_TOL)
       AND (ABS(D1024 - HOME_S40) <= POS_TOL)
       AND (ABS(D1028 - HOME_S41) <= POS_TOL)
       AND (ABS(D1032 - HOME_S42) <= POS_TOL);

readyForCompletion := done0 AND done1 AND X51 AND allHome AND (seq_state = 0);

IF readyForCompletion AND NOT y2_declared THEN
    y2_declared := TRUE;
END_IF;

Y2 := y2_declared;

END_PROGRAM