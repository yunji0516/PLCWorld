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

    trig_start : R_TRIG;
    step : INT := 0;
END_VAR

trig_start(CLK := X10);

IF trig_start.Q AND (step = 0) THEN
    step := 10;
END_IF;

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y2 := FALSE;

    10:
        (* Grip receiver with both vacuum sides *)
        Y20 := TRUE;
        Y21 := TRUE;
        IF X20 AND X21 THEN
            step := 20;
        END_IF;

    20:
        (* Open receiver to full opening *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE;
            step := 30;
        END_IF;

    30:
        (* Insert content until seated at full forward *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y24 := TRUE;
        IF X24 AND X25 THEN
            Y24 := FALSE;
            step := 40;
        END_IF;

    40:
        (* Retract insertion slide until tool is fully home and clear *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y25 := TRUE;
        IF X23 THEN
            Y25 := FALSE;
            step := 50;
        END_IF;

    50:
        (* Release vacuum sides now that tool is clear *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF X26 AND NOT X20 AND NOT X21 THEN
            step := 60;
        END_IF;

    60:
        (* Complete: maintain completion claim and all actuators OFF *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
END_CASE;

END_PROGRAM