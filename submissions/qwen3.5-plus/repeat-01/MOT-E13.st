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
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    (* Internal variables *)
    state : INT := 0;
    stability_timer : TON;
    observation_timer : TON;
    left_cmd_prev : REAL := 0.0;
    right_cmd_prev : REAL := 0.0;
END_VAR

VAR
    current_x : REAL;
    current_z : REAL;
    current_heading : REAL;
    speed_x : REAL;
    speed_heading : REAL;
    target : REAL;
    error : REAL;
    forward_raw : REAL;
    forward : REAL;
    heading_err_deg : REAL;
    heading_err_rad : REAL;
    heading_correction : REAL;
    z_correction : REAL;
    left_cmd : REAL;
    right_cmd : REAL;
    d20_raw : DINT;
    d21_raw : DINT;
    done : BOOL;
END_VAR

(* Read inputs and convert from raw (×0.01) to physical units *)
current_x := DINT_TO_REAL(D11) / 100.0;
current_z := DINT_TO_REAL(D13) / 100.0;
current_heading := DINT_TO_REAL(D15) / 100.0;
speed_x := DINT_TO_REAL(D12) / 100.0;
speed_heading := DINT_TO_REAL(D16) / 100.0;
target := DINT_TO_REAL(D10) / 100.0;
error := target - current_x;

CASE state OF
    0: (* STATE_IDLE - wait for request *)
        IF X10 THEN
            state := 1;
        END_IF;
        left_cmd := 0.0;
        right_cmd := 0.0;

    1: (* STATE_DRIVING *)
        (* Forward velocity: proportional with brake zone for smooth stop *)
        forward_raw := error * 0.35;
        IF forward_raw < 0.0 THEN
            forward_raw := 0.0;
        END_IF;
        IF forward_raw > 100.0 THEN
            forward_raw := 100.0;
        END_IF;
        
        (* Brake zone: quadratic reduction near target *)
        IF error < 25.0 THEN
            forward_raw := MIN(forward_raw, 8.75 * (error / 25.0) * (error / 25.0));
        END_IF;
        forward := forward_raw;
        
        (* Heading correction to maintain straight travel *)
        heading_err_deg := current_heading;
        heading_err_rad := heading_err_deg * 0.0174533;
        heading_correction := heading_err_rad * forward * 0.5;
        IF heading_correction > 15.0 THEN
            heading_correction := 15.0;
        ELSIF heading_correction < -15.0 THEN
            heading_correction := -15.0;
        END_IF;
        
        (* Z correction to stay centered *)
        z_correction := current_z * 0.3;
        IF z_correction > 8.0 THEN
            z_correction := 8.0;
        ELSIF z_correction < -8.0 THEN
            z_correction := -8.0;
        END_IF;
        
        (* Differential drive: left slows on positive heading error, right speeds up *)
        left_cmd := forward - heading_correction - z_correction;
        right_cmd := forward + heading_correction - z_correction;
        
        (* Clamp wheel speeds to valid range *)
        IF left_cmd < 0.0 THEN
            left_cmd := 0.0;
        ELSIF left_cmd > 200.0 THEN
            left_cmd := 200.0;
        END_IF;
        
        IF right_cmd < 0.0 THEN
            right_cmd := 0.0;
        ELSIF right_cmd > 200.0 THEN
            right_cmd := 200.0;
        END_IF;
        
        (* Acceleration limiting: max 30 mm/s change per scan (3000 mm/s²) *)
        IF (left_cmd - left_cmd_prev) > 30.0 THEN
            left_cmd := left_cmd_prev + 30.0;
        ELSIF (left_cmd - left_cmd_prev) < -30.0 THEN
            left_cmd := left_cmd_prev - 30.0;
        END_IF;
        
        IF (right_cmd - right_cmd_prev) > 30.0 THEN
            right_cmd := right_cmd_prev + 30.0;
        ELSIF (right_cmd - right_cmd_prev) < -30.0 THEN
            right_cmd := right_cmd_prev - 30.0;
        END_IF;
        
        left_cmd_prev := left_cmd;
        right_cmd_prev := right_cmd;
        
        (* Convert to raw output values (×100) *)
        d20_raw := DINT(left_cmd * 100.0);
        d21_raw := DINT(right_cmd * 100.0);

    2: (* STATE_COMPLETE - maintain outputs, wait for observation *)
        left_cmd := 0.0;
        right_cmd := 0.0;
        d20_raw := 0;
        d21_raw := 0;
END_CASE;

(* Apply output commands *)
D20 := d20_raw;
D21 := d21_raw;

(* Completion check: all conditions must be met simultaneously *)
done := (ABS(error) <= 1.0) 
    AND (ABS(current_heading) <= 0.3) 
    AND (ABS(current_z) <= 2.0) 
    AND (ABS(speed_x) <= 2.0) 
    AND (ABS(speed_heading) <= 1.0);

IF done THEN
    stability_timer(IN := TRUE, PT := T#30ms);
    IF stability_timer.Q THEN
        state := 2;
        Y2 := TRUE;
        observation_timer(IN := TRUE, PT := T#100ms);
    END_IF;
ELSE
    stability_timer(IN := FALSE);
    IF state <> 2 THEN
        Y2 := FALSE;
    END_IF;
END_IF;

(* Observation window - keep Y2 TRUE for 100ms *)
IF state = 2 THEN
    observation_timer(IN := TRUE, PT := T#100ms);
END_IF;

END_PROGRAM