PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    reqLatched : BOOL;
    state : INT;
    refPos : DINT;
    refVel : DINT;
    relPos : DINT;
    relVel : DINT;
    errRef : DINT;
    propTerm : DINT;
    vDes : DINT;
    dv : DINT;
    dPos : DINT;
    alignTight : BOOL;
    alignOK : BOOL;
    alignCond : BOOL;
    resultCond : BOOL;
    alignTimer : TON;
    resultTimer : TON;
END_VAR

(* Implement the control logic here. *)

IF X10 AND NOT reqLatched THEN
    reqLatched := TRUE;
    state := 1;
    refPos := D11;
    refVel := D12;
    Y2 := FALSE;
END_IF;

relPos := D11 - D13;
relVel := D12 - D14;

alignTight := (ABS(relPos) <= 10) AND (ABS(relVel) <= 50);
alignOK := (ABS(relPos) <= 20) AND (ABS(relVel) <= 100);

alignCond := reqLatched AND (state = 1) AND alignTight;
alignTimer(IN := alignCond, PT := T#50ms);

IF reqLatched AND (state = 1) AND alignTimer.Q THEN
    state := 2;
    refPos := D13;
    refVel := D14;
END_IF;

IF NOT reqLatched THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    D20 := D13;
    D21 := D14;
ELSE
    Y20 := TRUE;

    IF state >= 2 THEN
        Y21 := TRUE;
        refPos := D13;
        refVel := D14;
        D20 := D13;
        D21 := D14;
    ELSE
        Y21 := FALSE;

        errRef := D13 - refPos;
        propTerm := errRef * 3;
        vDes := D14 + propTerm;

        IF vDes > 110000 THEN
            vDes := 110000;
        ELSIF vDes < -110000 THEN
            vDes := -110000;
        END_IF;

        dv := vDes - refVel;
        IF dv > 10000 THEN
            dv := 10000;
        ELSIF dv < -10000 THEN
            dv := -10000;
        END_IF;

        refVel := refVel + dv;

        D20 := refPos;
        D21 := refVel;

        dPos := refVel / 100;
        refPos := refPos + dPos;
    END_IF;
END_IF;

resultCond := reqLatched AND (state >= 2) AND X11 AND alignOK;
resultTimer(IN := resultCond, PT := T#30ms);

IF reqLatched AND resultTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM