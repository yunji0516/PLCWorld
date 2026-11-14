PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    
    start_edge : R_TRIG;
    state : INT;
    y20_cmd : BOOL;
    y21_cmd : BOOL;
    y2_cmd : BOOL;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* Idle - wait for start rising edge *)
        IF start_edge.Q AND D10 = 1 THEN
            state := 1;
            y20_cmd := TRUE;
            y21_cmd := TRUE;
        END_IF;
        
    1: (* Advance both alignment fingers toward datum faces *)
        y20_cmd := TRUE;
        y21_cmd := TRUE;
        (* When both datum sensors trigger, alignment is achieved *)
        IF X20 AND X21 THEN
            state := 2;
            y20_cmd := FALSE;
            y21_cmd := FALSE;
        END_IF;
        
    2: (* Retract fingers - outputs OFF, wait for fingers_clear *)
        y20_cmd := FALSE;
        y21_cmd := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;
        
    3: (* Completion - hold Y2 for remainder of evaluation window *)
        y20_cmd := FALSE;
        y21_cmd := FALSE;
        y2_cmd := TRUE;
END_CASE;

Y20 := y20_cmd;
Y21 := y21_cmd;
Y2 := y2_cmd;

END_PROGRAM