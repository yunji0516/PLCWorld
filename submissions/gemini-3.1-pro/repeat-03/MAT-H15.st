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
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    init_done : BOOL := FALSE;
    head_state : INT := 0;
    fork_state : INT := 0;
    fork_task : INT := 0;
    a_pallet_supplied : BOOL := FALSE;
    b_pallet_supplied : BOOL := FALSE;
    a_shipped : BOOL := FALSE;
    b_shipped : BOOL := FALSE;
    side_used_this_scan : BOOL := FALSE;
END_VAR

IF NOT init_done THEN
    D203 := 850;
    D204 := 850;
    init_done := TRUE;
END_IF;

side_used_this_scan := FALSE;

CASE head_state OF
    0:
        Y10 := TRUE;
        Y11 := TRUE;
        head_state := 1;
    1:
        Y10 := FALSE;
        Y11 := FALSE;
        IF NOT X12 THEN
            IF X13 THEN
                IF D5 = D7 AND X28 AND X25 AND D11 < 3 THEN
                    IF NOT side_used_this_scan THEN
                        D201 := 1;
                        IF D11 = 0 THEN D202 := 850; ELSE D202 := D9; END_IF;
                        Y13 := TRUE;
                        side_used_this_scan := TRUE;
                        head_state := 2;
                    END_IF;
                ELSIF D5 = D8 AND X29 AND X26 AND D12 < 4 THEN
                    IF NOT side_used_this_scan THEN
                        D201 := 2;
                        IF D12 = 0 THEN D202 := 850; ELSE D202 := D10; END_IF;
                        Y13 := TRUE;
                        side_used_this_scan := TRUE;
                        head_state := 2;
                    END_IF;
                END_IF;
            ELSE
                IF X28 AND X25 AND D11 < 3 AND D7 = 1 AND X10 THEN
                    D200 := 1; 
                    Y12 := TRUE; 
                    head_state := 2;
                ELSIF X28 AND X25 AND D11 < 3 AND D7 = 2 AND X11 THEN
                    D200 := 2; 
                    Y12 := TRUE; 
                    head_state := 2;
                ELSIF X29 AND X26 AND D12 < 4 AND D8 = 1 AND X10 THEN
                    D200 := 1; 
                    Y12 := TRUE; 
                    head_state := 2;
                ELSIF X29 AND X26 AND D12 < 4 AND D8 = 2 AND X11 THEN
                    D200 := 2; 
                    Y12 := TRUE; 
                    head_state := 2;
                END_IF;
            END_IF;
        END_IF;
    2:
        Y12 := FALSE;
        Y13 := FALSE;
        IF X12 THEN
            head_state := 3;
        END_IF;
    3:
        IF NOT X12 THEN
            head_state := 1;
        END_IF;
END_CASE;

CASE fork_state OF
    0:
        IF NOT a_pallet_supplied AND X27 THEN
            fork_task := 1; 
            fork_state := 10;
        ELSIF NOT b_pallet_supplied AND X27 THEN
            fork_task := 2; 
            fork_state := 10;
        ELSIF D11 >= 3 AND NOT a_shipped AND NOT X12 THEN
            fork_task := 3; 
            fork_state := 20;
        ELSIF D12 >= 4 AND NOT b_shipped AND NOT X12 THEN
            fork_task := 4; 
            fork_state := 20;
        END_IF;

    10:
        Y1C := TRUE;
        fork_state := 11;
    11:
        Y1C := FALSE;
        IF X2A THEN
            Y1D := TRUE;
            fork_state := 12;
        END_IF;
    12:
        Y1D := FALSE;
        IF X2B THEN
            IF NOT side_used_this_scan THEN
                IF fork_task = 1 THEN D201 := 1; ELSE D201 := 2; END_IF;
                Y1E := TRUE;
                side_used_this_scan := TRUE;
                fork_state := 13;
            END_IF;
        END_IF;
    13:
        Y1E := FALSE;
        IF X2C THEN
            Y1F := TRUE;
            fork_state := 14;
        END_IF;
    14:
        Y1F := FALSE;
        IF X18 THEN
            IF fork_task = 1 THEN a_pallet_supplied := TRUE; END_IF;
            IF fork_task = 2 THEN b_pallet_supplied := TRUE; END_IF;
            fork_state := 0;
        END_IF;

    20:
        IF NOT side_used_this_scan THEN
            IF fork_task = 3 THEN D201 := 1; ELSE D201 := 2; END_IF;
            Y16 := TRUE;
            side_used_this_scan := TRUE;
            fork_state := 21;
        END_IF;
    21:
        Y16 := FALSE;
        IF X15 THEN
            Y17 := TRUE;
            fork_state := 22;
        END_IF;
    22:
        Y17 := FALSE;
        IF X16 THEN
            IF fork_task = 3 THEN D203 := 780; ELSE D204 := 780; END_IF;
            fork_state := 23;
        END_IF;
    23:
        IF (fork_task = 3 AND X23) OR (fork_task = 4 AND X24) THEN
            Y18 := TRUE;
            fork_state := 24;
        END_IF;
    24:
        Y18 := FALSE;
        IF X17 THEN
            Y19 := TRUE;
            fork_state := 25;
        END_IF;
    25:
        Y19 := FALSE;
        IF X19 THEN
            Y1A := TRUE;
            fork_state := 26;
        END_IF;
    26:
        Y1A := FALSE;
        IF X18 THEN
            IF fork_task = 3 THEN
                D203 := 850;
                a_shipped := TRUE;
            ELSE
                D204 := 850;
                b_shipped := TRUE;
            END_IF;
            fork_state := 27;
        END_IF;
    27:
        IF (fork_task = 3 AND X21) OR (fork_task = 4 AND X22) THEN
            fork_state := 0;
        END_IF;
END_CASE;

Y1B := (a_shipped AND b_shipped AND X18 AND X21 AND X22 AND NOT X12 AND NOT X13 AND fork_state = 0 AND head_state = 1);

END_PROGRAM