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
    state : INT;
    last_state : INT;
    current_id : DINT;
    current_chan : INT;
    current_status : DINT;
    origin_station : INT;
    current_station : INT;
    seq : DINT;
    r0_seen : DINT;
    r1_seen : DINT;
    r0_done : BOOL;
    r1_done : BOOL;
    y2_latched : BOOL;
    m3_retain_hold : BOOL;
    m3_retain_id : DINT;
    cap_epoch_req : DINT;
    idx_epoch_req : DINT;
    capTarget : DINT;
    idxTarget : DINT;
    portTarget : DINT;
    portId : DINT;
    portReady : BOOL;
    atAport : BOOL;
    atA0 : BOOL;
    atB0 : BOOL;
    atB180 : BOOL;
    liftReady : BOOL;
    s3Home : BOOL;
    s4Home : BOOL;
    finalReady : BOOL;
    preConn : BOOL;
    stateChanged : BOOL;
    finalTimer : TON;
END_VAR

stateChanged := state <> last_state;

IF D100 <> r0_seen THEN
    r0_seen := D100;
    r0_done := FALSE;
    IF D100 <> 0 THEN
        D300 := 0;
        D301 := 0;
    END_IF;
END_IF;

IF D120 <> r1_seen THEN
    r1_seen := D120;
    r1_done := FALSE;
    IF D120 <> 0 THEN
        D302 := 0;
        D303 := 0;
    END_IF;
END_IF;

IF current_station = 1 THEN
    portTarget := D403;
    portId := D404;
    portReady := X61;
ELSIF current_station = 2 THEN
    portTarget := D406;
    portId := D407;
    portReady := X62;
ELSIF current_station = 3 THEN
    portTarget := D409;
    portId := D410;
    portReady := X63;
ELSIF current_station = 4 THEN
    portTarget := D412;
    portId := D413;
    portReady := X64;
ELSE
    portTarget := 0;
    portId := 0;
    portReady := FALSE;
END_IF;

atAport := (ABS(D1000 - portTarget) <= 20) AND (ABS(D1001) <= 100);
atA0 := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100);
atB0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
atB180 := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);

s3Home := (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100);
s4Home := (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

D2000 := 0;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := 0;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := 15000;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := 15000;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := -60000;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := -60000;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := 0;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := 0;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := 0;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

D80 := 0;
D81 := 0;
D82 := seq;

Y70 := FALSE;
Y71 := m3_retain_hold;
IF m3_retain_hold THEN
    D700 := m3_retain_id;
ELSE
    D700 := 0;
END_IF;
D701 := 0;
D702 := 1000;

Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 1000;

Y30 := FALSE;

CASE state OF
0:
    IF (D100 <> 0) AND NOT r0_done THEN
        current_id := D100;
        current_chan := 0;
        current_status := 1;
        IF X31 THEN
            current_status := 2;
        END_IF;
        IF D101 = 2 THEN
            origin_station := 2;
        ELSE
            origin_station := 1;
        END_IF;
        current_station := origin_station;
        IF current_status = 2 THEN
            state := 150;
        ELSE
            state := 10;
        END_IF;
    ELSIF (D120 <> 0) AND NOT r1_done THEN
        current_id := D120;
        current_chan := 1;
        current_status := 1;
        IF X35 THEN
            current_status := 2;
        END_IF;
        IF D121 = 1 THEN
            origin_station := 1;
        ELSE
            origin_station := 2;
        END_IF;
        current_station := origin_station;
        IF current_status = 2 THEN
            state := 150;
        ELSE
            state := 10;
        END_IF;
    ELSE
        IF X51 THEN
            state := 200;
        END_IF;
    END_IF;

10:
    current_station := origin_station;
    IF origin_station = 1 THEN
        D2008 := D92;
        liftReady := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        D2012 := D92;
        liftReady := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF liftReady THEN
        state := 20;
    END_IF;

20:
    current_station := origin_station;
    IF origin_station = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    D2000 := portTarget;
    D2004 := 0;
    IF atAport AND atB0 AND portReady THEN
        state := 30;
    END_IF;

30:
    current_station := origin_station;
    IF stateChanged THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    IF origin_station = 1 THEN
        D2008 := D92;
        liftReady := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        D2012 := D92;
        liftReady := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := portTarget;
    preConn := atAport AND portReady AND liftReady AND ((portId = current_id) OR (portId = 0));
    IF preConn THEN
        D2004 := 18000;
    ELSE
        D2004 := 0;
    END_IF;
    IF preConn AND atB180 THEN
        D80 := 1;
        D81 := origin_station;
        IF D90 = current_id THEN
            state := 32;
        END_IF;
    END_IF;

32:
    current_station := origin_station;
    IF origin_station = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    D2000 := portTarget;
    D2004 := 0;
    IF atB0 THEN
        current_station := 3;
        state := 40;
    END_IF;

40:
    current_station := 3;
    D2000 := portTarget;
    D2004 := 0;
    IF atAport AND atB0 AND portReady AND s3Home THEN
        state := 50;
    END_IF;

50:
    current_station := 3;
    IF stateChanged THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    D2000 := portTarget;
    preConn := atAport AND portReady AND s3Home;
    IF preConn THEN
        D2004 := 18000;
    ELSE
        D2004 := 0;
    END_IF;
    IF preConn AND atB180 THEN
        D80 := 2;
        D81 := 3;
        IF D90 <> current_id THEN
            state := 52;
        END_IF;
    END_IF;

52:
    current_station := 3;
    D2000 := portTarget;
    D2004 := 0;
    IF atB0 THEN
        state := 60;
    END_IF;

60:
    IF stateChanged THEN
        cap_epoch_req := D91;
        m3_retain_hold := TRUE;
        m3_retain_id := current_id;
    END_IF;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := current_id;
    D701 := D526;
    D702 := 1000;
    IF D520 = 1 THEN
        capTarget := D501 + 25000;
        IF capTarget > 95000 THEN
            capTarget := 95000;
        END_IF;
        IF capTarget < -95000 THEN
            capTarget := -95000;
        END_IF;
        D2016 := -60000;
        D2020 := capTarget;
        IF (ABS(D1020 - capTarget) <= 20) AND (ABS(D1021) <= 100) AND X70 AND (D522 = current_id) AND (D524 = cap_epoch_req) THEN
            state := 62;
        END_IF;
    ELSE
        capTarget := D500 + 25000;
        IF capTarget > 95000 THEN
            capTarget := 95000;
        END_IF;
        IF capTarget < -95000 THEN
            capTarget := -95000;
        END_IF;
        D2016 := capTarget;
        D2020 := -60000;
        IF (ABS(D1016 - capTarget) <= 20) AND (ABS(D1017) <= 100) AND X70 AND (D522 = current_id) AND (D524 = cap_epoch_req) THEN
            state := 62;
        END_IF;
    END_IF;

62:
    Y70 := FALSE;
    Y71 := TRUE;
    D700 := current_id;
    D2016 := -60000;
    D2020 := -60000;
    IF s3Home THEN
        current_station := 3;
        state := 70;
    END_IF;

70:
    current_station := 3;
    IF stateChanged THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    D2000 := portTarget;
    preConn := atAport AND portReady AND s3Home;
    IF preConn THEN
        D2004 := 18000;
    ELSE
        D2004 := 0;
    END_IF;
    IF preConn AND atB180 THEN
        D80 := 1;
        D81 := 3;
        IF D90 = current_id THEN
            state := 72;
        END_IF;
    END_IF;

72:
    current_station := 3;
    D2000 := portTarget;
    D2004 := 0;
    IF atB0 THEN
        current_station := 4;
        state := 80;
    END_IF;

80:
    current_station := 4;
    D2000 := portTarget;
    D2004 := 0;
    IF atAport AND atB0 AND portReady AND s4Home THEN
        state := 90;
    END_IF;

90:
    current_station := 4;
    IF stateChanged THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    D2000 := portTarget;
    preConn := atAport AND portReady AND s4Home;
    IF preConn THEN
        D2004 := 18000;
    ELSE
        D2004 := 0;
    END_IF;
    IF preConn AND atB180 THEN
        D80 := 2;
        D81 := 4;
        IF D90 <> current_id THEN
            state := 92;
        END_IF;
    END_IF;

92:
    current_station := 4;
    D2000 := portTarget;
    D2004 := 0;
    IF atB0 THEN
        state := 100;
    END_IF;

100:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := current_id;
    D711 := D626;
    D712 := 1000;
    idxTarget := D600;
    IF idxTarget < 0 THEN
        idxTarget := 0;
    END_IF;
    IF idxTarget > 27000 THEN
        idxTarget := 27000;
    END_IF;
    D2024 := idxTarget;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1024 - idxTarget) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        m3_retain_hold := FALSE;
        state := 102;
    END_IF;

102:
    IF stateChanged THEN
        idx_epoch_req := D91;
    END_IF;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := current_id;
    D711 := D626;
    D712 := 1000;
    idxTarget := D600;
    IF idxTarget < 0 THEN
        idxTarget := 0;
    END_IF;
    IF idxTarget > 27000 THEN
        idxTarget := 27000;
    END_IF;
    D2024 := idxTarget;
    IF D620 = 1 THEN
        D2028 := 0;
        D2032 := 4000;
        IF (ABS(D1032 - 4000) <= 20) AND (ABS(D1033) <= 100) AND X75 AND (D622 = current_id) AND (D624 = idx_epoch_req) THEN
            state := 104;
        END_IF;
    ELSE
        D2028 := 4000;
        D2032 := 0;
        IF (ABS(D1028 - 4000) <= 20) AND (ABS(D1029) <= 100) AND X75 AND (D622 = current_id) AND (D624 = idx_epoch_req) THEN
            state := 104;
        END_IF;
    END_IF;

104:
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF s4Home THEN
        current_station := 4;
        state := 120;
    END_IF;

120:
    current_station := 4;
    IF stateChanged THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    D2000 := portTarget;
    preConn := atAport AND portReady AND s4Home;
    IF preConn THEN
        D2004 := 18000;
    ELSE
        D2004 := 0;
    END_IF;
    IF preConn AND atB180 THEN
        D80 := 1;
        D81 := 4;
        IF D90 = current_id THEN
            state := 122;
        END_IF;
    END_IF;

122:
    current_station := 4;
    D2000 := portTarget;
    D2004 := 0;
    IF atB0 THEN
        current_station := origin_station;
        state := 130;
    END_IF;

130:
    current_station := origin_station;
    IF origin_station = 1 THEN
        D2008 := D92;
        liftReady := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        D2012 := D92;
        liftReady := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := portTarget;
    D2004 := 0;
    IF atAport AND atB0 AND portReady AND liftReady THEN
        state := 140;
    END_IF;

140:
    current_station := origin_station;
    IF stateChanged THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    IF origin_station = 1 THEN
        D2008 := D92;
        liftReady := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        D2012 := D92;
        liftReady := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := portTarget;
    preConn := atAport AND portReady AND liftReady;
    IF preConn THEN
        D2004 := 18000;
    ELSE
        D2004 := 0;
    END_IF;
    IF preConn AND atB180 THEN
        D80 := 2;
        D81 := origin_station;
        IF D90 <> current_id THEN
            state := 142;
        END_IF;
    END_IF;

142:
    current_station := origin_station;
    D2000 := portTarget;
    D2004 := 0;
    IF origin_station = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    IF atB0 THEN
        state := 150;
    END_IF;

150:
    D2004 := 0;
    IF origin_station = 1 THEN
        D2008 := 15000;
        liftReady := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        D2012 := 15000;
        liftReady := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF liftReady THEN
        IF current_chan = 0 THEN
            D300 := current_id;
            IF X31 THEN
                D301 := 2;
            ELSE
                D301 := current_status;
            END_IF;
            r0_done := TRUE;
        ELSE
            D302 := current_id;
            IF X35 THEN
                D303 := 2;
            ELSE
                D303 := current_status;
            END_IF;
            r1_done := TRUE;
        END_IF;
        current_id := 0;
        current_chan := -1;
        current_status := 0;
        state := 0;
    END_IF;

200:
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (D100 <> 0) AND NOT r0_done THEN
        state := 0;
    ELSIF (D120 <> 0) AND NOT r1_done THEN
        state := 0;
    END_IF;

ELSE
    state := 0;
END_CASE;

finalReady := X51 AND atA0 AND atB0 AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND s3Home AND s4Home AND (state = 200);
finalTimer(IN := finalReady, PT := T#100ms);
IF finalTimer.Q THEN
    y2_latched := TRUE;
END_IF;

Y2 := y2_latched;
IF y2_latched THEN
    Y30 := TRUE;
END_IF;

last_state := state;

END_PROGRAM