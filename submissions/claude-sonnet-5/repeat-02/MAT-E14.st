PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    start_trig : R_TRIG;
    running    : BOOL;
    decided    : BOOL;
    chosen_left  : BOOL;
    chosen_right : BOOL;
    done       : BOOL;
    diff_left  : INT;
    diff_right : INT;
END_VAR

start_trig(CLK := X10);

IF start_trig.Q THEN
    running := TRUE;
    decided := FALSE;
    chosen_left := FALSE;
    chosen_right := FALSE;
    done := FALSE;
END_IF;

(* Decide which side to use, based on current loads and availability *)
IF running AND NOT decided THEN
    IF X22 AND X23 THEN
        diff_left  := ABS((D21 + D20) - D22);
        diff_right := ABS(D21 - (D22 + D20));
        IF diff_left <= diff_right THEN
            chosen_left := TRUE;
        ELSE
            chosen_right := TRUE;
        END_IF;
        decided := TRUE;
    ELSIF X22 THEN
        chosen_left := TRUE;
        decided := TRUE;
    ELSIF X23 THEN
        chosen_right := TRUE;
        decided := TRUE;
    END_IF;
END_IF;

(* Drive the chosen side until reception is observed, then stop and latch completion *)
IF decided AND NOT done THEN
    IF chosen_left THEN
        Y20 := TRUE;
        Y21 := FALSE;
        IF X20 THEN
            Y20 := FALSE;
            done := TRUE;
        END_IF;
    ELSIF chosen_right THEN
        Y21 := TRUE;
        Y20 := FALSE;
        IF X21 THEN
            Y21 := FALSE;
            done := TRUE;
        END_IF;
    END_IF;
ELSE
    IF NOT decided THEN
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;
END_IF;

IF done THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM