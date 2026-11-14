PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    
    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q AND D10 = 1 THEN
            state := 1;
        END_IF;
        
    1:
        (* Raise the bridge to provide continuous support and satisfy the span constraint *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X20 THEN
            state := 2;
        END_IF;
        
    2:
        (* Push the board while maintaining the raised bridge *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        (* Proceed once the board center is at least +699 mm, ensuring it is fully on the receiving support *)
        IF D20 >= 699 THEN
            state := 3;
        END_IF;
        
    3:
        (* Retract the pusher and lower the bridge simultaneously *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X21 AND X22 THEN
            state := 4;
        END_IF;
        
    4:
        (* Ensure all outputs are OFF and assert completion claim *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM