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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
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
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    
    total_admitted : INT := 0;
    total_completed : INT := 0;
    a_state : INT := 0;
    cradle_state : INT := 0;
    b_state : INT := 0;
    owner : INT := 0;
    tool_ex_state : INT := 0;
    head_ready_for_owner : BOOL := FALSE;
    needed_tool : INT := 0;

    pulse_dock : BOOL;
    pulse_unlock : BOOL;
    pulse_lock : BOOL;
    pulse_return : BOOL;
    pulse_admit : BOOL;
    pulse_to_cradle : BOOL;
    pulse_cradle_lock : BOOL;
    pulse_head_release : BOOL;
    pulse_rotate : BOOL;
    pulse_head_grip : BOOL;
    pulse_cradle_unlock : BOOL;
    pulse_to_b : BOOL;
    pulse_release : BOOL;
END_VAR

pulse_dock := FALSE;
pulse_unlock := FALSE;
pulse_lock := FALSE;
pulse_return := FALSE;
pulse_admit := FALSE;
pulse_to_cradle := FALSE;
pulse_cradle_lock := FALSE;
pulse_head_release := FALSE;
pulse_rotate := FALSE;
pulse_head_grip := FALSE;
pulse_cradle_unlock := FALSE;
pulse_to_b := FALSE;
pulse_release := FALSE;

IF a_state > 0 THEN
    D201 := SEL(D11 = 2, 160, 120);
ELSE
    D201 := SEL(D10 = 2, 160, 120);
END_IF;

IF b_state > 0 THEN
    D202 := SEL(D12 = 2, 160, 120);
ELSIF cradle_state >= 3 THEN
    D202 := SEL(D13 = 2, 160, 120);
ELSE
    D202 := 160;
END_IF;

IF owner = 0 THEN
    head_ready_for_owner := FALSE;
    IF b_state = 5 AND NOT X12 THEN
        owner := 4;
    ELSIF cradle_state = 6 AND b_state = 0 AND NOT X12 THEN
        owner := 3;
    ELSIF a_state = 4 AND cradle_state = 0 AND NOT X12 THEN
        owner := 2;
    ELSIF a_state = 0 AND X10 AND X28 AND total_admitted < 4 AND NOT X12 THEN
        owner := 1;
    ELSIF total_completed = 4 AND D8 <> 0 AND NOT X12 AND a_state = 0 AND cradle_state = 0 AND b_state = 0 THEN
        owner := 5;
    END_IF;
END_IF;

IF owner >= 1 AND owner <= 4 THEN
    IF owner = 1 THEN needed_tool := D10;
    ELSIF owner = 2 THEN needed_tool := D11;
    ELSIF owner = 3 THEN needed_tool := D13;
    ELSIF owner = 4 THEN needed_tool := D12;
    END_IF;
    
    IF NOT head_ready_for_owner THEN
        IF tool_ex_state = 0 THEN
            IF D8 <> needed_tool AND needed_tool <> 0 THEN
                IF D8 <> 0 THEN
                    tool_ex_state := 10;
                ELSE
                    tool_ex_state := 30;
                END_IF;
            ELSIF D8 = needed_tool AND needed_tool <> 0 THEN
                head_ready_for_owner := TRUE;
            END_IF;
        END_IF;
    END_IF;
ELSIF owner = 5 THEN
    IF tool_ex_state = 0 THEN
        IF D8 <> 0 THEN
            tool_ex_state := 10;
        ELSE
            owner := 0;
        END_IF;
    END_IF;
END_IF;

IF tool_ex_state = 10 THEN
    D200 := D8;
    pulse_dock := TRUE;
    tool_ex_state := 11;
ELSIF tool_ex_state = 11 THEN
    IF X2A AND NOT X11 THEN
        pulse_unlock := TRUE;
        tool_ex_state := 12;
    END_IF;
ELSIF tool_ex_state = 12 THEN
    IF NOT X2B AND NOT X11 THEN
        pulse_return := TRUE;
        tool_ex_state := 13;
    END_IF;
ELSIF tool_ex_state = 13 THEN
    IF NOT X2A AND NOT X11 THEN
        tool_ex_state := 0;
    END_IF;
ELSIF tool_ex_state = 30 THEN
    D200 := needed_tool;
    pulse_dock := TRUE;
    tool_ex_state := 31;
ELSIF tool_ex_state = 31 THEN
    IF X2A AND NOT X11 THEN
        pulse_lock := TRUE;
        tool_ex_state := 32;
    END_IF;
ELSIF tool_ex_state = 32 THEN
    IF X2B AND NOT X11 THEN
        pulse_return := TRUE;
        tool_ex_state := 33;
    END_IF;
ELSIF tool_ex_state = 33 THEN
    IF NOT X2A AND NOT X11 THEN
        tool_ex_state := 0;
    END_IF;
END_IF;

CASE a_state OF
    0:
        IF owner = 1 AND head_ready_for_owner AND NOT X11 THEN
            pulse_admit := TRUE;
            a_state := 1;
            total_admitted := total_admitted + 1;
        END_IF;
    1:
        IF X14 AND X13 THEN
            owner := 0;
            a_state := 2;
        END_IF;
    2:
        IF X2C AND (X16 OR X15) THEN
            a_state := 3;
        END_IF;
    3:
        IF X15 THEN
            a_state := 4;
        END_IF;
    4:
        IF owner = 2 AND head_ready_for_owner AND NOT X11 THEN
            pulse_to_cradle := TRUE;
            a_state := 5;
        END_IF;
    5:
        IF X17 THEN
            a_state := 0;
        END_IF;
END_CASE;

CASE cradle_state OF
    0:
        IF X1A THEN
            pulse_rotate := TRUE;
            cradle_state := 100;
        ELSIF X17 AND NOT X1A THEN
            cradle_state := 3;
        END_IF;
    100:
        IF NOT X1A AND NOT X1B THEN
            cradle_state := 0;
        END_IF;
    3:
        pulse_cradle_lock := TRUE;
        cradle_state := 31;
    31:
        IF X18 THEN
            cradle_state := 4;
        END_IF;
    4:
        pulse_head_release := TRUE;
        cradle_state := 41;
    41:
        IF X13 THEN
            owner := 0;
            cradle_state := 5;
        END_IF;
    5:
        pulse_rotate := TRUE;
        cradle_state := 51;
    51:
        IF X1A THEN
            cradle_state := 6;
        END_IF;
    6:
        IF owner = 3 AND head_ready_for_owner AND NOT X11 THEN
            pulse_head_grip := TRUE;
            cradle_state := 7;
        END_IF;
    7:
        IF X12 THEN
            cradle_state := 8;
        END_IF;
    8:
        pulse_cradle_unlock := TRUE;
        cradle_state := 81;
    81:
        IF X19 AND NOT X18 THEN
            cradle_state := 9;
        END_IF;
    9:
        IF NOT X11 THEN
            pulse_to_b := TRUE;
            cradle_state := 91;
        END_IF;
    91:
        IF X1C THEN
            cradle_state := 0;
        END_IF;
END_CASE;

CASE b_state OF
    0:
        IF X1C THEN
            b_state := 1;
        END_IF;
    1:
        IF X27 AND X2D THEN
            owner := 0;
            b_state := 2;
        END_IF;
    2:
        IF X23 AND X25 THEN
            b_state := 3;
        END_IF;
    3:
        IF X26 AND X22 AND X2D THEN
            b_state := 4;
        END_IF;
    4:
        IF X1E OR X1D THEN
            b_state := 41;
        END_IF;
    41:
        IF X1D THEN
            b_state := 5;
        END_IF;
    5:
        IF owner = 4 AND head_ready_for_owner AND NOT X11 THEN
            pulse_release := TRUE;
            b_state := 6;
        END_IF;
    6:
        IF X20 THEN
            owner := 0;
            b_state := 7;
        END_IF;
    7:
        IF NOT X20 AND X1F THEN
            b_state := 0;
            total_completed := total_completed + 1;
        END_IF;
END_CASE;

Y10 := pulse_admit;
Y12 := pulse_to_cradle;
Y13 := pulse_cradle_lock;
Y14 := pulse_head_release;
Y15 := pulse_rotate;
Y16 := pulse_head_grip;
Y17 := pulse_cradle_unlock;
Y18 := pulse_to_b;
Y1A := pulse_release;

Y1F := pulse_dock;
Y20 := pulse_unlock;
Y21 := pulse_lock;
Y22 := pulse_return;

Y1D := (b_state >= 2 AND b_state <= 7);
Y1E := (b_state >= 2 AND b_state <= 7);
Y1B := (b_state = 7);
Y11 := (a_state = 2 AND X2C);
Y19 := (b_state = 4 AND X2D);
Y23 := TRUE;
Y24 := TRUE;

IF total_completed = 4 AND owner = 0 AND cradle_state = 0 AND a_state = 0 AND b_state = 0 AND NOT X11 AND NOT X1B AND D8 = 0 THEN
    Y1C := TRUE;
END_IF;

END_PROGRAM