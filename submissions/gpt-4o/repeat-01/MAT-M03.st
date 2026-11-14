```iec
PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL; (* Command: grip *)
    Y21 : BOOL; (* Command: advance *)
    Y22 : BOOL; (* Command: return *)
    Y23 : BOOL; (* Command: up *)
    Y24 : BOOL; (* Command: down *)
    Y25 : BOOL; (* Command: align x *)
    Y26 : BOOL; (* Command: align z *)
    X20 : BOOL; (* Physical/status feedback: at source *)
    X21 : BOOL; (* Physical/status feedback: at target *)
    X22 : BOOL; (* Physical/status feedback: low *)
    X23 : BOOL; (* Physical/status feedback: high *)
    X24 : BOOL; (* Physical/status feedback: holding *)
    X25 : BOOL; (* Physical/status feedback: released *)
    X26 : BOOL; (* Physical/status feedback: source present *)
    X27 : BOOL; (* Physical/status feedback: receiver present *)
    X28 : BOOL; (* Physical/status feedback: stopped *)
    X29 : BOOL; (* Physical/status feedback: fingers clear *)
    X30 : BOOL; (* Physical/status feedback: z closed *)
    X31 : BOOL; (* Physical/status feedback: datum x *)
    X32 : BOOL; (* Physical/status feedback: datum z *)
    Y2 : BOOL;  (* Completion claim *)

    (* Add internal variables here. *)
    start_triggered : BOOL := FALSE;
    step : INT := 0;
    alignComplete : BOOL := FALSE;
    workpiece_aligned : BOOL := FALSE;
    receiver_reached : BOOL := FALSE;
    trig_X10 : R_TRIG;
    timer : TON;
END_VAR

(* Implement the control logic here. *)

trig_X10(CLK := X10);
IF trig_X10.Q THEN
    IF D10 = 1 THEN
        start_triggered := TRUE;
        step := 0;
    END_IF;
END_IF;

IF start_triggered THEN
    CASE step OF
        0: (* Ensure tool is at source and upper position with fingers clear *)
            IF X20 AND X23 AND X29 THEN
                Y20 := TRUE; (* Close grip on the workpiece *)
                timer(IN := TRUE, PT := T#230ms);
                IF timer.Q THEN
                    timer(IN := FALSE);
                    step := 1;
                END_IF;
            END_IF;
        
        1: (* Move down to pick workpiece *)
            Y23 := FALSE;
            Y24 := TRUE;
            IF X22 THEN (* Wait until low position is reached *)
                Y24 := FALSE;
                step := 2;
            END_IF;
        
        2: (* Align X and Z on source *)
            IF X31 AND X32 THEN
                alignComplete := TRUE;
                workpiece_aligned := TRUE;
                step := 3;
            ELSE
                IF NOT alignComplete THEN
                    Y25 := NOT X31; 
                    Y26 := NOT X32;
                    IF X31 THEN Y25 := FALSE; END_IF;
                    IF X32 THEN Y26 := FALSE; END_IF;
                ELSE
                    Y25 := FALSE;
                    Y26 := FALSE;
                    step := 3;
                END_IF;
            END_IF;
        
        3: (* Move up *)
            IF workpiece_aligned THEN
                Y24 := FALSE;
                Y23 := TRUE;
                IF X23 THEN (* Wait until high position is reached *)
                    step := 4;
                END_IF;
            END_IF;

        4: (* Move to receiver *)
            IF X23 THEN
                Y23 := FALSE;
                Y21 := TRUE;
                IF X21 THEN (* Wait until at target *)
                    Y21 := FALSE;
                    step := 5;
                END_IF;
            END_IF;
        
        5: (* Release workpiece *)
            IF X21 THEN
                Y20 := FALSE;
                IF X25 THEN
                    step := 6;
                END_IF;
            END_IF;

        6: (* Validate final alignment and complete *)
            IF X31 AND X32 THEN
                receiver_reached := TRUE;
            END_IF;
            IF receiver_reached AND X23 THEN
                Y22 := TRUE;  (* Return to source *)
                IF X20 THEN
                    Y22 := FALSE;
                    Y2 := TRUE;  (* Claim completion *)
                    step := 7;
                END_IF;
            END_IF;
        
        7: (* End program while maintaining completion signal *)
            ; (* Do nothing; hold outputs as required. *)
    
    ELSE
        (* Ensure all actuators are off after completing the sequence *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := FALSE;
    END_CASE;
END_IF;

END_PROGRAM
```