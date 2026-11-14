PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    request_latched : BOOL;
    home_done_seen : BOOL;
    complete_condition : BOOL;
    complete_timer : TON;
    speed_abs : DINT;
END_VAR

IF X10 THEN
    request_latched := TRUE;
END_IF;

IF D12 < 0 THEN
    speed_abs := 0 - D12;
ELSE
    speed_abs := D12;
END_IF;

IF NOT request_latched THEN
    Y21 := FALSE;
    Y2 := FALSE;
    home_done_seen := FALSE;
ELSE
    IF (NOT home_done_seen) AND X11 AND X13 AND (speed_abs = 0) THEN
        home_done_seen := TRUE;
    END_IF;

    IF Y2 THEN
        Y21 := FALSE;
    ELSE
        IF home_done_seen THEN
            Y21 := FALSE;
        ELSE
            Y21 := TRUE;
        END_IF;
    END_IF;
END_IF;

complete_condition := request_latched AND home_done_seen AND X11 AND (NOT Y21) AND (speed_abs = 0);
complete_timer(IN := complete_condition, PT := T#30ms);

IF request_latched AND (NOT Y2) AND complete_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM