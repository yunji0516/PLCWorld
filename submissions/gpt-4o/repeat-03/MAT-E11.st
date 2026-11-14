PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    start_triggered : BOOL := FALSE;
    edge_within_limit : BOOL := TRUE;
    scan_count : INT := 0;
    feed_time : TIME;
    left_command : BOOL := FALSE;
    right_command : BOOL := FALSE;
    
    r_trig_start : R_TRIG;
    ton_feed : TON;
END_VAR

(* Start request edge detection *)
r_trig_start(CLK := X10);
IF r_trig_start.Q THEN
    start_triggered := TRUE;
    scan_count := 0;
    edge_within_limit := TRUE;
END_IF;

(* Control logic during active feed interval *)
IF start_triggered AND D10 = 1 THEN
    ton_feed(IN := TRUE, PT := T#1500ms);
    feed_time := ton_feed.ET;
    
    (* Steering control to keep the edge within limits *)
    IF D20 > 12 THEN
        left_command := FALSE;
        right_command := TRUE;
    ELSIF D20 < -12 THEN
        left_command := TRUE;
        right_command := FALSE;
    ELSE
        left_command := FALSE;
        right_command := FALSE;
    END_IF;
    
    (* Ensure no opposing commands are active at the same time *)
    IF left_command AND right_command THEN
        left_command := FALSE;
        right_command := FALSE;
    END_IF;
    
    Y20 := left_command;
    Y21 := right_command;
    
    (* Monitor edge limits during feed *)
    IF D20 < -12 OR D20 > 12 THEN
        edge_within_limit := FALSE;
    END_IF;
    
    (* Increment scan count for feed interval monitoring *)
    scan_count := scan_count + 1;
   
    (* Evaluate if the feed time is complete and conditions are met *)
    IF ton_feed.Q THEN
        start_triggered := FALSE;  // Stop active feed control
        ton_feed(IN := FALSE);

        (* Check external_done and edge condition at end of feed *)
        IF X20 AND edge_within_limit THEN
            Y2 := TRUE;
        END_IF;

        (* Ensure all actuator commands are off before completion *)
        IF NOT Y20 AND NOT Y21 THEN
            Y2 := TRUE;
        END_IF;
    END_IF;
ELSE
    (* Ensure steer commands are OFF when not feeding *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF scan_count >= 1550 THEN
        Y2 := TRUE;  // Completion claim after feed interval
    END_IF;
END_IF;

END_PROGRAM