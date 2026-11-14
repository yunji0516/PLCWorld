PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    start_rig : R_TRIG;
    photoeye_was_on : BOOL := FALSE;
    state : INT := 0;
END_VAR

start_rig(CLK := X10);

CASE state OF
    0:
        IF start_rig.Q THEN
            state := 1;
            Y20 := TRUE;
            photoeye_was_on := FALSE;
        END_IF;
    1:
        IF X20 THEN
            photoeye_was_on := TRUE;
        END_IF;
        IF photoeye_was_on AND NOT X20 THEN
            Y20 := FALSE;
            state := 2;
        END_IF;
    2:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM