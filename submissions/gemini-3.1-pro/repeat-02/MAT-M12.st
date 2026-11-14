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
    Y27 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    edge_X10 : R_TRIG;
END_VAR

edge_X10(CLK := X10);

CASE state OF
    0:
        IF edge_X10.Q AND D10 = 1 THEN
            state := 1;
        END_IF;
        
    1: (* Turn ON scrap vacuum to acquire scraps *)
        IF X21 THEN
            state := 2;
        END_IF;
        
    2: (* Raise the scrap carrier out of the way *)
        IF X27 THEN
            state := 3;
        END_IF;
        
    3: (* Move the product head forward to the source *)
        IF X25 THEN
            state := 4;
        END_IF;
        
    4: (* Lower the product head to the product *)
        IF X23 THEN
            state := 5;
        END_IF;
        
    5: (* Turn ON product vacuum to acquire product *)
        IF X20 THEN
            state := 6;
        END_IF;
        
    6: (* Raise the product head *)
        IF X22 THEN
            state := 7;
        END_IF;
        
    7: (* Move the product head back to the receiver/home *)
        IF X24 THEN
            state := 8;
        END_IF;
        
    8: (* Lower the product head at the receiver *)
        IF X23 THEN
            state := 9;
        END_IF;
        
    9: (* Turn OFF product vacuum to release product *)
        IF NOT X20 AND X26 THEN
            state := 10;
        END_IF;
        
    10: (* Raise the empty product head back to home upper position *)
        IF X22 THEN
            state := 11;
        END_IF;
        
    11: (* Sequence complete; maintain end state *)
        ;
END_CASE;

(* Actuator logic mapping *)
Y2  := (state = 11);
Y20 := (state >= 5 AND state <= 8);
Y21 := (state >= 1);
Y22 := (state = 6) OR (state = 10);
Y23 := (state = 4) OR (state = 8);
Y24 := (state = 3);
Y25 := (state = 7);
Y26 := (state = 2);
Y27 := FALSE;

END_PROGRAM