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

    startEdge : R_TRIG;
    started   : BOOL := FALSE;
    state     : INT := 0;
    mask      : INT := 0;
    sel1      : BOOL := FALSE;
    sel2      : BOOL := FALSE;
    sel3      : BOOL := FALSE;
END_VAR

startEdge(CLK := X10);

IF (NOT started) AND startEdge.Q THEN
    mask := D10;
    CASE mask OF
        1: sel1 := TRUE;  sel2 := FALSE; sel3 := FALSE;
        2: sel1 := FALSE; sel2 := TRUE;  sel3 := FALSE;
        3: sel1 := TRUE;  sel2 := TRUE;  sel3 := FALSE;
        4: sel1 := FALSE; sel2 := FALSE; sel3 := TRUE;
        5: sel1 := TRUE;  sel2 := FALSE; sel3 := TRUE;
        6: sel1 := FALSE; sel2 := TRUE;  sel3 := TRUE;
    ELSE
        sel1 := FALSE; sel2 := FALSE; sel3 := FALSE;
    END_CASE;
    started := TRUE;
    state := 10;
END_IF;

IF NOT started THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y2  := FALSE;
ELSE
    CASE state OF
        10: (* move forward to target; lift already high from initial condition *)
            Y20 := TRUE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            IF X21 THEN
                Y20 := FALSE;
                state := 20;
            END_IF;

        20: (* lower at target *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := TRUE;
            IF X23 THEN
                Y23 := FALSE;
                state := 30;
            END_IF;

        30: (* release only the selected materials, at target, low pose *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := sel1;
            Y25 := sel2;
            Y26 := sel3;
            IF ((NOT sel1) OR (NOT X26)) AND ((NOT sel2) OR (NOT X27)) AND ((NOT sel3) OR (NOT X28)) THEN
                state := 50;
            END_IF;

        50: (* lift the remaining (unselected) materials up from target *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y23 := FALSE;
            Y22 := TRUE;
            IF X22 THEN
                Y22 := FALSE;
                state := 60;
            END_IF;

        60: (* move back to source *)
            Y20 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y21 := TRUE;
            IF X20 THEN
                Y21 := FALSE;
                state := 70;
            END_IF;

        70: (* lower at source *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := TRUE;
            IF X23 THEN
                Y23 := FALSE;
                state := 80;
            END_IF;

        80: (* release unselected materials at their source nests, low pose;
               previously-released selected grips remain released *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := TRUE;
            Y25 := TRUE;
            Y26 := TRUE;
            IF X25 THEN
                state := 100;
            END_IF;

        100: (* lift empty head back to source upper position *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y23 := FALSE;
            Y22 := TRUE;
            IF X22 THEN
                Y22 := FALSE;
                state := 110;
            END_IF;

        110: (* done: claim completion, travel/lift outputs OFF, releases held *)
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
    END_CASE;
END_IF;

END_PROGRAM