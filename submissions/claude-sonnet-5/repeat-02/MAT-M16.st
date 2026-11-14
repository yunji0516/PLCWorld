PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    start_trig : R_TRIG;
    accepted : BOOL := FALSE;
    completed : BOOL := FALSE;
    feed_done : BOOL := FALSE;
    target : INT := 0;
    edge_deadband : INT := 2;
    length_margin : INT := 2;
END_VAR

start_trig(CLK := X10);

IF start_trig.Q AND NOT accepted THEN
    accepted := TRUE;
    target := D10;
END_IF;

// Default all commanded outputs OFF each scan; overwritten below as needed.
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

IF completed THEN
    // Maintain terminal physical result and completion claim for the rest of the run.
    Y23 := TRUE;
    Y2 := TRUE;
ELSIF accepted THEN
    IF NOT feed_done THEN
        // Steering correction to keep actual edge within the receiving corridor.
        IF D20 > edge_deadband THEN
            Y20 := TRUE;
        ELSIF D20 < -edge_deadband THEN
            Y21 := TRUE;
        END_IF;

        // Feed control toward the requested length, stopping near target
        // so the final delivered length lands within the +/-3 mm tolerance.
        IF D21 < (target - length_margin) THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
            feed_done := TRUE;
        END_IF;

        Y23 := FALSE; // keep receiving clamp open while feeding
    ELSE
        // Feeding complete: stop all motion, command the clamp to secure.
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;

        IF X20 AND (ABS(D21 - target) <= 3) AND (ABS(D20) <= 12) THEN
            completed := TRUE;
            Y2 := TRUE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM