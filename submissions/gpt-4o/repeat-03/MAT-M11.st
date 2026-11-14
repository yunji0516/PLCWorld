PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;
    start_request_edge : R_TRIG;
    step : INT := 0;
END_VAR

start_request_edge(CLK := X10);

IF start_request_edge.Q THEN
    (* Accept the start request *)
    IF D10 = 1 THEN
        step := 1;
    END_IF;
END_IF;

CASE step OF
    1: (* Initial: Activate vacuum sides and opening if both are not held *)
        IF NOT X20 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
        END_IF;
        
        IF NOT X21 THEN
            Y21 := TRUE;
        ELSE
            Y21 := FALSE;
        END_IF;
        
        IF X20 AND X21 THEN
            Y22 := TRUE;
            Y23 := FALSE;
            step := 2;
        END_IF;
    
    2: (* Wait for the opening feedback to be true *)
        IF X22 THEN
            Y24 := TRUE;  (* Start insertion *)
            Y23 := FALSE; (* Ensure close is off *)
            step := 3;
        END_IF;

    3: (* Inserting content *)
        IF X24 THEN (* Content fully inserted *)
            Y24 := FALSE;
            Y25 := TRUE;  (* Retract the tool *)
            step := 4;
        END_IF;
    
    4: (* Wait until tool retracted (home position) *)
        IF X23 THEN
            Y25 := FALSE; (* Turn off retract *)
            
            (* Release vacuum *)
            Y20 := FALSE;
            Y21 := FALSE;

            (* Check if content is seated *)
            IF X25 THEN
                Y23 := TRUE;  (* Start closing process *)
                step := 5;
            END_IF;
        END_IF;

    5: (* Wait for both vacuums released and axis closed *)
        IF X26 THEN
            Y22 := FALSE;
            Y23 := FALSE;
            
            (* Both vacuums must remain released *)
            Y20 := FALSE;
            Y21 := FALSE;

            (* Validate the terminal result *)
            IF X22 AND X23 AND X25 AND X26 THEN
                Y2 := TRUE;  (* Completion claim *)
                step := 6;   (* Final state to maintain outputs *)
            END_IF;
        END_IF;

    6: (* Maintain the terminal result *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;

    ELSE
        (* Default case to reset all outputs in unsupported steps *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
END_CASE;

END_PROGRAM