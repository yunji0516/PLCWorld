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

    (* internal *)
    start_trig : R_TRIG;
    target : INT := 0;
    state : INT := 0; // 0 = idle/waiting for start, 1 = feeding, 2 = securing, 3 = done/maintain
    edge_deadband : INT := 2;
    actuator_limit : INT := 100;
END_VAR

start_trig(CLK := X10);

IF start_trig.Q AND state = 0 THEN
    target := D10;
    state := 1;
END_IF;

CASE state OF

0:
    // Before start acceptance: all actuator outputs must remain OFF.
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

1:
    // Feeding: clamp open, feed running, steering controls edge error.
    Y23 := FALSE;
    Y22 := TRUE;

    IF D20 > edge_deadband AND D22 > -actuator_limit THEN
        Y20 := TRUE;
        Y21 := FALSE;
    ELSIF D20 < -edge_deadband AND D22 < actuator_limit THEN
        Y21 := TRUE;
        Y20 := FALSE;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;

    IF ABS(D21 - target) <= 3 THEN
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        state := 2;
    END_IF;

2:
    // Securing: feed and steering off, close clamp, wait for confirmed secure with valid result.
    Y22 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := TRUE;

    IF X20 AND ABS(D21 - target) <= 3 AND ABS(D20) <= 12 THEN
        state := 3;
        Y2 := TRUE;
    END_IF;

3:
    // Done: maintain claim and terminal physical result.
    Y22 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := TRUE;
    Y2 := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

END_CASE;

END_PROGRAM