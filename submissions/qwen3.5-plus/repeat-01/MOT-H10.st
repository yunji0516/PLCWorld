PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT;
    D1012 : DINT; D1013 : DINT; D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT;
    D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT; D1032 : DINT; D1033 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT; X30 : BOOL; X31 : BOOL;
    D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT; X34 : BOOL; X35 : BOOL;
    X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT; X52 : BOOL; X53 : BOOL;
    D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT; X62 : BOOL;
    D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT;
    D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D602 : DINT; D620 : DINT; D621 : DINT; D622 : DINT;
    D623 : DINT; D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL; D2004 : DINT; D2005 : DINT;
    D2006 : DINT; Y41 : BOOL; D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL;
    D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL; D2016 : DINT; D2017 : DINT;
    D2018 : DINT; Y44 : BOOL; D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL; D2028 : DINT; D2029 : DINT;
    D2030 : DINT; Y47 : BOOL; D2032 : DINT; D2033 : DINT; D2034 : DINT; Y48 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT; Y70 : BOOL; Y71 : BOOL;
    D700 : DINT; D701 : DINT; D702 : DINT; Y75 : BOOL; Y76 : BOOL; D710 : DINT;
    D711 : DINT; D712 : DINT; D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;

    brkTim : TON;
    cpTim : TON;
    r0Edge : R_TRIG;
    r1Edge : R_TRIG;
    
    sc : INT := 0;
    brkCmd : BOOL := TRUE;
    brkPrevCmd : BOOL;
    brkStable : BOOL := TRUE;
    
    prevR0P : INT := -1;
    prevR1P : INT := -1;
    r0P : INT := 0;
    r1P : INT := 0;
    r0Ackd : BOOL := FALSE;
    r1Ackd : BOOL := FALSE;
    
    forkConn : BOOL := FALSE;
    forkPrevConn : BOOL := FALSE;
    forkTimer : TON;
    forkStable : BOOL := TRUE;
    
    seqNum : INT := 1;
    
    actSt : INT := 0;
    stA : DINT := 0;
    stB : DINT := 0;
    stC : DINT := 15000;
    stD : DINT := 15000;
    stS30 : DINT := 0;
    stS31 : DINT := 0;
    stS40 : DINT := 100000;
    stS41 : DINT := 0;
    stS42 : DINT := 0;
    
    rtA : DINT := 800;
    rtB : DINT := 800;
    rtC : DINT := 800;
    rtD : DINT := 800;
    rtS30 : DINT := 800;
    rtS31 : DINT := 800;
    rtS40 : DINT := 800;
    rtS41 : DINT := 800;
    rtS42 : DINT := 800;
    
    enA : BOOL := FALSE;
    enB : BOOL := FALSE;
    enC : BOOL := FALSE;
    enD : BOOL := FALSE;
    enS30 : BOOL := FALSE;
    enS31 : BOOL := FALSE;
    enS40 : BOOL := FALSE;
    enS41 : BOOL := FALSE;
    enS42 : BOOL := FALSE;
    
    ffA : DINT := 0;
    ffB : DINT := 0;
    ffC : DINT := 0;
    ffD : DINT := 0;
    ffS30 : DINT := 0;
    ffS31 : DINT := 0;
    ffS40 : DINT := 0;
    ffS41 : DINT := 0;
    ffS42 : DINT := 0;
    
    m3Cnf : BOOL := FALSE;
    m3Ret : BOOL := FALSE;
    m3Sel : DINT := 0;
    m3Rt : DINT := 0;
    m3Acc : DINT := 0;
    
    m4Cnf : BOOL := FALSE;
    m4Ret : BOOL := FALSE;
    m4Sel : DINT := 0;
    m4Rt : DINT := 0;
    m4Acc : DINT := 0;
    
    actOut : DINT := 0;
    staOut : DINT := 0;
    
    PI : REAL := 3.14159265358979;
    
    y2On : BOOL := FALSE;
    compHeld : BOOL := FALSE;
    holdSc : INT := 0;
    
    r0Done : BOOL := FALSE;
    r1Done : BOOL := FALSE;
END_VAR

sc := sc + 1;

r0P := D102;
r1P := D122;

r0Edge(CLK := r0P <> prevR0P);
prevR0P := r0P;
r1Edge(CLK := r1P <> prevR1P);
prevR1P := r1P;

IF brkCmd <> brkPrevCmd THEN
    brkTim(IN := TRUE, PT := T#80ms);
    brkStable := FALSE;
END_IF;
brkPrevCmd := brkCmd;

IF brkCmd AND X52 THEN
    brkStable := TRUE;
ELSIF NOT brkCmd AND X53 THEN
    brkStable := TRUE;
END_IF;

Y30 := brkCmd;

IF NOT forkConn <> forkPrevConn THEN
    forkTimer(IN := TRUE, PT := T#80ms);
    forkStable := FALSE;
END_IF;
forkPrevConn := forkConn;

IF D1004 >= 17900 AND forkConn THEN
    forkStable := TRUE;
ELSIF D1004 <= 100 AND NOT forkConn THEN
    forkStable := TRUE;
END_IF;

D2000 := stA; D2001 := rtA; D2002 := ffA; Y40 := enA;
D2004 := stB; D2005 := rtB; D2006 := ffB; Y41 := enB;
D2008 := stC; D2009 := rtC; D2010 := ffC; Y42 := enC;
D2012 := stD; D2013 := rtD; D2014 := ffD; Y43 := enD;
D2016 := stS30; D2017 := rtS30; D2018 := ffS30; Y44 := enS30;
D2020 := stS31; D2021 := rtS31; D2022 := ffS31; Y45 := enS31;
D2024 := stS40; D2025 := rtS40; D2026 := ffS40; Y46 := enS40;
D2028 := stS41; D2029 := rtS41; D2030 := ffS41; Y47 := enS41;
D2032 := stS42; D2023 := rtS42; D2034 := ffS42; Y48 := enS42;

Y70 := m3Cnf; Y71 := m3Ret; D700 := m3Sel; D701 := m3Rt; D702 := m3Acc;
Y75 := m4Cnf; Y76 := m4Ret; D710 := m4Sel; D711 := m4Rt; D712 := m4Acc;
D80 := actOut; D81 := staOut; D82 := seqNum;

IF r0P >= 3 AND NOT r0Ackd THEN
    r0Ackd := TRUE;
    D300 := D100;
    D301 := 1;
    r0Done := TRUE;
END_IF;

IF r1P >= 3 AND NOT r1Ackd THEN
    r1Ackd := TRUE;
    D302 := D120;
    D303 := 1;
    r1Done := TRUE;
END_IF;

IF X51 AND NOT compHeld THEN
    compHeld := TRUE;
    holdSc := 0;
END_IF;

IF compHeld THEN
    holdSc := holdSc + 1;
    IF holdSc >= 5 THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM