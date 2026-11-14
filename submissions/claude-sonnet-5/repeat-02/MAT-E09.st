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
    D21 : INT;
    (* internal variables *)
    edge        : R_TRIG;
    state       : INT := 0;   // 0=IDLE,1=FILLING,2=STOPPING,3=CHECK,4=DONE,5=FAILED
    target      : INT := 0;
    stableCounter : INT := 0;
    lastD20     : INT := 0;
    scanCount   : DINT := 0;
END_VAR

edge(CLK := X10);
scanCount := scanCount + 1;

CASE state OF

0: (* IDLE - wait for start request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := FALSE;
    IF edge.Q THEN
        target := D10;
        state := 1;
    END_IF;

1: (* FILLING - open valve and run pump until near target *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF D20 >= target - 2 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        stableCounter := 0;
        lastD20 := D20;
        state := 2;
    END_IF;

2: (* STOPPING - keep actuators off, wait for valve fully closed and reading stable *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF D20 = lastD20 THEN
        stableCounter := stableCounter + 1;
    ELSE
        stableCounter := 0;
        lastD20 := D20;
    END_IF;
    IF X21 AND (stableCounter >= 5) THEN
        state := 3;
    END_IF;

3: (* CHECK - evaluate result *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF (D20 >= target - 2) AND (D20 <= target + 2) THEN
        Y2 := TRUE;
        state := 4;
    ELSIF D20 < target - 2 THEN
        (* undershoot: reopen to add more liquid *)
        Y2 := FALSE;
        state := 1;
    ELSE
        (* overshoot: cannot recover, keep actuators off, no completion claim *)
        Y2 := FALSE;
        state := 5;
    END_IF;

4: (* DONE - hold result and completion claim *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := TRUE;

5: (* FAILED - actuators off, no completion claim *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := FALSE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;

END_CASE;

END_PROGRAM