PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    req_edge : R_TRIG;
    hold_timer : TON;
    stab_timer : TON;

    state : INT;
    M_req : BOOL;
    M_complete : BOOL;
    M_brake_engaged : BOOL;
    target_B_raw : DINT;
    pi : REAL := 3.14159265;
    A_deg : REAL;
    B_mm : REAL;
    M_nm : REAL;
END_VAR

req_edge(CLK := X10);

IF req_edge.Q THEN
    M_req := TRUE;
END_IF;

Y2 := M_complete;

CASE state OF
    0:
        IF M_req THEN
            state := 10;
            target_B_raw := DINT(-450.0 * SIN(REAL(D10) / 100.0 * pi / 180.0) * 100.0);
        END_IF;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        hold_timer(IN := FALSE);
        stab_timer(IN := FALSE);

    10:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := D10;
        D21 := target_B_raw;
        D22 := 0;
        Y22 := FALSE;
        hold_timer(IN := FALSE);
        stab_timer(IN := FALSE);

        IF ABS(D11 - D10) <= 20 AND ABS(D12) <= 100 AND ABS(D13 - target_B_raw) <= 20 AND ABS(D14) <= 100 THEN
            state := 20;
        END_IF;

    20:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := D10;
        D21 := target_B_raw;
        D22 := 0;
        Y22 := TRUE;

        hold_timer(IN := TRUE, PT := T#80ms);
        IF X11 OR hold_timer.Q THEN
            M_brake_engaged := TRUE;
            state := 30;
        END_IF;
        stab_timer(IN := FALSE);

    30:
        Y20 := FALSE;
        Y21 := TRUE;
        D20 := D10;
        D21 := target_B_raw;
        D22 := 0;
        Y22 := TRUE;
        hold_timer(IN := FALSE);
        stab_timer(IN := FALSE);
        state := 40;

    40:
        Y20 := FALSE;
        Y21 := TRUE;
        D20 := D10;
        D21 := target_B_raw;
        D22 := 0;
        Y22 := TRUE;
        hold_timer(IN := FALSE);

        A_deg := REAL(D11) / 100.0;
        B_mm := REAL(D13) / 100.0;
        M_nm := 88.29 * SIN(A_deg * pi / 180.0) + 0.1962 * B_mm;

        IF ABS(M_nm) <= 1.0 AND ABS(D11 - D10) <= 20 AND ABS(D13 - target_B_raw) <= 20 AND ABS(D12) <= 100 AND ABS(D14) <= 100 THEN
            stab_timer(IN := TRUE, PT := T#30ms);
            IF stab_timer.Q THEN
                M_complete := TRUE;
            END_IF;
        ELSE
            stab_timer(IN := FALSE);
        END_IF;
END_CASE;

END_PROGRAM