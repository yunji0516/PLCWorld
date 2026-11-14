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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    (* Add internal variables here. *)
    started : BOOL := FALSE;
    complete_latched : BOOL := FALSE;
    state : INT := 0;
    nextState : INT := 0;
    loaded_count : INT := 0;
    received_count : INT := 0;
    repair_count : INT := 0;
    currentHasInsert : BOOL := FALSE;
    lastNG : BOOL := FALSE;
    rotSeenMoving : BOOL := FALSE;
    insSeenBusy : BOOL := FALSE;
    inspSeenBusy : BOOL := FALSE;
    prepWait : INT := 0;
    completeReady : BOOL := FALSE;
END_VAR

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := TRUE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

D200 := D5;

IF X0 THEN
    started := TRUE;
END_IF;

IF complete_latched THEN
    state := 201;
END_IF;

CASE state OF
    0:
        IF started THEN
            state := 10;
        END_IF;

    10:
        IF received_count >= 6 THEN
            state := 200;
        ELSIF (loaded_count < 6) AND X10 AND X19 AND (NOT X18) AND (NOT X14) AND (NOT X15) AND (NOT X16) AND (NOT X17) AND (NOT X25) THEN
            Y10 := TRUE;
            loaded_count := loaded_count + 1;
            currentHasInsert := FALSE;
            lastNG := FALSE;
            state := 12;
        END_IF;

    12:
        IF (NOT X14) AND X19 AND (NOT X18) THEN
            nextState := 30;
            state := 100;
        END_IF;

    30:
        IF currentHasInsert THEN
            nextState := 40;
            state := 100;
        ELSIF X19 AND (NOT X18) AND (NOT X15) THEN
            prepWait := 0;
            state := 31;
        END_IF;

    31:
        IF X19 AND (NOT X18) AND (NOT X15) THEN
            IF X13 OR ((prepWait >= 5) AND X12) THEN
                Y12 := TRUE;
                insSeenBusy := FALSE;
                state := 32;
            ELSE
                IF X12 THEN
                    Y11 := TRUE;
                    IF prepWait < 30000 THEN
                        prepWait := prepWait + 1;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

    32:
        IF X15 THEN
            insSeenBusy := TRUE;
        END_IF;
        IF (NOT X15) AND X21 AND (insSeenBusy OR X21) THEN
            currentHasInsert := TRUE;
            nextState := 40;
            state := 100;
        END_IF;

    40:
        IF X19 AND (NOT X18) AND (NOT X16) THEN
            D200 := D5;
            Y13 := TRUE;
            inspSeenBusy := FALSE;
            state := 42;
        END_IF;

    42:
        D200 := D5;
        IF X16 THEN
            inspSeenBusy := TRUE;
        END_IF;
        IF inspSeenBusy AND (NOT X16) AND X22 AND (D7 = D5) THEN
            lastNG := X24;
            nextState := 50;
            state := 100;
        END_IF;

    50:
        IF X19 AND (NOT X18) AND X23 AND X1B AND (NOT X17) THEN
            IF lastNG OR X24 THEN
                lastNG := TRUE;
                state := 60;
            ELSE
                state := 70;
            END_IF;
        END_IF;

    60:
        IF X19 AND (NOT X18) AND X1B AND X20 AND X24 AND (NOT X25) THEN
            Y1B := TRUE;
            repair_count := repair_count + 1;
            state := 61;
        END_IF;

    61:
        IF X26 AND (NOT X25) THEN
            state := 62;
        END_IF;

    62:
        Y1C := TRUE;
        IF X27 AND (NOT X25) THEN
            state := 63;
        END_IF;

    63:
        Y1C := TRUE;
        IF X27 AND (NOT X25) THEN
            Y1D := TRUE;
            state := 64;
        END_IF;

    64:
        Y1C := TRUE;
        IF X28 AND (NOT X25) THEN
            state := 65;
        END_IF;

    65:
        Y1C := TRUE;
        IF X27 AND X28 AND (NOT X25) THEN
            Y1E := TRUE;
            state := 66;
        END_IF;

    66:
        Y1C := TRUE;
        IF X29 AND (NOT X25) THEN
            state := 67;
        END_IF;

    67:
        IF (NOT X27) AND (NOT X25) AND X19 AND (NOT X18) THEN
            state := 68;
        END_IF;

    68:
        IF X2A AND X19 AND (NOT X18) AND (NOT X25) AND (NOT X27) THEN
            Y1F := TRUE;
            currentHasInsert := TRUE;
            lastNG := FALSE;
            state := 69;
        END_IF;

    69:
        IF (NOT X25) AND (NOT X26) AND X19 AND (NOT X18) THEN
            nextState := 30;
            state := 100;
        END_IF;

    70:
        IF X19 AND (NOT X18) AND X23 AND (NOT X24) AND X1B AND X1D AND (NOT X1E) AND (NOT X17) THEN
            state := 71;
        ELSIF X24 THEN
            lastNG := TRUE;
            state := 60;
        END_IF;

    71:
        IF X1D AND (NOT X1E) THEN
            Y14 := TRUE;
            IF X1C THEN
                state := 72;
            END_IF;
        END_IF;

    72:
        Y15 := TRUE;
        IF X1B AND (NOT X17) THEN
            state := 73;
        END_IF;

    73:
        IF X20 AND X1B AND X1D AND (NOT X1E) AND (NOT X24) THEN
            Y16 := TRUE;
            state := 74;
        END_IF;

    74:
        IF X1E THEN
            Y19 := TRUE;
            received_count := received_count + 1;
            state := 76;
        END_IF;

    76:
        IF (NOT X1E) AND (NOT X20) AND X1B AND (NOT X17) THEN
            IF received_count >= 6 THEN
                state := 200;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    100:
        Y17 := FALSE;
        IF X1B AND (NOT X14) AND (NOT X15) AND (NOT X16) AND (NOT X17) AND (NOT X25) AND (NOT X18) AND X1A THEN
            rotSeenMoving := FALSE;
            state := 101;
        END_IF;

    101:
        Y17 := FALSE;
        Y18 := TRUE;
        rotSeenMoving := FALSE;
        state := 102;

    102:
        Y17 := FALSE;
        IF X18 THEN
            rotSeenMoving := TRUE;
        END_IF;
        IF rotSeenMoving AND (NOT X18) THEN
            state := 103;
        END_IF;

    103:
        Y17 := TRUE;
        IF X19 AND (NOT X18) THEN
            state := nextState;
        END_IF;

    200:
        completeReady := (received_count >= 6) AND (repair_count >= 2) AND X19 AND (NOT X18) AND X1B AND (NOT X20) AND (NOT X1E) AND (NOT X14) AND (NOT X15) AND (NOT X16) AND (NOT X17) AND (NOT X25) AND (NOT X27);
        IF completeReady THEN
            complete_latched := TRUE;
            state := 201;
        END_IF;

    201:
        Y17 := TRUE;

ELSE
    state := 0;
END_CASE;

IF (NOT Y14) AND (NOT X1B) THEN
    Y15 := TRUE;
END_IF;

IF complete_latched THEN
    Y1A := TRUE;
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y16 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    Y17 := TRUE;
    IF NOT X1B THEN
        Y15 := TRUE;
    ELSE
        Y15 := FALSE;
    END_IF;
END_IF;

END_PROGRAM