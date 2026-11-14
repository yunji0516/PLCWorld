PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;

    start_trig : R_TRIG;
    settle_ton : TON;

    state : INT;
    target_count : INT;
    net_count : INT;
    pe_state : INT;
    transfer_stage : INT;
    forward_just_completed : BOOL;
    partial_retreat_detected : BOOL;
END_VAR

start_trig(CLK := X10);

IF NOT X20 AND NOT X21 THEN
    pe_state := 0;
ELSIF X20 AND NOT X21 THEN
    pe_state := 1;
ELSIF X20 AND X21 THEN
    pe_state := 2;
ELSIF NOT X20 AND X21 THEN
    pe_state := 3;
END_IF;

forward_just_completed := FALSE;
partial_retreat_detected := FALSE;

CASE transfer_stage OF
    0:
        IF pe_state = 1 THEN
            transfer_stage := 1;
        ELSIF pe_state = 3 THEN
            transfer_stage := 10;
        END_IF;

    1:
        IF pe_state = 2 THEN
            transfer_stage := 2;
        ELSIF pe_state = 0 THEN
            transfer_stage := 0;
            partial_retreat_detected := TRUE;
        END_IF;

    2:
        IF pe_state = 3 THEN
            transfer_stage := 3;
        ELSIF pe_state = 1 THEN
            transfer_stage := 1;
        END_IF;

    3:
        IF pe_state = 0 THEN
            transfer_stage := 0;
            net_count := net_count + 1;
            forward_just_completed := TRUE;
        ELSIF pe_state = 2 THEN
            transfer_stage := 2;
        END_IF;

    10:
        IF pe_state = 2 THEN
            transfer_stage := 11;
        ELSIF pe_state = 0 THEN
            transfer_stage := 0;
        END_IF;

    11:
        IF pe_state = 1 THEN
            transfer_stage := 12;
        ELSIF pe_state = 3 THEN
            transfer_stage := 10;
        END_IF;

    12:
        IF pe_state = 0 THEN
            transfer_stage := 0;
            net_count := net_count - 1;
        ELSIF pe_state = 2 THEN
            transfer_stage := 11;
        END_IF;
ELSE
    transfer_stage := 0;
END_CASE;

settle_ton(
    IN := (state = 30 AND X23 AND X24 AND NOT X22 AND (net_count = target_count)),
    PT := T#2000ms
);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_trig.Q THEN
            target_count := D10;
            state := 10;
        END_IF;

    10:
        Y20 := TRUE;
        Y21 := FALSE;
        IF partial_retreat_detected THEN
            state := 15;
        ELSIF forward_just_completed THEN
            IF X22 THEN
                state := 12;
            ELSE
                state := 20;
            END_IF;
        END_IF;

    12:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X21 THEN
            state := 15;
        ELSIF NOT X22 THEN
            state := 20;
        END_IF;

    15:
        Y20 := FALSE;
        Y21 := FALSE;
        IF NOT X22 AND X23 THEN
            state := 10;
        END_IF;

    20:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X23 THEN
            IF net_count < target_count THEN
                state := 10;
            ELSE
                state := 30;
            END_IF;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        IF settle_ton.Q THEN
            state := 40;
        END_IF;

    40:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X25 THEN
            state := 50;
        END_IF;

    50:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM