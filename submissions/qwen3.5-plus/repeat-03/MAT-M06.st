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
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    target : INT;
    edge_X10 : R_TRIG;
END_VAR

CASE state OF
0: // IDLE - wait for rising edge on X10, then capture request
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y2 := FALSE;
    edge_X10(CLK := X10);
    IF edge_X10.Q THEN
        target := D10;
        state := 1;
    END_IF;

1: // MOVING_DOWN - nozzle travels to lower receiving position
    Y20 := TRUE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y2 := FALSE;
    IF X21 THEN
        Y20 := FALSE;
        state := 2;
    END_IF;

2: // OPEN_VALVE - command valve open, wait for full open feedback
    Y20 := FALSE; Y21 := FALSE; Y22 := TRUE; Y23 := FALSE; Y2 := FALSE;
    IF X22 THEN
        state := 3;
    END_IF;

3: // PUMPING - pump liquid until received volume reaches target
    Y20 := FALSE; Y21 := FALSE; Y22 := TRUE; Y23 := TRUE; Y2 := FALSE;
    IF D20 >= target THEN
        Y23 := FALSE;
        state := 4;
    END_IF;

4: // CLOSE_VALVE - pump stopped, close valve and wait for closed feedback
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y2 := FALSE;
    IF X23 THEN
        state := 5;
    END_IF;

5: // MOVING_UP - nozzle returns to upper position
    Y20 := FALSE; Y21 := TRUE; Y22 := FALSE; Y23 := FALSE; Y2 := FALSE;
    IF X20 THEN
        Y21 := FALSE;
        state := 6;
    END_IF;

6: // COMPLETE - all terminal conditions met, claim completion
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y2 := TRUE;
END_CASE;

END_PROGRAM