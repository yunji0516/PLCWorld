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

    step : INT := 0;
    started : BOOL := FALSE;
    latched_edge : DINT := 0;
    search_forward : BOOL := TRUE;
    r_trig_sensor : R_TRIG;
END_VAR

r_trig_sensor(CLK := X34);

IF NOT started THEN
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

    IF X0 THEN
        started := TRUE;
        IF D10 < 6000 THEN
            search_forward := TRUE;
        ELSE
            search_forward := FALSE;
        END_IF;
        step := 1;
    END_IF;
ELSE
    CASE step OF
        1:
            (* Retract internal tool along Z to B=0 *)
            D24 := 0;
            D25 := 1000;
            Y21 := TRUE;

            IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
                step := 2;
            END_IF;

        2:
            (* Raise elevation C to 100 mm *)
            D28 := 10000;
            D29 := 1000;
            Y22 := TRUE;

            IF (ABS(D14 - 10000) <= 20) AND (ABS(D15) <= 100) THEN
                step := 3;
            END_IF;

        3:
            (* Search for reference sensor edge on axis A *)
            IF search_forward THEN
                D20 := 30000;
            ELSE
                D20 := 0;
            END_IF;
            D21 := 120;
            Y20 := TRUE;

            IF r_trig_sensor.Q THEN
                latched_edge := D10;
                Y20 := FALSE;
                step := 4;
            END_IF;

        4:
            (* Apply braking deceleration to stop within 10 mm *)
            Y20 := FALSE;

            IF ABS(D11) <= 100 THEN
                step := 5;
            END_IF;

        5:
            (* Register latched origin with configure command Y30 *)
            Y30 := TRUE;

            IF X35 THEN
                Y30 := FALSE;
                step := 6;
            END_IF;

        6:
            (* Move axis A to final target: D90 + park *)
            D20 := D90 + D101;
            D21 := 1000;
            Y20 := TRUE;

            IF (ABS(D10 - (D90 + D101)) <= 20) AND (ABS(D11) <= 100)
                AND (ABS(D12) <= 20) AND (ABS(D13) <= 100)
                AND (ABS(D14 - 10000) <= 20) AND (ABS(D15) <= 100) THEN
                step := 7;
            END_IF;

        7:
            (* Hold final positions and declare completion *)
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
    END_CASE;
END_IF;

END_PROGRAM