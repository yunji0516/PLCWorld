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

    (* Internal variables *)
    startRequestProcessed : BOOL := FALSE;
    selectedSlot : INT := -1;
    edgeX10 : R_TRIG;
    initialPositionSet : BOOL := FALSE;
    scanning : BOOL := FALSE;
    insertionStep : INT := 0;
    alignedSlot : INT := 0;
END_VAR

(* Rising edge detection for start request *)
edgeX10(CLK := X10);

(* Main control logic *)
IF NOT startRequestProcessed AND edgeX10.Q THEN
    IF D10 = 1 THEN
        startRequestProcessed := TRUE;
        scanning := TRUE;
    END_IF
END_IF

IF scanning THEN
    IF initialPositionSet THEN
        (* Begin scanning for a vacant slot *)
        IF NOT X25 THEN
            IF D20 < 480 THEN
                Y21 := TRUE; (* Move down towards 480 mm *)
                Y20 := FALSE;
            ELSE
                Y21 := FALSE;
            END_IF
        ELSE
            IF NOT X24 THEN
                (* A vacant slot is found *)
                alignedSlot := D20 / 160;
                scanning := FALSE;
                insertionStep := 1;
            ELSE
                (* Move down to the next slot *)
                Y21 := TRUE;
                Y20 := FALSE;
            END_IF
        END_IF
    ELSE
        (* Initial set up, check pusher is retracted *)
        IF X22 THEN
            initialPositionSet := TRUE;
        ELSE
            (* Make sure the pusher is retracted *)
            Y23 := TRUE;
        END_IF
    END_IF
END_IF

(* Handle the insertion process *)
CASE insertionStep OF
    0: (* Not inserting *)
        Y23 := TRUE; (* Ensure pusher is retracted *)
    1: (* Move to insertion position *)
        IF X25 THEN
            Y23 := FALSE;
            Y22 := TRUE;
            insertionStep := 2;
        END_IF
    2: (* Insert plate *)
        IF X23 THEN
            (* Plate is fully inserted *)
            Y22 := FALSE;
            Y23 := TRUE;
            insertionStep := 3;
        END_IF
    3: (* Retract and verify *)
        IF X22 AND X26 THEN
            (* Plate is in place, pusher retracted *)
            insertionStep := 0;
            Y2 := TRUE; (* Completion claim *)
        END_IF
END_CASE

(* Ensure outputs are not opposing *)
IF Y21 THEN
    Y20 := FALSE;
END_IF

IF Y22 THEN
    Y23 := FALSE;
END_IF

END_PROGRAM