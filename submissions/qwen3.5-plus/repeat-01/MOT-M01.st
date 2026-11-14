PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    reqEdge : R_TRIG;
    settleTimer : TON;
    state : INT := 0;
    targetA : DINT := 0;
    targetB : DINT := 0;
    holdA : DINT := 0;
    holdB : DINT := 0;
    V_RAISE : DINT := 40000;
    V_HOME : DINT := 0;
    TOL : DINT := 20;
    SPD_TOL : DINT := 100;
END_VAR

reqEdge(CLK := X10);

CASE state OF
    0: (* IDLE - Wait for request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        settleTimer(IN := FALSE);
        IF reqEdge.Q THEN
            state := 1;
            targetA := D10;
            targetB := D13;
            holdA := D11;
            holdB := D14;
        END_IF;

    1: (* RAISE_A - Lift A to 400mm vertical clearance *)
        D20 := holdA;
        Y20 := TRUE;
        D21 := holdB;
        Y21 := TRUE;
        D22 := V_RAISE;
        Y22 := TRUE;
        IF (D16 >= (V_RAISE - TOL)) AND (ABS(D17) <= SPD_TOL) THEN
            state := 2;
        END_IF;

    2: (* SWAP_X - Move A and B to swapped horizontal targets *)
        D20 := targetA;
        Y20 := TRUE;
        D21 := targetB;
        Y21 := TRUE;
        D22 := V_RAISE;
        Y22 := TRUE;
        IF (ABS(D11 - targetA) <= TOL) AND (ABS(D12) <= SPD_TOL) AND
           (ABS(D14 - targetB) <= TOL) AND (ABS(D15) <= SPD_TOL) THEN
            state := 3;
        END_IF;

    3: (* LOWER_A - Lower A back to working height 0mm *)
        D20 := targetA;
        Y20 := TRUE;
        D21 := targetB;
        Y21 := TRUE;
        D22 := V_HOME;
        Y22 := TRUE;
        IF (D16 <= (V_HOME + TOL)) AND (ABS(D17) <= SPD_TOL) THEN
            state := 4;
        END_IF;

    4: (* SETTLE_CHECK - Verify all axes settled and assert completion *)
        D20 := targetA;
        Y20 := TRUE;
        D21 := targetB;
        Y21 := TRUE;
        D22 := V_HOME;
        Y22 := TRUE;
        IF (ABS(D11 - targetA) <= TOL) AND (ABS(D14 - targetB) <= TOL) AND
           (ABS(D16 - V_HOME) <= TOL) AND
           (ABS(D12) <= SPD_TOL) AND (ABS(D15) <= SPD_TOL) AND (ABS(D17) <= SPD_TOL) THEN
            settleTimer(IN := TRUE, PT := T#100ms);
            IF settleTimer.Q THEN
                Y2 := TRUE;
            ELSE
                Y2 := FALSE;
            END_IF;
        ELSE
            settleTimer(IN := FALSE);
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM