PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    stage : INT;
    x34Edge : R_TRIG;
    configTimer : TON;
    seenReferenceOff : BOOL;
    stopTargetA : DINT;
    targetA : DINT;
    reachB : DINT;
    registeredOrigin : DINT;
    approachDone : BOOL;
    started : BOOL;
END_VAR

(* Implement the control logic here. *)

x34Edge(CLK := X34);
configTimer(IN := (stage = 50), PT := T#600ms);

D20 := 0;
D21 := 1000;
Y20 := FALSE;
D24 := 0;
D25 := 1000;
Y21 := FALSE;
Y30 := FALSE;
Y2 := FALSE;

IF (stage = 0) AND (NOT started) THEN
    seenReferenceOff := FALSE;
    approachDone := FALSE;
END_IF;

CASE stage OF
    0:
        D20 := 0;
        D21 := 100;
        D24 := 0;
        D25 := 1000;
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        IF X0 THEN
            started := TRUE;
            approachDone := FALSE;
            IF X34 THEN
                seenReferenceOff := FALSE;
                stage := 10;
            ELSE
                seenReferenceOff := TRUE;
                stage := 20;
            END_IF;
        END_IF;

    10:
        D20 := 0;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF NOT X34 THEN
            seenReferenceOff := TRUE;
            stage := 20;
        END_IF;

    20:
        D20 := 12000;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF NOT X34 THEN
            seenReferenceOff := TRUE;
        END_IF;
        IF seenReferenceOff AND x34Edge.Q THEN
            stopTargetA := D10;
            stage := 30;
        END_IF;

    30:
        D20 := stopTargetA;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D10 - stopTargetA) <= 20) AND (ABS(D11) <= 100) THEN
            stage := 40;
        END_IF;

    40:
        D20 := stopTargetA;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := TRUE;
        stage := 50;

    50:
        D20 := stopTargetA;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF configTimer.Q THEN
            registeredOrigin := D90;
            targetA := D90 + ((D102 * D101) / 100);
            reachB := D103;
            stage := 60;
        END_IF;

    60:
        D20 := targetA;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D10 - targetA) <= 20) AND (ABS(D11) <= 100) THEN
            stage := 70;
        END_IF;

    70:
        D20 := targetA;
        D21 := 1000;
        Y20 := TRUE;
        D24 := reachB;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D12 - reachB) <= 20) AND (ABS(D13) <= 100) THEN
            approachDone := TRUE;
            stage := 80;
        END_IF;

    80:
        D20 := targetA;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF approachDone AND (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            stage := 90;
        END_IF;

    90:
        D20 := targetA;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y2 := TRUE;

ELSE
        stage := 0;
        started := FALSE;
        seenReferenceOff := FALSE;
        approachDone := FALSE;
END_CASE;

END_PROGRAM