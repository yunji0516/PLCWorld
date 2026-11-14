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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal *)
    state       : INT := 0;
    recipe      : INT := 0;
    startTrig   : R_TRIG;
END_VAR

startTrig(CLK := X10);

IF startTrig.Q AND state = 0 THEN
    recipe := D10;
    state  := 1;
END_IF;

CASE state OF

0: (* IDLE - wait for accepted start; no actuator operation before Start *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;

1: (* GRIP BOTH SIDES *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X20 AND X21 THEN
        state := 2;
    END_IF;

2: (* OPEN TO FULL OPEN (both sides held -> gap tracks opening_fraction) *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X22 THEN
        state := 3;
    END_IF;

3: (* INSERT - axis stays at full open (no close commanded), gap stays >=150 while
      content/tool front beyond entrance since both sides remain held *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := TRUE;
    Y25 := FALSE;
    IF X24 AND X25 THEN
        state := 4;
    END_IF;

4: (* RETRACT - both sides still held until tool clears entrance (returns home) *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := TRUE;
    IF X23 THEN
        state := 5;
    END_IF;

5: (* RELEASE VACUUM - tool already clear/home, safe to release *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X26 THEN
        state := 6;
    END_IF;

6: (* DONE - all actuator outputs OFF, claim completion, maintain result *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y2  := TRUE;

ELSE
    (* defensive: hold safe state *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;

END_CASE;

END_PROGRAM