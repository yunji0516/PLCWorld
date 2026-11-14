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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    (* internal *)
    r_trig1  : R_TRIG;
    state    : INT := 0;
    req      : INT := 0;
    fwd_ok   : BOOL := TRUE;
    unwind_on: BOOL := FALSE;
END_VAR

r_trig1(CLK := X10);

CASE state OF

0: (* IDLE - no actuator operation before Start accepted *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;

    IF r_trig1.Q THEN
        req := D10;
        fwd_ok := TRUE;
        unwind_on := FALSE;
        state := 1;
    END_IF;

1: (* EXTRACT: forward move with grip closed, unwind to preserve buffer *)
    (* buffer replenish hysteresis - keep well inside 80..900 *)
    IF D20 <= 250 THEN
        unwind_on := TRUE;
    ELSIF D20 >= 300 THEN
        unwind_on := FALSE;
    END_IF;
    Y26 := unwind_on;

    (* forward-progress hysteresis, safety margin above lower buffer limit *)
    IF D20 <= 90 THEN
        fwd_ok := FALSE;
    ELSIF D20 >= 120 THEN
        fwd_ok := TRUE;
    END_IF;

    IF D21 >= req THEN
        Y20 := FALSE;
        Y26 := FALSE;
        state := 2;
    ELSE
        Y20 := fwd_ok AND X22; (* forward requires grip fully closed *)
        Y21 := FALSE;
    END_IF;

2: (* STOPPING - wait for carriage to be actually at rest *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X21 THEN
        state := 3;
    END_IF;

3: (* CLOSE_RECEIVER - only at rest, at requested length +-3mm *)
    IF X24 THEN
        Y24 := FALSE;
        state := 4;
    ELSE
        Y24 := TRUE;
        Y25 := FALSE;
    END_IF;

4: (* OPEN_GRIP - web now held by closed receiver *)
    IF X23 THEN
        Y23 := FALSE;
        state := 5;
    ELSE
        Y23 := TRUE;
        Y22 := FALSE;
    END_IF;

5: (* REVERSE - requires grip fully open, receiver custody kept (no command) *)
    IF X20 AND X21 THEN
        Y21 := FALSE;
        state := 6;
    ELSE
        IF X23 THEN
            Y21 := TRUE;
        ELSE
            Y21 := FALSE;
        END_IF;
    END_IF;
    Y20 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;

6: (* DONE - all actuator outputs OFF, claim and maintain *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;

    IF (ABS(D21 - req) <= 3) AND X24 AND X23 AND X20 AND X21 THEN
        Y2 := TRUE;
    END_IF;

ELSE
    (* Unknown state guard - force safe idle *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM