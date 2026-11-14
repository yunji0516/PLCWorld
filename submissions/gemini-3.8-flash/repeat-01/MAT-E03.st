PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    r_trig_start : R_TRIG;
    ton_release : TON;
    step : INT;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
    temp : DINT;
    all_ok : BOOL;
END_VAR

r_trig_start(CLK := X10);

IF step = 0 THEN
    IF r_trig_start.Q THEN
        temp := DINT(D10);
        IF temp < 0 THEN
            temp := 0;
        END_IF;
        temp := temp MOD 8;
        sel1 := (temp = 1) OR (temp = 3) OR (temp = 5) OR (temp = 7);
        sel2 := (temp = 2) OR (temp = 3) OR (temp = 6) OR (temp = 7);
        sel3 := (temp = 4) OR (temp = 5) OR (temp = 6) OR (temp = 7);
        step := 1;
    END_IF;
END_IF;

IF step >= 1 THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

ton_release(IN := (step = 1), PT := T#400ms);

IF step = 1 THEN
    all_ok := (NOT sel1 OR NOT X20) AND (NOT sel2 OR NOT X21) AND (NOT sel3 OR NOT X22)
              AND (sel1 OR X20) AND (sel2 OR X21) AND (sel3 OR X22);
    IF ton_release.Q AND all_ok THEN
        step := 2;
    END_IF;
END_IF;

IF step = 2 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM