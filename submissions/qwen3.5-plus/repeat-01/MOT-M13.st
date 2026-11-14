PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    scan_counter : DINT;
    started : BOOL;
    state : INT;
    a_arrived : BOOL;
    b_arrived : BOOL;
    c_arrived : BOOL;
    d_arrived : BOOL;
    completion_hold : DINT;
    completion_flagged : BOOL;
END_VAR

(* Scale request values from x100 format to internal target positions *)
b_tgt := D101;
c_tgt := D102;
d_tgt := D103;

IF NOT X0 THEN
    (* Before start: disable all axes, clear outputs *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    D20 := 0; D24 := 0; D28 := 0; D32 := 0;
    D21 := 0; D25 := 0; D29 := 0; D33 := 0;
    Y2 := FALSE;
    started := FALSE;
    state := 0;
    completion_hold := 0;
    completion_flagged := FALSE;
ELSE
    IF NOT started THEN
        started := TRUE;
        scan_counter := 0;
        state := 0;
        completion_hold := 0;
        completion_flagged := FALSE;
    END_IF;

    scan_counter := scan_counter + 1;
    IF scan_counter > 1500 THEN
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y2 := FALSE;
        RETURN;
    END_IF;

    completion_hold := 0;

    CASE state OF

    0: (* State 0: Move A to 12000, B to angle, prepare C and D *)
        a_enable := TRUE;  a_target := 12000; a_rate := 1000;
        b_enable := TRUE;  b_target := b_tgt;  b_rate := 1000;
        c_enable := TRUE;  c_target := c_tgt;  c_rate := 1000;
        d_enable := TRUE;  d_target := d_tgt;  d_rate := 1000;
        IF ABS(D10 - 12000) <= 20 AND ABS(D11) <= 100 THEN
            state := 1;
        END_IF;

    1: (* State 1: Continue all movement, wait for C arrival *)
        a_enable := TRUE;  a_target := 12000; a_rate := 1000;
        b_enable := TRUE;  b_target := b_tgt;  b_rate := 1000;
        c_enable := TRUE;  c_target := c_tgt;  c_rate := 1000;
        d_enable := TRUE;  d_target := d_tgt;  d_rate := 1000;
        IF ABS(D14 - c_tgt) <= 20 AND ABS(D15) <= 100 THEN
            state := 2;
        END_IF;

    2: (* State 2: Dock - lower A to 100 *)
        a_enable := TRUE;  a_target := 10000; a_rate := 1000;
        b_enable := TRUE;  b_target := b_tgt;  b_rate := 1000;
        c_enable := TRUE;  c_target := c_tgt;  c_rate := 1000;
        d_enable := TRUE;  d_target := d_tgt;  d_rate := 1000;
        IF ABS(D10 - 10000) <= 20 AND ABS(D11) <= 100 THEN
            state := 3;
        END_IF;

    3: (* State 3: Hold docking position, assert completion *)
        a_enable := TRUE;  a_target := 10000; a_rate := 1000;
        b_enable := TRUE;  b_target := b_tgt;  b_rate := 1000;
        c_enable := TRUE;  c_target := c_tgt;  c_rate := 1000;
        d_enable := TRUE;  d_target := d_tgt;  d_rate := 1000;
        completion_hold := completion_hold + 1;
        IF completion_hold >= 10 THEN
            Y2 := TRUE;
            completion_flagged := TRUE;
            state := 4;
        END_IF;

    4: (* State 4: Raise A to 120 to leave support *)
        a_enable := TRUE;  a_target := 12000; a_rate := 1000;
        b_enable := TRUE;  b_target := b_tgt;  b_rate := 1000;
        c_enable := TRUE;  c_target := c_tgt;  c_rate := 1000;
        d_enable := TRUE;  d_target := d_tgt;  d_rate := 1000;
        IF ABS(D10 - 12000) <= 20 AND ABS(D11) <= 100 THEN
            state := 5;
        END_IF;

    5: (* State 5: Retrieve C to 0 *)
        a_enable := TRUE;  a_target := 12000; a_rate := 1000;
        b_enable := TRUE;  b_target := b_tgt;  b_rate := 1000;
        c_enable := TRUE;  c_target := 0;      c_rate := 1000;
        d_enable := TRUE;  d_target := d_tgt;  d_rate := 1000;
        IF ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 THEN
            state := 6;
        END_IF;

    6: (* State 6: Lower B to 0 *)
        a_enable := TRUE;  a_target := 12000; a_rate := 1000;
        b_enable := TRUE;  b_target := 0;     b_rate := 1000;
        c_enable := TRUE;  c_target := 0;     c_rate := 1000;
        d_enable := TRUE;  d_target := d_tgt;  d_rate := 1000;
        IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
            state := 7;
        END_IF;

    7: (* State 7: Lower D to 0, all axes homed *)
        a_enable := TRUE;  a_target := 12000; a_rate := 1000;
        b_enable := TRUE;  b_target := 0;     b_rate := 1000;
        c_enable := TRUE;  c_target := 0;     c_rate := 1000;
        d_enable := TRUE;  d_target := 0;     d_rate := 1000;
        IF ABS(D16 - 0) <= 20 AND ABS(D17) <= 100 THEN
            (* Sequence complete - maintain completion signal *)
        END_IF;

    END_CASE;
END_IF;

END_PROGRAM