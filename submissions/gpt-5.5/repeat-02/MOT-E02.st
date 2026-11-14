PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    requestAccepted : BOOL;
    homeCompleteSeen : BOOL;
    completionCondition : BOOL;
    settleTimer : TON;
END_VAR

IF X10 THEN
    requestAccepted := TRUE;
END_IF;

IF NOT requestAccepted THEN
    Y21 := FALSE;
    Y2 := FALSE;
    completionCondition := FALSE;
ELSE
    IF Y2 THEN
        Y21 := FALSE;
        completionCondition := homeCompleteSeen AND X11 AND (ABS(D12) <= 100) AND (NOT Y21);
    ELSE
        IF homeCompleteSeen THEN
            Y21 := FALSE;
        ELSE
            IF X11 AND X13 THEN
                homeCompleteSeen := TRUE;
                Y21 := FALSE;
            ELSE
                Y21 := TRUE;
            END_IF;
        END_IF;

        completionCondition := homeCompleteSeen AND X11 AND (ABS(D12) <= 100) AND (NOT Y21);
    END_IF;
END_IF;

settleTimer(IN := completionCondition AND (NOT Y2), PT := T#30ms);

IF requestAccepted AND (NOT Y2) AND settleTimer.Q THEN
    Y2 := TRUE;
    Y21 := FALSE;
END_IF;

END_PROGRAM