PROGRAM Main
VAR
    state : INT := 0;
    req_lane : INT := 0;
    req_pos : DINT := 0;
    couple_seq_val : DINT := 0;
    req1_ack : BOOL := FALSE;
    ton_100 : TON;
    edge_done : R_TRIG;
    
    CONST
        HOME_A : DINT := 0;
        LIFT1_POS : DINT := -405000;
        LIFT2_POS : DINT := -185000;
        C3_POS : DINT := 0;
        C4_POS : DINT := 670000;
        HOME_H : DINT := 40000;
        DOCK_H : DINT := 95000;
        FORK_CONN : DINT := 18000;
        FORK_RET : DINT := 0;
        RATE_MOVE : DINT := 800;
        RATE_SLOW : DINT := 400;
        ACC_VAL : DINT := 1000;
        TOL_POS : DINT := 500;
        TOL_ANG : DINT := 200;
        BOOM_RET : DINT := 8000;
        CLEAR_H : DINT := 22000;
    END_CONST
END_VAR

// Default assignments to prevent latching
D2000 := D1000; D2001 := 0; D2002 := 0; Y40 := FALSE;
D2004 := D1004; D2005 := 0; D2006 := 0; Y41 := FALSE;
D2008 := D1008; D2009 := 0; D2010 := 0; Y42 := FALSE;
D2012 := D1012; D2013 := 0; D2014 := 0; Y43 := FALSE;
D2016 := D1016; D2017 := 0; D2018 := 0; Y44 := FALSE;
D2020 := D1020; D2021 := 0; D2022 := 0; Y45 := FALSE;
D2024 := D1024; D2025 := 0; D2026 := 0; Y46 := FALSE;
D2028 := D1028; D2029 := 0; D2030 := 0; Y47 := FALSE;
D2032 := D1032; D2033 := 0; D2034 := 0; Y48 := FALSE;
D2036 := D1036; D2037 := 0; D2038 := 0; Y49 := FALSE;
D2040 := D1040; D2041 := 0; D2042 := 0; Y50 := FALSE;

D300 := 0; D301 := 0; D302 := 0; D303 := 0;
D80 := 0; D81 := 0; D82 := 0;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
Y30 := FALSE;
Y2 := FALSE;

CASE state OF
    0: // IDLE - Wait for request 0
        IF D100 > 0 AND NOT req1_ack THEN
            req_lane := 0;
            req_pos := LIFT1_POS;
            couple_seq_val := couple_seq_val + 1;
            state := 1;
        END_IF;
        
    1: // REQ0: MOVE TO LIFT
        D2000 := req_pos; D2001 := RATE_MOVE; Y40 := TRUE;
        D2008 := HOME_H; D2009 := RATE_MOVE; Y42 := TRUE;
        D2012 := HOME_H; D2013 := RATE_MOVE; Y43 := TRUE;
        D2004 := FORK_RET; D2005 := RATE_MOVE; Y41 := TRUE;
        // Retract booms, home angles
        D2020 := 0; D2021 := RATE_MOVE; Y45 := TRUE;
        D2028 := 0; D2029 := RATE_MOVE; Y47 := TRUE;
        D2016 := -6500; D2017 := RATE_MOVE; Y44 := TRUE;
        D2024 := 6500; D2025 := RATE_MOVE; Y46 := TRUE;
        // Exchange head home, safe height
        D2032 := -65000; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := 65000; D2037 := RATE_MOVE; Y49 := TRUE;
        D2040 := CLEAR_H; D2041 := RATE_MOVE; Y50 := TRUE;
        
        IF ABS(D1000 - req_pos) < TOL_POS AND ABS(D1008 - HOME_H) < TOL_POS AND ABS(D1012 - HOME_H) < TOL_POS THEN
            state := 2;
        END_IF;

    2: // REQ0: DOCK LIFT
        D2000 := req_pos; D2001 := 0; Y40 := FALSE;
        D2008 := DOCK_H; D2009 := RATE_MOVE; Y42 := TRUE;
        D2012 := DOCK_H; D2013 := RATE_MOVE; Y43 := TRUE;
        D2004 := FORK_CONN; D2005 := RATE_SLOW; Y41 := TRUE;
        D80 := 1; D81 := 1; D82 := couple_seq_val;
        // Maintain others
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := CLEAR_H; D2041 := 0; Y50 := FALSE;
        
        IF ABS(D1008 - DOCK_H) < TOL_POS AND ABS(D1012 - DOCK_H) < TOL_POS AND ABS(D1004 - FORK_CONN) < TOL_POS THEN
            state := 3;
        END_IF;

    3: // REQ0: MOVE TO CELL 3
        D80 := 0; D81 := 0;
        D2000 := C3_POS; D2001 := RATE_MOVE; Y40 := TRUE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        // Maintain cell axes home/retacted
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := CLEAR_H; D2041 := 0; Y50 := FALSE;
        
        IF ABS(D1000 - C3_POS) < TOL_POS THEN
            state := 4;
        END_IF;

    4: // REQ0: PROC CELL 3
        D2000 := C3_POS; D2001 := 0; Y40 := FALSE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        // Configure Cell 3
        Y70 := TRUE; Y71 := TRUE; D700 := req_lane; D702 := ACC_VAL;
        D2016 := D500; D2017 := RATE_MOVE; Y44 := TRUE;
        D2020 := D501; D2021 := RATE_MOVE; Y45 := TRUE;
        D2024 := D502; D2025 := RATE_MOVE; Y46 := TRUE;
        D2028 := D503; D2029 := RATE_MOVE; Y47 := TRUE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := CLEAR_H; D2041 := 0; Y50 := FALSE;
        
        IF X70 OR (ABS(D1016 - D500) < TOL_ANG AND ABS(D1020 - D501) < TOL_POS AND ABS(D1024 - D502) < TOL_ANG AND ABS(D1028 - D503) < TOL_POS) THEN
            Y70 := FALSE; Y71 := FALSE;
            state := 5;
        END_IF;

    5: // REQ0: MOVE TO CELL 4
        D2000 := C4_POS; D2001 := RATE_MOVE; Y40 := TRUE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        // Retract booms, home angles
        D2020 := 0; D2021 := RATE_MOVE; Y45 := TRUE;
        D2028 := 0; D2029 := RATE_MOVE; Y47 := TRUE;
        D2016 := -6500; D2017 := RATE_MOVE; Y44 := TRUE;
        D2024 := 6500; D2025 := RATE_MOVE; Y46 := TRUE;
        // Exchange head safe
        D2032 := -65000; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := 65000; D2037 := RATE_MOVE; Y49 := TRUE;
        D2040 := CLEAR_H; D2041 := RATE_MOVE; Y50 := TRUE;
        
        IF ABS(D1000 - C4_POS) < TOL_POS THEN
            state := 6;
        END_IF;

    6: // REQ0: PROC CELL 4
        D2000 := C4_POS; D2001 := 0; Y40 := FALSE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        // Configure Cell 4
        Y75 := TRUE; Y76 := TRUE; D710 := req_lane; D712 := ACC_VAL;
        D2032 := D600; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := D601; D2037 := RATE_MOVE; Y49 := TRUE;
        D2040 := D602; D2041 := RATE_MOVE; Y50 := TRUE;
        // Maintain booms retracted
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        
        // Safety clearance check enforcement
        IF ABS(D1032 - D1036) < 23000 THEN
            D2040 := MAX(D2040, CLEAR_H);
        END_IF;
        
        IF X75 OR (ABS(D1032 - D600) < TOL_POS AND ABS(D1036 - D601) < TOL_POS AND ABS(D1040 - D602) < TOL_POS) THEN
            Y75 := FALSE; Y76 := FALSE;
            state := 7;
        END_IF;

    7: // REQ0: MOVE BACK TO LIFT
        D2000 := req_pos; D2001 := RATE_MOVE; Y40 := TRUE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        // Retract booms
        D2020 := 0; D2021 := RATE_MOVE; Y45 := TRUE;
        D2028 := 0; D2029 := RATE_MOVE; Y47 := TRUE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        // Exchange head safe
        D2032 := -65000; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := 65000; D2037 := RATE_MOVE; Y49 := TRUE;
        D2040 := CLEAR_H; D2041 := RATE_MOVE; Y50 := TRUE;
        
        IF ABS(D1000 - req_pos) < TOL_POS THEN
            state := 8;
        END_IF;

    8: // REQ0: UNDOCK
        D2000 := req_pos; D2001 := 0; Y40 := FALSE;
        D2008 := HOME_H; D2009 := RATE_MOVE; Y42 := TRUE;
        D2012 := HOME_H; D2013 := RATE_MOVE; Y43 := TRUE;
        D2004 := FORK_RET; D2005 := RATE_SLOW; Y41 := TRUE;
        D80 := 2; D81 := 1; D82 := couple_seq_val;
        // Maintain others
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := CLEAR_H; D2041 := 0; Y50 := FALSE;
        
        IF ABS(D1008 - HOME_H) < TOL_POS AND ABS(D1012 - HOME_H) < TOL_POS AND ABS(D1004 - FORK_RET) < TOL_POS THEN
            state := 9;
        END_IF;

    9: // REQ0: ACK & WAIT RETURN
        D80 := 0; D81 := 0;
        D300 := D100; D301 := 1;
        IF X30 THEN
            req1_ack := TRUE;
            state := 10;
        END_IF;

    10: // WAIT REQ1
        IF D120 > 0 THEN
            req_lane := 1;
            req_pos := LIFT2_POS;
            couple_seq_val := couple_seq_val + 1;
            state := 11;
        END_IF;

    11: // REQ1: MOVE TO LIFT
        D2000 := req_pos; D2001 := RATE_MOVE; Y40 := TRUE;
        D2008 := HOME_H; D2009 := RATE_MOVE; Y42 := TRUE;
        D2012 := HOME_H; D2013 := RATE_MOVE; Y43 := TRUE;
        D2004 := FORK_RET; D2005 := RATE_MOVE; Y41 := TRUE;
        D2020 := 0; D2021 := RATE_MOVE; Y45 := TRUE;
        D2028 := 0; D2029 := RATE_MOVE; Y47 := TRUE;
        D2016 := -6500; D2017 := RATE_MOVE; Y44 := TRUE;
        D2024 := 6500; D2025 := RATE_MOVE; Y46 := TRUE;
        D2032 := -65000; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := 65000; D2037 := RATE_MOVE; Y49 := TRUE;
        D2040 := CLEAR_H; D2041 := RATE_MOVE; Y50 := TRUE;
        
        IF ABS(D1000 - req_pos) < TOL_POS AND ABS(D1008 - HOME_H) < TOL_POS AND ABS(D1012 - HOME_H) < TOL_POS THEN
            state := 12;
        END_IF;

    12: // REQ1: DOCK LIFT
        D2000 := req_pos; D2001 := 0; Y40 := FALSE;
        D2008 := DOCK_H; D2009 := RATE_MOVE; Y42 := TRUE;
        D2012 := DOCK_H; D2013 := RATE_MOVE; Y43 := TRUE;
        D2004 := FORK_CONN; D2005 := RATE_SLOW; Y41 := TRUE;
        D80 := 1; D81 := 2; D82 := couple_seq_val;
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := CLEAR_H; D2041 := 0; Y50 := FALSE;
        
        IF ABS(D1008 - DOCK_H) < TOL_POS AND ABS(D1012 - DOCK_H) < TOL_POS AND ABS(D1004 - FORK_CONN) < TOL_POS THEN
            state := 13;
        END_IF;

    13: // REQ1: MOVE TO CELL 3
        D80 := 0; D81 := 0;
        D2000 := C3_POS; D2001 := RATE_MOVE; Y40 := TRUE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := CLEAR_H; D2041 := 0; Y50 := FALSE;
        
        IF ABS(D1000 - C3_POS) < TOL_POS THEN
            state := 14;
        END_IF;

    14: // REQ1: PROC CELL 3
        D2000 := C3_POS; D2001 := 0; Y40 := FALSE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        Y70 := TRUE; Y71 := TRUE; D700 := req_lane; D702 := ACC_VAL;
        D2016 := D500; D2017 := RATE_MOVE; Y44 := TRUE;
        D2020 := D501; D2021 := RATE_MOVE; Y45 := TRUE;
        D2024 := D502; D2025 := RATE_MOVE; Y46 := TRUE;
        D2028 := D503; D2029 := RATE_MOVE; Y47 := TRUE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := CLEAR_H; D2041 := 0; Y50 := FALSE;
        
        IF X70 OR (ABS(D1016 - D500) < TOL_ANG AND ABS(D1020 - D501) < TOL_POS AND ABS(D1024 - D502) < TOL_ANG AND ABS(D1028 - D503) < TOL_POS) THEN
            Y70 := FALSE; Y71 := FALSE;
            state := 15;
        END_IF;

    15: // REQ1: MOVE TO CELL 4
        D2000 := C4_POS; D2001 := RATE_MOVE; Y40 := TRUE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        D2020 := 0; D2021 := RATE_MOVE; Y45 := TRUE;
        D2028 := 0; D2029 := RATE_MOVE; Y47 := TRUE;
        D2016 := -6500; D2017 := RATE_MOVE; Y44 := TRUE;
        D2024 := 6500; D2025 := RATE_MOVE; Y46 := TRUE;
        D2032 := -65000; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := 65000; D2037 := RATE_MOVE; Y49 := TRUE;
        D2040 := CLEAR_H; D2041 := RATE_MOVE; Y50 := TRUE;
        
        IF ABS(D1000 - C4_POS) < TOL_POS THEN
            state := 16;
        END_IF;

    16: // REQ1: PROC CELL 4
        D2000 := C4_POS; D2001 := 0; Y40 := FALSE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        Y75 := TRUE; Y76 := TRUE; D710 := req_lane; D712 := ACC_VAL;
        D2032 := D600; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := D601; D2037 := RATE_MOVE; Y49 := TRUE;
        D2040 := D602; D2041 := RATE_MOVE; Y50 := TRUE;
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        
        IF ABS(D1032 - D1036) < 23000 THEN
            D2040 := MAX(D2040, CLEAR_H);
        END_IF;
        
        IF X75 OR (ABS(D1032 - D600) < TOL_POS AND ABS(D1036 - D601) < TOL_POS AND ABS(D1040 - D602) < TOL_POS) THEN
            Y75 := FALSE; Y76 := FALSE;
            state := 17;
        END_IF;

    17: // REQ1: MOVE BACK TO LIFT
        D2000 := req_pos; D2001 := RATE_MOVE; Y40 := TRUE;
        D2008 := DOCK_H; D2009 := 0; Y42 := FALSE;
        D2012 := DOCK_H; D2013 := 0; Y43 := FALSE;
        D2004 := FORK_CONN; D2005 := 0; Y41 := FALSE;
        D2020 := 0; D2021 := RATE_MOVE; Y45 := TRUE;
        D2028 := 0; D2029 := RATE_MOVE; Y47 := TRUE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        D2032 := -65000; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := 65000; D2037 := RATE_MOVE; Y49 := TRUE;
        D2040 := CLEAR_H; D2041 := RATE_MOVE; Y50 := TRUE;
        
        IF ABS(D1000 - req_pos) < TOL_POS THEN
            state := 18;
        END_IF;

    18: // REQ1: UNDOCK
        D2000 := req_pos; D2001 := 0; Y40 := FALSE;
        D2008 := HOME_H; D2009 := RATE_MOVE; Y42 := TRUE;
        D2012 := HOME_H; D2013 := RATE_MOVE; Y43 := TRUE;
        D2004 := FORK_RET; D2005 := RATE_SLOW; Y41 := TRUE;
        D80 := 2; D81 := 2; D82 := couple_seq_val;
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := CLEAR_H; D2041 := 0; Y50 := FALSE;
        
        IF ABS(D1008 - HOME_H) < TOL_POS AND ABS(D1012 - HOME_H) < TOL_POS AND ABS(D1004 - FORK_RET) < TOL_POS THEN
            state := 19;
        END_IF;

    19: // REQ1: ACK & WAIT RETURN
        D80 := 0; D81 := 0;
        D302 := D120; D303 := 1;
        IF X34 THEN
            state := 20;
        END_IF;

    20: // COMPLETION CHECK
        // All axes home/zero, lifts at home
        D2000 := HOME_A; D2001 := 0; Y40 := FALSE;
        D2004 := FORK_RET; D2005 := 0; Y41 := FALSE;
        D2008 := HOME_H; D2009 := 0; Y42 := FALSE;
        D2012 := HOME_H; D2013 := 0; Y43 := FALSE;
        D2016 := -6500; D2017 := 0; Y44 := FALSE;
        D2020 := 0; D2021 := 0; Y45 := FALSE;
        D2024 := 6500; D2025 := 0; Y46 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2032 := -65000; D2033 := 0; Y48 := FALSE;
        D2036 := 65000; D2037 := 0; Y49 := FALSE;
        D2040 := 0; D2041 := 0; Y50 := FALSE;
        
        IF ABS(D1000 - HOME_A) < TOL_POS AND ABS(D1004 - FORK_RET) < TOL_POS AND 
           ABS(D1008 - HOME_H) < TOL_POS AND ABS(D1012 - HOME_H) < TOL_POS AND
           ABS(D1016 - (-6500)) < TOL_ANG AND ABS(D1020) < TOL_POS AND
           ABS(D1024 - 6500) < TOL_ANG AND ABS(D1028) < TOL_POS AND
           ABS(D1032 - (-65000)) < TOL_POS AND ABS(D1036 - 65000) < TOL_POS AND ABS(D1040) < TOL_POS THEN
            ton_100(IN := TRUE, PT := T#100ms);
            IF ton_100.Q THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            ton_100(IN := FALSE, PT := T#100ms);
            Y2 := FALSE;
        END_IF;
END_CASE;

edge_done(CLK := Y2);

END_PROGRAM