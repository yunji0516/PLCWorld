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

    edge : R_TRIG;
    state : INT := 0;
    target : INT := 0;
END_VAR

edge(CLK := X10);

CASE state OF

0: (* idle - wait for start request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF edge.Q THEN
        target := D10;
        state := 1;
    END_IF;

1: (* move nozzle down to lower position *)
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF NOT X21 THEN
        Y20 := TRUE;
    ELSE
        Y20 := FALSE;
        state := 2;
    END_IF;

2: (* open valve *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
    IF NOT X22 THEN
        Y22 := TRUE;
    ELSE
        state := 3;
    END_IF;

3: (* pump until target volume reached *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    IF D20 < target THEN
        Y23 := TRUE;
    ELSE
        Y23 := FALSE;
        Y22 := FALSE;
        state := 4;
    END_IF;

4: (* wait for valve fully closed *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X23 THEN
        state := 5;
    END_IF;

5: (* move nozzle back up *)
    Y20 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF NOT X20 THEN
        Y21 := TRUE;
    ELSE
        Y21 := FALSE;
        state := 6;
    END_IF;

6: (* completion check and hold *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF (D20 >= target - 2) AND (D20 <= target + 2) AND X20 AND X23 THEN
        Y2 := TRUE;
    END_IF;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM