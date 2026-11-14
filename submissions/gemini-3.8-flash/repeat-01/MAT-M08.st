PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;

    edge_start : R_TRIG;
    t_settle : TON;
    t_push_end : TON;
    t_done : TON;

    state : INT := 0;
    target_slot : INT := 0;
    target_coord : INT := 0;

    cmd_up : BOOL := FALSE;
    cmd_down : BOOL := FALSE;
    cmd_push : BOOL := FALSE;
    cmd_retract : BOOL := FALSE;
    claim : BOOL := FALSE;
    completed : BOOL := FALSE;
END_VAR

edge_start(CLK := X10);

cmd_up := FALSE;
cmd_down := FALSE;
cmd_push := FALSE;
cmd_retract := FALSE;

CASE state OF
    0:
        IF edge_start.Q AND (D10 = 1) THEN
            target_slot := 0;
            target_coord := 0;
            state := 10;
        END_IF;

    10:
        IF X25 AND (ABS(D20 - target_coord) < 4) THEN
            state := 20;
        ELSE
            state := 30;
        END_IF;

    20:
        IF t_settle.Q THEN
            IF NOT X24 THEN
                state := 40;
            ELSE
                IF target_slot < 3 THEN
                    target_slot := target_slot + 1;
                    target_coord := target_slot * 160;
                    state := 30;
                END_IF;
            END_IF;
        END_IF;

    30:
        IF D20 < target_coord THEN
            cmd_up := TRUE;
        ELSE
            cmd_up := FALSE;
            state := 10;
        END_IF;

    40:
        cmd_push := TRUE;
        IF X23 THEN
            state := 50;
        END_IF;

    50:
        cmd_push := TRUE;
        IF t_push_end.Q THEN
            state := 60;
        END_IF;

    60:
        cmd_retract := TRUE;
        IF X22 THEN
            cmd_retract := FALSE;
            state := 70;
        END_IF;

    70:
        IF t_done.Q THEN
            completed := TRUE;
        END_IF;
END_CASE;

t_settle(IN := (state = 20), PT := T#50ms);
t_push_end(IN := (state = 50), PT := T#100ms);
t_done(IN := (state = 70), PT := T#100ms);

IF NOT X22 THEN
    cmd_up := FALSE;
    cmd_down := FALSE;
END_IF;

IF (state = 40) OR (state = 50) THEN
    IF NOT X25 THEN
        cmd_push := FALSE;
    END_IF;
END_IF;

IF cmd_up AND cmd_down THEN
    cmd_up := FALSE;
    cmd_down := FALSE;
END_IF;

IF cmd_push AND cmd_retract THEN
    cmd_push := FALSE;
    cmd_retract := FALSE;
END_IF;

IF completed THEN
    cmd_up := FALSE;
    cmd_down := FALSE;
    cmd_push := FALSE;
    cmd_retract := FALSE;
    claim := TRUE;
END_IF;

Y20 := cmd_up;
Y21 := cmd_down;
Y22 := cmd_push;
Y23 := cmd_retract;
Y2 := claim;

END_PROGRAM