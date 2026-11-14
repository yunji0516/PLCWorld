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
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal variables *)
    startEdge : R_TRIG;
    state     : INT := 0;
    target    : INT := 0;
END_VAR

startEdge(CLK := X10);

IF startEdge.Q AND (state = 0) THEN
    target := D10;
    state := 1;
END_IF;

CASE state OF

0: (* idle - all actuators off, waiting for start *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

1: (* move nozzle down to lower receiving position *)
    Y21 := FALSE;
    Y20 := TRUE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X21 THEN
        Y20 := FALSE;
        state := 2;
    END_IF;

2: (* open valve while nozzle held stationary at lower position *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    IF X22 THEN
        state := 3;
    END_IF;

3: (* run pump until requested volume reached *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := TRUE;
    IF D20 >= target THEN
        Y23 := FALSE;
        state := 4;
    END_IF;

4: (* stop pump, close valve *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
    Y22 := FALSE;
    IF X23 THEN
        state := 5;
    END_IF;

5: (* move nozzle back up *)
    Y22 := FALSE;
    Y23 := FALSE;
    Y20 := FALSE;
    Y21 := TRUE;
    IF X20 THEN
        Y21 := FALSE;
        state := 6;
    END_IF;

6: (* verify completion conditions *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF (D20 >= target - 2) AND (D20 <= target + 2)
       AND X23 AND X20 AND (NOT Y22) AND (NOT Y23) THEN
        Y2 := TRUE;
        state := 7;
    END_IF;

7: (* maintain terminal result and completion claim *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM