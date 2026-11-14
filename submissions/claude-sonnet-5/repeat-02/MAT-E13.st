PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;

    (* internal *)
    startTrig : R_TRIG;
    pendingStart : BOOL := FALSE;
    state : INT := 0;          (* 0=idle,1=extending,2=retracting,3=done *)
    matched : BOOL := FALSE;
    keyLatched : INT := 0;
    reqLatched : INT := 0;
    doneLatched : BOOL := FALSE;
END_VAR

startTrig(CLK := X10);
IF startTrig.Q THEN
    pendingStart := TRUE;
END_IF;

CASE state OF

0: (* idle - waiting for start, must be at home to latch decision *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF pendingStart AND X20 THEN
        keyLatched := D20;
        reqLatched := D10;
        matched := (keyLatched = reqLatched);
        Y20 := matched;
        Y21 := NOT matched;
        pendingStart := FALSE;
        state := 1;
    END_IF;

1: (* extending - hold selected output until source empties (and, for take path, placement confirmed) *)
    Y20 := matched;
    Y21 := NOT matched;
    IF matched THEN
        IF (D20 = 0) AND X21 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        END_IF;
    ELSE
        IF D20 = 0 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        END_IF;
    END_IF;

2: (* retracting - both outputs off, wait for home *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X20 THEN
        doneLatched := TRUE;
        state := 3;
    END_IF;

3: (* done - hold result and completion claim *)
    Y20 := FALSE;
    Y21 := FALSE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
END_CASE;

Y2 := doneLatched;

END_PROGRAM