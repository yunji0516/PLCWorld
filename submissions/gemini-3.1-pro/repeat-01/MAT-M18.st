PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D200 : INT;
    
    state : INT := 0;
END_VAR

CASE state OF
    0:
        IF X0 THEN
            Y10 := TRUE;
            Y11 := FALSE;
            Y12 := FALSE;
            Y13 := FALSE;
            Y14 := FALSE;
            Y15 := FALSE;
            Y16 := FALSE;
            Y17 := FALSE;
            state := 10;
        END_IF;

    10:
        (* Move feed carriage to requested segment length D0 *)
        D200 := D0;
        Y12 := TRUE;
        IF X11 AND (ABS(D1 - D0) <= 1) THEN
            Y12 := FALSE;
            state := 20;
        END_IF;

    20:
        (* Close stock clamp to secure the raw material side *)
        Y11 := TRUE;
        IF X14 THEN
            state := 30;
        END_IF;

    30:
        (* Lower both pad and blade *)
        Y13 := TRUE;
        Y14 := TRUE;
        IF X16 AND X19 THEN
            state := 40;
        END_IF;

    40:
        (* Apply vacuum to acquire segment, retract blade *)
        Y16 := TRUE;
        Y13 := FALSE;
        IF X1C AND X15 AND X17 THEN
            state := 50;
        END_IF;

    50:
        (* Open feed grip to release the segment side *)
        Y10 := FALSE;
        IF X13 THEN
            state := 60;
        END_IF;

    60:
        (* Extract segment (lift pad) and initiate feed carriage return *)
        Y14 := FALSE;
        D200 := 100;
        Y12 := TRUE;
        IF X18 THEN
            state := 70;
        END_IF;

    70:
        (* Move pad horizontally to receiver *)
        Y15 := TRUE;
        IF X1B THEN
            state := 80;
        END_IF;

    80:
        (* Lower pad to receiving support contact surface *)
        Y14 := TRUE;
        IF X19 THEN
            state := 90;
        END_IF;

    90:
        (* Release segment by turning off vacuum *)
        Y16 := FALSE;
        IF NOT X1C THEN
            state := 100;
        END_IF;

    100:
        (* Lift empty pad *)
        Y14 := FALSE;
        IF X18 THEN
            state := 110;
        END_IF;

    110:
        (* Return empty pad horizontally to start position *)
        Y15 := FALSE;
        IF X1A THEN
            state := 120;
        END_IF;

    120:
        (* Wait for feed carriage to complete its return to origin *)
        IF X10 AND X11 THEN
            Y12 := FALSE;
            state := 130;
        END_IF;

    130:
        (* Verify completion states and assert complete signal *)
        IF (ABS(D3 - D0) <= 1) AND X15 AND X10 AND X11 AND X13 AND X18 AND X1A AND (NOT X1C) AND X14 THEN
            Y17 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM