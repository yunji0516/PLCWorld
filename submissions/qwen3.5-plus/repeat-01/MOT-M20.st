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
    ratio_latched : DINT;
    span_latched : DINT;
    park_latched : DINT;
    U_origin : DINT;
    S_origin : DINT;
    pos_at_sep : DINT;
    sync_confirmed : BOOL := FALSE;
    park_cmd_set : BOOL := FALSE;
    
    edge_X10 : R_TRIG;
    X11_timer : TON;
    sep_wait_timer : TON;
    
    park_rem : DINT;
    current_rem : DINT;
    delta : DINT;
END_VAR

IF state = 0 THEN
    edge_X10(CLK := X10);
    IF edge_X10.Q THEN
        ratio_latched := D15;
        span_latched := D14;
        park_latched := D13;
        D20 := ratio_latched;
        Y20 := TRUE;
        state := 1;
    END_IF;
END_IF;

IF state = 1 THEN
    Y20 := FALSE;
    IF X12 THEN
        U_origin := D10;
        S_origin := D11;
        state := 2;
    END_IF;
END_IF;

IF state = 2 THEN
    D21 := S_origin + (D10 - U_origin) * ratio_latched / 1000;
    X11_timer(IN := X11, PT := T#30ms);
    IF X11_timer.Q AND NOT sync_confirmed THEN
        sync_confirmed := TRUE;
    END_IF;
    IF sync_confirmed AND (D10 - U_origin) >= span_latched THEN
        Y21 := TRUE;
        pos_at_sep := D11;
        state := 3;
    END_IF;
END_IF;

IF state = 3 THEN
    Y21 := FALSE;
    sep_wait_timer(IN := TRUE, PT := T#50ms);
    IF sep_wait_timer.Q THEN
        state := 4;
    END_IF;
END_IF;

IF state = 4 THEN
    IF sep_wait_timer.Q AND NOT park_cmd_set THEN
        park_rem := park_latched - 36000 * (park_latched / 36000);
        IF park_rem < 0 THEN
            park_rem := park_rem + 36000;
        END_IF;
        current_rem := pos_at_sep - 36000 * (pos_at_sep / 36000);
        IF current_rem < 0 THEN
            current_rem := current_rem + 36000;
        END_IF;
        delta := park_rem - current_rem;
        IF delta > 18000 THEN
            delta := delta - 36000;
        ELSIF delta < -18000 THEN
            delta := delta + 36000;
        END_IF;
        D21 := pos_at_sep + delta;
        Y22 := TRUE;
        park_cmd_set := TRUE;
    END_IF;
    IF park_cmd_set AND ABS(D11 - D21) <= 20 AND ABS(D12) <= 100 THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM