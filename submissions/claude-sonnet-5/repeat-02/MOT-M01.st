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

    (* Internal variables *)
    state       : INT := 0;
    reqEdge     : R_TRIG;
    reqA        : DINT := 0;   (* captured target for A horizontal (s) *)
    reqB        : DINT := 0;   (* captured target for B horizontal (u) *)
    holdA       : DINT := 0;   (* A horizontal position to hold during raise *)
    holdB       : DINT := 0;   (* B horizontal position to hold during raise *)

    POS_TOL     : DINT := 20;      (* 0.2 mm * 100 *)
    SPD_TOL     : DINT := 100;     (* 1 mm/s * 100 *)
    RAISE_HGT   : DINT := 40000;   (* 400.00 mm * 100 *)
    SETTLE_PT   : TIME := T#30ms;

    phaseCond   : BOOL := FALSE;

    t1          : TON;   (* raise settle *)
    t2          : TON;   (* horizontal move settle *)
    t3          : TON;   (* lower settle *)
    t4          : TON;   (* final completion settle *)
END_VAR

reqEdge(CLK := X10);

CASE state OF

0:  (* IDLE - motion function must not be activated before request acceptance *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D20 := D11;
    D21 := D14;
    D22 := D16;

    IF reqEdge.Q THEN
        reqA  := D10;
        reqB  := D13;
        holdA := D11;
        holdB := D14;
        state := 1;
    END_IF;

1:  (* Raise A to secure vertical clearance; hold S,U in place *)
    D20 := holdA;
    Y20 := TRUE;
    D21 := holdB;
    Y21 := TRUE;
    D22 := RAISE_HGT;
    Y22 := TRUE;

    phaseCond := (ABS(D16 - RAISE_HGT) <= POS_TOL) AND (ABS(D17) <= SPD_TOL);
    t1(IN := phaseCond, PT := SETTLE_PT);
    IF t1.Q THEN
        state := 2;
    END_IF;

2:  (* Move S and U to their swapped targets while A stays raised *)
    D20 := reqA;
    Y20 := TRUE;
    D21 := reqB;
    Y21 := TRUE;
    D22 := RAISE_HGT;
    Y22 := TRUE;

    phaseCond := (ABS(D11 - reqA) <= POS_TOL) AND (ABS(D12) <= SPD_TOL) AND
                 (ABS(D14 - reqB) <= POS_TOL) AND (ABS(D15) <= SPD_TOL);
    t2(IN := phaseCond, PT := SETTLE_PT);
    IF t2.Q THEN
        state := 3;
    END_IF;

3:  (* Lower A back to working height (0 mm) *)
    D20 := reqA;
    Y20 := TRUE;
    D21 := reqB;
    Y21 := TRUE;
    D22 := 0;
    Y22 := TRUE;

    phaseCond := (ABS(D16 - 0) <= POS_TOL) AND (ABS(D17) <= SPD_TOL);
    t3(IN := phaseCond, PT := SETTLE_PT);
    IF t3.Q THEN
        state := 4;
    END_IF;

4:  (* Final position maintained; confirm and retain completion *)
    D20 := reqA;
    Y20 := TRUE;
    D21 := reqB;
    Y21 := TRUE;
    D22 := 0;
    Y22 := TRUE;

    phaseCond := (ABS(D11 - reqA) <= POS_TOL) AND (ABS(D12) <= SPD_TOL) AND
                 (ABS(D14 - reqB) <= POS_TOL) AND (ABS(D15) <= SPD_TOL) AND
                 (ABS(D16 - 0)    <= POS_TOL) AND (ABS(D17) <= SPD_TOL);
    t4(IN := phaseCond, PT := SETTLE_PT);
    IF t4.Q THEN
        Y2 := TRUE;
    END_IF;

ELSE
    state := 0;

END_CASE;

END_PROGRAM