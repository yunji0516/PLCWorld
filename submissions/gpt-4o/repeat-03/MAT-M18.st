PROGRAM Main
VAR
    X0 : BOOL; // Start
    X10 : BOOL; // Feed home
    X11 : BOOL; // Feed stopped
    X12 : BOOL; // Gripped
    X13 : BOOL; // Grip open
    X14 : BOOL; // Stock clamped
    X15 : BOOL; // Blade up
    X16 : BOOL; // Blade down
    X17 : BOOL; // Cut complete
    X18 : BOOL; // Pad up
    X19 : BOOL; // Pad down
    X1A : BOOL; // Pad source
    X1B : BOOL; // Pad receiver
    X1C : BOOL; // Pad held
    X1D : BOOL; // Receiver present
    Y10 : BOOL; // Feed grip
    Y11 : BOOL; // Stock clamp
    Y12 : BOOL; // Feed move
    Y13 : BOOL; // Blade down
    Y14 : BOOL; // Pad down
    Y15 : BOOL; // Pad out
    Y16 : BOOL; // Vacuum
    Y17 : BOOL; // Complete
    D0 : INT; // Requested segment length
    D1 : INT; // Feed mm
    D2 : INT; // Stock edge mm
    D3 : INT; // Received mm
    D200 : INT; // Feed target

    // Internal Variables
    currentState : INT := 0;
    startEdge : R_TRIG;
    feedMoveTimer : TON;
    bladeTimer : TON;
    padTimer : TON;
    vacuumTimer : TON;
    completeTimer : TON;
    scanCounter : INT := 0;
    isSegmentSevered : BOOL := FALSE;
    
END_VAR

// State Constants
CONST
    IDLE : INT := 0;
    PREPARE_FEED : INT := 1;
    MOVE_FEED : INT := 2;
    SEVER_SEGMENT : INT := 3;
    MOVE_PAD : INT := 4;
    RELEASE_SEGMENT : INT := 5;
END_CONST

// R_TRIG for X0 (start) rising edge detection
startEdge(CLK := X0);

// Main State Machine
CASE currentState OF
    IDLE:
        IF startEdge.Q AND X10 THEN // Start and feed home
            Y10 := TRUE; // Engage feed grip
            Y11 := FALSE; // Ensure stock clamp open
            D200 := D0 + 100; // Set target position
            currentState := PREPARE_FEED;
        END_IF
        
    PREPARE_FEED:
        IF X12 THEN // Feed grip confirmed 
            Y12 := TRUE; // Move feed carriage
            feedMoveTimer(IN := TRUE, PT := T#300ms); // Assumed time to place feed
            currentState := MOVE_FEED;
        END_IF
        
    MOVE_FEED:
        IF feedMoveTimer.Q OR X11 THEN // Movement completed
            Y12 := FALSE; // Stop feed move
            currentState := SEVER_SEGMENT;
        END_IF

    SEVER_SEGMENT:
        IF NOT X15 THEN // Ensure blade is up
            Y13 := TRUE; // Lower the blade
            bladeTimer(IN := TRUE, PT := T#650ms); // Blade descent timeout
        END_IF
        
        IF bladeTimer.Q THEN
            IF X16 THEN // Blade down at 97%
                isSegmentSevered := TRUE;
            END_IF
            Y13 := FALSE; // Raise the blade back
            IF isSegmentSevered AND X15 THEN // Blade back up
                Y10 := FALSE; // Open feed grip
                currentState := MOVE_PAD;
            END_IF
        END_IF
        
    MOVE_PAD:
        IF NOT X18 THEN // Ensure pad is up
            Y14 := TRUE; // Lower pad
            padTimer(IN := TRUE, PT := T#500ms); // Lowering pad timeout
        END_IF
        
        IF padTimer.Q THEN
            IF X19 THEN // Pad down
                Y16 := TRUE; // Activate vacuum
                vacuumTimer(IN := TRUE, PT := T#500ms); // Vacuum formation time
                Y15 := TRUE; // Extend pad out
            END_IF
        END_IF

        IF X1B AND X1C AND vacuumTimer.Q THEN // Pad reached receiver, held confirmed
            Y16 := FALSE; // Release vacuum
            currentState := RELEASE_SEGMENT;
        END_IF
    
    RELEASE_SEGMENT:
        IF NOT X1C THEN // Segment released
            Y15 := FALSE; // Retract pad
            Y14 := FALSE; // Lift pad up
            completeTimer(IN := TRUE, PT := T#500ms); // Completion hold time
        END_IF

        IF completeTimer.Q THEN
            IF X10 AND NOT X13 THEN // Feed grip return ensured
                Y17 := TRUE; // Set complete signal
                currentState := IDLE; // Reset state
            END_IF
        END_IF
END_CASE

END_PROGRAM