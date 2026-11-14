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

    (* Internal state *)
    state       : INT := 0;
    startTrig   : R_TRIG;

    (* State numbering:
       0  IDLE
       1  FORWARD to source
       2  LOWER head at source
       3  WAIT head vacuum acquisition
       4  RAISE head (with product)
       5  BACK to home
       6  LOWER head at home
       7  WAIT product release
       8  RAISE head (empty) to home upper
       9  TURN ON scrap vacuum, wait acquisition
       10 RAISE scrap carrier
       11 DONE - maintain
    *)
END_VAR

startTrig(CLK := X10);

(* Accept start request *)
IF state = 0 AND startTrig.Q AND D10 = 1 THEN
    state := 1;
END_IF;

(* Default all outputs to FALSE each scan, then set per active state *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y27 := FALSE;

CASE state OF

0: (* IDLE - no actuator commands before Start accepted *)
    ;

1: (* Move forward to source, lift already full at home *)
    Y24 := TRUE;
    IF X25 THEN
        state := 2;
    END_IF;

2: (* Lower head at source to acquire product *)
    Y23 := TRUE;
    IF X23 THEN
        state := 3;
    END_IF;

3: (* Head at low contact at source: energize head vacuum, wait for acquisition *)
    Y20 := TRUE;
    IF X20 THEN
        state := 4;
    END_IF;

4: (* Raise head with product to full lift *)
    Y20 := TRUE;
    Y22 := TRUE;
    IF X22 THEN
        state := 5;
    END_IF;

5: (* Move back to home/receiver at full lift *)
    Y20 := TRUE;
    Y25 := TRUE;
    IF X24 THEN
        state := 6;
    END_IF;

6: (* Lower head at home to release contact height *)
    Y20 := TRUE;
    Y23 := TRUE;
    IF X23 THEN
        state := 7;
    END_IF;

7: (* Release product: vacuum OFF, wait for confirmed release *)
    (* Y20 left FALSE (default) to release *)
    IF NOT X20 THEN
        state := 8;
    END_IF;

8: (* Raise empty head back to home upper full lift *)
    Y22 := TRUE;
    IF X22 THEN
        state := 9;
    END_IF;

9: (* Energize scrap vacuum at carrier lower contact, wait acquisition *)
    Y21 := TRUE;
    IF X21 THEN
        state := 10;
    END_IF;

10: (* Raise scrap carrier to full height, holding scraps *)
    Y21 := TRUE;
    Y26 := TRUE;
    IF X27 THEN
        state := 11;
    END_IF;

11: (* DONE: maintain terminal result, only scrap vacuum ON *)
    Y21 := TRUE;

ELSE
    state := 0;
END_CASE;

(* Completion claim latched once terminal state reached, maintained thereafter *)
IF state = 11 THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM