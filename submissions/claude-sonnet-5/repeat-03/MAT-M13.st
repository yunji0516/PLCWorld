PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal state *)
    state : INT := 0;
    target : INT := 0;
    next_target : INT := 0;
    eject_target_index : INT := 0;
    done : BOOL := FALSE;
    startReq : R_TRIG;
END_VAR

startReq(CLK := X10);

CASE state OF

0: (* IDLE - wait for accepted start request, no actuator commands allowed yet *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF startReq.Q THEN
        target := D10;
        state := 1;
    END_IF;

1: (* CheckReader - only evaluate identity when indexed/aligned *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X20 THEN
        IF D20 = target THEN
            (* Ejector station is 180 degrees (2 steps) from reader station *)
            eject_target_index := (D21 + 2) MOD 4;
            state := 3;
        ELSE
            next_target := (D21 + 1) MOD 4;
            state := 2;
        END_IF;
    END_IF;

2: (* RotatingSearch - step carousel CW one detent, pusher stays retracted *)
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF (D21 = next_target) AND X20 THEN
        Y20 := FALSE;
        state := 1;
    ELSE
        Y20 := TRUE;
    END_IF;

3: (* RotateToEject - move the found item to the ejector station *)
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF (D21 = eject_target_index) AND X20 THEN
        Y20 := FALSE;
        state := 4;
    ELSE
        Y20 := TRUE;
    END_IF;

4: (* Push - full stroke ejection, indexed & aligned already confirmed *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
    IF X22 THEN
        Y22 := FALSE;
        state := 5;
    ELSE
        Y22 := TRUE;
    END_IF;

5: (* Retract - return pusher to home before declaring completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF X21 THEN
        Y23 := FALSE;
        state := 6;
    ELSE
        Y23 := TRUE;
    END_IF;

6: (* Complete / hold - all drive outputs OFF, latch completion once verified *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF NOT done THEN
        IF X23 AND X21 AND X20 THEN
            Y2 := TRUE;
            done := TRUE;
        END_IF;
    END_IF;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

END_CASE;

END_PROGRAM