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

    (* internal state *)
    state       : INT := 0;
    side_val    : DINT := 0;
    target_val  : DINT := 0;
    stroke_val  : DINT := 0;
    a_ref       : DINT := 0;
    b_ref       : DINT := 0;
    rate_val    : DINT := 1000;
END_VAR

CASE state OF

0: (* idle - wait for start, keep everything off/zero *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := FALSE;
    D20 := 0; D21 := 0;
    D24 := 0; D25 := 0;
    D28 := 0; D29 := 0;
    D32 := 0; D33 := 0;

    IF X0 THEN
        side_val   := D101;
        target_val := D102;
        stroke_val := D103;
        IF side_val = 100 THEN
            a_ref := 6000; (* 60 mm *)
            b_ref := 0;
        ELSE
            a_ref := 0;
            b_ref := 6000; (* 60 mm *)
        END_IF;
        state := 1;
    END_IF;

1: (* establish directional reference pins A/B *)
    Y20 := TRUE;
    Y21 := TRUE;
    D20 := a_ref; D21 := rate_val;
    D24 := b_ref; D25 := rate_val;

    IF ABS(D10 - a_ref) <= 20 AND ABS(D11) <= 100 AND
       ABS(D12 - b_ref) <= 20 AND ABS(D13) <= 100 THEN
        state := 2;
    END_IF;

2: (* move transfer axis C to target through-hole position *)
    Y22 := TRUE;
    D28 := target_val; D29 := rate_val;

    IF ABS(D14 - target_val) <= 20 AND ABS(D15) <= 100 THEN
        state := 3;
    END_IF;

3: (* approach upper tool: move D to stroke, C held at target *)
    Y23 := TRUE;
    D32 := stroke_val; D33 := rate_val;

    IF ABS(D16 - stroke_val) <= 20 AND ABS(D17) <= 100 THEN
        state := 4;
    END_IF;

4: (* retract upper tool D to 0, C held at target *)
    D32 := 0; D33 := rate_val;

    IF ABS(D16 - 0) <= 20 AND ABS(D17) <= 100 THEN
        state := 5;
    END_IF;

5: (* tool clear, now retract C to 0 *)
    D28 := 0; D29 := rate_val;

    IF ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 THEN
        state := 6;
    END_IF;

6: (* release directional reference: move A/B back to 0 *)
    D20 := 0; D21 := rate_val;
    D24 := 0; D25 := rate_val;

    IF ABS(D10 - 0) <= 20 AND ABS(D11) <= 100 AND
       ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
        state := 7;
    END_IF;

7: (* all axes at zero: disable actuators, declare completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    D21 := 0; D25 := 0; D29 := 0; D33 := 0;
    Y2 := TRUE;
    state := 8;

8: (* maintain completion, all actuators off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM