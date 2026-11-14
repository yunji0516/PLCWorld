PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    state : INT;
    req_target_raw : DINT;
    req_depth_raw : DINT;
    count_at_request : DINT;
    at_access_pose : BOOL;
    at_final_pose : BOOL;
    module_done_seen : BOOL;
END_VAR

at_access_pose := (ABS(D10 - req_target_raw) <= 20) AND
                  (ABS(D11) <= 100) AND
                  (ABS(D12 - req_depth_raw) <= 20) AND
                  (ABS(D13) <= 100);

at_final_pose := (ABS(D10 - req_target_raw) <= 20) AND
                 (ABS(D11) <= 100) AND
                 (ABS(D12) <= 20) AND
                 (ABS(D13) <= 100);

CASE state OF
    0:
        IF X0 THEN
            IF D101 < 0 THEN
                req_target_raw := 0;
            ELSIF D101 > 30000 THEN
                req_target_raw := 30000;
            ELSE
                req_target_raw := D101;
            END_IF;

            IF D102 < 0 THEN
                req_depth_raw := 0;
            ELSIF D102 > 12000 THEN
                req_depth_raw := 12000;
            ELSE
                req_depth_raw := D102;
            END_IF;

            count_at_request := D95;
            module_done_seen := FALSE;

            IF X34 THEN
                state := 5;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    5:
        IF NOT X34 THEN
            state := 10;
        END_IF;

    10:
        IF at_access_pose AND (NOT X34) THEN
            count_at_request := D95;
            module_done_seen := FALSE;
            state := 20;
        END_IF;

    20:
        state := 30;

    30:
        IF (D95 > count_at_request) AND X35 THEN
            module_done_seen := TRUE;
        END_IF;

        IF module_done_seen AND (NOT X34) THEN
            state := 40;
        END_IF;

    40:
        IF at_final_pose THEN
            state := 50;
        END_IF;

    50:
        state := 50;

ELSE
    state := 0;
END_CASE;

D21 := 1000;
D25 := 1000;
Y30 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        D20 := 0;
        D24 := 0;
        Y20 := FALSE;
        Y21 := FALSE;

    5:
        D20 := req_target_raw;
        D24 := req_depth_raw;
        Y20 := FALSE;
        Y21 := FALSE;

    10:
        D20 := req_target_raw;
        D24 := req_depth_raw;
        Y20 := TRUE;
        Y21 := TRUE;

    20:
        D20 := req_target_raw;
        D24 := req_depth_raw;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := TRUE;

    30:
        D20 := req_target_raw;
        D24 := req_depth_raw;
        Y20 := TRUE;
        Y21 := TRUE;

    40:
        D20 := req_target_raw;
        D24 := 0;
        Y20 := TRUE;
        Y21 := TRUE;

    50:
        D20 := req_target_raw;
        D24 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;

ELSE
    D20 := 0;
    D24 := 0;
    Y20 := FALSE;
    Y21 := FALSE;
END_CASE;

END_PROGRAM