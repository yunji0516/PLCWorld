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
    
    State : INT := 0;
    U_start : DINT := 0;
    temp_mod_D11 : DINT;
    temp_mod_D13 : DINT;
    rem_dist : DINT;
    
    Result_Met : BOOL;
    settle_timer : TON;
    complete_timer : TON;
END_VAR

CASE State OF
    0:
        IF X10 THEN
            State := 1;
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y2 := FALSE;
        END_IF;

    1:
        D20 := D15;
        Y20 := TRUE;
        IF X11 THEN
            U_start := D10;
            State := 2;
        END_IF;

    2:
        D20 := D15;
        Y20 := TRUE;
        IF D10 >= U_start + D14 THEN
            State := 3;
        END_IF;

    3:
        Y21 := TRUE;
        Y20 := FALSE;
        IF NOT X12 THEN
            temp_mod_D11 := D11 MOD 36000;
            IF temp_mod_D11 < 0 THEN
                temp_mod_D11 := temp_mod_D11 + 36000;
            END_IF;
            
            temp_mod_D13 := D13 MOD 36000;
            IF temp_mod_D13 < 0 THEN
                temp_mod_D13 := temp_mod_D13 + 36000;
            END_IF;
            
            rem_dist := temp_mod_D13 - temp_mod_D11;
            IF rem_dist < 0 THEN
                rem_dist := rem_dist + 36000;
            END_IF;
            
            (* Ensure a sufficient braking distance buffer (> 39 degrees) for safety before engaging stop *)
            IF rem_dist < 5000 THEN
                rem_dist := rem_dist + 36000;
            END_IF;
            
            D21 := D11 + rem_dist;
            Y22 := TRUE;
            State := 4;
        END_IF;

    4:
        Y21 := FALSE;
        Y22 := TRUE;

    5:
        Y21 := FALSE;
        Y22 := TRUE;
        Y2 := TRUE;

    6:
        Y2 := FALSE;
        Y22 := TRUE;
END_CASE;

Result_Met := (State >= 4 AND State <= 5) AND (ABS(D11 - D21) <= 20) AND (ABS(D12) <= 100);

settle_timer(IN := (State = 4) AND Result_Met, PT := T#30ms);
IF settle_timer.Q AND State = 4 THEN
    State := 5;
END_IF;

complete_timer(IN := (State = 5) AND Result_Met, PT := T#100ms);
IF complete_timer.Q AND State = 5 THEN
    State := 6;
END_IF;

END_PROGRAM