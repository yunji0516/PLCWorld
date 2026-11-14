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
    step        : INT := 0;
    startTrig   : R_TRIG;
    accepted    : BOOL := FALSE;
    gripCmd     : BOOL := FALSE;
    rel_angle   : DINT := 0;
    diff        : DINT := 0;
    doneFlag    : BOOL := FALSE;
END_VAR

(* edge detect start *)
startTrig(CLK := X10);

IF startTrig.Q AND (NOT accepted) THEN
    accepted  := TRUE;
    rel_angle := DINT(D20);   (* capture offset before acquisition zeroes D20 *)
    step      := 10;
END_IF;

(* default: bidirectional / motion outputs off each scan, grip driven from gripCmd *)
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

IF NOT doneFlag THEN

    CASE step OF

    0: (* idle, waiting for start *)
        ;

    10: (* descend to low at source *)
        Y24 := TRUE;
        IF X22 THEN
            step := 20;
        END_IF;

    20: (* close grip to acquire *)
        gripCmd := TRUE;
        IF X24 THEN
            step := 30;
        END_IF;

    30: (* raise to high (>=360mm lift) *)
        Y23 := TRUE;
        IF X23 THEN
            step := 40;
        END_IF;

    40: (* rotate plate to requested angle *)
        diff := DINT(D10) - (DINT(D21) + rel_angle);
        WHILE diff > 180 DO
            diff := diff - 360;
        END_WHILE;
        WHILE diff <= -180 DO
            diff := diff + 360;
        END_WHILE;

        IF diff > 1 THEN
            Y25 := TRUE;
            Y26 := FALSE;
        ELSIF diff < -1 THEN
            Y25 := FALSE;
            Y26 := TRUE;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
            step := 50;
        END_IF;

    50: (* advance to receiver *)
        Y21 := TRUE;
        IF X21 THEN
            step := 60;
        END_IF;

    60: (* descend to low at receiver, wait for receiver support *)
        IF NOT X22 THEN
            Y24 := TRUE;
        ELSE
            Y24 := FALSE;
        END_IF;
        IF X22 AND X27 THEN
            step := 70;
        END_IF;

    70: (* release plate *)
        gripCmd := FALSE;
        IF X25 THEN
            step := 80;
        END_IF;

    80: (* raise empty tool *)
        Y23 := TRUE;
        IF X23 THEN
            step := 90;
        END_IF;

    90: (* return to source *)
        Y22 := TRUE;
        IF X20 THEN
            step := 100;
        END_IF;

    100: (* verify final state and claim completion *)
        IF X20 AND X23 AND X25 AND X27 THEN
            Y2       := TRUE;
            doneFlag := TRUE;
        END_IF;

    ELSE
        ;
    END_CASE;

END_IF;

(* grip output driven from latched command, persists across scans *)
Y20 := gripCmd;

(* once claimed, hold completion and keep all motion outputs off *)
IF doneFlag THEN
    Y2  := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
END_IF;

END_PROGRAM