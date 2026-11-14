PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
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
    Y2 : BOOL;

    state : INT := 0;
    dir : DINT := 1;
    latched_pos : DINT := 0;
    sensor_prev : BOOL := FALSE;
    sensor_edge : BOOL := FALSE;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        D20 := D10;
        D21 := 0;
        D24 := D12;
        D25 := 0;
        D28 := D14;
        D29 := 0;
        sensor_prev := X34;
        IF X0 THEN
            D24 := 0;
            D25 := 1000;
            Y21 := TRUE;
            state := 10;
        END_IF;

    10:
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            D28 := 10000;
            D29 := 1000;
            Y22 := TRUE;
            state := 20;
        END_IF;

    20:
        IF ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
            IF D10 < 6000 THEN
                dir := 1;
                D20 := 30000;
            ELSE
                dir := -1;
                D20 := 0;
            END_IF;
            D21 := 100;
            Y20 := TRUE;
            sensor_prev := X34;
            state := 30;
        END_IF;

    30:
        sensor_edge := X34 AND NOT sensor_prev;
        sensor_prev := X34;
        IF sensor_edge THEN
            latched_pos := D10;
            D20 := LIMIT(0, latched_pos + dir * 200, 35000);
            state := 40;
        END_IF;

    40:
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            Y30 := TRUE;
            state := 50;
        END_IF;

    50:
        IF X35 THEN
            Y30 := FALSE;
            D20 := LIMIT(0, D90 + D101, 35000);
            D21 := 1000;
            state := 60;
        END_IF;

    60:
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14 - D28) <= 20 AND ABS(D15) <= 100 THEN
            Y2 := TRUE;
            state := 70;
        END_IF;

    70:
        Y2 := TRUE;
END_CASE;

END_PROGRAM