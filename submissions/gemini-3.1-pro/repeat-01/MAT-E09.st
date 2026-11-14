PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1:
        Y2 := FALSE;
        Y20 := TRUE;  (* Command valve to open *)
        Y21 := FALSE;
        IF X20 THEN   (* Wait until valve is fully open *)
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y21 := TRUE;  (* Start pump since valve is fully open *)
        IF D20 >= D10 THEN
            Y21 := FALSE; (* Stop pump immediately when target is reached *)
            Y20 := FALSE; (* Command valve to close *)
            state := 3;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X21 THEN   (* Wait until valve is fully closed *)
            state := 4;
        END_IF;

    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;   (* Assert completion claim and hold *)
END_CASE;

END_PROGRAM