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

(* Sample the start request edge *)
start_edge(CLK := X10);

(* 
   Sequence of Operations:
   State 0: Wait for Start.
   State 1: Raise the bridge to provide continuous support and satisfy the 150 mm span limit.
   State 2: Push the board across the raised bridge until the required receiver endpoint is reached.
   State 3: Retract the pusher fully to home.
   State 4: Lower the bridge (the board is now fully supported by the receiver).
   State 5: Claim completion with all actuator outputs off.
*)
CASE state OF
    0:
        IF start_edge.Q THEN
            state := 1;
        END_IF
        
    1:
        IF X20 THEN
            state := 2;
        END_IF
        
    2:
        IF (D20 >= 699) AND X25 THEN
            state := 3;
        END_IF
        
    3:
        IF X22 THEN
            state := 4;
        END_IF
        
    4:
        IF X21 THEN
            state := 5;
        END_IF
END_CASE

(* Combinatorial output assignment to ensure immediate and exclusive actuator control *)
Y2  := (state = 5);
Y20 := (state = 1) OR (state = 2) OR (state = 3);
Y21 := (state = 4);
Y22 := (state = 2);
Y23 := (state = 3);

END_PROGRAM