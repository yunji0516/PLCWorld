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
    (* Add internal variables here. *)
    state : INT;
    reqAngle : DINT;
    reqEntry : DINT;
    rawLimit : DINT;
    retractTarget : DINT;
    slideAtReq : BOOL;
    terminalCond : BOOL;
    terminalTimer : TON;
END_VAR

IF state = 0 THEN
    IF X10 THEN
        reqAngle := D14;
        reqEntry := D15;

        rawLimit := 50000;
        IF D16 < rawLimit THEN
            rawLimit := D16;
        END_IF;
        IF rawLimit < 0 THEN
            rawLimit := 0;
        END_IF;

        IF rawLimit > 100 THEN
            retractTarget := rawLimit - 100;
        ELSE
            retractTarget := 0;
        END_IF;

        state := 10;
    END_IF;
END_IF;

IF state = 10 THEN
    IF X11 THEN
        state := 20;
    END_IF;
END_IF;

IF state = 20 THEN
    IF X12 THEN
        state := 30;
    END_IF;
END_IF;

slideAtReq := (ABS(D12 - reqEntry) <= 20) AND (ABS(D13) <= 100);
terminalCond := (state = 30) AND X12 AND slideAtReq;
terminalTimer(IN := terminalCond, PT := T#30ms);

IF (state = 30) AND terminalTimer.Q THEN
    state := 40;
END_IF;

CASE state OF
    0:
        D20 := D10;
        D21 := D12;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;

    10:
        D20 := D10;
        D21 := retractTarget;
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;

    20:
        D20 := reqAngle;
        D21 := retractTarget;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;

    30:
        D20 := reqAngle;
        IF X12 THEN
            D21 := reqEntry;
        ELSE
            D21 := retractTarget;
        END_IF;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;

    40:
        D20 := reqAngle;
        D21 := reqEntry;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;

ELSE
        D20 := D10;
        D21 := D12;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        state := 0;
END_CASE;

END_PROGRAM