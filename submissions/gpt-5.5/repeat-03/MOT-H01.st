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
    state : INT;
    currentChan : INT;
    currentID : DINT;
    originStation : INT;
    portOrigin : DINT;
    desiredA : DINT;
    desiredB : DINT;
    desiredC : DINT;
    desiredD : DINT;
    desiredE : DINT;
    desiredF : DINT;
    targetAngle : DINT;
    targetDepth : DINT;
    cmdSeq : DINT;
    initDone : BOOL;
    cmdIssued : BOOL;
    pending0 : BOOL;
    pending1 : BOOL;
    y2Latch : BOOL;
    shuttleAtOrigin : BOOL;
    shuttleAtTable : BOOL;
    forkRetracted : BOOL;
    forkConnected : BOOL;
    sourceReady : BOOL;
    liftHome0 : BOOL;
    liftHome1 : BOOL;
    finalReady : BOOL;
    currentLoc : DINT;
    requestReturned : BOOL;
    aHome : BOOL;
    tableZero : BOOL;
    slideHome : BOOL;
END_VAR

IF NOT initDone THEN
    cmdSeq := D96;
    D82 := cmdSeq;
    targetAngle := 9000;
    targetDepth := 70000;
    initDone := TRUE;
END_IF;

IF D100 <> D300 THEN
    D301 := 0;
END_IF;
IF D110 <> D302 THEN
    D303 := 0;
END_IF;

pending0 := (D100 <> 0) AND NOT ((D300 = D100) AND (D301 = 1));
pending1 := (D110 <> 0) AND NOT ((D302 = D110) AND (D303 = 1));

IF originStation = 2 THEN
    portOrigin := -35000;
    sourceReady := X55;
ELSE
    portOrigin := -90000;
    sourceReady := X54;
END_IF;

IF currentChan = 1 THEN
    currentLoc := D114;
    requestReturned := X33;
ELSE
    currentLoc := D104;
    requestReturned := X32;
END_IF;

shuttleAtOrigin := (ABS(D10 - portOrigin) <= 20) AND (ABS(D11) <= 100);
shuttleAtTable := (ABS(D10 - 85000) <= 20) AND (ABS(D11) <= 100);
forkRetracted := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
forkConnected := (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100);
liftHome0 := (ABS(D14 - D150) <= 20) AND (ABS(D15) <= 100);
liftHome1 := (ABS(D16 - D151) <= 20) AND (ABS(D17) <= 100);
aHome := (ABS(D10) <= 20) AND (ABS(D11) <= 100);
tableZero := (ABS(D18) <= 20) AND (ABS(D19) <= 100);
slideHome := (ABS(D20 - 5000) <= 20) AND (ABS(D21) <= 100);

finalReady := X51 AND NOT pending0 AND NOT pending1 AND (state = 0) AND
              (D90 = 0) AND (D91 = 0) AND (D92 = 0) AND
              aHome AND forkRetracted AND tableZero AND slideHome AND liftHome0 AND liftHome1;

desiredA := 0;
desiredB := 0;
desiredC := D150;
desiredD := D151;
desiredE := 0;
desiredF := 5000;

D201 := 1000;
D205 := 1000;
D209 := 1000;
D213 := 1000;
D217 := 1000;
D221 := 1000;

Y20 := TRUE;
Y21 := TRUE;
Y22 := TRUE;
Y23 := TRUE;
Y24 := TRUE;
Y25 := TRUE;

CASE state OF
    0:
        desiredA := 0;
        desiredB := 0;
        desiredC := D150;
        desiredD := D151;
        desiredE := 0;
        desiredF := 5000;
        IF pending0 OR pending1 THEN
            IF pending0 AND pending1 THEN
                IF D103 <= D113 THEN
                    currentChan := 0;
                    currentID := D100;
                    originStation := 1;
                ELSE
                    currentChan := 1;
                    currentID := D110;
                    originStation := 2;
                END_IF;
            ELSIF pending0 THEN
                currentChan := 0;
                currentID := D100;
                originStation := 1;
            ELSE
                currentChan := 1;
                currentID := D110;
                originStation := 2;
            END_IF;
            targetAngle := 9000;
            targetDepth := 70000;
            cmdIssued := FALSE;
            state := 100;
        ELSE
            IF finalReady THEN
                y2Latch := TRUE;
            END_IF;
        END_IF;

    100:
        desiredA := portOrigin;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtOrigin AND forkRetracted AND sourceReady THEN
            state := 120;
        END_IF;

    120:
        desiredA := portOrigin;
        desiredB := 18000;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtOrigin AND forkConnected AND sourceReady THEN
            cmdIssued := FALSE;
            state := 130;
        END_IF;

    130:
        desiredA := portOrigin;
        desiredB := 18000;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtOrigin AND forkConnected AND sourceReady THEN
            IF NOT cmdIssued THEN
                IF cmdSeq <= D96 THEN
                    cmdSeq := D96 + 1;
                ELSE
                    cmdSeq := cmdSeq + 1;
                END_IF;
                D80 := 1;
                D81 := DINT(originStation);
                cmdIssued := TRUE;
            END_IF;
            IF (D90 = currentID) OR (currentLoc = 0) THEN
                state := 140;
            END_IF;
        ELSE
            cmdIssued := FALSE;
            state := 120;
        END_IF;

    140:
        desiredA := portOrigin;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF ((D90 = currentID) OR (currentLoc = 0)) AND forkRetracted THEN
            state := 150;
        END_IF;

    150:
        desiredA := 85000;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtTable AND forkRetracted AND X56 AND ((D91 = 0) OR (D91 = currentID)) THEN
            state := 170;
        END_IF;

    170:
        desiredA := 85000;
        desiredB := 18000;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtTable AND forkConnected AND X56 THEN
            cmdIssued := FALSE;
            state := 180;
        END_IF;

    180:
        desiredA := 85000;
        desiredB := 18000;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtTable AND forkConnected AND X56 THEN
            IF NOT cmdIssued THEN
                IF cmdSeq <= D96 THEN
                    cmdSeq := D96 + 1;
                ELSE
                    cmdSeq := cmdSeq + 1;
                END_IF;
                D80 := 2;
                D81 := 4;
                cmdIssued := TRUE;
            END_IF;
            IF (D91 = currentID) OR (currentLoc = 4) THEN
                state := 190;
            END_IF;
        ELSE
            cmdIssued := FALSE;
            state := 170;
        END_IF;

    190:
        desiredA := 85000;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF D91 = currentID THEN
            IF (D94 >= 8000) AND (D94 <= 10000) THEN
                targetAngle := D94;
            ELSE
                targetAngle := 9000;
            END_IF;
            IF (D95 >= 69000) AND (D95 <= 71000) THEN
                targetDepth := D95;
            ELSE
                targetDepth := 70000;
            END_IF;
        END_IF;
        IF (D91 = currentID) AND forkRetracted THEN
            state := 200;
        END_IF;

    200:
        desiredA := 85000;
        desiredB := 0;
        desiredE := targetAngle;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF D91 = currentID THEN
            IF (D94 >= 8000) AND (D94 <= 10000) THEN
                targetAngle := D94;
            END_IF;
            IF (D95 >= 69000) AND (D95 <= 71000) THEN
                targetDepth := D95;
            END_IF;
        END_IF;
        IF forkRetracted AND X53 THEN
            state := 210;
        END_IF;

    210:
        desiredA := 85000;
        desiredB := 0;
        desiredE := targetAngle;
        desiredF := targetDepth;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF X52 OR ((currentChan = 0) AND X30) OR ((currentChan = 1) AND X31) THEN
            state := 230;
        END_IF;

    230:
        desiredA := 85000;
        desiredB := 0;
        desiredE := targetAngle;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF slideHome THEN
            state := 240;
        END_IF;

    240:
        desiredA := 85000;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF X56 THEN
            state := 250;
        END_IF;

    250:
        desiredA := 85000;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtTable AND forkRetracted AND X56 AND (D91 = currentID) THEN
            state := 260;
        END_IF;

    260:
        desiredA := 85000;
        desiredB := 18000;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtTable AND forkConnected AND X56 THEN
            cmdIssued := FALSE;
            state := 270;
        END_IF;

    270:
        desiredA := 85000;
        desiredB := 18000;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtTable AND forkConnected AND X56 THEN
            IF NOT cmdIssued THEN
                IF cmdSeq <= D96 THEN
                    cmdSeq := D96 + 1;
                ELSE
                    cmdSeq := cmdSeq + 1;
                END_IF;
                D80 := 1;
                D81 := 4;
                cmdIssued := TRUE;
            END_IF;
            IF (D90 = currentID) OR (currentLoc = 0) THEN
                state := 280;
            END_IF;
        ELSE
            cmdIssued := FALSE;
            state := 260;
        END_IF;

    280:
        desiredA := 85000;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF ((D90 = currentID) OR (currentLoc = 0)) AND forkRetracted THEN
            state := 290;
        END_IF;

    290:
        desiredA := portOrigin;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtOrigin AND forkRetracted AND sourceReady THEN
            state := 300;
        END_IF;

    300:
        desiredA := portOrigin;
        desiredB := 18000;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtOrigin AND forkConnected AND sourceReady THEN
            cmdIssued := FALSE;
            state := 310;
        END_IF;

    310:
        desiredA := portOrigin;
        desiredB := 18000;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF shuttleAtOrigin AND forkConnected AND sourceReady THEN
            IF NOT cmdIssued THEN
                IF cmdSeq <= D96 THEN
                    cmdSeq := D96 + 1;
                ELSE
                    cmdSeq := cmdSeq + 1;
                END_IF;
                D80 := 2;
                D81 := DINT(originStation);
                cmdIssued := TRUE;
            END_IF;
            IF (currentLoc = DINT(originStation)) OR (D90 <> currentID) THEN
                state := 320;
            END_IF;
        ELSE
            cmdIssued := FALSE;
            state := 300;
        END_IF;

    320:
        desiredA := portOrigin;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := 73250;
            desiredD := D151;
        ELSE
            desiredC := D150;
            desiredD := 73250;
        END_IF;
        IF (currentLoc = DINT(originStation)) AND forkRetracted THEN
            state := 330;
        END_IF;

    330:
        desiredA := portOrigin;
        desiredB := 0;
        desiredE := 0;
        desiredF := 5000;
        IF originStation = 1 THEN
            desiredC := D150;
            desiredD := D151;
            IF requestReturned AND liftHome0 THEN
                IF currentChan = 0 THEN
                    D300 := currentID;
                    D301 := 1;
                ELSE
                    D302 := currentID;
                    D303 := 1;
                END_IF;
                state := 0;
            END_IF;
        ELSE
            desiredC := D150;
            desiredD := D151;
            IF requestReturned AND liftHome1 THEN
                IF currentChan = 0 THEN
                    D300 := currentID;
                    D301 := 1;
                ELSE
                    D302 := currentID;
                    D303 := 1;
                END_IF;
                state := 0;
            END_IF;
        END_IF;

ELSE
    state := 0;
END_CASE;

IF D12 > 4000 THEN
    Y20 := FALSE;
END_IF;

D200 := desiredA;
D204 := desiredB;
D208 := desiredC;
D212 := desiredD;
D216 := desiredE;
D220 := desiredF;
D82 := cmdSeq;

IF y2Latch THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM