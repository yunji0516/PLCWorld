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
    
    // State machine
    state : INT := 0;
    
    // Latched parameters at request
    latched_ratio : DINT := 0;
    latched_span : DINT := 0;
    latched_park : DINT := 0;
    
    // Origin positions captured at gear-in rising edge
    U_origin : DINT := 0;
    S_origin : DINT := 0;
    
    // Edge detection
    req_trig : R_TRIG;
    
    // Timers
    in_gear_timer : TON;
    arrival_timer : TON;
    y2_hold_timer : TON;
    
    // Real arithmetic intermediates
    delta_U_real : REAL;
    ratio_real : REAL;
    delta_S_real : REAL;
    S_target_calc : DINT;
END_VAR

// Detect rising edge of task request
req_trig(CLK := X10);

// Main state machine
CASE state OF
    0: // WAIT_REQUEST — idle, ensure outputs are clean
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2  := FALSE;
        IF req_trig.Q THEN
            latched_ratio := D15;
            latched_span  := D14;
            latched_park  := D13;
            state := 1;
        END_IF;

    1: // ENGAGE — issue ratio, fire gear-in edge, capture origins
        D20 := latched_ratio;
        Y20 := TRUE;
        U_origin := D10;
        S_origin := D11;
        state := 2;

    2: // SYNCED_CONTROL — track slave to master at locked ratio
        delta_U_real  := REAL(D10 - U_origin);
        ratio_real    := REAL(latched_ratio);
        delta_S_real  := delta_U_real * ratio_real / 1000.0;
        S_target_calc := S_origin + DINT(ROUND(delta_S_real));
        D21 := S_target_calc;

        // Confirm synchronization is established (X11 stable 30 ms)
        in_gear_timer(IN := X11, PT := T#30ms);
        IF in_gear_timer.Q THEN
            state := 3;
        END_IF;

    3: // WAIT_SPAN — maintain sync target, wait for reference axis rotation
        delta_U_real  := REAL(D10 - U_origin);
        ratio_real    := REAL(latched_ratio);
        delta_S_real  := delta_U_real * ratio_real / 1000.0;
        S_target_calc := S_origin + DINT(ROUND(delta_S_real));
        D21 := S_target_calc;

        IF (D10 - U_origin) >= latched_span THEN
            state := 4;
        END_IF;

    4: // DISENGAGE — fire gear-out edge, zero ratio, drop gear-in
        Y21 := TRUE;
        D20 := 0;
        Y20 := FALSE;
        state := 5;

    5: // INDEPENDENT_PARK — position slave to park angle
        D21 := latched_park;
        Y22 := TRUE;

        // Arrival check: position ±0.20 deg (≤20 in ×0.01), speed ±1 deg/s (≤100 in ×0.01 deg/s)
        IF ABS(D11 - latched_park) <= 20 AND ABS(D12) <= 100 THEN
            arrival_timer(IN := TRUE, PT := T#30ms);
            IF arrival_timer.Q THEN
                state := 6;
            END_IF;
        ELSE
            arrival_timer(IN := FALSE);
        END_IF;

    6: // COMPLETION_HOLD — assert completion, retain 100 ms
        Y2 := TRUE;
        y2_hold_timer(IN := TRUE, PT := T#100ms);
        IF y2_hold_timer.Q THEN
            state := 7;
        END_IF;

    7: // DONE — retain Y2 indefinitely
        Y2 := TRUE;

END_CASE;

END_PROGRAM