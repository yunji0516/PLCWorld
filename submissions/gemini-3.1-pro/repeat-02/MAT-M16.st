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
    D20 : INT;
    D21 : INT;
    D22 : INT;

    start_edge : R_TRIG;
    state : INT := 0;
    target_length : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* Wait for Start Request *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        
        IF start_edge.Q THEN
            target_length := D10;
            state := 1;
        END_IF;

    1: (* Feeding and Active Steering *)
        Y22 := TRUE;
        
        (* Steer to keep the actual edge near 0, safely within the +/- 12 mm corridor *)
        IF D20 > 0 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < 0 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;

        (* Check if the next 10ms feed scan will exceed or optimally meet the target length.
           The increment is 4 mm/scan, so target_length - 1 bounds final error to [-1, +2] mm. *)
        IF D21 >= target_length - 1 THEN
            Y22 := FALSE;
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        END_IF;

    2: (* Halt Feed/Steering and Engage Clamp *)
        Y23 := TRUE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        
        (* Wait for physical clamp secured feedback *)
        IF X20 THEN
            state := 3;
        END_IF;

    3: (* Completion Claim and Terminal Maintenance *)
        Y2 := TRUE;
        Y23 := TRUE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM