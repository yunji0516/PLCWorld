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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    startEdge : R_TRIG;
    sepHoldTimer : TON;
    started : BOOL;
    completed : BOOL;
    state : INT;
    currentID : INT;
    packageCount : INT;
    sepCount : INT;
    alignCount : INT;
    sepTimerIn : BOOL;
    avail1 : BOOL;
    avail2 : BOOL;
    avail3 : BOOL;
    avail4 : BOOL;
    currentAvail : BOOL;
    done1 : BOOL;
    done2 : BOOL;
    done3 : BOOL;
    done4 : BOOL;
    minAperture : INT;
END_VAR

startEdge(CLK := X0);

IF startEdge.Q AND NOT started THEN
    started := TRUE;
    completed := FALSE;
    state := 100;
    currentID := 0;
    packageCount := 0;
    sepCount := 0;
    alignCount := 0;
    done1 := FALSE;
    done2 := FALSE;
    done3 := FALSE;
    done4 := FALSE;
END_IF;

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
D200 := 0;
sepTimerIn := FALSE;

avail1 := (D4 = 1) OR (D4 = 3) OR (D4 = 5) OR (D4 = 7) OR (D4 = 9) OR (D4 = 11) OR (D4 = 13) OR (D4 = 15);
avail2 := (D4 = 2) OR (D4 = 3) OR (D4 = 6) OR (D4 = 7) OR (D4 = 10) OR (D4 = 11) OR (D4 = 14) OR (D4 = 15);
avail3 := (D4 = 4) OR (D4 = 5) OR (D4 = 6) OR (D4 = 7) OR (D4 = 12) OR (D4 = 13) OR (D4 = 14) OR (D4 = 15);
avail4 := (D4 = 8) OR (D4 = 9) OR (D4 = 10) OR (D4 = 11) OR (D4 = 12) OR (D4 = 13) OR (D4 = 14) OR (D4 = 15);

currentAvail := FALSE;
IF currentID = 1 THEN
    currentAvail := avail1 AND NOT done1;
ELSIF currentID = 2 THEN
    currentAvail := avail2 AND NOT done2;
ELSIF currentID = 3 THEN
    currentAvail := avail3 AND NOT done3;
ELSIF currentID = 4 THEN
    currentAvail := avail4 AND NOT done4;
END_IF;

IF completed THEN
    Y1A := TRUE;
ELSE
    Y1A := FALSE;
END_IF;

IF started AND NOT completed THEN
    IF (state >= 110) AND (state <= 180) THEN
        Y12 := TRUE;
        Y13 := TRUE;
        IF X1A AND X1B THEN
            Y14 := TRUE;
        END_IF;
    END_IF;

    CASE state OF
        100:
            currentID := 0;
            IF X10 AND X20 THEN
                Y1B := TRUE;
                sepTimerIn := X22;
                IF sepHoldTimer.Q AND X22 AND (NOT X21) AND (NOT X12) THEN
                    Y1C := TRUE;
                    sepCount := sepCount + 1;
                    state := 101;
                END_IF;
            ELSIF X10 AND X23 AND (NOT X20) AND (NOT X21) AND (NOT X12) THEN
                Y10 := TRUE;
                state := 110;
            END_IF;

        101:
            Y1B := TRUE;
            IF (NOT X21) AND X23 AND (NOT X20) THEN
                state := 100;
            END_IF;

        110:
            IF X11 AND (D0 >= 1) AND (D0 <= 4) THEN
                currentID := D0;
                state := 120;
            END_IF;

        120:
            IF X1A AND X1B AND X1C AND (D5 >= 38) AND X11 THEN
                Y15 := TRUE;
                state := 130;
            END_IF;

        130:
            IF X13 THEN
                state := 140;
            END_IF;

        140:
            IF D2 = currentID THEN
                state := 150;
            ELSIF (D2 = 0) AND (NOT X14) AND currentAvail THEN
                D200 := currentID;
                Y11 := TRUE;
                state := 145;
            END_IF;

        145:
            D200 := currentID;
            IF D2 = currentID THEN
                state := 150;
            END_IF;

        150:
            IF X24 THEN
                alignCount := alignCount + 1;
                state := 160;
            ELSE
                Y1D := TRUE;
                Y1E := TRUE;
            END_IF;

        160:
            IF X25 THEN
                state := 170;
            END_IF;

        170:
            IF (D6 > 0) THEN
                minAperture := D6 + 4;
            ELSE
                minAperture := 38;
            END_IF;

            IF X13 AND (D2 = currentID) AND X25 AND X1A AND X1B AND X1C AND (D5 >= minAperture) AND X17 AND (NOT X16) THEN
                Y16 := TRUE;
                state := 175;
            END_IF;

        175:
            IF (D6 > 0) THEN
                minAperture := D6 + 4;
            ELSE
                minAperture := 38;
            END_IF;

            IF X19 THEN
                state := 180;
            ELSIF X13 AND (D2 = currentID) AND X25 AND X1A AND X1B AND X1C AND (D5 >= minAperture) THEN
                Y16 := TRUE;
            END_IF;

        180:
            IF X17 AND X19 THEN
                state := 190;
            ELSE
                Y17 := TRUE;
            END_IF;

        190:
            IF X19 AND X17 AND X1D AND X25 AND (NOT X16) AND (NOT X14) THEN
                Y18 := TRUE;
                state := 200;
            END_IF;

        200:
            IF X1E THEN
                Y19 := TRUE;
                CASE currentID OF
                    1:
                        IF NOT done1 THEN
                            done1 := TRUE;
                            packageCount := packageCount + 1;
                        END_IF;
                    2:
                        IF NOT done2 THEN
                            done2 := TRUE;
                            packageCount := packageCount + 1;
                        END_IF;
                    3:
                        IF NOT done3 THEN
                            done3 := TRUE;
                            packageCount := packageCount + 1;
                        END_IF;
                    4:
                        IF NOT done4 THEN
                            done4 := TRUE;
                            packageCount := packageCount + 1;
                        END_IF;
                ELSE
                    packageCount := packageCount;
                END_CASE;
                state := 210;
            END_IF;

        210:
            Y19 := TRUE;
            IF NOT X1E THEN
                IF packageCount >= 4 THEN
                    state := 800;
                ELSE
                    currentID := 0;
                    state := 100;
                END_IF;
            END_IF;

        800:
            IF (packageCount >= 4) AND (sepCount >= 2) AND (alignCount >= 4) AND X1F AND X17 AND (NOT X16) AND (D2 = 0) AND (NOT X14) AND X25 AND (NOT X11) AND (NOT X13) THEN
                completed := TRUE;
                Y1A := TRUE;
                state := 900;
            END_IF;

        900:
            completed := TRUE;
            Y1A := TRUE;

    ELSE
        state := 100;
    END_CASE;
END_IF;

sepHoldTimer(IN := sepTimerIn, PT := T#250ms);

END_PROGRAM