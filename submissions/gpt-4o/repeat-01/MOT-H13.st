PROGRAM Main
VAR
    // Inputs
    D1000 : DINT;
    D1001 : DINT;
    D1004 : DINT;
    D1005 : DINT;
    D1008 : DINT;
    D1009 : DINT;
    D1012 : DINT;
    D1013 : DINT;
    D1016 : DINT;
    D1017 : DINT;
    D1020 : DINT;
    D1021 : DINT;
    D1024 : DINT;
    D1025 : DINT;
    D1028 : DINT;
    D1029 : DINT;
    D1032 : DINT;
    D1033 : DINT;
    D100 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    X30 : BOOL;
    X31 : BOOL;
    D120 : DINT;
    D121 : DINT;
    D122 : DINT;
    D123 : DINT;
    D124 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    D403 : DINT;
    D404 : DINT;
    X61 : BOOL;
    D406 : DINT;
    D407 : DINT;
    X62 : BOOL;
    D409 : DINT;
    D410 : DINT;
    X63 : BOOL;
    D412 : DINT;
    D413 : DINT;
    X64 : BOOL;
    D500 : DINT;
    D501 : DINT;
    D502 : DINT;
    D520 : DINT;
    D521 : DINT;
    D522 : DINT;
    D523 : DINT;
    D524 : DINT;
    D525 : DINT;
    D526 : DINT;
    D527 : DINT;
    X70 : BOOL;
    X71 : BOOL;
    X72 : BOOL;
    D600 : DINT;
    D601 : DINT;
    D620 : DINT;
    D621 : DINT;
    D622 : DINT;
    D623 : DINT;
    D624 : DINT;
    D625 : DINT;
    D626 : DINT;
    D627 : DINT;
    X75 : BOOL;
    X76 : BOOL;
    X77 : BOOL;

    // Outputs
    D2000 : DINT;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL;
    D2004 : DINT;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL;
    D2008 : DINT;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL;
    D2012 : DINT;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL;
    D2016 : DINT;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL;
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
    D2024 : DINT;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL;
    D2028 : DINT;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL;
    D2032 : DINT;
    D2033 : DINT;
    D2034 : DINT;
    Y48 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    Y70 : BOOL;
    Y71 : BOOL;
    D700 : DINT;
    D701 : DINT;
    D702 : DINT;
    Y75 : BOOL;
    Y76 : BOOL;
    D710 : DINT;
    D711 : DINT;
    D712 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y30 : BOOL;
    Y2 : BOOL;

    // Internal Variables
    currentRequest : DINT;
    synchronizationEstablished : BOOL;
    errorCount : DINT;
    commonMotorRunning : BOOL;
    timeoutCounter : DINT;
    isCompletionObserved : BOOL;

    // Function block instances
    syncTimer : TON;
    completionEdge : R_TRIG;
END_VAR

(* Initialize internal variables *)
syncTimer(IN := synchronizationEstablished, PT := T#50ms);
completionEdge(CLK := X51);

(* Reset error and timeout counts when necessary *)
IF completionEdge.Q THEN
    errorCount := 0;
    timeoutCounter := 0;
    isCompletionObserved := FALSE;
END_IF

(* Check for synchronization conditions *)
IF NOT synchronizationEstablished THEN
    IF ABS(D1021) > 100 AND ABS(D2021 - D1021) <= 20 AND ABS(D2021 - D1021) <= 100 THEN
        syncTimer(IN := TRUE);
        IF syncTimer.Q THEN
            synchronizationEstablished := TRUE;
        END_IF
    ELSE
        syncTimer(IN := FALSE);
    END_IF
END_IF

(* Maintain motor speed during request processing *)
IF currentRequest <> 0 THEN
    IF NOT commonMotorRunning THEN
        D2017 := 1000; // Set speed to 200°/s
        Y44 := TRUE;   // Enable motor
        commonMotorRunning := TRUE;
    END_IF
ELSE
    Y44 := FALSE;
    commonMotorRunning := FALSE;
END_IF

(* Handle completion conditions *)
IF completionEdge.Q THEN
    Y2 := TRUE;
    timeoutCounter := 0;
END_IF

(* Ensure completion is observed within the required timeframe *)
IF Y2 THEN
    timeoutCounter := timeoutCounter + 1;
    IF timeoutCounter >= 5 THEN // 100 ms with 20 ms scan time
        Y2 := FALSE;
    END_IF
END_IF

(* Handle safety and error conditions *)
IF errorCount >= 3 THEN
    Y44 := FALSE;  // Disable motor on repeated errors
    commonMotorRunning := FALSE;
END_IF

END_PROGRAM