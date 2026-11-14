PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    state : DINT := 0;
    Sync_U_Pos : DINT := 0;
    rem : DINT;
    rem_curr : DINT;
    diff : DINT;
    Arr_Cond : BOOL;
    Arr_Timer : TON;
END_VAR

CASE state OF
0:
    IF X10 THEN
        D20 := D15;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        state := 1;
    END_IF;

1:
    IF X11 THEN
        Sync_U_Pos := D10;
        state := 2;
    END_IF;

2:
    IF (D10 - Sync_U_Pos) >= D14 THEN
        Y21 := TRUE;
        Y20 := FALSE;
        state := 3;
    END_IF;

3:
    IF NOT X12 THEN
        rem := D13 MOD 36000;
        IF rem < 0 THEN
            rem := rem + 36000;
        END_IF;
        
        rem_curr := D11 MOD 36000;
        IF rem_curr < 0 THEN
            rem_curr := rem_curr + 36000;
        END_IF;
        
        diff := rem - rem_curr;
        WHILE diff < 6000 DO
            diff := diff + 36000;
        END_WHILE;
        
        D21 := D11 + diff;
        Y22 := TRUE;
        Y21 := FALSE;
        state := 4;
    END_IF;

END_CASE;

Arr_Cond := (state >= 4) AND (ABS(D11 - D21) <= 20) AND (ABS(D12) <= 100);
Arr_Timer(IN := Arr_Cond, PT := T#30ms);

IF Arr_Timer.Q THEN
    Y2 := TRUE;
    state := 5;
END_IF;

END_PROGRAM