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
    req_latch : BOOL := FALSE;
    sync_U0 : DINT;
    sync_S0 : DINT;
    ratio_latched : DINT;
    t_y2 : TON;
    y2_ready : BOOL := FALSE;
    cond_met : BOOL := FALSE;
END_VAR

IF X10 AND NOT req_latch THEN
    req_latch := TRUE;
END_IF;

CASE state OF
    0: (* IDLE *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        D20 := 0;
        D21 := 0;
        Y2 := FALSE;
        y2_ready := FALSE;
        cond_met := FALSE;
        t_y2(IN := FALSE);
        IF req_latch THEN
            state := 1;
        END_IF;

    1: (* GEAR_IN *)
        Y20 := TRUE;
        ratio_latched := D15;
        sync_U0 := D10;
        sync_S0 := D11;
        state := 2;

    2: (* SYNCHRONIZING *)
        Y20 := FALSE;
        D20 := ratio_latched;
        D21 := sync_S0 + DINT(REAL(D10 - sync_U0) * REAL(ratio_latched) / 1000.0);
        Y22 := FALSE;
        IF (D10 - sync_U0) >= D14 THEN
            state := 3;
        END_IF;

    3: (* GEAR_OUT *)
        Y21 := TRUE;
        D20 := 0;
        state := 4;

    4: (* PARKING *)
        Y21 := FALSE;
        Y22 := TRUE;
        D21 := D13;
        D20 := 0;
        IF (ABS(D11 - D13) <= 20) AND (ABS(D12) <= 100) THEN
            cond_met := TRUE;
        END_IF;
        t_y2(IN := cond_met AND NOT y2_ready, PT := T#30ms);
        IF t_y2.Q THEN
            y2_ready := TRUE;
            state := 5;
        END_IF;

    5: (* COMPLETED *)
        Y2 := TRUE;
        Y22 := TRUE;
        D21 := D13;
        D20 := 0;
END_CASE;

END_PROGRAM