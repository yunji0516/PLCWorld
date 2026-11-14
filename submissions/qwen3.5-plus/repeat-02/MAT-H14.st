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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    
    step : INT := 0;
    processed : INT := 0;
    seq_p : INT := 0;
    seq_po : INT := 0;
    tar_mass : INT := 0;
    fin_mass : INT := 0;
    sel_lane : INT := 1;
    tmr_complete : TON;
END_VAR

CASE step OF
    0:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF X0 THEN step := 1; END_IF;
    1:
        Y10 := X10 AND NOT X11; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF X11 THEN step := 2; END_IF;
    2:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := NOT X1E; Y18 := FALSE;
        IF X1E THEN step := 3; END_IF;
    3:
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := TRUE; Y18 := FALSE;
        seq_p := seq_p + 1; D202 := seq_p;
        step := 4;
    4:
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := TRUE; Y18 := FALSE;
        IF X15 AND D4 = seq_p THEN
            tar_mass := D2;
            Y11 := FALSE;
            step := 5;
        END_IF;
    5:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF X1F THEN step := 6; END_IF;
    6:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF X17 THEN sel_lane := 1; ELSIF X19 THEN sel_lane := 2; ELSE step := 6; END_IF;
        D200 := sel_lane; Y12 := TRUE;
        step := 7;
    7:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF (sel_lane = 1 AND X18) OR (sel_lane = 2 AND X1A) THEN step := 8; END_IF;
    8:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := TRUE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF X13 THEN step := 9; END_IF;
    9:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := NOT X20;
        IF X20 THEN step := 10; END_IF;
    10:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := TRUE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := TRUE;
        seq_po := seq_po + 1; D203 := seq_po;
        step := 11;
    11:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := TRUE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := TRUE;
        IF X16 AND D5 = seq_po THEN
            fin_mass := D3;
            Y14 := FALSE;
            step := 12;
        END_IF;
    12:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF X21 THEN step := 13; END_IF;
    13:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF fin_mass - tar_mass >= 95 AND fin_mass - tar_mass <= 105 THEN D204 := 1; ELSE D204 := 2; END_IF;
        IF (D204 = 1 AND X1B) OR (D204 = 2 AND X1C) THEN
            D201 := D204; Y15 := TRUE; step := 14;
        END_IF;
    14:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF NOT X13 OR X1D THEN
            processed := processed + 1;
            IF processed >= 4 THEN step := 15; ELSE step := 1; END_IF;
        END_IF;
    15:
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE; Y17 := FALSE; Y18 := FALSE;
        IF NOT X11 AND NOT X13 THEN
            tmr_complete(IN := TRUE, PT := T#500ms);
            IF tmr_complete.Q THEN Y16 := TRUE; ELSE Y16 := FALSE; END_IF;
        ELSE
            tmr_complete(IN := FALSE);
            Y16 := FALSE;
        END_IF;
END_CASE;
END_PROGRAM