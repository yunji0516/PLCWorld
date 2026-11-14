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
    active_request : DINT := 0;
    state : DINT := 0;
END_VAR

(* Implement the control logic here. *)

(* Initialize variables for each new request *)
IF active_request = 0 THEN
    IF NOT X30 AND NOT X31 THEN
        active_request := 1;
    ELSIF NOT X34 AND NOT X35 THEN
        active_request := 2;
    END_IF;
END_IF;

(* Process currently active request based on state *)
CASE state OF
    0: (* Begin processing active request *)
        IF active_request = 1 THEN
            D80 := 2; (* Execute request for D100 *)
            D81 := D101;
            D82 := D103;
            state := 1;
        ELSIF active_request = 2 THEN
            D80 := 2; (* Execute request for D120 *)
            D81 := D121;
            D82 := D123;
            state := 1;
        END_IF;
        
    1: (* Move to Cell 3 *)
        IF X70 THEN
            Y70 := TRUE;
            D700 := D500;
            D701 := D526;
            D702 := 1000; (* Max acceleration *)
            state := 2;
        END_IF;
        
    2: (* Move to Cell 4 *)
        IF X75 THEN
            Y75 := TRUE;
            D710 := D600;
            D711 := D626;
            D712 := 1000; (* Max acceleration *)
            state := 3;
        END_IF;
        
    3: (* Return to original lift *)
        IF X61 THEN
            IF active_request = 1 THEN
                D2008 := 150; (* Return lift A to initial height *)
                D2009 := 850; (* Max rate *)
                Y42 := TRUE;
            ELSIF active_request = 2 THEN
                D2012 := 150; (* Return lift B to initial height *)
                D2013 := 850; (* Max rate *)
                Y43 := TRUE;
            END_IF;
            state := 4;
        END_IF;
        
    4: (* Complete Request *)
        IF X51 THEN
            IF active_request = 1 THEN
                D300 := D100;
                D301 := 1; (* Completion *)
                active_request := 0;
            ELSIF active_request = 2 THEN
                D302 := D120;
                D303 := 1; (* Completion *)
                active_request := 0;
            END_IF;
            state := 0;
            Y2 := TRUE;
        END_IF;
        
ELSE
    state := 0;
END_CASE;

END_PROGRAM