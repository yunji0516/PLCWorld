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
    initialized : BOOL;
    state : INT;
    activeChan : INT;
    activeID : DINT;
    sourceStation : DINT;
    sourceX : DINT;
    activeLoc : DINT;
    targetAngle : DINT;
    depthCmd : DINT;
    cHome : DINT;
    dHome : DINT;
    seq : DINT;
    aCmd : DINT;
    bCmd : DINT;
    cCmd : DINT;
    dCmd : DINT;
    eCmd : DINT;
    fCmd : DINT;
    pending0 : BOOL;
    pending1 : BOOL;
    sourceReady : BOOL;
    activeReturned : BOOL;
    activeServed : BOOL;
    aAtSource : BOOL;
    aAtTable : BOOL;
    aAtZero : BOOL;
    bAtZero : BOOL;
    bAtConn : BOOL;
    eAtZero : BOOL;
    fAt50 : BOOL;
    cAtHome : BOOL;
    dAtHome : BOOL;
    sourceHomeOk : BOOL;
    finalCond : BOOL;
    finalTimer : TON;
END_VAR

IF NOT initialized THEN
    initialized := TRUE;
    state := 0;
    activeChan := 0;
    activeID := 0;
    seq := D96;
    D80 := 0;
    D81 := 0;
    D82 := seq;
    D300 := 0;
    D301 := 0;
    D302 := 0;
    D303 := 0;
END_IF;

cHome := D150;
IF cHome < 0 THEN
    cHome := 0;
ELSIF cHome > 95000 THEN
    cHome := 95000;
END_IF;

dHome := D151;
IF dHome < 0 THEN
    dHome := 0;
ELSIF dHome > 95000 THEN
    dHome := 95000;
END_IF;

targetAngle := D94;
IF targetAngle < 1000 THEN
    targetAngle := 9000;
ELSIF targetAngle > 27000 THEN
    targetAngle := 27000;
END_IF;

depthCmd := D95;
IF (depthCmd < 69000) OR (depthCmd > 71000) THEN
    depthCmd := 70000;
END_IF;

pending0 := (D100 <> 0) AND NOT ((D300 = D100) AND (D301 = 1));
pending1 := (D110 <> 0) AND NOT ((D302 = D110) AND (D303 = 1));

IF (state = 0) AND (activeChan = 0) THEN
    IF pending0 AND pending1 THEN
        IF D103 <= D113 THEN
            activeChan := 1;
            activeID := D100;
            state := 10;
        ELSE
            activeChan := 2;
            activeID := D110;
            state := 10;
        END_IF;
    ELSIF pending0 THEN
        activeChan := 1;
        activeID := D100;
        state := 10;
    ELSIF pending1 THEN
        activeChan := 2;
        activeID := D110;
        state := 10;
    END_IF;
END_IF;

sourceStation := 0;
sourceX := 0;
activeLoc := 0;
sourceReady := FALSE;
activeReturned := FALSE;
activeServed := FALSE;

IF activeChan = 1 THEN
    sourceStation := 1;
    sourceX := -90000;
    activeLoc := D104;
    sourceReady := X54;
    activeReturned := X32;
    activeServed := X30;
ELSIF activeChan = 2 THEN
    sourceStation := 2;
    sourceX := -35000;
    activeLoc := D114;
    sourceReady := X55;
    activeReturned := X33;
    activeServed := X31;
END_IF;

aAtSource := (ABS(D10 - sourceX) <= 20) AND (ABS(D11) <= 100);
aAtTable := (ABS(D10 - 85000) <= 20) AND (ABS(D11) <= 100);
aAtZero := (ABS(D10) <= 20) AND (ABS(D11) <= 100);
bAtZero := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
bAtConn := (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100);
eAtZero := (ABS(D18) <= 20) AND (ABS(D19) <= 100);
fAt50 := (ABS(D20 - 5000) <= 20) AND (ABS(D21) <= 100);
cAtHome := (ABS(D14 - cHome) <= 20) AND (ABS(D15) <= 100);
dAtHome := (ABS(D16 - dHome) <= 20) AND (ABS(D17) <= 100);

sourceHomeOk := FALSE;
IF activeChan = 1 THEN
    sourceHomeOk := cAtHome;
ELSIF activeChan = 2 THEN
    sourceHomeOk := dAtHome;
END_IF;

CASE state OF
    10:
        IF aAtSource AND bAtZero AND sourceReady THEN
            state := 20;
        END_IF;

    20:
        IF aAtSource AND bAtConn AND sourceReady THEN
            state := 30;
        END_IF;

    30:
        IF aAtSource AND bAtConn AND sourceReady THEN
            seq := seq + 1;
            D80 := 1;
            D81 := sourceStation;
            D82 := seq;
            state := 40;
        ELSE
            state := 20;
        END_IF;

    40:
        IF (D90 = activeID) OR (activeLoc = 0) THEN
            state := 50;
        END_IF;

    50:
        IF bAtZero THEN
            state := 60;
        END_IF;

    60:
        IF aAtTable AND bAtZero AND X56 THEN
            state := 70;
        END_IF;

    70:
        IF aAtTable AND bAtConn AND X56 THEN
            state := 80;
        END_IF;

    80:
        IF aAtTable AND bAtConn AND X56 THEN
            seq := seq + 1;
            D80 := 2;
            D81 := 4;
            D82 := seq;
            state := 90;
        ELSE
            state := 70;
        END_IF;

    90:
        IF (D91 = activeID) OR (activeLoc = 4) THEN
            state := 100;
        END_IF;

    100:
        IF bAtZero THEN
            state := 105;
        END_IF;

    105:
        IF aAtZero AND bAtZero THEN
            state := 110;
        END_IF;

    110:
        IF X53 AND (D91 = activeID) THEN
            state := 120;
        END_IF;

    120:
        IF ((D91 = activeID) AND X52) OR activeServed THEN
            state := 140;
        END_IF;

    140:
        IF (D20 <= 50000) AND (ABS(D21) <= 100) THEN
            state := 150;
        END_IF;

    150:
        IF X56 AND eAtZero AND fAt50 THEN
            state := 160;
        END_IF;

    160:
        IF aAtTable AND bAtZero AND X56 THEN
            state := 170;
        END_IF;

    170:
        IF aAtTable AND bAtConn AND X56 THEN
            state := 180;
        END_IF;

    180:
        IF aAtTable AND bAtConn AND X56 THEN
            seq := seq + 1;
            D80 := 1;
            D81 := 4;
            D82 := seq;
            state := 190;
        ELSE
            state := 170;
        END_IF;

    190:
        IF (D90 = activeID) OR (activeLoc = 0) THEN
            state := 200;
        END_IF;

    200:
        IF bAtZero THEN
            state := 210;
        END_IF;

    210:
        IF aAtSource AND bAtZero AND sourceReady THEN
            state := 220;
        END_IF;

    220:
        IF aAtSource AND bAtConn AND sourceReady THEN
            state := 230;
        END_IF;

    230:
        IF aAtSource AND bAtConn AND sourceReady THEN
            seq := seq + 1;
            D80 := 2;
            D81 := sourceStation;
            D82 := seq;
            state := 240;
        ELSE
            state := 220;
        END_IF;

    240:
        IF activeLoc = sourceStation THEN
            state := 250;
        END_IF;

    250:
        IF bAtZero THEN
            state := 260;
        END_IF;

    260:
        IF activeReturned AND sourceHomeOk AND bAtZero THEN
            IF activeChan = 1 THEN
                D300 := activeID;
                D301 := 1;
            ELSIF activeChan = 2 THEN
                D302 := activeID;
                D303 := 1;
            END_IF;
            activeChan := 0;
            activeID := 0;
            state := 0;
        END_IF;

ELSE
    state := 0;
END_CASE;

aCmd := 0;
bCmd := 0;
cCmd := cHome;
dCmd := dHome;
eCmd := 0;
fCmd := 5000;

CASE state OF
    10:
        aCmd := sourceX;
        bCmd := 0;
        IF activeChan = 1 THEN
            cCmd := 73250;
        ELSIF activeChan = 2 THEN
            dCmd := 73250;
        END_IF;

    20, 30, 40:
        aCmd := sourceX;
        bCmd := 18000;
        IF activeChan = 1 THEN
            cCmd := 73250;
        ELSIF activeChan = 2 THEN
            dCmd := 73250;
        END_IF;

    50:
        aCmd := sourceX;
        bCmd := 0;
        IF activeChan = 1 THEN
            cCmd := 73250;
        ELSIF activeChan = 2 THEN
            dCmd := 73250;
        END_IF;

    60:
        aCmd := 85000;
        bCmd := 0;
        eCmd := 0;
        fCmd := 5000;

    70, 80, 90:
        aCmd := 85000;
        bCmd := 18000;
        eCmd := 0;
        fCmd := 5000;

    100:
        aCmd := 85000;
        bCmd := 0;
        eCmd := 0;
        fCmd := 5000;

    105:
        aCmd := 0;
        bCmd := 0;
        eCmd := 0;
        fCmd := 5000;

    110:
        aCmd := 0;
        bCmd := 0;
        eCmd := targetAngle;
        fCmd := 5000;

    120:
        aCmd := 0;
        bCmd := 0;
        eCmd := targetAngle;
        fCmd := depthCmd;

    140:
        aCmd := 0;
        bCmd := 0;
        eCmd := targetAngle;
        fCmd := 5000;

    150:
        aCmd := 0;
        bCmd := 0;
        eCmd := 0;
        fCmd := 5000;

    160:
        aCmd := 85000;
        bCmd := 0;
        eCmd := 0;
        fCmd := 5000;

    170, 180, 190:
        aCmd := 85000;
        bCmd := 18000;
        eCmd := 0;
        fCmd := 5000;

    200:
        aCmd := 85000;
        bCmd := 0;
        eCmd := 0;
        fCmd := 5000;

    210:
        aCmd := sourceX;
        bCmd := 0;
        IF activeChan = 1 THEN
            cCmd := 73250;
        ELSIF activeChan = 2 THEN
            dCmd := 73250;
        END_IF;

    220, 230, 240:
        aCmd := sourceX;
        bCmd := 18000;
        IF activeChan = 1 THEN
            cCmd := 73250;
        ELSIF activeChan = 2 THEN
            dCmd := 73250;
        END_IF;

    250:
        aCmd := sourceX;
        bCmd := 0;
        IF activeChan = 1 THEN
            cCmd := 73250;
        ELSIF activeChan = 2 THEN
            dCmd := 73250;
        END_IF;

    260:
        aCmd := 0;
        bCmd := 0;
        cCmd := cHome;
        dCmd := dHome;
        eCmd := 0;
        fCmd := 5000;
ELSE
    aCmd := 0;
    bCmd := 0;
    cCmd := cHome;
    dCmd := dHome;
    eCmd := 0;
    fCmd := 5000;
END_CASE;

IF aCmd < -100000 THEN
    aCmd := -100000;
ELSIF aCmd > 100000 THEN
    aCmd := 100000;
END_IF;

IF bCmd < 0 THEN
    bCmd := 0;
ELSIF bCmd > 20000 THEN
    bCmd := 20000;
END_IF;

IF cCmd < 0 THEN
    cCmd := 0;
ELSIF cCmd > 95000 THEN
    cCmd := 95000;
END_IF;

IF dCmd < 0 THEN
    dCmd := 0;
ELSIF dCmd > 95000 THEN
    dCmd := 95000;
END_IF;

IF eCmd < 0 THEN
    eCmd := 0;
ELSIF eCmd > 27000 THEN
    eCmd := 27000;
END_IF;

IF fCmd < 0 THEN
    fCmd := 0;
ELSIF fCmd > 74000 THEN
    fCmd := 74000;
END_IF;

D200 := aCmd;
D204 := bCmd;
D208 := cCmd;
D212 := dCmd;
D216 := eCmd;
D220 := fCmd;

D201 := 1000;
D205 := 1000;
D209 := 1000;
D213 := 1000;
D217 := 1000;
D221 := 1000;

IF D12 <= 4000 THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;
Y21 := TRUE;
Y22 := TRUE;
Y23 := TRUE;
Y24 := TRUE;
Y25 := TRUE;

D82 := seq;

finalCond := X51 AND (state = 0) AND (activeChan = 0) AND aAtZero AND bAtZero AND eAtZero AND fAt50 AND cAtHome AND dAtHome AND (D90 = 0) AND (D91 = 0) AND (D92 = 0);
finalTimer(IN := finalCond, PT := T#100ms);
Y2 := finalTimer.Q AND finalCond;

END_PROGRAM