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
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal *)
    state        : INT := 0;
    startTrig    : R_TRIG;
    req_angle    : INT := 0;
    plate_angle_init : INT := 0;
    head_angle_at_grip : INT := 0;
    offset       : INT := 0;
    target_head  : INT := 0;
    diff         : INT := 0;
    rot_tol      : INT := 1;
    i            : INT;
END_VAR

startTrig(CLK := X10);

CASE state OF

0: (* IDLE - wait for start, no actuator commands *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    IF startTrig.Q THEN
        req_angle := D10;
        state := 1;
    END_IF;

1: (* move down to low at source *)
    Y24 := TRUE;
    IF X22 THEN
        Y24 := FALSE;
        state := 2;
    END_IF;

2: (* capture plate/head angle while source valid, then grip *)
    IF X26 AND X31 THEN
        plate_angle_init := D20;
        head_angle_at_grip := D21;
    END_IF;
    Y20 := TRUE;
    IF X24 THEN
        offset := plate_angle_init - head_angle_at_grip;
        state := 3;
    END_IF;

3: (* lift to high before horizontal travel / rotation *)
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        target_head := req_angle - offset;
        state := 4;
    END_IF;

4: (* rotate head to target *)
    diff := target_head - D21;
    FOR i := 1 TO 20 DO
        IF diff > 180 THEN
            diff := diff - 360;
        ELSIF diff <= -180 THEN
            diff := diff + 360;
        END_IF;
    END_FOR;

    IF ABS(diff) <= rot_tol THEN
        Y25 := FALSE;
        Y26 := FALSE;
        state := 5;
    ELSIF diff > 0 THEN
        Y25 := TRUE;
        Y26 := FALSE;
    ELSE
        Y25 := FALSE;
        Y26 := TRUE;
    END_IF;

5: (* advance to receiver *)
    Y21 := TRUE;
    IF X21 THEN
        Y21 := FALSE;
        state := 6;
    END_IF;

6: (* move down to low at receiver *)
    Y24 := TRUE;
    IF X22 THEN
        Y24 := FALSE;
        state := 7;
    END_IF;

7: (* release only with receiver support *)
    IF X27 THEN
        Y20 := FALSE;
        IF X25 THEN
            state := 8;
        END_IF;
    END_IF;

8: (* lift up after release *)
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        state := 9;
    END_IF;

9: (* return empty tool to source *)
    Y22 := TRUE;
    IF X20 THEN
        Y22 := FALSE;
        state := 10;
    END_IF;

10: (* completed - all outputs off except claim, maintain result *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM