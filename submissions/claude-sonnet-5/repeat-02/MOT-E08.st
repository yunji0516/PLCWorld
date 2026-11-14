PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    requestAccepted : BOOL := FALSE;
    cmdPos : DINT;
    cmdVel : DINT;

    reqReal : REAL;
    sPosReal : REAL;
    sVelReal : REAL;
    uPosReal : REAL;
    uVelReal : REAL;
    relPosErrReal : REAL;
    relVelErrReal : REAL;
    condOK : BOOL;

    stableTimer : TON;
    obsTimer : TON;
END_VAR

(* --- Request acceptance latch --- *)
IF X10 THEN
    requestAccepted := TRUE;
END_IF;

(* --- Command generation: follower target = master position + requested interval, *)
(*     feedforward velocity = master actual speed --- *)
IF requestAccepted THEN
    Y20 := TRUE;

    cmdPos := D11 + D10;
    cmdVel := D12;

    (* Clamp to permitted raw command bounds *)
    IF cmdPos > 200000 THEN
        cmdPos := 200000;
    ELSIF cmdPos < -200000 THEN
        cmdPos := -200000;
    END_IF;

    IF cmdVel > 200000 THEN
        cmdVel := 200000;
    ELSIF cmdVel < -200000 THEN
        cmdVel := -200000;
    END_IF;

    D20 := cmdPos;
    D21 := cmdVel;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
END_IF;

(* --- Error evaluation in physical units --- *)
reqReal  := REAL(D10) * 0.01;
sPosReal := REAL(D11) * 0.01;
sVelReal := REAL(D12) * 0.01;
uPosReal := REAL(D13) * 0.01;
uVelReal := REAL(D14) * 0.01;

relPosErrReal := ABS((uPosReal - sPosReal) - reqReal);
relVelErrReal := ABS(uVelReal - sVelReal);

condOK := (relPosErrReal <= 0.3) AND (relVelErrReal <= 2.0);

(* --- 30 ms continuous stability check before latching Y2 --- *)
stableTimer(IN := requestAccepted AND condOK, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

(* --- 250 ms continuous retention observation after Y2 latched --- *)
obsTimer(IN := Y2 AND condOK, PT := T#250ms);

END_PROGRAM