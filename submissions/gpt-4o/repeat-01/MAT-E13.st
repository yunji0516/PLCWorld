PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    start_edge : R_TRIG;
    timer : TON;
    state : INT := 0;
    product_key : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* Initial state, wait for Start request *)
        IF start_edge.Q THEN
            IF X20 THEN (* Confirm module is at home before proceeding *)
                product_key := D20; (* Capture the current product key *)
                IF product_key <> 0 THEN
                    IF product_key = D10 THEN
                        Y20 := TRUE; (* Select Take if keys match *)
                    ELSE
                        Y21 := TRUE; (* Select Skip if keys do not match *)
                    END_IF;
                    state := 1; (* Proceed to move product *)
                END_IF;
            END_IF;
        END_IF;

    1: (* Move product to destination *)
        timer(IN := TRUE, PT := T#500ms);
        IF timer.Q THEN
            Y20 := FALSE;
            Y21 := FALSE;
            timer(IN := FALSE); (* Reset timer *)
            state := 2; (* Settle to evaluate destination *)
        END_IF;

    2: (* Evaluate if product has reached the destination *)
        IF X21 THEN
            Y2 := TRUE; (* Claim completion at placement *)
            state := 3; 
        ELSIF X20 THEN
            state := 4; (* Move back to home if not placed correctly *)
        END_IF;

    3: (* Hold result for stability period *)
        timer(IN := TRUE, PT := T#500ms);
        IF timer.Q THEN
            timer(IN := FALSE); (* Reset timer *)
            state := 4;
        END_IF;

    4: (* Return module to home *)
        IF NOT (Y20 OR Y21) THEN
            IF X20 THEN
                Y2 := FALSE; (* Reset completion claim *)
                state := 0;
            END_IF;
        END_IF;
        
    ELSE
        state := 0; (* Default to initial state *)
END_CASE;

END_PROGRAM