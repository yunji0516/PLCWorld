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
    delivery_target : INT;
    buffer_target : INT;
    state : INT;
END_VAR

(* Update edge detector every scan *)
start_edge(CLK := X10);

(* Accept request on rising edge of start *)
IF state = 0 AND start_edge.Q THEN
    delivery_target := D10;
    buffer_target := D10 + 200;
    
    (* Check if unwinding is needed before delivery *)
    IF D20 < buffer_target THEN
        state := 1;
    ELSE
        state := 2;
    END_IF;
END_IF;

CASE state OF
0:
    (* Wait for start - no actuator commands *)
    ;

1:
    (* Unwind: close grip, start unwind until buffer sufficient *)
    Y22 := TRUE;   (* grip close *)
    Y26 := TRUE;   (* unwind *)
    
    IF D20 >= buffer_target THEN
        Y26 := FALSE;
        state := 2;
    END_IF;

2:
    (* Delivery: move forward with grip closed *)
    Y20 := TRUE;   (* forward *)
    Y22 := TRUE;   (* grip close *)
    
    IF (D21 >= delivery_target - 3) AND (D21 <= delivery_target + 3) THEN
        (* Delivery target reached *)
        Y20 := FALSE;
        state := 3;
    ELSIF D20 < 80 THEN
        (* Buffer low - pause delivery and unwind more *)
        Y20 := FALSE;
        state := 1;
    END_IF;

3:
    (* Carriage stopped, close receiver *)
    Y22 := TRUE;   (* grip still closed holding web *)
    Y24 := TRUE;   (* receiver close *)
    
    IF X24 THEN
        (* Receiver fully closed - web now held by receiver *)
        state := 4;
    END_IF;

4:
    (* Open feed grip to release web to receiver *)
    Y22 := FALSE;  (* grip open command *)
    Y23 := TRUE;   (* grip open *)
    
    IF X23 THEN
        (* Grip fully open - web solely in receiver custody *)
        state := 5;
    END_IF;

5:
    (* Return carriage to home with grip open *)
    Y21 := TRUE;   (* reverse *)
    
    IF X20 THEN
        (* At home *)
        Y21 := FALSE;
        state := 6;
    END_IF;

6:
    (* Complete - maintain receiver closed as required *)
    Y2 := TRUE;
END_CASE;

END_PROGRAM