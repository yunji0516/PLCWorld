PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

CASE state OF
    0: (* IDLE - wait for start edge *)
        start_edge(CLK := X10);
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
    1: (* SCRAP_ACQUIRE - engage scrap vacuum at lower contact *)
        Y21 := TRUE;
        Y20 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X21 THEN
            state := 2;
        END_IF;
    2: (* SCRAP_RAISE - lift carrier with scraps held *)
        Y21 := TRUE; Y26 := TRUE;
        Y20 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X27 THEN
            Y26 := FALSE;
            state := 3;
        END_IF;
    3: (* HEAD_MOVE_TO_SOURCE - travel to source with head high *)
        Y21 := TRUE;
        Y20 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := TRUE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X25 THEN
            Y25 := FALSE;
            state := 4;
        END_IF;
    4: (* HEAD_LOW_SOURCE - lower head at source *)
        Y21 := TRUE;
        Y20 := FALSE; Y22 := FALSE; Y23 := TRUE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X23 THEN
            Y23 := FALSE;
            state := 5;
        END_IF;
    5: (* HEAD_ACQUIRE - pick up product *)
        Y21 := TRUE; Y20 := TRUE;
        Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X20 THEN
            state := 6;
        END_IF;
    6: (* HEAD_RAISE - raise product to safe travel height *)
        Y21 := TRUE; Y20 := TRUE; Y22 := TRUE;
        Y23 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X22 THEN
            Y22 := FALSE;
            state := 7;
        END_IF;
    7: (* HEAD_MOVE_TO_RECEIVER - transport product to receiver *)
        Y21 := TRUE; Y20 := TRUE;
        Y22 := FALSE; Y23 := FALSE;
        Y24 := TRUE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X24 THEN
            Y24 := FALSE;
            state := 8;
        END_IF;
    8: (* HEAD_LOW_RECEIVER - lower head at receiver for release *)
        Y21 := TRUE; Y20 := TRUE;
        Y22 := FALSE; Y23 := TRUE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X23 THEN
            Y23 := FALSE;
            state := 9;
        END_IF;
    9: (* HEAD_RELEASE - drop product on receiver *)
        Y21 := TRUE; Y20 := FALSE;
        Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        state := 10;
    10: (* HEAD_HIGH_HOME - raise empty head to home upper *)
        Y21 := TRUE;
        Y20 := FALSE; Y22 := TRUE;
        Y23 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF X22 THEN
            Y22 := FALSE;
            state := 11;
        END_IF;
    11: (* COMPLETE - product on receiver, head at home upper, scraps held *)
        Y2 := TRUE;
        Y21 := TRUE;
        Y20 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
END_CASE;

END_PROGRAM