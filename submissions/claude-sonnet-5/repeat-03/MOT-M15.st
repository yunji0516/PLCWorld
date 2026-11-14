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
    state : INT := 0;
    a_ref_target : DINT := 0;
    b_ref_target : DINT := 0;
    c_move_target : DINT := 0;
    d_stroke_target : DINT := 0;

    (* arrival tolerances scaled by 100 (raw units) *)
    pos_tol : DINT := 20;   (* 0.2 mm *)
    vel_tol : DINT := 100;  (* 1 mm/s *)
END_VAR

CASE state OF

0: (* idle - wait for start request; keep all actuators off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := FALSE;

    (* decode side and prepare targets while disabled (allowed) *)
    IF D101 = 100 THEN
        a_ref_target := 6000;
        b_ref_target := 0;
    ELSIF D101 = 200 THEN
        a_ref_target := 0;
        b_ref_target := 6000;
    END_IF;

    c_move_target := D102;
    d_stroke_target := D103;

    D20 := a_ref_target;
    D21 := 1000;
    D24 := b_ref_target;
    D25 := 1000;
    D28 := 0;
    D29 := 1000;
    D32 := 0;
    D33 := 1000;

    IF X0 THEN
        state := 10;
    END_IF;

10: (* enable A/B, drive to reference posture *)
    Y20 := TRUE;
    Y21 := TRUE;
    D20 := a_ref_target;
    D21 := 1000;
    D24 := b_ref_target;
    D25 := 1000;

    IF (ABS(D10 - a_ref_target) <= pos_tol) AND (ABS(D11) <= vel_tol) AND
       (ABS(D12 - b_ref_target) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        state := 20;
    END_IF;

20: (* enable C, move to alignment target; maintain A/B *)
    D20 := a_ref_target;
    D24 := b_ref_target;
    Y22 := TRUE;
    D28 := c_move_target;
    D29 := 1000;

    IF (ABS(D14 - c_move_target) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        state := 30;
    END_IF;

30: (* enable D, approach stroke; maintain A/B and C *)
    D20 := a_ref_target;
    D24 := b_ref_target;
    D28 := c_move_target;
    D29 := 1000;
    Y23 := TRUE;
    D32 := d_stroke_target;
    D33 := 1000;

    IF (ABS(D16 - d_stroke_target) <= pos_tol) AND (ABS(D17) <= vel_tol) THEN
        state := 40;
    END_IF;

40: (* retract D to 0; maintain A/B and C *)
    D20 := a_ref_target;
    D24 := b_ref_target;
    D28 := c_move_target;
    D29 := 1000;
    D32 := 0;
    D33 := 1000;

    IF (ABS(D16 - 0) <= pos_tol) AND (ABS(D17) <= vel_tol) THEN
        state := 50;
    END_IF;

50: (* retract C to 0; maintain A/B reference *)
    D20 := a_ref_target;
    D24 := b_ref_target;
    D28 := 0;
    D29 := 1000;
    D32 := 0;
    D33 := 1000;

    IF (ABS(D14 - 0) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        state := 60;
    END_IF;

60: (* release reference: drive A/B back to 0 *)
    D20 := 0;
    D21 := 1000;
    D24 := 0;
    D25 := 1000;
    D28 := 0;
    D29 := 1000;
    D32 := 0;
    D33 := 1000;

    IF (ABS(D10 - 0) <= pos_tol) AND (ABS(D11) <= vel_tol) AND
       (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        state := 70;
    END_IF;

70: (* disable all actuators, assert completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := TRUE;
    state := 80;

80: (* maintain completion with all actuators off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM