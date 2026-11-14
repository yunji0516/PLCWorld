PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    state : INT := 0;
    count : INT := 0;
END_VAR

CASE state OF
    0: (* Idle - wait for request, drive disabled *)
        Y20 := FALSE;
        D20 := 0;
        Y2 := FALSE;
        IF X10 THEN
            state := 1;
            count := 0;
        END_IF;

    1: (* Drive enabled, ramping to target speed *)
        Y20 := TRUE;
        D20 := D10;
        Y2 := FALSE;

        IF ABS(D12 - D10) <= 200 THEN
            count := count + 1;
            IF count >= 3 THEN
                state := 2;
                count := 0;
            END_IF;
        ELSE
            count := 0;
        END_IF;

    2: (* Observation period - Y2 TRUE, maintain rotation *)
        Y20 := TRUE;
        D20 := D10;
        Y2 := TRUE;
        count := count + 1;

END_CASE;

END_PROGRAM