PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D200 : INT;
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

start_edge(CLK := X0);

CASE state OF
    0: (* WAIT_START *)
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        IF start_edge.Q THEN state := 1; END_IF;

    1: (* FEED_ADV *)
        Y10 := TRUE; Y11 := FALSE; Y12 := TRUE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        D200 := D0;
        IF X11 THEN state := 2; END_IF;

    2: (* CUT_DOWN *)
        Y10 := TRUE; Y11 := TRUE; Y12 := FALSE; Y13 := TRUE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        IF X16 THEN state := 3; END_IF;

    3: (* CUT_UP *)
        Y10 := TRUE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        IF X17 THEN state := 4; END_IF;

    4: (* GRIP_RELEASE *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        IF X13 THEN state := 5; END_IF;

    5: (* PAD_DOWN *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := TRUE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        IF X19 THEN state := 6; END_IF;

    6: (* VACUUM_ON *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := TRUE; Y15 := FALSE; Y16 := TRUE; Y17 := FALSE;
        IF X1C THEN state := 7; END_IF;

    7: (* PAD_OUT *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := TRUE; Y15 := TRUE; Y16 := TRUE; Y17 := FALSE;
        IF X1B THEN state := 8; END_IF;

    8: (* VACUUM_OFF *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := TRUE; Y15 := TRUE; Y16 := FALSE; Y17 := FALSE;
        IF NOT X1C THEN state := 9; END_IF;

    9: (* PAD_UP *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := FALSE; Y15 := TRUE; Y16 := FALSE; Y17 := FALSE;
        IF X18 THEN state := 10; END_IF;

    10: (* PAD_RET *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        IF X1A THEN state := 11; END_IF;

    11: (* FEED_RET *)
        Y10 := FALSE; Y11 := TRUE; Y12 := TRUE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        D200 := 100;
        IF X10 THEN state := 12; END_IF;

    12: (* DONE *)
        Y10 := FALSE; Y11 := TRUE; Y12 := FALSE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := TRUE;
END_CASE;

END_PROGRAM