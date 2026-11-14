PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    target_pos : DINT;
    stability_timer : TON;
    observation_timer : TON;
    state : INT;
END_VAR

CASE state OF
    0: // IDLE - wait for function request
        IF X10 THEN
            target_pos := D10;
            Y20 := TRUE;
            D20 := target_pos;
            state := 1;
        END_IF;
        
    1: // ACTIVE - send position command, monitor completion
        D20 := target_pos;
        // Completion: position error ≤ 0.2 mm (raw ≤ 20), speed ≤ 1 mm/s (raw ≤ 100)
        IF ABS(D10 - D11) <= 20 AND ABS(D12) <= 100 THEN
            stability_timer(IN := TRUE, PT := T#30ms);
            IF stability_timer.Q THEN
                Y2 := TRUE;
                state := 2;
            END_IF;
        ELSE
            stability_timer(IN := FALSE);
        END_IF;
        
    2: // OBSERVATION - Y2 TRUE, maintain for 100 ms observation
        D20 := target_pos;
        observation_timer(IN := TRUE, PT := T#100ms);
        IF observation_timer.Q THEN
            state := 3;
        END_IF;
        
    3: // DONE - maintain outputs
        D20 := target_pos;
END_CASE;

END_PROGRAM