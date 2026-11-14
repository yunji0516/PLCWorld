PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    edge_start : R_TRIG;
    state : INT;
    feed_scans : DINT;
END_VAR

edge_start(CLK := X10);

IF state = 0 THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    IF edge_start.Q THEN
        state := 1;
        feed_scans := 0;
    END_IF;
END_IF;

IF state = 1 THEN
    feed_scans := feed_scans + 1;
    IF X20 AND (feed_scans >= 50) THEN
        state := 2;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
    ELSE
        IF (D20 > 0) AND (D21 > -95) THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF (D20 < 0) AND (D21 < 95) THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
    END_IF;
END_IF;

IF state = 2 THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

END_PROGRAM