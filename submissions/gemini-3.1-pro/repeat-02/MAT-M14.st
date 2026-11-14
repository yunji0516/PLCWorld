PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    X10_prev : BOOL := FALSE;
    start_requested : BOOL := FALSE;
    ready_to_fire : BOOL := FALSE;
    prev_D20 : INT := 0;
END_VAR

(* Capture the rising edge of the start request *)
IF X10 AND NOT X10_prev THEN
    start_requested := TRUE;
END_IF;
X10_prev := X10;

(* Execute the supply and launch sequence *)
CASE state OF
    0:
        (* Wait for start request and verify initial home states *)
        IF start_requested AND X20 AND X24 THEN
            state := 1;
        END_IF;
        
    1:
        (* Supply the product into the launch nest *)
        IF X23 THEN
            state := 2;
        END_IF;
        
    2:
        (* Withdraw the supply finger *)
        IF X24 THEN
            state := 3;
            ready_to_fire := FALSE;
            prev_D20 := D20;
        END_IF;
        
    3:
        (* Coordinate the launch timing *)
        (* The launch pusher takes exactly 1.0 s. Pocket speed is D21 mm/s. *)
        (* We must fire when the pocket is approximately D21 mm away. *)
        
        (* Arm the firing logic if the pocket is sufficiently far away or has just wrapped around *)
        IF D20 > D21 + 20 THEN
            ready_to_fire := TRUE;
        END_IF;
        
        IF D20 > prev_D20 THEN
            ready_to_fire := TRUE;
        END_IF;
        
        (* Fire the launch pusher exactly when the pocket reaches the 1.0 s distance *)
        IF ready_to_fire AND (D20 <= D21) THEN
            state := 4;
        END_IF;
        
        prev_D20 := D20;
        
    4:
        (* Wait for full launch extension *)
        IF X21 THEN
            state := 5;
        END_IF;
        
    5:
        (* Retract the launch pusher to its home position *)
        IF X20 THEN
            state := 6;
        END_IF;
        
    6:
        (* Sequence complete; hold final state *)
        ;
END_CASE;

(* Actuator and completion outputs *)
Y22 := (state = 1);
Y20 := (state = 4);
Y21 := (state = 5);
Y2  := (state = 6);

END_PROGRAM