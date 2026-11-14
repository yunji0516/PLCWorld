PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Add internal variables here. *)
    prevStart : BOOL;
    startPulse : BOOL;
    active : BOOL;
    phase : INT;
    testCount : INT;
    baseActuator : INT;
    deltaActuator : INT;
    leftDecreases : BOOL := TRUE;
    edgeFault : BOOL;
END_VAR

startPulse := X10 AND NOT prevStart;

Y20 := FALSE;
Y21 := FALSE;

IF NOT Y2 THEN
    IF startPulse AND (D10 = 1) AND NOT active THEN
        active := TRUE;
        phase := 1;
        testCount := 0;
        baseActuator := D21;
        deltaActuator := 0;
        leftDecreases := TRUE;
        edgeFault := FALSE;
    END_IF;

    IF active THEN
        IF (D20 > 12) OR (D20 < -12) THEN
            edgeFault := TRUE;
        END_IF;

        IF X20 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            active := FALSE;
            phase := 0;

            IF NOT edgeFault AND (D20 <= 11) AND (D20 >= -11) THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            CASE phase OF
                1:
                    IF testCount < 3 THEN
                        Y20 := TRUE;
                        Y21 := FALSE;
                        testCount := testCount + 1;
                    ELSE
                        deltaActuator := D21 - baseActuator;
                        IF deltaActuator < 0 THEN
                            leftDecreases := TRUE;
                            phase := 3;
                        ELSIF deltaActuator > 0 THEN
                            leftDecreases := FALSE;
                            phase := 3;
                        ELSE
                            phase := 2;
                            testCount := 0;
                            baseActuator := D21;
                        END_IF;
                    END_IF;

                2:
                    IF testCount < 3 THEN
                        Y20 := FALSE;
                        Y21 := TRUE;
                        testCount := testCount + 1;
                    ELSE
                        deltaActuator := D21 - baseActuator;
                        IF deltaActuator > 0 THEN
                            leftDecreases := TRUE;
                        ELSIF deltaActuator < 0 THEN
                            leftDecreases := FALSE;
                        ELSE
                            leftDecreases := TRUE;
                        END_IF;
                        phase := 3;
                    END_IF;

                3:
                    Y20 := FALSE;
                    Y21 := FALSE;

                ELSE
                    phase := 3;
            END_CASE;

            IF phase = 3 THEN
                IF D20 > 0 THEN
                    IF leftDecreases THEN
                        Y20 := TRUE;
                        Y21 := FALSE;
                    ELSE
                        Y20 := FALSE;
                        Y21 := TRUE;
                    END_IF;
                ELSIF D20 < 0 THEN
                    IF leftDecreases THEN
                        Y20 := FALSE;
                        Y21 := TRUE;
                    ELSE
                        Y20 := TRUE;
                        Y21 := FALSE;
                    END_IF;
                ELSE
                    Y20 := FALSE;
                    Y21 := FALSE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
END_IF;

IF Y2 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

prevStart := X10;

END_PROGRAM