PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
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
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    D21 : INT;
    
    State : INT := 0;
    X10_prev : BOOL := FALSE;
    initial_D21 : INT := 0;
    target_head_angle : INT := 0;
    diff_int : INT := 0;
    rot_done : BOOL := FALSE;
    travel_done : BOOL := FALSE;
END_VAR

CASE State OF
    0:
        (* Wait for Start edge while plate is at source and valid *)
        IF X10 AND NOT X10_prev AND X26 AND X31 THEN
            initial_D21 := D21;
            
            (* Calculate the required head rotation based on shortest plate angle difference *)
            diff_int := D10 - D20;
            WHILE diff_int > 180 DO
                diff_int := diff_int - 360;
            END_WHILE;
            WHILE diff_int < -180 DO
                diff_int := diff_int + 360;
            END_WHILE;
            
            target_head_angle := initial_D21 + diff_int;
            State := 1;
        END_IF;
        
    1: (* Go down to acquire plate *)
        IF X22 THEN 
            State := 2; 
        END_IF;
        
    2: (* Wait for vertical axis to fully stop at the low position *)
        IF X28 THEN 
            State := 3; 
        END_IF;
        
    3: (* Grip the plate *)
        IF X24 THEN 
            State := 4; 
        END_IF;
        
    4: (* Go up with plate *)
        IF X23 THEN 
            State := 5; 
        END_IF;
        
    5: (* Wait for vertical axis to fully stop at the upper position before horizontal/rotation moves *)
        IF X28 THEN
            rot_done := FALSE;
            travel_done := FALSE;
            State := 6;
        END_IF;
        
    6: (* Concurrently travel to target and rotate to target_head_angle *)
        IF NOT travel_done THEN
            IF X21 THEN 
                travel_done := TRUE; 
            END_IF;
        END_IF;
        
        IF NOT rot_done THEN
            IF target_head_angle > initial_D21 THEN
                IF D21 >= target_head_angle THEN 
                    rot_done := TRUE; 
                END_IF;
            ELSIF target_head_angle < initial_D21 THEN
                IF D21 <= target_head_angle THEN 
                    rot_done := TRUE; 
                END_IF;
            ELSE
                rot_done := TRUE;
            END_IF;
        END_IF;
        
        IF travel_done AND rot_done THEN
            State := 7;
        END_IF;
        
    7: (* Wait for all axes to fully stop at target position *)
        IF X28 THEN 
            State := 8; 
        END_IF;
        
    8: (* Go down to receiver *)
        IF X22 THEN 
            State := 9; 
        END_IF;
        
    9: (* Wait for vertical axis to fully stop before releasing *)
        IF X28 THEN 
            State := 10; 
        END_IF;
        
    10: (* Release plate at receiver *)
        IF X25 THEN 
            State := 11; 
        END_IF;
        
    11: (* Go up empty *)
        IF X23 THEN 
            State := 12; 
        END_IF;
        
    12: (* Wait for vertical axis to fully stop at upper position *)
        IF X28 THEN 
            State := 13; 
        END_IF;
        
    13: (* Return empty to source *)
        IF X20 THEN 
            State := 14; 
        END_IF;
        
    14: (* Wait for all axes to fully stop *)
        IF X28 THEN 
            State := 15; 
        END_IF;
        
    15:
        (* Task sequence successfully completed *)
END_CASE;

(* Declarative assignment of all commands based securely on active state *)
Y24 := (State = 1 OR State = 8);
Y20 := (State >= 3 AND State <= 9);
Y23 := (State = 4 OR State = 11);
Y21 := (State = 6 AND NOT travel_done);
Y22 := (State = 13);
Y25 := (State = 6 AND NOT rot_done AND target_head_angle > initial_D21);
Y26 := (State = 6 AND NOT rot_done AND target_head_angle < initial_D21);
Y2  := (State = 15);

(* Retain history *)
X10_prev := X10;

END_PROGRAM