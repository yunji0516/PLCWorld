PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
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
    D20 : INT;
    D21 : INT;
    D22 : INT;
    
    start_edge : R_TRIG;
    
    target : INT;
    phase : INT;
    
    buffer_thresh : INT;
    tol : INT := 3;
END_VAR

start_edge(CLK := X10);

(* Clear all actuator outputs each scan *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE phase OF
    0: (* Wait for start request edge *)
        IF start_edge.Q THEN
            target := D10;
            buffer_thresh := target + 83;
            phase := 1;
        END_IF;
        
    1: (* Unwind buffer if below safe threshold *)
        IF D20 >= buffer_thresh THEN
            phase := 2;
        ELSE
            IF D20 < 900 THEN
                Y26 := TRUE;
            ELSE
                (* Upper limit reached, proceed anyway *)
                phase := 2;
            END_IF;
        END_IF;
        
    2: (* Forward to extract web - requires grip closed *)
        IF X22 THEN
            Y20 := TRUE;
        END_IF;
        
        IF D21 >= target - tol THEN
            phase := 3;
        END_IF;
        
    3: (* Wait for carriage to stop *)
        IF X21 THEN
            phase := 4;
        END_IF;
        
    4: (* Close receiver - only at rest and within tolerance *)
        IF X21 AND (D21 >= target - tol) AND (D21 <= target + tol) THEN
            Y24 := TRUE;
        END_IF;
        
        IF X24 THEN
            phase := 5;
        END_IF;
        
    5: (* Open feed grip - receiver now holds web *)
        Y23 := TRUE;
        
        IF X23 THEN
            phase := 6;
        END_IF;
        
    6: (* Reverse to home - requires grip open *)
        IF X23 THEN
            Y21 := TRUE;
        END_IF;
        
        IF X20 AND X21 THEN
            phase := 7;
        END_IF;
        
    7: (* Verify completion and claim *)
        IF X24 AND X23 AND X20 AND X21 AND (D21 >= target - tol) AND (D21 <= target + tol) THEN
            Y2 := TRUE;
        END_IF;
        
END_CASE;

END_PROGRAM