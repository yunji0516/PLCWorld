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
    Y27 : BOOL;
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
    D21 : INT;

    (* Internal variables *)
    startTrig : R_TRIG;
    started : BOOL := FALSE;
    state : INT := 0;
    done : BOOL := FALSE;
END_VAR

startTrig(CLK := X10);

IF NOT started THEN
    IF startTrig.Q AND D10 = 1 THEN
        started := TRUE;
        state := 1;
    END_IF;
END_IF;

(* Default all actuator outputs off each scan; re-assert as needed below *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y27 := FALSE;

IF started THEN
    CASE state OF

        1: (* Turn on scrap vacuum at lower contact, wait for actual holding *)
            Y21 := TRUE;
            IF X21 THEN
                state := 2;
            END_IF;

        2: (* Raise scrap carrier to full height once scraps are held *)
            Y21 := TRUE;
            Y26 := TRUE;
            IF X27 THEN
                state := 3;
            END_IF;

        3: (* Move product head (currently at full lift/home) forward to source *)
            Y21 := TRUE;
            Y24 := TRUE;
            IF X25 THEN
                state := 4;
            END_IF;

        4: (* Lower product head at source to pickup position *)
            Y21 := TRUE;
            Y23 := TRUE;
            IF X23 THEN
                state := 5;
            END_IF;

        5: (* Turn on product vacuum, wait for actual holding *)
            Y21 := TRUE;
            Y20 := TRUE;
            IF X20 THEN
                state := 6;
            END_IF;

        6: (* Raise product head to full lift before horizontal travel *)
            Y21 := TRUE;
            Y20 := TRUE;
            Y22 := TRUE;
            IF X22 THEN
                state := 7;
            END_IF;

        7: (* Move product head back to receiver/home *)
            Y21 := TRUE;
            Y20 := TRUE;
            Y25 := TRUE;
            IF X24 THEN
                state := 8;
            END_IF;

        8: (* Lower product head at receiver to release position *)
            Y21 := TRUE;
            Y20 := TRUE;
            Y23 := TRUE;
            IF X23 THEN
                state := 9;
            END_IF;

        9: (* Release product vacuum, wait for actual release confirmation *)
            Y21 := TRUE;
            Y20 := FALSE;
            IF NOT X20 THEN
                state := 10;
            END_IF;

        10: (* Raise empty product head back to home upper position *)
            Y21 := TRUE;
            Y22 := TRUE;
            IF X22 THEN
                state := 11;
            END_IF;

        11: (* Terminal state: maintain result *)
            Y21 := TRUE;
            done := TRUE;

        ELSE
            ;
    END_CASE;
END_IF;

IF done THEN
    Y2 := TRUE;
    Y21 := TRUE;
    Y20 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;
END_IF;

END_PROGRAM