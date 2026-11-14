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
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;

    st : INT := 0;
    seqA : INT := 0;
    seqB : INT := 0;
    nItems : INT := 0;
    exchgProg : BOOL := FALSE;
    exchgDone : BOOL := FALSE;
    prevD3 : INT := 0;
    prevD4 : INT := 0;
    nADone : INT := 0;
    nBDone : INT := 0;
    
    tpExt : TON;
    tp13 : TON; tp14 : TON; tp15 : TON; tp16 : TON; tp17 : TON; tp18 : TON; tp19 : TON;
    tpComp : TON;
    
    eX17 : R_TRIG; eX16 : R_TRIG; eX1B : R_TRIG; eX10 : R_TRIG; eX1A : R_TRIG;
    eX1C : R_TRIG; eX18 : R_TRIG; eX14 : R_TRIG; eX13 : R_TRIG; eX11 : R_TRIG;
    eD3 : R_TRIG; eD4 : R_TRIG;
    eRelA : R_TRIG; eRelB : R_TRIG;
END_VAR

eX17(CLK := X17);
eX16(CLK := X16);
eX1B(CLK := X1B);
eX10(CLK := X10);
eX1A(CLK := X1A);
eX1C(CLK := X1C);
eX18(CLK := X18);
eX14(CLK := X14);
eX13(CLK := X13);
eX11(CLK := X11);
eD3(CLK := D3 > prevD3);
eD4(CLK := D4 > prevD4);
eRelA(CLK := X22 AND X23);
eRelB(CLK := X28 AND X29);

CASE st OF
    0: (* WAIT_START *)
        Y10 := TRUE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE; D200 := 0; D201 := 0; Y1A := FALSE;
        IF X0 THEN st := 1; END_IF;

    1: (* PREP_EXTRACT *)
        Y10 := TRUE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        IF X16 AND X11 AND X12 THEN
            Y10 := FALSE;
            st := 2;
        END_IF;

    2: (* WAIT_LOADED *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        IF eX17.Q THEN st := 3; END_IF;

    3: (* EXTRACT_MOVE *)
        Y10 := FALSE; Y11 := TRUE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        Y12 := TRUE;
        tpExt(IN := Y12, PT := T#650ms);
        IF tpExt.Q OR X18 THEN
            Y12 := FALSE;
            st := 4;
        END_IF;

    4: (* SEND_ITEM *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        IF nItems < 3 THEN
            D200 := 1; seqA := seqA + 1; D201 := seqA;
        ELSE
            D200 := 2; seqB := seqB + 1; D201 := seqB;
        END_IF;
        Y13 := TRUE;
        tp13(IN := Y13, PT := T#100ms);
        IF tp13.Q THEN
            Y13 := FALSE;
            st := 5;
        END_IF;

    5: (* WAIT_SHUTTLE_HOME *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        IF eX16.Q THEN
            nItems := nItems + 1;
            IF nItems = 4 AND NOT exchgProg THEN
                st := 6;
            ELSE
                st := 1;
            END_IF;
        END_IF;

    6: (* PREP_SWAP *)
        Y10 := TRUE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        IF eX18.Q AND eX14.Q AND eX13.Q AND eX1A.Q AND X16 THEN
            exchgProg := TRUE;
            Y14 := TRUE;
            tp14(IN := Y14, PT := T#100ms);
            IF tp14.Q THEN
                Y14 := FALSE;
                st := 7;
            END_IF;
        END_IF;

    7: (* WAIT_DOCK_NEW *)
        Y10 := TRUE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        IF eX10.Q AND D0 = 202 THEN
            exchgDone := TRUE;
            st := 8;
        END_IF;

    8: (* TAKE_EMPTY *)
        Y10 := TRUE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        IF eX1B.Q THEN
            Y15 := TRUE;
            tp15(IN := Y15, PT := T#100ms);
            IF tp15.Q THEN
                Y15 := FALSE;
                st := 9;
            END_IF;
        END_IF;

    9: (* WAIT_EMPTY_REMOVED *)
        Y10 := TRUE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
        Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        IF eX1C.Q THEN
            exchgProg := FALSE;
            st := 1;
        END_IF;
END_CASE;

(* Consumption Handling *)
IF eD3.Q THEN
    IF X20 AND NOT X21 THEN
        Y16 := TRUE;
        tp16(IN := Y16, PT := T#100ms);
        IF tp16.Q THEN Y16 := FALSE; END_IF;
    END_IF;
END_IF;

IF eD4.Q THEN
    IF X26 AND NOT X27 THEN
        Y17 := TRUE;
        tp17(IN := Y17, PT := T#100ms);
        IF tp17.Q THEN Y17 := FALSE; END_IF;
    END_IF;
END_IF;

IF eRelA.Q THEN
    Y18 := TRUE;
    tp18(IN := Y18, PT := T#100ms);
    IF tp18.Q THEN Y18 := FALSE; END_IF;
    nADone := nADone + 1;
END_IF;

IF eRelB.Q THEN
    Y19 := TRUE;
    tp19(IN := Y19, PT := T#100ms);
    IF tp19.Q THEN Y19 := FALSE; END_IF;
    nBDone := nBDone + 1;
END_IF;

prevD3 := D3;
prevD4 := D4;

(* Completion Check *)
IF nADone >= 3 AND nBDone >= 4 AND nItems >= 7 AND exchgDone AND D1 = 1 AND X16 AND Y10 AND NOT Y11 THEN
    tpComp(IN := TRUE, PT := T#500ms);
    Y1A := tpComp.Q;
ELSE
    Y1A := FALSE;
    tpComp(IN := FALSE);
END_IF;

END_PROGRAM