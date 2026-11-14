PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;
    
    startEdge : R_TRIG;
    placeTimer : TON;
    
    masses : ARRAY[0..3] OF INT;
    bestAssign : ARRAY[0..3] OF INT;
    
    state : INT := 0;
    currentIdx : INT := 0;
    placed : INT := 0;
    
    bestDiff : INT;
    diff : INT;
    i, j, k : INT;
    totalSum, sLeft, sRight : INT;
END_VAR

startEdge(CLK := X10);
placeTimer(IN := (state = 1), PT := T#500ms);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF startEdge.Q THEN
            masses[0] := D20;
            masses[1] := D21;
            masses[2] := D22;
            masses[3] := D23;
            
            totalSum := masses[0] + masses[1] + masses[2] + masses[3];
            bestDiff := 32767;
            
            FOR i := 0 TO 3 DO
                FOR j := i + 1 TO 3 DO
                    sLeft := masses[i] + masses[j];
                    sRight := totalSum - sLeft;
                    diff := ABS(sLeft - sRight);
                    IF diff < bestDiff THEN
                        bestDiff := diff;
                        FOR k := 0 TO 3 DO
                            bestAssign[k] := 1;
                        END_FOR;
                        bestAssign[i] := 0;
                        bestAssign[j] := 0;
                    END_IF;
                END_FOR;
            END_FOR;
            
            currentIdx := 0;
            placed := 0;
            state := 1;
        END_IF;
        
    1:
        IF bestAssign[currentIdx] = 0 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y21 := TRUE;
            Y20 := FALSE;
        END_IF;
        
        IF placeTimer.Q THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            placed := placed + 1;
            currentIdx := currentIdx + 1;
            IF placed < 4 THEN
                state := 1;
            ELSE
                state := 3;
            END_IF;
        END_IF;
        
    3:
        IF X20 THEN
            Y22 := TRUE;
        END_IF;
        IF X23 THEN
            Y22 := FALSE;
            state := 4;
        END_IF;
        
    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE;
        
END_CASE;
END_PROGRAM