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
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;

    (* internal *)
    start_edge : R_TRIG;
    grip_timer : TON;
    step       : INT := 0;
    sel_mask   : INT := 0;
    tmp        : INT := 0;
    sel1       : BOOL := FALSE;
    sel2       : BOOL := FALSE;
    sel3       : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

CASE step OF

0: (* WAIT_START - no actuator commands before accepted start *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF start_edge.Q THEN
        sel_mask := D10;
        sel1 := (sel_mask MOD 2) = 1;
        tmp  := sel_mask / 2;
        sel2 := (tmp MOD 2) = 1;
        tmp  := tmp / 2;
        sel3 := (tmp MOD 2) = 1;
        step := 1;
    END_IF

1: (* ensure lift high before any horizontal move *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
    Y22 := TRUE;
    IF X22 THEN
        Y22 := FALSE;
        step := 2;
    END_IF

2: (* lower to source low pose *)
    Y22 := FALSE;
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        step := 3;
    END_IF

3: (* command release of unselected materials at source low *)
    Y24 := NOT sel1;
    Y25 := NOT sel2;
    Y26 := NOT sel3;
    grip_timer(IN := TRUE, PT := T#120ms);
    IF grip_timer.Q THEN
        step := 4;
    END_IF

4: (* confirm unselected released / selected still held *)
    grip_timer(IN := FALSE, PT := T#120ms);
    IF ((sel1 AND X26) OR ((NOT sel1) AND (NOT X26))) AND
       ((sel2 AND X27) OR ((NOT sel2) AND (NOT X27))) AND
       ((sel3 AND X28) OR ((NOT sel3) AND (NOT X28))) THEN
        step := 5;
    END_IF

5: (* lift up carrying only the selected materials *)
    Y23 := FALSE;
    Y22 := TRUE;
    IF X22 THEN
        Y22 := FALSE;
        step := 6;
    END_IF

6: (* move forward to target, lift already >=220mm (at high) *)
    Y22 := FALSE;
    Y23 := FALSE;
    Y21 := FALSE;
    Y20 := TRUE;
    IF X21 THEN
        Y20 := FALSE;
        step := 7;
    END_IF

7: (* lower to target low pose *)
    Y20 := FALSE;
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        step := 8;
    END_IF

8: (* release selected materials at target; unselected remain open from before *)
    Y24 := TRUE;
    Y25 := TRUE;
    Y26 := TRUE;
    grip_timer(IN := TRUE, PT := T#120ms);
    IF grip_timer.Q THEN
        step := 9;
    END_IF

9: (* confirm everything released *)
    grip_timer(IN := FALSE, PT := T#120ms);
    IF (NOT X26) AND (NOT X27) AND (NOT X28) THEN
        step := 10;
    END_IF

10: (* lift up empty head *)
    Y23 := FALSE;
    Y22 := TRUE;
    IF X22 THEN
        Y22 := FALSE;
        step := 11;
    END_IF

11: (* move back to source *)
    Y22 := FALSE;
    Y23 := FALSE;
    Y20 := FALSE;
    Y21 := TRUE;
    IF X20 THEN
        Y21 := FALSE;
        step := 12;
    END_IF

12: (* finalize: travel/lift outputs off, confirm empty head at source upper *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X20 AND X22 AND (NOT X26) AND (NOT X27) AND (NOT X28) THEN
        Y2 := TRUE;
        step := 13;
    END_IF

13: (* maintain completion and terminal state *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    step := 0;

END_CASE

END_PROGRAM