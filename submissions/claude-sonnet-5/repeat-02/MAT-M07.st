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
    D20 : INT;

    (* Internal variables *)
    started : BOOL := FALSE;
    state : INT := 0;
    target_spacing : INT := 0;
    edge : R_TRIG;
END_VAR

edge(CLK := X10);

IF edge.Q AND NOT started THEN
    started := TRUE;
    target_spacing := D10;
    state := 1;
END_IF;

IF NOT started THEN
    (* No commands before start is accepted *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
ELSE
    CASE state OF

        1: (* Move down at source to low contact pose *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
            Y24 := FALSE;
            Y22 := FALSE;
            Y23 := TRUE;
            IF X23 THEN
                Y23 := FALSE;
                state := 2;
            END_IF;

        2: (* Grip both materials at low contact pose *)
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := TRUE;
            IF X24 THEN
                state := 3;
            END_IF;

        3: (* Lift up to high position (>=220mm clearance) *)
            Y24 := TRUE;
            Y23 := FALSE;
            Y22 := TRUE;
            IF X22 THEN
                Y22 := FALSE;
                state := 4;
            END_IF;

        4: (* Adjust spacing to requested target while lifted *)
            Y24 := TRUE;
            IF D20 < target_spacing THEN
                Y25 := TRUE;
                Y26 := FALSE;
            ELSIF D20 > target_spacing THEN
                Y25 := FALSE;
                Y26 := TRUE;
            ELSE
                Y25 := FALSE;
                Y26 := FALSE;
                state := 5;
            END_IF;

        5: (* Move horizontally to target while lifted *)
            Y24 := TRUE;
            Y25 := FALSE;
            Y26 := FALSE;
            Y21 := FALSE;
            Y20 := TRUE;
            IF X21 THEN
                Y20 := FALSE;
                state := 6;
            END_IF;

        6: (* Move down at target to low contact pose *)
            Y24 := TRUE;
            Y20 := FALSE;
            Y22 := FALSE;
            Y23 := TRUE;
            IF X23 THEN
                Y23 := FALSE;
                state := 7;
            END_IF;

        7: (* Release materials at low contact pose *)
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            IF X25 THEN
                state := 8;
            END_IF;

        8: (* Lift empty tool back up to high position *)
            Y24 := FALSE;
            Y23 := FALSE;
            Y22 := TRUE;
            IF X22 THEN
                Y22 := FALSE;
                state := 9;
            END_IF;

        9: (* Move back to source/home while lifted *)
            Y24 := FALSE;
            Y20 := FALSE;
            Y21 := TRUE;
            IF X20 THEN
                Y21 := FALSE;
                state := 10;
            END_IF;

        10: (* Completion: all actuators off, claim completion *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
            Y2 := TRUE;

        ELSE
            (* Should not occur; keep outputs safe *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;

    END_CASE;
END_IF;

END_PROGRAM