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

    (* internal *)
    startReq : R_TRIG;
    started  : BOOL := FALSE;
    state    : INT  := 0;
END_VAR

(* ---- edge detect for start request ---- *)
startReq(CLK := X10);

IF (NOT started) AND startReq.Q AND (D10 = 1) THEN
    started := TRUE;
    state := 1;
END_IF;

(* ---- default: clear command outputs each scan, re-assert per state ---- *)
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

        1: (* acquire scrap: carrier already at lower contact, energize scrap vacuum *)
            Y21 := TRUE;
            IF X21 THEN
                state := 2;
            END_IF;

        2: (* raise scrap carrier to full height, out of the head's path *)
            Y21 := TRUE;
            Y26 := TRUE;
            IF X27 THEN
                state := 3;
            END_IF;

        3: (* move product head from home to source (lift already at 280mm) *)
            Y21 := TRUE;
            Y24 := TRUE;
            IF X25 THEN
                state := 4;
            END_IF;

        4: (* lower head onto product at source *)
            Y21 := TRUE;
            Y23 := TRUE;
            IF X23 THEN
                state := 5;
            END_IF;

        5: (* acquire product *)
            Y21 := TRUE;
            Y20 := TRUE;
            IF X20 THEN
                state := 6;
            END_IF;

        6: (* raise head with product before horizontal travel *)
            Y21 := TRUE;
            Y20 := TRUE;
            Y22 := TRUE;
            IF X22 THEN
                state := 7;
            END_IF;

        7: (* return to receiver/home *)
            Y21 := TRUE;
            Y20 := TRUE;
            Y25 := TRUE;
            IF X24 THEN
                state := 8;
            END_IF;

        8: (* lower head to release product at receiver *)
            Y21 := TRUE;
            Y20 := TRUE;
            Y23 := TRUE;
            IF X23 THEN
                state := 9;
            END_IF;

        9: (* release product to receiver: vacuum off *)
            Y21 := TRUE;
            IF (NOT X20) AND X26 THEN
                state := 10;
            END_IF;

        10: (* raise empty head back to home upper position *)
            Y21 := TRUE;
            Y22 := TRUE;
            IF X22 AND X24 THEN
                state := 11;
                Y2 := TRUE;
            END_IF;

        11: (* terminal: hold result, only scrap vacuum stays on *)
            Y21 := TRUE;
            Y2 := TRUE;

        ELSE
            ;
    END_CASE;
END_IF;

END_PROGRAM