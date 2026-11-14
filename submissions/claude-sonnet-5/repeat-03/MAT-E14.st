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

    (* Internal variables *)
    start_trig   : R_TRIG;
    decided      : BOOL := FALSE;
    done         : BOOL := FALSE;
    side_chosen  : INT := 0;   (* 0 = none, 1 = left, 2 = right *)
    w1           : INT := 0;
    diff_left    : INT := 0;
    diff_right   : INT := 0;
END_VAR

start_trig(CLK := X10);

(* --- Decision phase: triggered once on rising edge of Start --- *)
IF start_trig.Q AND NOT decided AND NOT done THEN
    w1 := D20;

    IF X22 AND X23 THEN
        (* Both sides free: choose side minimizing resulting |left-right| *)
        diff_left  := ABS((D21 + w1) - D22);
        diff_right := ABS(D21 - (D22 + w1));
        IF diff_left <= diff_right THEN
            side_chosen := 1;
        ELSE
            side_chosen := 2;
        END_IF;
    ELSIF X22 THEN
        side_chosen := 1;
    ELSIF X23 THEN
        side_chosen := 2;
    ELSE
        side_chosen := 0; (* no side available *)
    END_IF;

    decided := TRUE;
END_IF;

(* --- Execution phase: drive the chosen side until receipt confirmed --- *)
IF decided AND NOT done THEN
    CASE side_chosen OF
        1:
            Y20 := TRUE;
            Y21 := FALSE;
            IF X20 THEN
                Y20  := FALSE;
                Y2   := TRUE;
                done := TRUE;
            END_IF;

        2:
            Y21 := TRUE;
            Y20 := FALSE;
            IF X21 THEN
                Y21  := FALSE;
                Y2   := TRUE;
                done := TRUE;
            END_IF;

        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
    END_CASE;
END_IF;

(* --- Hold phase: maintain completion state, outputs OFF except Y2 --- *)
IF done THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := TRUE;
END_IF;

END_PROGRAM