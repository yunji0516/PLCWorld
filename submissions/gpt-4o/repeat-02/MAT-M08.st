PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := TRUE; // Ensure pusher starts retracted
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    start_rising_edge : R_TRIG;
    move_step : INT := 0;
    target_position : INT;
    slots_checked : ARRAY[0..3] OF BOOL := [FALSE, FALSE, FALSE, FALSE];
END_VAR

(* Implement the control logic here. *)

start_rising_edge(CLK := X10);

IF start_rising_edge.Q AND D10 = 1 THEN
    move_step := 1;
END_IF

CASE move_step OF
    1: (* Move down to find first vacant slot. *)
        IF X22 AND NOT Y23 THEN
            Y23 := TRUE; (* Ensure pusher retracted before moving. *)
        END_IF

        IF NOT X24 THEN
            target_position := (D20 + 80) / 160 * 160; (* Calculate the next slot position *)
            IF target_position > 480 THEN
                target_position := 0; (* Wrap around to first slot if exceed *)
            END_IF
            Y21 := TRUE; (* Command rack down. *)
            move_step := 2;
        END_IF
        
    2: (* Check alignment and vacancy. *)
        Y21 := FALSE; (* Stop any rack movement. *)
        IF X25 THEN (* Slot aligned *)
            slots_checked[D20 / 160] := TRUE;
            IF NOT X24 THEN
                move_step := 3; (* Slot is vacant; ready to insert the plate. *)
            ELSE
                move_step := 1; (* Find next vacant slot. *)
            END_IF
        END_IF

    3: (* Insert the plate *)
        IF X22 AND NOT X23 THEN
            Y22 := TRUE; (* Command push operation. *)
        ELSIF X23 THEN
            Y22 := FALSE; (* Stop pushing operation when fully extended. *)
            move_step := 4; 
        END_IF

    4: (* Check receipt and retract. *)
        IF X26 THEN
            Y23 := TRUE; (* Command retract operation. *)
            IF X22 THEN
                move_step := 5; 
            END_IF
        END_IF

    5: (* Completion and output off. *)
        Y2 := TRUE; (* Claim completion. *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        move_step := 6; 

    6: (* Maintain completion after storing. *)
        Y2 := TRUE; (* Maintain completion claim. *)

    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
END_CASE

END_PROGRAM