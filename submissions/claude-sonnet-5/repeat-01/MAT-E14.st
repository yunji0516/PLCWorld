PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    (* internal *)
    startTrig : R_TRIG;
    state : INT := 0;      (* 0=IDLE, 1=MOVING_LEFT, 2=MOVING_RIGHT, 3=DONE *)
    chosenLeft : BOOL := FALSE;
    chosenRight : BOOL := FALSE;
    validChoice : BOOL := FALSE;

    diffLeft : DINT;
    diffRight : DINT;
    w1_cap : DINT;
    left_cap : DINT;
    right_cap : DINT;
END_VAR

startTrig(CLK := X10);

CASE state OF

0: (* IDLE - wait for start edge, then decide side *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF startTrig.Q THEN
        w1_cap := DINT(D20);
        left_cap := DINT(D21);
        right_cap := DINT(D22);

        chosenLeft := FALSE;
        chosenRight := FALSE;
        validChoice := FALSE;

        IF X22 AND X23 THEN
            diffLeft := ABS((left_cap + w1_cap) - right_cap);
            diffRight := ABS(left_cap - (right_cap + w1_cap));
            IF diffLeft <= diffRight THEN
                chosenLeft := TRUE;
            ELSE
                chosenRight := TRUE;
            END_IF;
            validChoice := TRUE;
        ELSIF X22 THEN
            chosenLeft := TRUE;
            validChoice := TRUE;
        ELSIF X23 THEN
            chosenRight := TRUE;
            validChoice := TRUE;
        ELSE
            validChoice := FALSE;
        END_IF;

        IF validChoice AND chosenLeft THEN
            state := 1;
        ELSIF validChoice AND chosenRight THEN
            state := 2;
        ELSE
            state := 0;
        END_IF;
    END_IF;

1: (* MOVING_LEFT *)
    Y20 := TRUE;
    Y21 := FALSE;
    IF X20 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
        state := 3;
    END_IF;

2: (* MOVING_RIGHT *)
    Y20 := FALSE;
    Y21 := TRUE;
    IF X21 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
        state := 3;
    END_IF;

3: (* DONE - hold result *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM