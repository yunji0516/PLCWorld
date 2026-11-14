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
    step        : INT := 0;
    item_count  : INT := 0;
    class_buf   : INT := 0;
    req_val     : INT := 0;
    start_edge  : R_TRIG;
END_VAR

start_edge(CLK := X10);

(* default: all actuator outputs off each scan; set explicitly below where needed *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;

(* keep destination selector aligned with captured class for the whole active
   transport of the item (from pick-up through release) *)
IF step >= 1 AND step <= 9 THEN
    Y25 := (class_buf = 1);
END_IF;

CASE step OF

0: (* WAIT_START *)
    IF start_edge.Q THEN
        req_val    := D10;   (* accept request value / recipe *)
        item_count := 0;
        IF X26 AND X31 THEN
            class_buf := D20;
        ELSE
            class_buf := 0;
        END_IF;
        step := 1;
    END_IF;

1: (* LOWER_TO_PICK: move down to low position at source *)
    Y24 := TRUE;
    IF X22 THEN
        step := 2;
    END_IF;

2: (* CLOSE_GRIP at low contact pose *)
    Y20 := TRUE;
    IF X24 THEN
        step := 3;
    END_IF;

3: (* RAISE_AFTER_PICK: lift before travel (>=360mm, i.e. to high) *)
    Y20 := TRUE;
    Y23 := TRUE;
    IF X23 THEN
        step := 4;
    END_IF;

4: (* ADVANCE toward selected destination *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF X21 THEN
        step := 5;
    END_IF;

5: (* LOWER_AT_TARGET *)
    Y20 := TRUE;
    Y24 := TRUE;
    IF X22 THEN
        step := 6;
    END_IF;

6: (* OPEN_GRIP: release onto receiver *)
    Y20 := FALSE;
    IF X25 THEN
        step := 7;
    END_IF;

7: (* WAIT_RECEIVER_CONFIRM *)
    IF X27 THEN
        step := 8;
    END_IF;

8: (* RAISE_AFTER_RELEASE *)
    Y23 := TRUE;
    IF X23 THEN
        step := 9;
    END_IF;

9: (* RETURN_HOME *)
    Y22 := TRUE;
    IF X20 THEN
        item_count := item_count + 1;
        step := 10;
    END_IF;

10: (* CHECK_NEXT_ITEM *)
    IF item_count < 2 THEN
        IF X26 AND X31 THEN
            class_buf := D20;
            step := 1;
        END_IF;
        (* else: wait here (no actuators asserted) until next item is valid *)
    ELSE
        step := 11;
    END_IF;

11: (* DONE: both items delivered, tool empty at source upper, all actuators off *)
    Y2 := TRUE;

ELSE
    step := 0;

END_CASE;

END_PROGRAM