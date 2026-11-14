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

    (* ---- internal state ---- *)
    r0_state : INT := 0;
    r1_state : INT := 0;
    r0_old : INT := 0;
    r1_old : INT := 0;
    active_req : INT := -1;
    liftABusy : BOOL := FALSE;
    liftBBusy : BOOL := FALSE;
    seq : DINT := 0;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    r0_cancel : BOOL := FALSE;
    r1_cancel : BOOL := FALSE;
    r0_last_id : DINT := 0;
    r1_last_id : DINT := 0;
    r0_loc : DINT := 0;
    r1_loc : DINT := 0;
    r0_port : DINT := 0;
    r1_port : DINT := 0;
    r0_station : DINT := 0;
    r1_station : DINT := 0;

    all_home : BOOL := FALSE;
    completion_ready : BOOL := FALSE;
    completionLatch : BOOL := FALSE;
    allHomeTimer : TON;

    POSTOL : DINT := 20;
    VELTOL : DINT := 100;
    RATE_MOVE : DINT := 300;
    RATE_SLOW : DINT := 60;
    NEARZONE : DINT := 4000;

    A_HOME : DINT := 0;
    B_HOME : DINT := 0;
    C_HOME : DINT := 15000;
    D_HOME : DINT := 15000;
    S3_0_HOME : DINT := -85000;
    S3_1_HOME : DINT := -85000;
    S4_0_HOME : DINT := -65000;
    S4_1_HOME : DINT := 65000;
    S4_2_HOME : DINT := 0;

    FORK_CONNECT : DINT := 18000;
    FORK_RETRIEVE : DINT := 0;
END_VAR

(* ================= defaults for freed axes ================= *)
IF active_req = -1 THEN
    D2000 := A_HOME;
    D2004 := B_HOME;
END_IF;

IF NOT liftABusy THEN
    D2008 := C_HOME;
END_IF;
IF NOT liftBBusy THEN
    D2012 := D_HOME;
END_IF;

IF NOT ( (active_req = 0 AND r0_state >= 6 AND r0_state <= 15) OR
         (active_req = 1 AND r1_state >= 6 AND r1_state <= 15) ) THEN
    D2016 := S3_0_HOME;
    D2020 := S3_1_HOME;
END_IF;

IF NOT ( (active_req = 0 AND r0_state >= 16 AND r0_state <= 25) OR
         (active_req = 1 AND r1_state >= 16 AND r1_state <= 25) ) THEN
    D2024 := S4_0_HOME;
    D2028 := S4_1_HOME;
    D2032 := S4_2_HOME;
END_IF;

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;

r0_old := r0_state;
r1_old := r1_state;

(* ================= request 0 ================= *)
CASE r0_state OF

0: (* IDLE *)
    IF D100 <> r0_last_id THEN
        r0_done := FALSE;
        r0_cancel := FALSE;
        r0_last_id := D100;
    END_IF;
    IF (D100 <> 0) AND (NOT r0_done) THEN
        IF X31 THEN
            r0_cancel := TRUE;
            r0_state := 31;
        ELSE
            IF D101 = 0 THEN r0_loc := 0; ELSE r0_loc := 1; END_IF;
            IF (r0_loc = 0 AND NOT liftABusy) OR (r0_loc = 1 AND NOT liftBBusy) THEN
                IF r0_loc = 0 THEN liftABusy := TRUE; ELSE liftBBusy := TRUE; END_IF;
                r0_state := 1;
            END_IF;
        END_IF;
    END_IF;

1: (* RAISE_LIFT *)
    IF r0_loc = 0 THEN
        D2008 := D92;
        IF (ABS(D1008 - D92) <= POSTOL) AND (ABS(D1009) <= VELTOL) THEN
            IF active_req = -1 THEN active_req := 0; r0_state := 2; END_IF;
        END_IF;
    ELSE
        D2012 := D92;
        IF (ABS(D1012 - D92) <= POSTOL) AND (ABS(D1013) <= VELTOL) THEN
            IF active_req = -1 THEN active_req := 0; r0_state := 2; END_IF;
        END_IF;
    END_IF;

2: (* APPROACH_LIFT *)
    IF r0_loc = 0 THEN r0_port := D403; r0_station := 1;
    ELSE r0_port := D406; r0_station := 2; END_IF;
    D2000 := r0_port; D2004 := FORK_RETRIEVE;
    IF (ABS(D1000 - r0_port) <= POSTOL) AND (ABS(D1001) <= VELTOL) AND
       (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 3;
    END_IF;

3: (* LIFT_EXTEND *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 4;
    END_IF;

4: (* LIFT_OWN_EXTRACT *)
    IF ( (r0_station = 1 AND X61 AND D404 = D100) OR
         (r0_station = 2 AND X62 AND D407 = D100) ) THEN
        r0_state := 5;
    END_IF;

5: (* LIFT_RETRACT *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        IF X31 THEN
            r0_cancel := TRUE;
            r0_state := 26;
        ELSE
            r0_state := 6;
        END_IF;
    END_IF;

6: (* MOVE_TO_CROSS *)
    D2000 := D409;
    IF (ABS(D1000 - D409) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r0_state := 7;
    END_IF;

7: (* CROSS_EXTEND *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 8;
    END_IF;

8: (* CROSS_OWN_PLACE *)
    IF X63 AND (D410 = D100) THEN
        r0_state := 9;
    END_IF;

9: (* CROSS_RETRACT *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 10;
    END_IF;

10: (* CROSS_RETREAT *)
    D2000 := r0_port;
    IF (ABS(D1000 - r0_port) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r0_state := 11;
    END_IF;

11: (* CROSS_CONFIGURE_WAIT *)
    D2016 := D500; D2020 := D501;
    IF X70 THEN
        r0_state := 12;
    END_IF;

12: (* CROSS_APPROACH_PICKUP *)
    D2000 := D409;
    IF (ABS(D1000 - D409) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r0_state := 13;
    END_IF;

13: (* CROSS_EXTEND2 *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 14;
    END_IF;

14: (* CROSS_OWN_EXTRACT *)
    IF X63 AND (D410 = D100) THEN
        r0_state := 15;
    END_IF;

15: (* CROSS_RETRACT2 *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        IF X31 THEN
            r0_cancel := TRUE;
            r0_state := 26;
        ELSE
            r0_state := 16;
        END_IF;
    END_IF;

16: (* MOVE_TO_EXCHANGE *)
    D2000 := D412;
    IF (ABS(D1000 - D412) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r0_state := 17;
    END_IF;

17: (* EXCH_EXTEND *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 18;
    END_IF;

18: (* EXCH_OWN_PLACE *)
    IF X64 AND (D413 = D100) THEN
        r0_state := 19;
    END_IF;

19: (* EXCH_RETRACT *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 20;
    END_IF;

20: (* EXCH_RETREAT *)
    D2000 := D409;
    IF (ABS(D1000 - D409) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r0_state := 21;
    END_IF;

21: (* EXCH_CONFIGURE_WAIT *)
    D2024 := D600; D2028 := D601; D2032 := D602;
    IF X75 THEN
        r0_state := 22;
    END_IF;

22: (* EXCH_APPROACH_PICKUP *)
    D2000 := D412;
    IF (ABS(D1000 - D412) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r0_state := 23;
    END_IF;

23: (* EXCH_EXTEND2 *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 24;
    END_IF;

24: (* EXCH_OWN_EXTRACT *)
    IF X64 AND (D413 = D100) THEN
        r0_state := 25;
    END_IF;

25: (* EXCH_RETRACT2 *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 26;
    END_IF;

26: (* MOVE_TO_RETURN *)
    D2000 := r0_port;
    IF (ABS(D1000 - r0_port) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r0_state := 27;
    END_IF;

27: (* RETURN_EXTEND *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r0_state := 28;
    END_IF;

28: (* RETURN_OWN_PLACE *)
    IF ( (r0_station = 1 AND X61 AND D404 = D100) OR
         (r0_station = 2 AND X62 AND D407 = D100) ) THEN
        r0_state := 29;
    END_IF;

29: (* RETURN_RETRACT *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        active_req := -1;
        r0_state := 30;
    END_IF;

30: (* LOWER_LIFT *)
    IF r0_loc = 0 THEN
        D2008 := C_HOME;
        IF (ABS(D1008 - C_HOME) <= POSTOL) AND (ABS(D1009) <= VELTOL) THEN
            r0_state := 31;
        END_IF;
    ELSE
        D2012 := D_HOME;
        IF (ABS(D1012 - D_HOME) <= POSTOL) AND (ABS(D1013) <= VELTOL) THEN
            r0_state := 31;
        END_IF;
    END_IF;

31: (* WAIT_RETURNED *)
    IF X30 THEN
        IF r0_loc = 0 THEN liftABusy := FALSE; ELSE liftBBusy := FALSE; END_IF;
        r0_state := 32;
    END_IF;

32: (* RESPOND *)
    D300 := D100;
    IF r0_cancel THEN D301 := 2; ELSE D301 := 1; END_IF;
    r0_state := 33;

33: (* DONE *)
    r0_done := TRUE;
    IF D100 <> r0_last_id THEN
        r0_state := 0;
    END_IF;

ELSE
    r0_state := 0;
END_CASE;

IF (r0_state <> r0_old) AND
   (r0_state = 4 OR r0_state = 8 OR r0_state = 14 OR r0_state = 18 OR
    r0_state = 24 OR r0_state = 28) THEN
    seq := seq + 1;
END_IF;

(* ================= request 1 ================= *)
CASE r1_state OF

0: (* IDLE *)
    IF D120 <> r1_last_id THEN
        r1_done := FALSE;
        r1_cancel := FALSE;
        r1_last_id := D120;
    END_IF;
    IF (D120 <> 0) AND (NOT r1_done) THEN
        IF X35 THEN
            r1_cancel := TRUE;
            r1_state := 31;
        ELSE
            IF D121 = 0 THEN r1_loc := 0; ELSE r1_loc := 1; END_IF;
            IF (r1_loc = 0 AND NOT liftABusy) OR (r1_loc = 1 AND NOT liftBBusy) THEN
                IF r1_loc = 0 THEN liftABusy := TRUE; ELSE liftBBusy := TRUE; END_IF;
                r1_state := 1;
            END_IF;
        END_IF;
    END_IF;

1: (* RAISE_LIFT *)
    IF r1_loc = 0 THEN
        D2008 := D92;
        IF (ABS(D1008 - D92) <= POSTOL) AND (ABS(D1009) <= VELTOL) THEN
            IF active_req = -1 THEN active_req := 1; r1_state := 2; END_IF;
        END_IF;
    ELSE
        D2012 := D92;
        IF (ABS(D1012 - D92) <= POSTOL) AND (ABS(D1013) <= VELTOL) THEN
            IF active_req = -1 THEN active_req := 1; r1_state := 2; END_IF;
        END_IF;
    END_IF;

2: (* APPROACH_LIFT *)
    IF r1_loc = 0 THEN r1_port := D403; r1_station := 1;
    ELSE r1_port := D406; r1_station := 2; END_IF;
    D2000 := r1_port; D2004 := FORK_RETRIEVE;
    IF (ABS(D1000 - r1_port) <= POSTOL) AND (ABS(D1001) <= VELTOL) AND
       (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 3;
    END_IF;

3: (* LIFT_EXTEND *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 4;
    END_IF;

4: (* LIFT_OWN_EXTRACT *)
    IF ( (r1_station = 1 AND X61 AND D404 = D120) OR
         (r1_station = 2 AND X62 AND D407 = D120) ) THEN
        r1_state := 5;
    END_IF;

5: (* LIFT_RETRACT *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        IF X35 THEN
            r1_cancel := TRUE;
            r1_state := 26;
        ELSE
            r1_state := 6;
        END_IF;
    END_IF;

6: (* MOVE_TO_CROSS *)
    D2000 := D409;
    IF (ABS(D1000 - D409) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r1_state := 7;
    END_IF;

7: (* CROSS_EXTEND *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 8;
    END_IF;

8: (* CROSS_OWN_PLACE *)
    IF X63 AND (D410 = D120) THEN
        r1_state := 9;
    END_IF;

9: (* CROSS_RETRACT *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 10;
    END_IF;

10: (* CROSS_RETREAT *)
    D2000 := r1_port;
    IF (ABS(D1000 - r1_port) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r1_state := 11;
    END_IF;

11: (* CROSS_CONFIGURE_WAIT *)
    D2016 := D500; D2020 := D501;
    IF X70 THEN
        r1_state := 12;
    END_IF;

12: (* CROSS_APPROACH_PICKUP *)
    D2000 := D409;
    IF (ABS(D1000 - D409) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r1_state := 13;
    END_IF;

13: (* CROSS_EXTEND2 *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 14;
    END_IF;

14: (* CROSS_OWN_EXTRACT *)
    IF X63 AND (D410 = D120) THEN
        r1_state := 15;
    END_IF;

15: (* CROSS_RETRACT2 *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        IF X35 THEN
            r1_cancel := TRUE;
            r1_state := 26;
        ELSE
            r1_state := 16;
        END_IF;
    END_IF;

16: (* MOVE_TO_EXCHANGE *)
    D2000 := D412;
    IF (ABS(D1000 - D412) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r1_state := 17;
    END_IF;

17: (* EXCH_EXTEND *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 18;
    END_IF;

18: (* EXCH_OWN_PLACE *)
    IF X64 AND (D413 = D120) THEN
        r1_state := 19;
    END_IF;

19: (* EXCH_RETRACT *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 20;
    END_IF;

20: (* EXCH_RETREAT *)
    D2000 := D409;
    IF (ABS(D1000 - D409) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r1_state := 21;
    END_IF;

21: (* EXCH_CONFIGURE_WAIT *)
    D2024 := D600; D2028 := D601; D2032 := D602;
    IF X75 THEN
        r1_state := 22;
    END_IF;

22: (* EXCH_APPROACH_PICKUP *)
    D2000 := D412;
    IF (ABS(D1000 - D412) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r1_state := 23;
    END_IF;

23: (* EXCH_EXTEND2 *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 24;
    END_IF;

24: (* EXCH_OWN_EXTRACT *)
    IF X64 AND (D413 = D120) THEN
        r1_state := 25;
    END_IF;

25: (* EXCH_RETRACT2 *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 26;
    END_IF;

26: (* MOVE_TO_RETURN *)
    D2000 := r1_port;
    IF (ABS(D1000 - r1_port) <= POSTOL) AND (ABS(D1001) <= VELTOL) THEN
        r1_state := 27;
    END_IF;

27: (* RETURN_EXTEND *)
    D2004 := FORK_CONNECT;
    IF (ABS(D1004 - FORK_CONNECT) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        r1_state := 28;
    END_IF;

28: (* RETURN_OWN_PLACE *)
    IF ( (r1_station = 1 AND X61 AND D404 = D120) OR
         (r1_station = 2 AND X62 AND D407 = D120) ) THEN
        r1_state := 29;
    END_IF;

29: (* RETURN_RETRACT *)
    D2004 := FORK_RETRIEVE;
    IF (ABS(D1004 - FORK_RETRIEVE) <= POSTOL) AND (ABS(D1005) <= VELTOL) THEN
        active_req := -1;
        r1_state := 30;
    END_IF;

30: (* LOWER_LIFT *)
    IF r1_loc = 0 THEN
        D2008 := C_HOME;
        IF (ABS(D1008 - C_HOME) <= POSTOL) AND (ABS(D1009) <= VELTOL) THEN
            r1_state := 31;
        END_IF;
    ELSE
        D2012 := D_HOME;
        IF (ABS(D1012 - D_HOME) <= POSTOL) AND (ABS(D1013) <= VELTOL) THEN
            r1_state := 31;
        END_IF;
    END_IF;

31: (* WAIT_RETURNED *)
    IF X34 THEN
        IF r1_loc = 0 THEN liftABusy := FALSE; ELSE liftBBusy := FALSE; END_IF;
        r1_state := 32;
    END_IF;

32: (* RESPOND *)
    D302 := D120;
    IF r1_cancel THEN D303 := 2; ELSE D303 := 1; END_IF;
    r1_state := 33;

33: (* DONE *)
    r1_done := TRUE;
    IF D120 <> r1_last_id THEN
        r1_state := 0;
    END_IF;

ELSE
    r1_state := 0;
END_CASE;

IF (r1_state <> r1_old) AND
   (r1_state = 4 OR r1_state = 8 OR r1_state = 14 OR r1_state = 18 OR
    r1_state = 24 OR r1_state = 28) THEN
    seq := seq + 1;
END_IF;

D82 := seq;

(* ============ centralized handoff / cell command outputs ============ *)
IF r0_state = 4 THEN
    D80 := 1; D81 := r0_station;
ELSIF r0_state = 8 THEN
    D80 := 2; D81 := 3;
ELSIF r0_state = 14 THEN
    D80 := 1; D81 := 3;
ELSIF r0_state = 18 THEN
    D80 := 2; D81 := 4;
ELSIF r0_state = 24 THEN
    D80 := 1; D81 := 4;
ELSIF r0_state = 28 THEN
    D80 := 2; D81 := r0_station;
ELSIF r1_state = 4 THEN
    D80 := 1; D81 := r1_station;
ELSIF r1_state = 8 THEN
    D80 := 2; D81 := 3;
ELSIF r1_state = 14 THEN
    D80 := 1; D81 := 3;
ELSIF r1_state = 18 THEN
    D80 := 2; D81 := 4;
ELSIF r1_state = 24 THEN
    D80 := 1; D81 := 4;
ELSIF r1_state = 28 THEN
    D80 := 2; D81 := r1_station;
ELSE
    D80 := 0; D81 := 0;
END_IF;

IF r0_state = 11 THEN
    Y70 := TRUE; Y71 := FALSE; D700 := D100; D701 := D526; D702 := 500;
ELSIF (r0_state >= 12) AND (r0_state <= 14) THEN
    Y70 := FALSE; Y71 := TRUE; D700 := D100; D701 := D526; D702 := 500;
ELSIF r1_state = 11 THEN
    Y70 := TRUE; Y71 := FALSE; D700 := D120; D701 := D526; D702 := 500;
ELSIF (r1_state >= 12) AND (r1_state <= 14) THEN
    Y70 := FALSE; Y71 := TRUE; D700 := D120; D701 := D526; D702 := 500;
ELSE
    Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
END_IF;

IF r0_state = 21 THEN
    Y75 := TRUE; Y76 := FALSE; D710 := D100; D711 := D626; D712 := 500;
ELSIF (r0_state >= 22) AND (r0_state <= 24) THEN
    Y75 := FALSE; Y76 := TRUE; D710 := D100; D711 := D626; D712 := 500;
ELSIF r1_state = 21 THEN
    Y75 := TRUE; Y76 := FALSE; D710 := D120; D711 := D626; D712 := 500;
ELSIF (r1_state >= 22) AND (r1_state <= 24) THEN
    Y75 := FALSE; Y76 := TRUE; D710 := D120; D711 := D626; D712 := 500;
ELSE
    Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
END_IF;

(* ============ rate computation (near-zone slow-down) ============ *)
IF ABS(D2000 - D1000) <= NEARZONE THEN D2001 := RATE_SLOW; ELSE D2001 := RATE_MOVE; END_IF;
IF ABS(D2004 - D1004) <= NEARZONE THEN D2005 := RATE_SLOW; ELSE D2005 := RATE_MOVE; END_IF;
IF ABS(D2008 - D1008) <= NEARZONE THEN D2009 := RATE_SLOW; ELSE D2009 := RATE_MOVE; END_IF;
IF ABS(D2012 - D1012) <= NEARZONE THEN D2013 := RATE_SLOW; ELSE D2013 := RATE_MOVE; END_IF;
IF ABS(D2016 - D1016) <= NEARZONE THEN D2017 := RATE_SLOW; ELSE D2017 := RATE_MOVE; END_IF;
IF ABS(D2020 - D1020) <= NEARZONE THEN D2021 := RATE_SLOW; ELSE D2021 := RATE_MOVE; END_IF;
IF ABS(D2024 - D1024) <= NEARZONE THEN D2025 := RATE_SLOW; ELSE D2025 := RATE_MOVE; END_IF;
IF ABS(D2028 - D1028) <= NEARZONE THEN D2029 := RATE_SLOW; ELSE D2029 := RATE_MOVE; END_IF;
IF ABS(D2032 - D1032) <= NEARZONE THEN D2033 := RATE_SLOW; ELSE D2033 := RATE_MOVE; END_IF;

(* ============ final completion tracking ============ *)
all_home := (ABS(D1000 - A_HOME) <= POSTOL) AND (ABS(D1001) <= VELTOL) AND
            (ABS(D1004 - B_HOME) <= POSTOL) AND (ABS(D1005) <= VELTOL) AND
            (ABS(D1008 - C_HOME) <= POSTOL) AND (ABS(D1009) <= VELTOL) AND
            (ABS(D1012 - D_HOME) <= POSTOL) AND (ABS(D1013) <= VELTOL) AND
            (ABS(D1016 - S3_0_HOME) <= POSTOL) AND (ABS(D1017) <= VELTOL) AND
            (ABS(D1020 - S3_1_HOME) <= POSTOL) AND (ABS(D1021) <= VELTOL) AND
            (ABS(D1024 - S4_0_HOME) <= POSTOL) AND (ABS(D1025) <= VELTOL) AND
            (ABS(D1028 - S4_1_HOME) <= POSTOL) AND (ABS(D1029) <= VELTOL) AND
            (ABS(D1032 - S4_2_HOME) <= POSTOL) AND (ABS(D1033) <= VELTOL);

completion_ready := X51 AND all_home AND r0_done AND r1_done;

allHomeTimer(IN := completion_ready, PT := T#100ms);
IF allHomeTimer.Q THEN
    completionLatch := TRUE;
END_IF;

Y2 := completionLatch;
Y30 := completionLatch;

END_PROGRAM