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

    started : BOOL := FALSE;
    first_scan : BOOL := TRUE;
    prev_X34 : BOOL := FALSE;
    step : INT := 0;
    search_target : DINT := 0;
    latched_origin : DINT := 0;
END_VAR

IF first_scan THEN
    first_scan := FALSE;
    prev_X34 := X34;
END_IF;

IF NOT started THEN
    IF X0 THEN
        started := TRUE;
        step := 10;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        D28 := 0;
        D29 := 0;
    END_IF;
END_IF;

IF started THEN
    IF step = 10 THEN
        // Retract internal tool B to 0 mm while head C remains at 0 mm
        D20 := 0;
        D21 := 0;
        Y20 := FALSE;

        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        D28 := 0;
        D29 := 0;
        Y22 := FALSE;

        Y30 := FALSE;
        Y2 := FALSE;

        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            step := 20;
        END_IF;

    ELSIF step = 20 THEN
        // Raise head C to 100 mm while B is held retracted
        D20 := 0;
        D21 := 0;
        Y20 := FALSE;

        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;

        Y30 := FALSE;
        Y2 := FALSE;

        IF ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
            IF D10 < 9000 THEN
                search_target := 13000;
            ELSE
                search_target := 3000;
            END_IF;
            step := 30;
        END_IF;

    ELSIF step = 30 THEN
        // Move A at safe rate to search for reference sensor OFF->ON transition
        D20 := search_target;
        D21 := 100;
        Y20 := TRUE;

        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;

        Y30 := FALSE;
        Y2 := FALSE;

        IF X34 AND NOT prev_X34 THEN
            latched_origin := D10;
            D20 := D10;
            D21 := 1000;
            step := 40;
        END_IF;

    ELSIF step = 40 THEN
        // Decelerate and stop within 10 mm after the edge
        D21 := 1000;
        Y20 := TRUE;

        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;

        Y30 := FALSE;
        Y2 := FALSE;

        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            step := 50;
        END_IF;

    ELSIF step = 50 THEN
        // Hold position and issue configure command Y30
        D21 := 1000;
        Y20 := TRUE;

        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;

        Y30 := TRUE;
        Y2 := FALSE;

        IF X35 THEN
            Y30 := FALSE;
            step := 60;
        END_IF;

    ELSIF step = 60 THEN
        // Move to final position: A = D90 + request_park, B = 0, C = 100
        D20 := D90 + D101;
        D21 := 1000;
        Y20 := TRUE;

        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;

        Y30 := FALSE;
        Y2 := FALSE;

        IF ABS(D10 - (D90 + D101)) <= 20 AND ABS(D11) <= 100
           AND ABS(D12) <= 20 AND ABS(D13) <= 100
           AND ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
            step := 70;
        END_IF;

    ELSIF step = 70 THEN
        // Assert completion and maintain final positions
        D20 := D90 + D101;
        D21 := 1000;
        Y20 := TRUE;

        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;

        Y30 := FALSE;
        Y2 := TRUE;
    END_IF;
END_IF;

prev_X34 := X34;

END_PROGRAM