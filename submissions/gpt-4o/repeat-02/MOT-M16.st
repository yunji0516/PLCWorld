PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    request_sent : BOOL := FALSE;
    module_count_previous : DINT := 0;
    request_start_time : TIME := T#0ms;
    confirm_start_time : TIME := T#0ms;
    confirm_sent : BOOL := FALSE;

    (* Constants *)
    a_command_limit : DINT := 30000; // 300 mm * 100
    b_command_limit : DINT := 12000; // 120 mm * 100
    a_target_position : DINT;
    b_target_position : DINT;
END_VAR

(* Set target position *)
a_target_position := D101;
b_target_position := D102;

(* State Machine *)
CASE state OF

    0: (* Wait for start request X0 *)
        IF X0 THEN
            Y20 := FALSE;  // Disable A
            Y21 := FALSE;  // Disable B
            D20 := a_target_position;
            D21 := 1000;  // 100% rate
            D24 := b_target_position;
            D25 := 1000;  // 100% rate
            state := 1;
        END_IF

    1: (* Move to target position and wait to settle *)
        Y20 := TRUE;  // Enable A
        Y21 := TRUE;  // Enable B

        IF (ABS(D10 - a_target_position) <= 20) AND (ABS(D12 - b_target_position) <= 20) AND
           (ABS(D11) <= 100) AND (ABS(D13) <= 100) AND NOT X34 THEN
            Y30 := TRUE;  // Send module request
            request_sent := TRUE;
            request_start_time := TIME();  // Capture the time of request
            state := 2;
        ELSE
            Y30 := FALSE;
        END_IF

    2: (* Wait for module to finish processing *)
        IF request_sent AND X35 THEN
            Y30 := FALSE;  // Reset request
            Y21 := TRUE;   // Keep B enabled to retract
            D24 := 0;      // Retract B to 0
            state := 3;
        ELSIF NOT request_sent AND NOT X34 THEN
            Y30 := TRUE;  // Re-trigger if the request was not processed
        ELSE
            Y30 := FALSE;
        END_IF
    
    3: (* Confirmation and completion *)
        IF (D12 = 0) AND (ABS(D13) <= 100) THEN
            IF NOT confirm_sent THEN
                Y2 := TRUE;  // Send completion signal
                confirm_start_time := TIME();
                confirm_sent := TRUE;
            ELSIF TIME() - confirm_start_time >= T#100ms THEN
                Y2 := FALSE;  // Maintain for 100 ms
                confirm_sent := FALSE;
                state := 4;  // Go to idle state
            END_IF
        END_IF

    4: (* Idle state waiting for next start request *)
        IF NOT X0 THEN
            state := 0;  // Return to initial state to wait for a new start command
        END_IF

END_CASE

END_PROGRAM