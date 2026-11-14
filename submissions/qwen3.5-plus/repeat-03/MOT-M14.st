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
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    timer30 : TON;
    timer100 : TON;
    edgeReq : R_TRIG;
END_VAR

edgeReq(CLK := X10);

CASE state OF
    0: (* IDLE *)
        D20 := D10;
        D21 := D12;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF edgeReq.Q THEN
            state := 1;
        END_IF;

    1: (* RETRACT *)
        D20 := D10;
        D21 := 0;
        Y20 := FALSE;
        Y21 := TRUE;
        IF X11 THEN
            state := 2;
        END_IF;

    2: (* ROTATE *)
        D20 := D14;
        D21 := 0;
        Y20 := TRUE;
        Y21 := FALSE;
        IF X12 THEN
            state := 3;
        END_IF;

    3: (* APPROACH *)
        D20 := D14;
        D21 := D15;
        Y20 := FALSE;
        Y21 := TRUE;
        IF X12 AND (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100) THEN
            state := 4;
        END_IF;

    4: (* SETTLE 30ms *)
        D20 := D14;
        D21 := D15;
        Y20 := FALSE;
        Y21 := FALSE;
        timer30(IN := TRUE, PT := T#30ms);
        IF timer30.Q THEN
            state := 5;
        END_IF;
        IF NOT (X12 AND (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100)) THEN
            state := 3;
        END_IF;

    5: (* COMPLETE *)
        D20 := D14;
        D21 := D15;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
        timer100(IN := TRUE, PT := T#100ms);
        IF timer100.Q THEN
            state := 6;
        END_IF;
        IF NOT (X12 AND (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100)) THEN
            state := 3;
        END_IF;

    6: (* DONE *)
        Y2 := TRUE;
        D20 := D14;
        D21 := D15;
END_CASE;

END_PROGRAM