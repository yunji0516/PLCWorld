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

    start_detected : BOOL;
    feed_in_progress : BOOL;
    completion_ready : BOOL;
    edge_valid : BOOL;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q AND NOT start_detected THEN
    start_detected := TRUE;
    feed_in_progress := TRUE;
    completion_ready := FALSE;
    edge_valid := TRUE;
END_IF;

IF feed_in_progress THEN
    IF D20 > 12 OR D20 < -12 THEN
        edge_valid := FALSE;
    END_IF;

    IF D20 > 10 THEN
        Y20 := TRUE;
        Y21 := FALSE;
    ELSIF D20 < -10 THEN
        Y20 := FALSE;
        Y21 := TRUE;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;

    IF X20 THEN
        feed_in_progress := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;

        IF edge_valid AND D20 >= -12 AND D20 <= 12 THEN
            completion_ready := TRUE;
        END_IF;
    END_IF;
END_IF;

IF completion_ready THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM