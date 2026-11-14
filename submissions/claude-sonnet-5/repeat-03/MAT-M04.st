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

    (* internal state *)
    state : INT := 0;
    item : INT := 0;
    class1 : INT := 0;
    class2 : INT := 0;
    cur_class : INT := 0;
    req : INT := 0;

    startTrig : R_TRIG;
END_VAR

(* --- start request handling --- *)
startTrig(CLK := X10);

IF (state = 0) AND startTrig.Q THEN
    req := D10;
    item := 1;
    state := 1;
END_IF;

(* --- default: all actuator outputs OFF each scan; explicit states re-assert as needed --- *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;

(* determine class of item currently being handled *)
IF item = 1 THEN
    cur_class := class1;
ELSE
    cur_class := class2;
END_IF;

CASE state OF

0: (* IDLE - wait for start; no actuator commands *)
    ;

1: (* WAIT_SOURCE: latch class while item is valid at source *)
    IF X26 AND X31 THEN
        IF item = 1 THEN
            class1 := D20;
        ELSE
            class2 := D20;
        END_IF;
        state := 2;
    END_IF;

2: (* LOWER to pick pose *)
    Y24 := TRUE;
    IF X22 THEN
        state := 3;
    END_IF;

3: (* GRIP close *)
    Y20 := TRUE;
    IF X24 THEN
        state := 4;
    END_IF;

4: (* LIFT to travel height (>=360mm) *)
    Y20 := TRUE;
    Y23 := TRUE;
    IF X23 THEN
        state := 5;
    END_IF;

5: (* ADVANCE toward selected receiver *)
    Y20 := TRUE;
    Y25 := (cur_class = 1);
    Y21 := TRUE;
    IF X21 THEN
        state := 6;
    END_IF;

6: (* LOWER at target to release pose *)
    Y20 := TRUE;
    Y25 := (cur_class = 1);
    Y24 := TRUE;
    IF X22 THEN
        state := 7;
    END_IF;

7: (* RELEASE - open grip onto receiver *)
    Y25 := (cur_class = 1);
    Y20 := FALSE;
    IF X25 THEN
        state := 8;
    END_IF;

8: (* LIFT after release *)
    Y25 := (cur_class = 1);
    Y23 := TRUE;
    IF X23 THEN
        state := 9;
    END_IF;

9: (* RETURN toward home/source *)
    Y22 := TRUE;
    IF X20 THEN
        IF item = 1 THEN
            item := 2;
            state := 1;
        ELSE
            state := 20;
        END_IF;
    END_IF;

20: (* FINAL_CHECK: empty tool at source upper position, all outputs off *)
    IF X20 AND X23 AND X25 THEN
        Y2 := TRUE;
        state := 21;
    END_IF;

21: (* HOLD: maintain completion result for remainder of run *)
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM