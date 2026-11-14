PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;

    (* internal variables *)
    state       : INT := 0;
    itemCount   : INT := 0;
    itemTarget  : INT := 2;
    classLatch  : INT := 0;
    started     : BOOL := FALSE;
    reqValue    : INT := 0;
    startReq    : R_TRIG;
END_VAR

startReq(CLK := X10);

IF startReq.Q AND NOT started THEN
    started  := TRUE;
    reqValue := D10;
END_IF;

CASE state OF

0: (* idle - no actuator commands before Start is accepted *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF started THEN
        state := 1;
    END_IF;

1: (* wait for a valid item present at source, latch its class *)
    IF X26 AND X31 THEN
        classLatch := D20;
        Y25 := (classLatch = 1);
        state := 2;
    END_IF;

2: (* descend to low contact pose at source *)
    Y23 := FALSE;
    Y24 := TRUE;
    IF X22 THEN
        Y24 := FALSE;
        state := 3;
    END_IF;

3: (* close grip to acquire, at low contact pose *)
    Y20 := TRUE;
    IF X24 THEN
        state := 4;
    END_IF;

4: (* lift to high (>=360mm) before travel *)
    Y24 := FALSE;
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        state := 5;
    END_IF;

5: (* advance toward selected accept/reject destination *)
    Y22 := FALSE;
    Y21 := TRUE;
    IF X21 THEN
        Y21 := FALSE;
        state := 6;
    END_IF;

6: (* descend to low pose to release onto receiver *)
    Y23 := FALSE;
    Y24 := TRUE;
    IF X22 THEN
        Y24 := FALSE;
        state := 7;
    END_IF;

7: (* open grip, release only at low pose onto receiver *)
    Y20 := FALSE;
    IF X25 THEN
        state := 8;
    END_IF;

8: (* lift to high before return travel *)
    Y24 := FALSE;
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        state := 9;
    END_IF;

9: (* return toward home/source *)
    Y21 := FALSE;
    Y22 := TRUE;
    IF X20 THEN
        Y22 := FALSE;
        Y25 := FALSE;
        itemCount := itemCount + 1;
        IF itemCount >= itemTarget THEN
            state := 10;
        ELSE
            state := 1;
        END_IF;
    END_IF;

10: (* both items delivered: hold all actuators off, claim completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y2  := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM