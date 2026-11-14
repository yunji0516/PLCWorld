```st
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
    X16 : BOOL;
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
    
    eS : R_TRIG;
    eRA : R_TRIG;
    eRB : R_TRIG;
    eFO : R_TRIG;
    ePA : R_TRIG;
    ePB : R_TRIG;
    eOCA : R_TRIG;
    eOCB : R_TRIG;
    eBS : R_TRIG;
    eBF : R_TRIG;
    eAR : R_TRIG;
    eBR : R_TRIG;
    
    tClamp : TON;
    tComplete : TON;
    
    running : BOOL := FALSE;
    step : INT := 0;
    
    accA : BOOL := FALSE;
    accB : BOOL := FALSE;
    
    kitsA : INT := 0;
    kitsB : INT := 0;
    boxesDone : INT := 0;
    
    tgt : INT := 1;
    onDeck : BOOL := FALSE;
    deckKind : INT := 0;
    
    stor0 : INT := 0;
    stor1 : INT := 0;
    stor0Used : BOOL := FALSE;
    stor1Used : BOOL := FALSE;
    
    closeADone : BOOL := FALSE;
    closeBDone : BOOL := FALSE;
    packADone : BOOL := FALSE;
    packBDone : BOOL := FALSE;
    ackADone : BOOL := FALSE;
    ackBDone : BOOL := FALSE;
    relADone : BOOL := FALSE;
    relBDone : BOOL := FALSE;
    feedBoxDone : BOOL := FALSE;
    clampBoxDone : BOOL := FALSE;
    
    completeFlag : BOOL := FALSE;
    
    curGen : INT := 1;
    
    partKindOnDeck : INT := 0;
END_VAR

BEGIN
    eS(CLK := X0);
    eRA(CLK := X13);
    eRB(CLK := X14);
    eFO(CLK := X12);
    ePA(CLK := X22);
    ePB(CLK := X23);
    eOCA(CLK := X19);
    eOCB(CLK := X1A);
    eBS(CLK := X1F);
    eBF(CLK := X24);
    eAR(CLK := X1B);
    eBR(CLK := X1C);
    
    tClamp(IN := clampBoxDone, PT := T#300ms);
    tComplete(IN := completeFlag, PT := T#500ms);
    
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
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    D200 := 0;
    D201 := curGen;
    
    IF NOT running AND eS.Q THEN
        running := TRUE;
        step := 1;
    END_IF;
    
    IF running THEN
        CASE step OF
            1:
                IF eRA.Q AND NOT accA THEN
                    Y13 := TRUE;
                    accA := TRUE;
                END_IF;
                IF eRB.Q AND NOT accB THEN
                    Y14 := TRUE;
                    accB := TRUE;
                END_IF;
                IF accA OR accB OR X15 OR X16 THEN
                    step := 10;
                END_IF;
            
            10:
                tgt := 1;
                Y10 := TRUE;
                D200 := 1;
                IF X11 = FALSE AND D0 = 1 THEN
                    step := 20;
                END_IF;
            
            20:
                Y10 := FALSE;
                IF X10 AND NOT onDeck THEN
                    IF (X15 AND D2 = D11) OR (X16 AND D2 = D12) THEN
                        Y11 := TRUE;
                        step := 30;
                    ELSIF NOT stor0Used THEN
                        Y11 := TRUE;
                        step := 30;
                    ELSIF NOT stor1Used THEN
                        Y11 := TRUE;
                        step := 30;
                    ELSE
                        step := 45;
                    END_IF;
                END_IF;
            
            30:
                Y11 := FALSE;
                IF eFO.Q THEN
                    onDeck := TRUE;
                    deckKind := D2;
                    partKindOnDeck := D2;
                    step := 40;
                END_IF;
            
            40:
                IF (X15 AND partKindOnDeck = D11) THEN
                    tgt := 4;
                    Y10 := TRUE;
                    D200 := 4;
                    step := 50;
                ELSIF (X16 AND partKindOnDeck = D12) THEN
                    tgt := 5;
                    Y10 := TRUE;
                    D200 := 5;
                    step := 50;
                ELSE
                    IF NOT stor0Used THEN
                        tgt := 2;
                        Y10 := TRUE;
                        D200 := 2;
                        step := 55;
                    ELSIF NOT stor1Used THEN
                        tgt := 3;
                        Y10 := TRUE;
                        D200 := 3;
                        step := 55;
                    ELSE
                        step := 45;
                    END_IF;
                END_IF;
            
            45:
                IF (X15 AND stor0Used AND stor0 = D11) THEN
                    tgt := 2;
                ELSIF (X15 AND stor1Used AND stor1 = D11) THEN
                    tgt := 3;
                ELSIF (X16 AND stor0Used AND stor0 = D12) THEN
                    tgt := 2;
                ELSIF (X16 AND stor1Used AND stor1 = D12) THEN
                    tgt := 3;
                ELSE
                    step := 10;
                END_IF;
                Y10 := TRUE;
                D200 := tgt;
                IF X11 = FALSE AND D0 = tgt THEN
                    Y11 := TRUE;
                    IF tgt = 2 THEN
                        stor0Used := FALSE;
                    END_IF;
                    IF tgt = 3 THEN
                        stor1Used := FALSE;
                    END_IF;
                    step := 30;
                END_IF;
            
            50:
                IF X11 = FALSE AND D0 = tgt THEN
                    step := 52;
                END_IF;
            
            52:
                Y10 := FALSE;
                IF D0 = 4 THEN
                    Y12 := TRUE;
                    onDeck := FALSE;
                    step := 60;
                ELSIF D0 = 5 THEN
                    Y12 := TRUE;
                    onDeck := FALSE;
                    step := 60;
                END_IF;
            
            55:
                Y10 := FALSE;
                IF X11 = FALSE AND D0 = tgt THEN
                    Y12 := TRUE;
                    IF tgt = 2 THEN
                        stor0Used := TRUE;
                        stor0 := partKindOnDeck;
                    END_IF;
                    IF tgt = 3 THEN
                        stor1Used := TRUE;
                        stor1 := partKindOnDeck;
                    END_IF;
                    onDeck := FALSE;
                    step := 60;
                END_IF;
            
            60:
                Y12 := FALSE;
                IF X15 AND D13 >= 2 AND NOT closeADone THEN
                    Y15 := TRUE;
                    closeADone := TRUE;
                END_IF;
                IF X16 AND D14 >= 2 AND NOT closeBDone THEN
                    Y16 := TRUE;
                    closeBDone := TRUE;
                END_IF;
                IF closeADone OR closeBDone THEN
                    step := 70;
                ELSE
                    step := 10;
                END_IF;
            
            70:
                IF X17 AND NOT packADone THEN
                    Y1E := TRUE;
                    packADone := TRUE;
                    step := 80;
                ELSIF X18 AND NOT packBDone THEN
                    Y1F := TRUE;
                    packBDone := TRUE;
                    step := 80;
                ELSE
                    step := 10;
                END_IF;
            
            80:
                Y1E := FALSE;
                Y1F := FALSE;
                IF ePA.Q OR ePB.Q THEN
                    step := 90;
                END_IF;
            
            90:
                IF eAR.Q AND NOT ackADone THEN
                    Y19 := TRUE;
                    ackADone := TRUE;
                END_IF;
                IF eBR.Q AND NOT ackBDone THEN
                    Y1A := TRUE;
                    ackBDone := TRUE;
                END_IF;
                step := 100;
            
            100:
                IF eOCA.Q AND NOT relADone THEN
                    Y17 := TRUE;
                    relADone := TRUE;
                    kitsA := kitsA + 1;
                END_IF;
                IF eOCB.Q AND NOT relBDone THEN
                    Y18 := TRUE;
                    relBDone := TRUE;
                    kitsB := kitsB + 1;
                END_IF;
                step := 110;
            
            110:
                IF X1E AND NOT feedBoxDone THEN
                    Y1C := TRUE;
                    feedBoxDone := TRUE;
                END_IF;
                IF eBS.Q AND NOT clampBoxDone THEN
                    Y1D := TRUE;
                    clampBoxDone := TRUE;
                END_IF;
                IF tClamp.Q THEN
                    Y1D := FALSE;
                    clampBoxDone := FALSE;
                END_IF;
                IF X24 AND X25 AND boxesDone < 2 THEN
                    Y20 := TRUE;
                    boxesDone := boxesDone + 1;
                    step := 120;
                END_IF;
            
            120:
                Y1C := FALSE;
                Y20 := FALSE;
                
                IF kitsA >= 2 AND kitsB >= 2 AND boxesDone >= 2 THEN
                    IF D0 = 1 AND NOT onDeck AND X11 = FALSE THEN
                        completeFlag := TRUE;
                    END_IF;
                END_IF;
                
                IF NOT completeFlag THEN
                    accA := FALSE;
                    accB := FALSE;
                    closeADone := FALSE;
                    closeBDone := FALSE;
                    packADone := FALSE;
                    packBDone := FALSE;
                    ackADone := FALSE;
                    ackBDone := FALSE;
                    relADone := FALSE;
                    relBDone := FALSE;
                    feedBoxDone := FALSE;
                    clampBoxDone := FALSE;
                    
                    IF boxesDone >= 2 THEN
                        curGen := curGen + 1;
                        step := 1;
                    ELSE
                        step := 10;
                    END_IF;
                END_IF;
        END_CASE;
    END_IF;
    
    Y1B := completeFlag AND tComplete.Q;
END_PROGRAM
```