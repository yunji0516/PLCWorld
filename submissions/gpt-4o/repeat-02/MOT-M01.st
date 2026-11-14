PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    request_accepted : BOOL := FALSE;
    a_raised : BOOL := FALSE;
    b_moved : BOOL := FALSE;
    a_moved : BOOL := FALSE;
    move_completed : BOOL := FALSE;
    timer : TON;
    hold_timer : TON;
END_VAR

(* Implement the control logic here. *)

(* Accept request *)
IF NOT request_accepted AND X10 THEN
    request_accepted := TRUE;
    a_raised := FALSE;
    b_moved := FALSE;
    a_moved := FALSE;
    move_completed := FALSE;
END_IF

(* Lift Head A for clearance *)
IF request_accepted AND NOT a_raised THEN
    D22 := 40000; // Raise A by 400 mm (scaled by 0.01)
    Y22 := TRUE;
    
    IF D16 >= 40000 THEN
        a_raised := TRUE;
        Y22 := FALSE; // Stop A elevation command
    END_IF
END_IF

(* Move Head B to target A position *)
IF a_raised AND NOT b_moved THEN
    D21 := D10; // Move B to A initial position
    Y21 := TRUE;
    
    IF ABS(D14 - D10) <= 20 THEN // Check if within tolerance, considering scale
        b_moved := TRUE;
        Y21 := FALSE; // Stop B position command
    END_IF
END_IF

(* Move Head A to target B position after B *)
IF b_moved AND NOT a_moved THEN
    D20 := D13; // Move A to B initial position
    Y20 := TRUE;
    
    IF ABS(D11 - D13) <= 20 THEN // Check if within tolerance, considering scale
        a_moved := TRUE;
        Y20 := FALSE; // Stop A position command
    END_IF
END_IF

(* Lower Head A to working height and check completion *)
IF a_moved AND NOT move_completed THEN
    D22 := 0; // Lower A to working height
    Y22 := TRUE;

    IF D16 <= 0 THEN
        move_completed := TRUE;
        Y22 := FALSE; // Stop A elevation command

        (* Engage completion timer *)
        timer(IN := TRUE, PT := T#100ms);
    END_IF
END_IF

(* Check and signal task completion *)
IF move_completed THEN
    IF timer.Q THEN
        Y2 := TRUE; // Signal task completion
        
        (* Hold the completion signal *)
        hold_timer(IN := TRUE, PT := T#100ms);
        
        IF hold_timer.Q THEN
            Y2 := FALSE;
            request_accepted := FALSE; // Reset for the next request
        END_IF
    END_IF
END_IF

END_PROGRAM