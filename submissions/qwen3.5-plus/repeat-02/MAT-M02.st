PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    start_edge : R_TRIG;
    state : INT := 0; (* 0=WAIT, 1=GRAB, 2=GRIP, 3=LIFT, 4=ADVANCE, 5=ROTATE, 6=LOWER, 7=RELEASE, 8=LIFT_RETURN, 9=RETURN_TO_SRC, 10=FINISH *)
    
    target_angle : INT;
    head_at_pickup : INT;
    
    grip_timer : TON;
    release_timer : TON;
    
    advance_start : DINT;
    return_start : DINT;
    
    diff : REAL;
    norm_diff : REAL;
    
    angle_tolerance : REAL := 3.0;
    
    ADVANCE_SCANS : DINT := 130;
    VERT_SCANS : DINT := 90;
    RETURN_SCANS : DINT := 130;
    GRIP_MS : TIME := T#250ms;
    OPEN_MS : TIME := T#200ms;
END_VAR

(* Initialize all outputs to safe state *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y2 := FALSE;

(* Detect rising edge on start request *)
start_edge(CLK := X10);

CASE state OF
    (* WAIT_START: Wait for rising edge on X10 *)
    0:
        IF start_edge.Q THEN
            target_angle := DINT#10; (* Capture D10 *)
            head_at_pickup := DINT#D21; (* Capture initial head angle *)
            state := 1; (* Go to GRAB *)
        END_IF;

    (* GRAB: Move down to source, prepare to grip *)
    1:
        Y24 := TRUE; (* Down command *)
        Y25 := FALSE;
        Y26 := FALSE;
        IF X22 THEN
            state := 2; (* Go to GRIP *)
        END_IF;

    (* GRIP: Close grip, wait for grip timer and holding feedback *)
    2:
        Y24 := FALSE;
        Y20 := TRUE; (* Grip close *)
        grip_timer(IN := TRUE, PT := GRIP_MS);
        IF grip_timer.Q AND X24 THEN
            state := 3; (* Go to LIFT *)
        END_IF;

    (* LIFT: Raise tool high before horizontal travel *)
    3:
        Y20 := TRUE; (* Maintain grip *)
        Y23 := TRUE; (* Up command *)
        IF X23 THEN
            advance_start := DINT#0;
            state := 4; (* Go to ADVANCE *)
        END_IF;

    (* ADVANCE: Travel to receiver *)
    4:
        Y23 := FALSE;
        Y21 := TRUE; (* Advance command *)
        advance_start := advance_start + 1;
        IF advance_start >= ADVANCE_SCANS THEN
            IF X21 THEN
                state := 5; (* Go to ROTATE *)
            END_IF;
        END_IF;

    (* ROTATE: Rotate head to achieve target plate orientation *)
    5:
        Y21 := TRUE; (* Continue advancing *)
        
        diff := REAL#D21 - REAL#head_at_pickup;
        norm_diff := REAL#target_angle - diff;
        
        (* Normalize angle difference to [-180, 180) *)
        WHILE norm_diff >= 180.0 DO
            norm_diff := norm_diff - 360.0;
        END_WHILE;
        WHILE norm_diff < -180.0 DO
            norm_diff := norm_diff + 360.0;
        END_WHILE;
        
        IF ABS(norm_diff) <= angle_tolerance THEN
            (* Rotation complete *)
            Y25 := FALSE;
            Y26 := FALSE;
            Y21 := FALSE;
            state := 6; (* Go to LOWER *)
        ELSIF norm_diff > 0.0 THEN
            Y25 := TRUE;
            Y26 := FALSE;
        ELSE
            Y25 := FALSE;
            Y26 := TRUE;
        END_IF;

    (* LOWER: Lower tool at receiver for release *)
    6:
        Y25 := FALSE;
        Y26 := FALSE;
        Y21 := FALSE;
        Y24 := TRUE; (* Down command *)
        IF X22 THEN
            state := 7; (* Go to RELEASE *)
        END_IF;

    (* RELEASE: Open grip, wait for release timer and released feedback *)
    7:
        Y24 := FALSE;
        Y20 := FALSE; (* Grip open/release *)
        release_timer(IN := TRUE, PT := OPEN_MS);
        IF release_timer.Q AND X25 THEN
            state := 8; (* Go to LIFT_RETURN *)
        END_IF;

    (* LIFT_RETURN: Lift tool after release *)
    8:
        Y20 := FALSE;
        Y23 := TRUE; (* Up command *)
        IF X23 THEN
            return_start := DINT#0;
            state := 9; (* Go to RETURN_TO_SRC *)
        END_IF;

    (* RETURN_TO_SRC: Return to source position *)
    9:
        Y23 := FALSE;
        Y22 := TRUE; (* Return command *)
        return_start := return_start + 1;
        IF return_start >= RETURN_SCANS THEN
            IF X20 THEN
                state := 10; (* Go to FINISH *)
            END_IF;
        END_IF;

    (* FINISH: Verify and assert completion *)
    10:
        Y22 := FALSE;
        Y23 := TRUE; (* Ensure high position *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X20 AND X23 AND NOT X24 THEN
            Y2 := TRUE;
        END_IF;

ELSE
    (* Default safe state *)
    state := 0;
END_CASE;

END_PROGRAM