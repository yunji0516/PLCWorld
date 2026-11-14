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

    state    : INT := 0;
    a_tgt    : DINT := 0;
    b_tgt    : DINT := 0;
    c_tgt    : DINT := 0;
    d_tgt    : DINT := 0;
    pos_tol  : DINT := 20;   (* 0.2 mm x100 *)
    spd_tol  : DINT := 100;  (* 1 mm/s x100 *)
END_VAR

(* --- compute current-cycle targets based on state --- *)
IF state <= 5 THEN
    IF D101 <= 150 THEN
        a_tgt := 6000;  (* A = 60 mm *)
        b_tgt := 0;
    ELSE
        a_tgt := 0;
        b_tgt := 6000;  (* B = 60 mm *)
    END_IF;
ELSE
    a_tgt := 0;
    b_tgt := 0;
END_IF;

IF state <= 1 THEN
    c_tgt := 0;
ELSIF state <= 4 THEN
    c_tgt := D102;  (* through-hole target, already x100 scaled *)
ELSE
    c_tgt := 0;
END_IF;

IF state <= 2 THEN
    d_tgt := 0;
ELSIF state = 3 THEN
    d_tgt := D103;  (* stroke target, already x100 scaled *)
ELSE
    d_tgt := 0;
END_IF;

CASE state OF

    0: (* wait for start request before any enable *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        D20 := 0; D21 := 0;
        D24 := 0; D25 := 0;
        D28 := 0; D29 := 0;
        D32 := 0; D33 := 0;
        IF X0 THEN
            state := 1;
        END_IF;

    1: (* establish directional reference posture on A/B *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        D20 := a_tgt; D21 := 1000;
        D24 := b_tgt; D25 := 1000;
        D28 := 0; D29 := 0;
        D32 := 0; D33 := 0;
        IF ABS(D10 - a_tgt) <= pos_tol AND ABS(D11) <= spd_tol AND
           ABS(D12 - b_tgt) <= pos_tol AND ABS(D13) <= spd_tol THEN
            state := 2;
        END_IF;

    2: (* transfer jig to align through-hole under tool *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE;
        D20 := a_tgt; D21 := 1000;
        D24 := b_tgt; D25 := 1000;
        D28 := c_tgt; D29 := 1000;
        D32 := 0; D33 := 0;
        IF ABS(D14 - c_tgt) <= pos_tol AND ABS(D15) <= spd_tol THEN
            state := 3;
        END_IF;

    3: (* approach: lower tool to stroke, C held at target *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        D20 := a_tgt; D21 := 1000;
        D24 := b_tgt; D25 := 1000;
        D28 := c_tgt; D29 := 1000;
        D32 := d_tgt; D33 := 1000;
        IF ABS(D16 - d_tgt) <= pos_tol AND ABS(D17) <= spd_tol THEN
            state := 4;
        END_IF;

    4: (* retract tool to 0, C still held at target *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        D20 := a_tgt; D21 := 1000;
        D24 := b_tgt; D25 := 1000;
        D28 := c_tgt; D29 := 1000;
        D32 := d_tgt; D33 := 1000;
        IF ABS(D16 - d_tgt) <= pos_tol AND ABS(D17) <= spd_tol THEN
            state := 5;
        END_IF;

    5: (* retract transfer axis C back to 0 *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        D20 := a_tgt; D21 := 1000;
        D24 := b_tgt; D25 := 1000;
        D28 := c_tgt; D29 := 1000;
        D32 := d_tgt; D33 := 1000;
        IF ABS(D14 - c_tgt) <= pos_tol AND ABS(D15) <= spd_tol THEN
            state := 6;
        END_IF;

    6: (* release reference pins back to 0 *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        D20 := a_tgt; D21 := 1000;
        D24 := b_tgt; D25 := 1000;
        D28 := c_tgt; D29 := 1000;
        D32 := d_tgt; D33 := 1000;
        IF ABS(D10 - a_tgt) <= pos_tol AND ABS(D11) <= spd_tol AND
           ABS(D12 - b_tgt) <= pos_tol AND ABS(D13) <= spd_tol THEN
            state := 7;
        END_IF;

    7: (* completed: hold all axes at zero, assert completion *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        D20 := a_tgt; D21 := 1000;
        D24 := b_tgt; D25 := 1000;
        D28 := c_tgt; D29 := 1000;
        D32 := d_tgt; D33 := 1000;
        Y2 := TRUE;

    ELSE
        state := 0;

END_CASE;

END_PROGRAM