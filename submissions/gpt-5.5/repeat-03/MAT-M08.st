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
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    startEdge : R_TRIG;
    state : INT;
    requestValue : INT;
    slotIndex : INT;
    selectedSlot : INT;
    target : INT;
    accepted : BOOL;
    vacantConfirmed : BOOL;
    receivedSeen : BOOL;
    pushStarted : BOOL;
END_VAR

startEdge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

IF state < 30 THEN
    target := slotIndex * 160;
ELSE
    target := selectedSlot * 160;
END_IF;

CASE state OF
    0:
        accepted := FALSE;
        IF startEdge.Q AND (D10 = 1) THEN
            requestValue := D10;
            accepted := TRUE;
            slotIndex := 0;
            selectedSlot := 0;
            vacantConfirmed := FALSE;
            receivedSeen := FALSE;
            pushStarted := FALSE;
            state := 10;
        END_IF;

    10:
        IF X22 THEN
            state := 20;
        ELSE
            Y23 := TRUE;
        END_IF;

    20:
        target := slotIndex * 160;
        IF NOT X22 THEN
            state := 10;
        ELSIF X25 AND (ABS(D20 - target) <= 4) THEN
            IF NOT X24 THEN
                selectedSlot := slotIndex;
                vacantConfirmed := TRUE;
                pushStarted := FALSE;
                state := 30;
            ELSE
                vacantConfirmed := FALSE;
                IF slotIndex < 3 THEN
                    slotIndex := slotIndex + 1;
                ELSE
                    state := 80;
                END_IF;
            END_IF;
        ELSE
            IF D20 < target THEN
                IF NOT X21 THEN
                    Y20 := TRUE;
                END_IF;
            ELSIF D20 > target THEN
                IF NOT X20 THEN
                    Y21 := TRUE;
                END_IF;
            END_IF;
        END_IF;

    30:
        target := selectedSlot * 160;
        IF NOT X22 THEN
            Y23 := TRUE;
        ELSIF vacantConfirmed AND X25 AND (ABS(D20 - target) <= 4) AND (NOT X24) THEN
            pushStarted := FALSE;
            state := 40;
        ELSE
            vacantConfirmed := FALSE;
            state := 20;
        END_IF;

    40:
        target := selectedSlot * 160;
        IF X26 THEN
            receivedSeen := TRUE;
            state := 50;
        ELSIF NOT (X25 AND (ABS(D20 - target) <= 4)) THEN
            state := 70;
        ELSIF NOT pushStarted THEN
            IF X22 AND vacantConfirmed AND (NOT X24) THEN
                Y22 := TRUE;
                pushStarted := TRUE;
            ELSE
                vacantConfirmed := FALSE;
                state := 20;
            END_IF;
        ELSE
            Y22 := TRUE;
        END_IF;

    50:
        IF X26 THEN
            receivedSeen := TRUE;
        END_IF;
        IF X22 AND receivedSeen THEN
            state := 60;
        ELSE
            Y23 := TRUE;
        END_IF;

    60:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

    70:
        IF NOT X22 THEN
            Y23 := TRUE;
        END_IF;

    80:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

ELSE
    state := 0;
END_CASE;

IF state = 60 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM