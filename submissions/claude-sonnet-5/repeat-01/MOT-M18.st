PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    step : INT := 0;
    started : BOOL := FALSE;
    initial_A : DINT := 0;
    moving_dir : INT := 1;

    b_retract_history : BOOL := FALSE;
    c_raise_history : BOOL := FALSE;
    edge_captured : BOOL := FALSE;
    edge_pos : DINT := 0;
    configure_issued : BOOL := FALSE;
    origin_latched : DINT := 0;
    final_A_target : DINT := 0;
    final_target_valid : BOOL := FALSE;

    edge_trig : R_TRIG;

    (* constants (as ordinary initialized variables) *)
    POS_TOL : DINT := 20;      (* 0.2 mm * 100 *)
    SPD_TOL : DINT := 100;     (* 1 mm/s * 100 *)
    C_TARGET_100 : DINT := 10000; (* 100 mm * 100 *)
    A_MAX : DINT := 35000;     (* 350 mm * 100 *)
    A_MIN : DINT := 0;
    SEARCH_RATE : DINT := 300;
    FULL_RATE : DINT := 1000;
END_VAR

(* update edge detector every scan *)
edge_trig(CLK := X34);

CASE step OF

0: (* IDLE - wait for start; no enable before X0 *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    D20 := 0;
    D21 := 0;
    D24 := 0;
    D25 := 0;
    D28 := 0;
    D29 := 0;
    IF X0 THEN
        started := TRUE;
        initial_A := D10;
        IF initial_A < 9000 THEN
            moving_dir := 1;
        ELSE
            moving_dir := -1;
        END_IF;
        step := 1;
    END_IF;

1: (* RETRACT_B: retract internal tool to B=0 before raising C *)
    Y21 := TRUE;
    D24 := 0;
    D25 := FULL_RATE;
    Y20 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    D20 := 0;
    D21 := 0;
    D28 := 0;
    D29 := 0;
    IF (ABS(D12) <= POS_TOL) AND (ABS(D13) <= SPD_TOL) THEN
        b_retract_history := TRUE;
        step := 2;
    END_IF;

2: (* RAISE_C: raise elevation to C=100 after retraction complete *)
    Y21 := TRUE;
    D24 := 0;
    D25 := FULL_RATE;
    Y22 := TRUE;
    D28 := C_TARGET_100;
    D29 := FULL_RATE;
    Y20 := FALSE;
    Y30 := FALSE;
    D20 := 0;
    D21 := 0;
    IF (ABS(D14 - C_TARGET_100) <= POS_TOL) AND (ABS(D15) <= SPD_TOL) THEN
        c_raise_history := TRUE;
        step := 3;
    END_IF;

3: (* SEARCH_A: move A to look for fresh reference-sensor edge *)
    Y21 := TRUE;
    D24 := 0;
    D25 := FULL_RATE;
    Y22 := TRUE;
    D28 := C_TARGET_100;
    D29 := FULL_RATE;
    Y20 := TRUE;
    IF moving_dir = 1 THEN
        D20 := A_MAX;
    ELSE
        D20 := A_MIN;
    END_IF;
    D21 := SEARCH_RATE;
    Y30 := FALSE;
    IF edge_trig.Q AND (NOT edge_captured) AND b_retract_history AND c_raise_history THEN
        edge_captured := TRUE;
        edge_pos := D10;
        step := 4;
    END_IF;

4: (* STOPPING: brake A to stop within 10 mm after the edge *)
    Y21 := TRUE;
    D24 := 0;
    D25 := FULL_RATE;
    Y22 := TRUE;
    D28 := C_TARGET_100;
    D29 := FULL_RATE;
    Y20 := FALSE; (* disable to apply braking deceleration *)
    Y30 := FALSE;
    IF ABS(D11) <= SPD_TOL THEN
        step := 5;
    END_IF;

5: (* CONFIGURE: issue reference-configuration edge, then wait for ack *)
    Y21 := TRUE;
    D24 := 0;
    D25 := FULL_RATE;
    Y22 := TRUE;
    D28 := C_TARGET_100;
    D29 := FULL_RATE;
    Y20 := FALSE;
    IF b_retract_history AND c_raise_history AND edge_captured THEN
        IF NOT configure_issued THEN
            Y30 := TRUE;
            configure_issued := TRUE;
        ELSE
            Y30 := FALSE;
            IF X35 THEN
                origin_latched := D90;
                final_A_target := origin_latched + D101;
                final_target_valid := TRUE;
                step := 6;
            END_IF;
        END_IF;
    ELSE
        Y30 := FALSE;
    END_IF;

6: (* MOVE_TO_FINAL: drive A to origin+park, hold B=0, C=100 *)
    Y21 := TRUE;
    D24 := 0;
    D25 := FULL_RATE;
    Y22 := TRUE;
    D28 := C_TARGET_100;
    D29 := FULL_RATE;
    Y20 := TRUE;
    D20 := final_A_target;
    D21 := FULL_RATE;
    Y30 := FALSE;

ELSE
    (* safety fallback: disable everything *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    step := 0;
END_CASE;

(* live completion check: no additional dwell required *)
IF final_target_valid
   AND (ABS(D10 - final_A_target) <= POS_TOL) AND (ABS(D11) <= SPD_TOL)
   AND (ABS(D12) <= POS_TOL) AND (ABS(D13) <= SPD_TOL)
   AND (ABS(D14 - C_TARGET_100) <= POS_TOL) AND (ABS(D15) <= SPD_TOL)
THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM