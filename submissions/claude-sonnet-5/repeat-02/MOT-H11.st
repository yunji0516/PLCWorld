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
    D2000 : DINT := 0;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL;
    D2004 : DINT := 0;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL;
    D2008 : DINT := 40000;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL;
    D2012 : DINT := 40000;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL;
    D2016 : DINT := 0;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL;
    D2020 : DINT := 5000;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
    D2024 : DINT := 0;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL;
    D2028 : DINT := 0;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL;
    D2032 : DINT := 0;
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

    (* internal state *)
    step        : DINT := 0;
    prevStep    : DINT := -1;
    stableCnt   : DINT := 0;
    reqSel      : DINT := 0;
    curId       : DINT;
    curLoc      : DINT;
    curCancelled: BOOL;
    curReturned : BOOL;
    seqNum      : DINT := 0;
    doneR0      : BOOL := FALSE;
    doneR1      : BOOL := FALSE;
    liftCoord   : DINT;
    portReadyLift : BOOL;
    cond        : BOOL;

    a_ok, b_ok, c_ok, d_ok : BOOL;
    s3_0_ok, s3_1_ok : BOOL;
    s4_0_ok, s4_1_ok, s4_2_ok : BOOL;
    readyForCompletion : BOOL;
    holdTmr : TON;

    (* constants *)
    POS_LIFT1   : DINT := -405000;
    POS_LIFT2   : DINT := -185000;
    POS_C3      : DINT := 0;
    POS_C4      : DINT := 360000;
    DOCK_HEIGHT : DINT := 95000;
    HOME_A      : DINT := 0;
    HOME_B      : DINT := 0;
    HOME_C      : DINT := 40000;
    HOME_D      : DINT := 40000;
    HOME_S3_0   : DINT := 0;
    HOME_S3_1   : DINT := 5000;
    HOME_S4_0   : DINT := 0;
    HOME_S4_1   : DINT := 0;
    HOME_S4_2   : DINT := 0;
    RETRACT_B   : DINT := 0;
    CONNECT_B   : DINT := 18000;
    SLIDE_RETRACT : DINT := 5000;
    NOM_RATE    : DINT := 500;
END_VAR

(* ---- 1. fixed per-scan defaults ---- *)
Y40:=TRUE; Y41:=TRUE; Y42:=TRUE; Y43:=TRUE; Y44:=TRUE; Y45:=TRUE; Y46:=TRUE; Y47:=TRUE; Y48:=TRUE;
D2001:=NOM_RATE; D2005:=NOM_RATE; D2009:=NOM_RATE; D2013:=NOM_RATE;
D2017:=NOM_RATE; D2021:=NOM_RATE; D2025:=NOM_RATE; D2029:=NOM_RATE; D2033:=NOM_RATE;
D2002:=0; D2006:=0; D2010:=0; D2014:=0; D2018:=0; D2022:=0; D2026:=0; D2030:=0; D2034:=0;

(* ---- 2. arrival ok flags (based on previously commanded targets) ---- *)
a_ok  := (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100);
b_ok  := (ABS(D1004 - D2004) <= 20) AND (ABS(D1005) <= 100);
c_ok  := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
d_ok  := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);
s3_0_ok := (ABS(D1016 - D2016) <= 20) AND (ABS(D1017) <= 100);
s3_1_ok := (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100);
s4_0_ok := (ABS(D1024 - D2024) <= 20) AND (ABS(D1025) <= 100);
s4_1_ok := (ABS(D1028 - D2028) <= 20) AND (ABS(D1029) <= 100);
s4_2_ok := (ABS(D1032 - D2032) <= 20) AND (ABS(D1033) <= 100);

(* ---- 3. immediate cancellation response for not-yet-started requests ---- *)
IF (NOT doneR0) AND (reqSel<>1) AND X31 THEN
    D300:=D100; D301:=2; doneR0:=TRUE;
END_IF;
IF (NOT doneR1) AND (reqSel<>2) AND X35 THEN
    D302:=D120; D303:=2; doneR1:=TRUE;
END_IF;

(* ---- 4. selection (priority by earliest due) ---- *)
IF reqSel=0 THEN
    IF (NOT doneR0) AND (NOT doneR1) THEN
        IF D103 <= D123 THEN reqSel:=1; ELSE reqSel:=2; END_IF;
    ELSIF NOT doneR0 THEN
        reqSel:=1;
    ELSIF NOT doneR1 THEN
        reqSel:=2;
    END_IF;
    IF reqSel<>0 THEN
        curId := SEL(reqSel=2, D100, D120);
        curLoc := SEL(reqSel=2, D101, D121);
        step := 10;
        prevStep := -1;
        stableCnt := 0;
    END_IF;
END_IF;

(* ---- 5. mapping for active request ---- *)
curCancelled := SEL(reqSel=2, X31, X35);
curReturned  := SEL(reqSel=2, X30, X34);
liftCoord    := SEL(curLoc=2, POS_LIFT1, POS_LIFT2);
portReadyLift:= SEL(curLoc=2, X61, X62);

(* ---- 6. cancellation jump ---- *)
IF (reqSel<>0) AND curCancelled AND (step>=10) AND (step<=27) THEN
    step := 50;
END_IF;

(* ---- 7. one-shot entry actions on step change ---- *)
IF step <> prevStep THEN
    stableCnt := 0;
    CASE step OF
        12: D80:=1; D81:=curLoc; seqNum:=seqNum+1; D82:=seqNum;
        14: D80:=2; D81:=3; seqNum:=seqNum+1; D82:=seqNum;
        20: D80:=1; D81:=3; seqNum:=seqNum+1; D82:=seqNum; Y70:=FALSE; Y71:=FALSE;
        22: D80:=2; D81:=4; seqNum:=seqNum+1; D82:=seqNum;
        27: D80:=1; D81:=4; seqNum:=seqNum+1; D82:=seqNum; Y75:=FALSE; Y76:=FALSE;
        29: D80:=2; D81:=curLoc; seqNum:=seqNum+1; D82:=seqNum;
        50: Y70:=FALSE; Y71:=FALSE; Y75:=FALSE; Y76:=FALSE;
    END_CASE;
    prevStep := step;
END_IF;

(* ---- 8. idle homing ---- *)
IF reqSel=0 THEN
    D2000:=HOME_A; D2004:=HOME_B; D2008:=HOME_C; D2012:=HOME_D;
    D2016:=HOME_S3_0; D2020:=HOME_S3_1; D2024:=HOME_S4_0; D2028:=HOME_S4_1; D2032:=HOME_S4_2;
END_IF;

(* ---- 9. main sequencer ---- *)
IF reqSel<>0 THEN
    CASE step OF
        10:
            D2000:=liftCoord; D2008:=DOCK_HEIGHT; D2012:=DOCK_HEIGHT;
            cond := a_ok AND c_ok AND d_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=12; stableCnt:=0; END_IF;

        12:
            D2004:=RETRACT_B;
            cond := portReadyLift AND b_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=13; stableCnt:=0; END_IF;

        13:
            D2000:=POS_C3;
            cond := a_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=14; stableCnt:=0; END_IF;

        14:
            D2004:=CONNECT_B;
            cond := X63 AND b_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=15; stableCnt:=0; END_IF;

        15:
            D700:=curId; D701:=1; D702:=500; Y70:=TRUE;
            IF D523<>0 THEN Y71:=TRUE; END_IF;
            cond := D523<>0;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=16; stableCnt:=0; END_IF;

        16:
            D2020:=SLIDE_RETRACT;
            cond := s3_1_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=17; stableCnt:=0; END_IF;

        17:
            D2016:=D500;
            cond := s3_0_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=18; stableCnt:=0; END_IF;

        18:
            D2020:=D501;
            cond := s3_1_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=19; stableCnt:=0; END_IF;

        19:
            cond := X70;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=20; stableCnt:=0; END_IF;

        20:
            D2004:=RETRACT_B; D2016:=HOME_S3_0; D2020:=HOME_S3_1;
            cond := X63 AND b_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=21; stableCnt:=0; END_IF;

        21:
            D2000:=POS_C4;
            cond := a_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=22; stableCnt:=0; END_IF;

        22:
            D2004:=CONNECT_B;
            cond := X64 AND b_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=23; stableCnt:=0; END_IF;

        23:
            D710:=curId; D711:=1; D712:=500; Y75:=TRUE;
            IF D623<>0 THEN Y76:=TRUE; END_IF;
            cond := D623<>0;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=24; stableCnt:=0; END_IF;

        24:
            D2024:=D600;
            cond := s4_0_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=25; stableCnt:=0; END_IF;

        25:
            D2028:=D601; D2032:=D602;
            cond := s4_1_ok AND s4_2_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=26; stableCnt:=0; END_IF;

        26:
            cond := X75;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=27; stableCnt:=0; END_IF;

        27:
            D2004:=RETRACT_B; D2024:=HOME_S4_0; D2028:=HOME_S4_1; D2032:=HOME_S4_2;
            cond := X64 AND b_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=28; stableCnt:=0; END_IF;

        28:
            D2000:=liftCoord;
            cond := a_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=29; stableCnt:=0; END_IF;

        29:
            D2004:=CONNECT_B;
            cond := portReadyLift AND b_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=30; stableCnt:=0; END_IF;

        30:
            D2004:=RETRACT_B;
            cond := b_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=31; stableCnt:=0; END_IF;

        31:
            D2008:=HOME_C; D2012:=HOME_D;
            cond := c_ok AND d_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=32; stableCnt:=0; END_IF;

        32:
            cond := curReturned;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN
                IF reqSel=1 THEN
                    D300:=curId; D301:=SEL(curCancelled,1,2); doneR0:=TRUE;
                ELSE
                    D302:=curId; D303:=SEL(curCancelled,1,2); doneR1:=TRUE;
                END_IF;
                reqSel:=0; step:=0; stableCnt:=0;
            END_IF;

        50:
            D2004:=RETRACT_B;
            cond := b_ok;
            IF cond THEN stableCnt:=stableCnt+1; ELSE stableCnt:=0; END_IF;
            IF stableCnt>=2 THEN step:=28; stableCnt:=0; END_IF;
    END_CASE;
END_IF;

(* ---- 10. common brake: hold when lifts settled ---- *)
Y30 := c_ok AND d_ok;

(* ---- 11. completion ---- *)
readyForCompletion := doneR0 AND doneR1 AND X51 AND (reqSel=0)
    AND a_ok AND b_ok AND c_ok AND d_ok
    AND s3_0_ok AND s3_1_ok AND s4_0_ok AND s4_1_ok AND s4_2_ok;

holdTmr(IN:=readyForCompletion, PT:=T#100ms);

IF holdTmr.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM