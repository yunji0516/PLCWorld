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

    startEdge : R_TRIG;
    state : INT := 0;
    target : INT := 0;
    checkCount : INT := 0;
    foundMatch : BOOL := FALSE;
    moveSteps : INT := 0;
    completed : BOOL := FALSE;
END_VAR

startEdge(CLK := X10);

// Default all actuator outputs off each scan; individual states re-assert as needed.
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

CASE state OF

    0: // IDLE - wait for accepted start request
        IF startEdge.Q THEN
            target := D10;
            checkCount := 0;
            foundMatch := FALSE;
            moveSteps := 0;
            state := 1;
        END_IF;

    1: // Decision point: only acts while resting at an aligned detent
        IF X20 THEN
            IF NOT foundMatch THEN
                IF D20 = target THEN
                    foundMatch := TRUE;
                    moveSteps := 2; // reader and ejector are 2 detents (180 deg) apart
                ELSE
                    checkCount := checkCount + 1;
                END_IF;
            ELSE
                moveSteps := moveSteps - 1;
            END_IF;

            IF foundMatch AND (moveSteps <= 0) THEN
                state := 6; // ready to eject at ejector station
            ELSIF (NOT foundMatch) AND (checkCount >= 4) THEN
                state := 99; // safety fallback; should not occur given task guarantee
            ELSE
                state := 2; // continue rotating one more detent
            END_IF;
        END_IF;

    2: // Rotate: leave current detent (confirm departure before awaiting next alignment)
        Y20 := TRUE;
        IF NOT X20 THEN
            state := 3;
        END_IF;

    3: // Rotate: approach next detent
        Y20 := TRUE;
        IF X20 THEN
            state := 1;
        END_IF;

    6: // Push to full stroke at the ejector-aligned position
        Y22 := TRUE;
        IF X22 THEN
            state := 7;
        END_IF;

    7: // Retract fully
        Y23 := TRUE;
        IF X21 THEN
            state := 8;
        END_IF;

    8: // Monitor terminal state and latch completion; keep all actuators off
        IF NOT completed THEN
            IF X23 AND X21 AND X20 THEN
                completed := TRUE;
            END_IF;
        END_IF;

    99: // Safe stuck fallback (should not be reached)
        ;

    ELSE
        ;
END_CASE;

Y2 := completed;

END_PROGRAM