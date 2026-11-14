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
    latched_table_angle : DINT := 0;
    terminal_ok : BOOL := FALSE;
    ton_terminal : TON;
END_VAR

terminal_ok := (state = 2) AND X12 AND (ABS(D10 - D14) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100);
ton_terminal(IN := terminal_ok, PT := T#30ms);

CASE state OF
    0:
        IF X10 THEN
            latched_table_angle := D10;
            IF X12 AND (ABS(D10 - D14) <= 20) AND (ABS(D11) <= 100) THEN
                state := 2;
                D20 := D14;
                Y20 := TRUE;
                D21 := D15;
                Y21 := TRUE;
                Y2 := FALSE;
            ELSIF X11 AND (D12 <= D16) AND (ABS(D13) <= 100) THEN
                state := 1;
                D20 := D14;
                Y20 := TRUE;
                D21 := 0;
                Y21 := TRUE;
                Y2 := FALSE;
            ELSE
                state := 3;
                D20 := latched_table_angle;
                Y20 := TRUE;
                D21 := 0;
                Y21 := TRUE;
                Y2 := FALSE;
            END_IF;
        ELSE
            D20 := D10;
            D21 := D12;
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := FALSE;
        END_IF;

    3:
        D20 := latched_table_angle;
        Y20 := TRUE;
        D21 := 0;
        Y21 := TRUE;
        Y2 := FALSE;
        IF X11 AND (D12 <= D16) AND (ABS(D13) <= 100) THEN
            state := 1;
            D20 := D14;
        END_IF;

    1:
        D20 := D14;
        Y20 := TRUE;
        D21 := 0;
        Y21 := TRUE;
        Y2 := FALSE;
        IF X12 AND (ABS(D10 - D14) <= 20) AND (ABS(D11) <= 100) THEN
            state := 2;
            D21 := D15;
        END_IF;

    2:
        D20 := D14;
        Y20 := TRUE;
        D21 := D15;
        Y21 := TRUE;
        IF ton_terminal.Q THEN
            state := 4;
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;

    4:
        D20 := D14;
        Y20 := TRUE;
        D21 := D15;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM