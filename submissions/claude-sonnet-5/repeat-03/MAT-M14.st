PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal *)
    state : INT := 0;
    startTrig : R_TRIG;
    fireTimer : TON;
    retractTimer : TON;
    predicted : INT;
END_VAR

startTrig(CLK := X10);

(* default outputs off each scan, overridden below where required *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;

IF (state = 0) AND startTrig.Q AND (D10 = 1) THEN
    state := 1;
END_IF;

CASE state OF

    0: // idle - waiting for start request
        ; // outputs already off

    1: // advance supply finger, only if pusher is home
        IF X20 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
        END_IF;
        IF X23 THEN
            Y22 := FALSE;
            state := 2;
        END_IF;

    2: // wait for supply finger to fully retract
        Y22 := FALSE;
        IF X24 THEN
            state := 3;
        END_IF;

    3: // wait for correct alignment of receiving pocket, then fire
        predicted := D20 - D21; // predicted remaining arc distance after 1.0 s fire travel
        IF X23 AND X24 AND X20 AND (predicted >= -30) AND (predicted <= 30) THEN
            state := 4;
        END_IF;

    4: // firing pusher for exactly 1.0 s
        Y20 := TRUE;
        fireTimer(IN := TRUE, PT := T#1s);
        IF fireTimer.Q THEN
            Y20 := FALSE;
            fireTimer(IN := FALSE, PT := T#1s);
            state := 5;
        END_IF;

    5: // retracting pusher for exactly 1.0 s
        Y21 := TRUE;
        retractTimer(IN := TRUE, PT := T#1s);
        IF retractTimer.Q THEN
            Y21 := FALSE;
            retractTimer(IN := FALSE, PT := T#1s);
            state := 6;
        END_IF;

    6: // completion reached - hold claim, keep actuators off
        Y2 := TRUE;

    ELSE
        ; // unreachable, outputs already off
END_CASE;

END_PROGRAM