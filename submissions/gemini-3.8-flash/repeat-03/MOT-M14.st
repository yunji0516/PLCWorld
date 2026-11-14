PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    latched_angle : DINT := 0;
    table_ok : BOOL := FALSE;
    slide_ok : BOOL := FALSE;
    combined_ok : BOOL := FALSE;
    ton_settled : TON;
END_VAR

table_ok := (ABS(D10 - D14) <= 20) AND (ABS(D11) <= 100);
slide_ok := (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100);
combined_ok := table_ok AND slide_ok;

ton_settled(IN := ((state = 3) OR (state = 4)) AND combined_ok, PT := T#30ms);

CASE state OF
    0:
        IF X10 THEN
            latched_angle := D10;
            IF X12 THEN
                state := 3;
            ELSIF X11 THEN
                state := 2;
            ELSE
                state := 1;
            END_IF;
        END_IF;

    1:
        IF X11 THEN
            state := 2;
        END_IF;

    2:
        IF X12 THEN
            state := 3;
        END_IF;

    3:
        IF ton_settled.Q THEN
            state := 4;
        END_IF;

    4:
        ;
END_CASE;

CASE state OF
    0:
        D20 := D10;
        D21 := D12;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;

    1:
        D20 := latched_angle;
        D21 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;

    2:
        D20 := D14;
        D21 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;

    3:
        D20 := D14;
        D21 := D15;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;

    4:
        D20 := D14;
        D21 := D15;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM