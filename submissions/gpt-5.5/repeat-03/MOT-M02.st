PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;
    state : INT;
    dock_target : DINT;
    park_target : DINT;
    ab_diff : DINT;
    a_at_dock : BOOL;
    b_at_dock : BOOL;
    a_at_origin : BOOL;
    b_at_origin : BOOL;
    c_at_park : BOOL;
    ab_sync_band : DINT := 400;
    ab_rate : DINT := 200;
    c_rate : DINT := 1000;
END_VAR

a_at_dock := (ABS(D10 - dock_target) <= 20) AND (ABS(D11) <= 100);
b_at_dock := (ABS(D12 - dock_target) <= 20) AND (ABS(D13) <= 100);
a_at_origin := (ABS(D10) <= 20) AND (ABS(D11) <= 100);
b_at_origin := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
c_at_park := (ABS(D14 - park_target) <= 20) AND (ABS(D15) <= 100);
ab_diff := D10 - D12;

D20 := 0;
D21 := ab_rate;
Y20 := FALSE;
D24 := 0;
D25 := ab_rate;
Y21 := FALSE;
D28 := 10000;
D29 := c_rate;
Y22 := FALSE;
Y30 := FALSE;
Y31 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        IF X0 THEN
            dock_target := D101;
            IF dock_target < 0 THEN
                dock_target := 0;
            END_IF;
            IF dock_target > 50000 THEN
                dock_target := 50000;
            END_IF;

            park_target := D102;
            IF park_target < 0 THEN
                park_target := 0;
            END_IF;
            IF park_target > 90000 THEN
                park_target := 90000;
            END_IF;

            state := 10;
        END_IF;

    10:
        D20 := 0;
        D24 := 0;
        D28 := 10000;

        IF X1 THEN
            state := 20;
        ELSE
            IF (D14 < 54000) OR (D14 > 66000) THEN
                Y31 := TRUE;
            END_IF;
        END_IF;

    20:
        D20 := dock_target;
        D24 := dock_target;
        D28 := 10000;

        IF X1 THEN
            IF ab_diff > ab_sync_band THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSIF ab_diff < -ab_sync_band THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSE
                Y20 := TRUE;
                Y21 := TRUE;
            END_IF;
        END_IF;

        IF a_at_dock AND b_at_dock AND X4 THEN
            state := 30;
        END_IF;

    30:
        D20 := dock_target;
        D24 := dock_target;
        D28 := 10000;

        IF X2 THEN
            state := 40;
        ELSE
            IF X4 AND a_at_dock AND b_at_dock THEN
                Y30 := TRUE;
            END_IF;
        END_IF;

    40:
        D20 := dock_target;
        D24 := dock_target;
        D28 := park_target;
        D29 := c_rate;
        Y22 := TRUE;

        IF X2 AND X4 THEN
            IF c_at_park AND X5 THEN
                state := 50;
            END_IF;
        END_IF;

    50:
        D20 := dock_target;
        D24 := dock_target;
        D28 := park_target;
        D29 := c_rate;
        Y22 := TRUE;

        IF X1 THEN
            state := 60;
        ELSE
            IF c_at_park AND X5 AND ((D14 < 54000) OR (D14 > 66000)) THEN
                Y31 := TRUE;
            END_IF;
        END_IF;

    60:
        D20 := 0;
        D24 := 0;
        D28 := park_target;
        D29 := c_rate;
        Y22 := TRUE;

        IF X1 THEN
            IF ab_diff > ab_sync_band THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF ab_diff < -ab_sync_band THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := TRUE;
                Y21 := TRUE;
            END_IF;
        END_IF;

        IF X1 AND a_at_origin AND b_at_origin AND c_at_park THEN
            state := 70;
        END_IF;

    70:
        D20 := 0;
        D21 := ab_rate;
        Y20 := TRUE;
        D24 := 0;
        D25 := ab_rate;
        Y21 := TRUE;
        D28 := park_target;
        D29 := c_rate;
        Y22 := TRUE;
        Y2 := TRUE;

ELSE
    state := 0;
END_CASE;

END_PROGRAM