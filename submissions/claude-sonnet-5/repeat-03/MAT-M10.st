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

    (* Internal variables *)
    start_edge : R_TRIG;
    started    : BOOL := FALSE;
    state      : INT := 0;
    mask       : INT := 0;
    rem2       : INT := 0;
    rem3       : INT := 0;
    sel1       : BOOL := FALSE;
    sel2       : BOOL := FALSE;
    sel3       : BOOL := FALSE;
END_VAR

(* --- Accept start request on rising edge, latch recipe --- *)
start_edge(CLK := X10);

IF start_edge.Q AND NOT started THEN
    started := TRUE;
    mask := D10;
    sel1 := (mask MOD 2) = 1;
    rem2 := mask / 2;
    sel2 := (rem2 MOD 2) = 1;
    rem3 := rem2 / 2;
    sel3 := (rem3 MOD 2) = 1;
    state := 10;
END_IF;

(* --- Default travel/lift outputs OFF each scan; set explicitly per state --- *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

CASE state OF

    0:
        ; // idle, waiting for start

    10: // lower to low pose at source
        Y23 := TRUE;
        IF X23 THEN
            state := 20;
        END_IF;

    20: // release unselected materials at source (low pose)
        IF NOT sel1 THEN
            Y24 := TRUE;
        END_IF;
        IF NOT sel2 THEN
            Y25 := TRUE;
        END_IF;
        IF NOT sel3 THEN
            Y26 := TRUE;
        END_IF;
        IF (sel1 OR NOT X26) AND (sel2 OR NOT X27) AND (sel3 OR NOT X28) THEN
            state := 30;
        END_IF;

    30: // lift fully up before horizontal travel
        Y22 := TRUE;
        IF X22 THEN
            state := 40;
        END_IF;

    40: // move forward to target
        Y20 := TRUE;
        IF X21 THEN
            state := 50;
        END_IF;

    50: // lower to low pose at target
        Y23 := TRUE;
        IF X23 THEN
            state := 60;
        END_IF;

    60: // release selected materials at target (low pose)
        IF sel1 THEN
            Y24 := TRUE;
        END_IF;
        IF sel2 THEN
            Y25 := TRUE;
        END_IF;
        IF sel3 THEN
            Y26 := TRUE;
        END_IF;
        IF (NOT sel1 OR NOT X26) AND (NOT sel2 OR NOT X27) AND (NOT sel3 OR NOT X28) THEN
            state := 70;
        END_IF;

    70: // lift fully up before returning empty
        Y22 := TRUE;
        IF X22 THEN
            state := 80;
        END_IF;

    80: // move back to source (empty head)
        Y21 := TRUE;
        IF X20 THEN
            state := 90;
        END_IF;

    90: // completion: empty head at source upper position
        Y2 := TRUE;

    ELSE
        ;
END_CASE;

END_PROGRAM