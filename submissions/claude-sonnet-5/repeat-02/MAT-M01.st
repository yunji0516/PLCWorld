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
    state      : INT := 0;
    target     : INT := 0;
    startTrig  : R_TRIG;
END_VAR

startTrig(CLK := X10);

CASE state OF

0: // IDLE - wait for start request
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    IF startTrig.Q THEN
        target := D10;
        state := 1;
    END_IF;

1: // EXTRACTING - move forward with grip closed, unwind to protect buffer
    Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
    IF D21 >= target THEN
        Y20 := FALSE;
        Y26 := FALSE;
        state := 2;
    ELSE
        IF D20 <= 85 THEN
            // buffer near lower limit: pause extraction, keep unwinding
            Y20 := FALSE;
            Y26 := TRUE;
        ELSIF D20 >= 895 THEN
            // buffer near upper limit: stop unwind, continue extraction
            Y20 := TRUE AND X22 AND (NOT X24);
            Y26 := FALSE;
        ELSE
            Y20 := TRUE AND X22 AND (NOT X24);
            Y26 := TRUE;
        END_IF;
    END_IF;

2: // WAIT for carriage to come to rest before touching receiver
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    IF X21 THEN
        IF ABS(D21 - target) <= 3 THEN
            state := 3;
        ELSE
            // not yet at target length; resume extraction phase
            state := 1;
        END_IF;
    END_IF;

3: // CLOSE_RECEIVER - only at rest, at required length
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y26 := FALSE; Y25 := FALSE;
    IF X24 THEN
        Y24 := FALSE;
        state := 4;
    ELSE
        Y24 := TRUE;
    END_IF;

4: // OPEN_GRIP - web now held by closed receiver
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    IF X23 THEN
        Y23 := FALSE;
        state := 5;
    ELSE
        Y23 := TRUE;
    END_IF;

5: // REVERSE_HOME - grip must be fully open to reverse
    Y20 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    IF X20 AND X21 THEN
        Y21 := FALSE;
        state := 6;
    ELSE
        Y21 := TRUE AND X23;
    END_IF;

6: // DONE - claim completion, keep actuators off
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM