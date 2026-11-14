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

    (* Internal variables *)
    state       : INT := 0;
    startEdge   : R_TRIG;
    fireTimer   : TON;
    predicted   : DINT;
END_VAR

(* Detect start request rising edge *)
startEdge(CLK := X10);

CASE state OF

0: (* IDLE - wait for a valid start request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF startEdge.Q AND (D10 = 1) THEN
        state := 1;
    END_IF;

1: (* Advance supply finger - only while pusher is home *)
    IF X23 THEN
        (* Product fully placed: command finger to return *)
        Y22 := FALSE;
        state := 2;
    ELSE
        IF X20 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
        END_IF;
    END_IF;

2: (* Withdraw supply finger fully home *)
    Y22 := FALSE;
    IF X24 THEN
        state := 3;
    END_IF;

3: (* Wait for correct synchronization window to fire *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF D21 > 0 THEN
        predicted := DINT(D20) - DINT(D21); (* remaining arc distance after 1.0 s of extension *)
        IF (predicted <= 30) AND (predicted >= -30) THEN
            fireTimer(IN := FALSE, PT := T#1000ms); (* ensure timer reset before starting *)
            state := 4;
        END_IF;
    END_IF;

4: (* Fire: extend launch pusher for exactly 1.0 s *)
    Y21 := FALSE;
    Y20 := TRUE;
    fireTimer(IN := TRUE, PT := T#1000ms);
    IF fireTimer.Q THEN
        Y20 := FALSE;
        fireTimer(IN := FALSE, PT := T#1000ms);
        state := 5;
    END_IF;

5: (* Retract launch pusher back home *)
    Y20 := FALSE;
    Y21 := TRUE;
    IF X20 THEN
        Y21 := FALSE;
        state := 6;
    END_IF;

6: (* Completion check / hold *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF NOT Y2 THEN
        IF X22 AND X24 AND X20 THEN
            Y2 := TRUE;
        END_IF;
    END_IF;

ELSE
    (* Safety fallback: force outputs off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM