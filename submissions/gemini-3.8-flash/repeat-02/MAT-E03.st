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

    trig_start : R_TRIG;
    timer_hold : TON;
    started : BOOL;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
    done : BOOL;
    cond_released : BOOL;
    cond_unselected : BOOL;
    cond_all : BOOL;
END_VAR

trig_start(CLK := X10);

IF trig_start.Q AND NOT started THEN
    started := TRUE;
    sel1 := (D10 MOD 2) = 1;
    sel2 := ((D10 / 2) MOD 2) = 1;
    sel3 := ((D10 / 4) MOD 2) = 1;
END_IF;

IF started THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;

    cond_released := (NOT sel1 OR NOT X20) AND (NOT sel2 OR NOT X21) AND (NOT sel3 OR NOT X22);
    cond_unselected := (sel1 OR X20) AND (sel2 OR X21) AND (sel3 OR X22);
    cond_all := cond_released AND cond_unselected;

    timer_hold(IN := cond_all, PT := T#200ms);

    IF timer_hold.Q THEN
        done := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    timer_hold(IN := FALSE, PT := T#200ms);
END_IF;

IF done THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM