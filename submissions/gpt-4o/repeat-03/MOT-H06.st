PROGRAM Main
VAR
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
    D1036 : DINT;
    D1037 : DINT;
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
    D602 : DINT;
    D603 : DINT;
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
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
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
    requestState : INT; (* 0 - idle, 1 - active, 2 - cancelled *)
    position_a : DINT;
    position_b : DINT;
    position_c : DINT;
    position_d : DINT;
    completionTimer : TON;
    cancellationTimer : TON;
END_VAR

(* Initialization *)
IF requestState = 0 THEN
    IF X31 OR X35 THEN
        requestState := 2; (* Cancellation Mode *)
        cancellationTimer(IN := TRUE, PT := T#100ms);
    ELSIF D102 > 0 OR D122 > 0 THEN
        requestState := 1; (* Active Request Mode *)
    END_IF
END_IF

(* Cancellation Handling *)
IF requestState = 2 THEN
    IF cancellationTimer.Q THEN
        IF D102 > 0 THEN
            D300 := D100; (* Set cancellation completion ID *)
            D301 := 2; (* Set cancellation status *)
        ELSIF D122 > 0 THEN
            D302 := D120; (* Set cancellation completion ID *)
            D303 := 2; (* Set cancellation status *)
        END_IF
        requestState := 0; (* Return to idle *)
    END_IF
END_IF

(* Active Request Mode *)
IF requestState = 1 THEN
    (* Check completion condition *)
    IF X51 AND D1000 = 0 AND D1004 = 0 AND D1008 = 150 AND D1012 = 150 THEN
        completionTimer(IN := TRUE, PT := T#100ms);
        IF completionTimer.Q THEN
            IF D102 > 0 THEN
                D300 := D100; (* Set completion ID *)
                D301 := 1; (* Set completion status *)
            ELSIF D122 > 0 THEN
                D302 := D120; (* Set completion ID *)
                D303 := 1; (* Set completion status *)
            END_IF
            requestState := 0; (* Return to idle *)
        END_IF
    END_IF
END_IF

(* Outputs for Safety *)
Y40 := FALSE;
Y41 := FALSE;
Y42 := FALSE;
Y43 := FALSE;
Y44 := FALSE;
Y45 := FALSE;
Y46 := FALSE;
Y47 := FALSE;
Y48 := FALSE;
Y49 := FALSE;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;
Y30 := X52;
Y2 := X51 AND requestState = 0;

END_PROGRAM