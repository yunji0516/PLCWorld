PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    startEdge : R_TRIG;
    inserting : BOOL := FALSE;
    targetSlot : INT := 0;
    slotIndex : INT := 0;
    isAligned : BOOL := FALSE;
    pusherState : BOOL := FALSE;
    insertionStarted : BOOL := FALSE;
END_VAR

(* Initialize edge detection instance *)
startEdge(CLK := X10);

(* Main Logic *)
IF startEdge.Q AND (D10 = 1) THEN
    (* Start only on rising edge of X10 and when D10 equals 1 *)
    inserting := TRUE;
    Y2 := FALSE;      (* Completion signal reset *)
    slotIndex := 0;   (* Start from the first slot *)
END_IF

IF inserting THEN
    IF NOT X22 AND NOT X23 THEN
        (* Only move rack if pusher is retracted *)
        
        (* Calculate the target position for the current slot index *)
        targetSlot := slotIndex * 160;
        
        IF D20 < targetSlot THEN
            Y20 := TRUE;  (* Move rack up *)
            Y21 := FALSE;
        ELSIF D20 > targetSlot THEN
            Y20 := FALSE;
            Y21 := TRUE;  (* Move rack down *)
        ELSE
            Y20 := FALSE;
            Y21 := FALSE; (* Stop movement when aligned *)
            isAligned := TRUE;
        END_IF

        (* Check for alignment and occupancy *)
        IF isAligned AND NOT X24 THEN
            IF X25 THEN
                Y22 := TRUE;  (* Command pusher to insert *)
                insertionStarted := TRUE;
            END_IF
        ELSE
            (* Move to the next slot if current is occupied or unaligned *)
            IF isAligned AND X24 THEN
                slotIndex := slotIndex + 1;
                isAligned := FALSE;
            END_IF
        END_IF

        (* Safety constraints *)
        IF insertionStarted THEN
            pusherState := X23;  (* Read pusher end position *)
            IF pusherState THEN
                Y22 := FALSE;    (* Stop pushing when fully inserted *)
                Y23 := TRUE;     (* Command retraction *)
                insertionStarted := FALSE;
            END_IF
        END_IF
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
    END_IF

    (* Check insertion completion *)
    IF X26 AND NOT X22 AND X22 THEN
        Y2 := TRUE;  (* Indicate task completion *)
        inserting := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;(* Ensure all actuators are off *)
    END_IF
END_IF

END_PROGRAM