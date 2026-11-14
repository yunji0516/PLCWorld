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
    Y22 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    u_sync_start : DINT := 0;
    span_req : DINT := 0;
    stop_dist : DINT := 0;
    min_pos : DINT := 0;
    park_mod : DINT := 0;
    diff : DINT := 0;
    rem : DINT := 0;
    target_pos : DINT := 0;
    settle_timer : TON;
    timer_in : BOOL := FALSE;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        IF X10 THEN
            D20 := LIMIT(500, D15, 2500);
            Y20 := TRUE;
            state := 10;
        END_IF;

    10:
        D20 := LIMIT(500, D15, 2500);
        Y20 := TRUE;
        IF X11 THEN
            u_sync_start := D10;
            span_req := D14;
            Y20 := FALSE;
            D20 := 0;
            state := 20;
        END_IF;

    20:
        Y20 := FALSE;
        D20 := 0;
        IF (D10 - u_sync_start) >= span_req THEN
            Y21 := TRUE;
            state := 30;
        END_IF;

    30:
        Y21 := TRUE;
        IF NOT X12 THEN
            Y21 := FALSE;
            IF D12 <= 0 THEN
                stop_dist := 0;
            ELSE
                stop_dist := DINT((REAL(D12) / 1200.0) * (REAL(D12) / 1200.0));
            END_IF;
            min_pos := D11 + stop_dist + 500;
            park_mod := ((D13 MOD 36000) + 36000) MOD 36000;
            diff := min_pos - park_mod;
            IF diff <= 0 THEN
                target_pos := park_mod;
            ELSE
                rem := diff MOD 36000;
                IF rem = 0 THEN
                    target_pos := min_pos;
                ELSE
                    target_pos := min_pos + (36000 - rem);
                END_IF;
            END_IF;
            D21 := target_pos;
            Y22 := TRUE;
            state := 40;
        END_IF;

    40:
        Y22 := TRUE;
        D21 := target_pos;
        IF settle_timer.Q THEN
            Y2 := TRUE;
            state := 50;
        END_IF;

    50:
        Y22 := TRUE;
        D21 := target_pos;
        Y2 := TRUE;
END_CASE;

timer_in := (state = 40) AND (ABS(D11 - target_pos) <= 20) AND (ABS(D12) <= 100);
settle_timer(IN := timer_in, PT := T#30ms);

END_PROGRAM