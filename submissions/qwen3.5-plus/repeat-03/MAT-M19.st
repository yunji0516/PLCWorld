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
    state : INT;
    phase : INT;
    cmdSequence : ARRAY[0..3] OF INT;
    cmdIndex : INT;
    d0 : INT;
    d1 : INT;
    d2 : INT;
END_VAR

CASE state OF
    0: // IDLE - wait for start request
        startEdge(CLK := X10);
        IF startEdge.Q THEN
            state := 1;
        END_IF;
        
    1: // DETERMINE - compute best balanced pairing
        d0 := ABS((D20 + D21) - (D22 + D23));
        d1 := ABS((D20 + D22) - (D21 + D23));
        d2 := ABS((D20 + D23) - (D21 + D22));
        
        IF d0 <= d1 AND d0 <= d2 THEN
            // Left: items 0,1  Right: items 2,3
            cmdSequence[0] := 0; cmdSequence[1] := 0;
            cmdSequence[2] := 1; cmdSequence[3] := 1;
        ELSIF d1 <= d0 AND d1 <= d2 THEN
            // Left: items 0,2  Right: items 1,3
            cmdSequence[0] := 0; cmdSequence[1] := 1;
            cmdSequence[2] := 0; cmdSequence[3] := 1;
        ELSE
            // Left: items 0,3  Right: items 1,2
            cmdSequence[0] := 0; cmdSequence[1] := 1;
            cmdSequence[2] := 1; cmdSequence[3] := 0;
        END_IF;
        
        cmdIndex := 0;
        phase := 0;
        state := 2;
        
    2: // PLACING - cycle module for each item
        CASE phase OF
            0: // SETUP - issue placement command from home
                IF cmdIndex < 4 THEN
                    IF cmdSequence[cmdIndex] = 0 THEN
                        Y20 := TRUE;
                        Y21 := FALSE;
                    ELSE
                        Y20 := FALSE;
                        Y21 := TRUE;
                    END_IF;
                    phase := 1;
                ELSE
                    Y20 := FALSE;
                    Y21 := FALSE;
                    Y22 := TRUE;
                    state := 3;
                END_IF;
                
            1: // WAIT_END - module traveling outward, wait for end position
                IF X21 THEN
                    phase := 2;
                END_IF;
                
            2: // RELEASE - turn off command so module returns home
                Y20 := FALSE;
                Y21 := FALSE;
                phase := 3;
                
            3: // WAIT_HOME - module returning, wait for home position
                IF X20 THEN
                    cmdIndex := cmdIndex + 1;
                    phase := 0;
                END_IF;
        END_CASE;
        
    3: // WAIT_DEPARTURE - receiver departing
        IF X23 THEN
            Y22 := FALSE;
            Y2 := TRUE;
            state := 4;
        END_IF;
        
    4: // COMPLETE - hold completion claim
        Y2 := TRUE;
        
    ELSE
        Y2 := TRUE;
END_CASE;

END_PROGRAM