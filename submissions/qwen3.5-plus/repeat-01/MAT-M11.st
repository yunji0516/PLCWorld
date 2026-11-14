PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;
    
    (* Internal variables *)
    openCmd     : BOOL := FALSE;
    closeCmd    : BOOL := FALSE;
    insertCmd   : BOOL := FALSE;
    retractCmd  : BOOL := FALSE;
    leftVacuum  : BOOL := FALSE;
    rightVacuum : BOOL := FALSE;
    done        : BOOL := FALSE;
    requestAccepted : BOOL := FALSE;
    reqD10      : INT := 0;
    
    edge : R_TRIG;
    
    TYPE StateType : (STATE_IDLE, STATE_GRIP, STATE_OPEN, STATE_INSERT, STATE_RETRACT, STATE_RELEASE, STATE_DONE); END_TYPE
    state : StateType := STATE_IDLE;
END_VAR

// Rising edge detection for start request (X10 is read-only input)
edge(CLK := X10);

// Main state machine
IF NOT requestAccepted THEN
    // Wait for rising edge on X10 before commanding any actuator
    IF edge.Q THEN
        requestAccepted := TRUE;
        reqD10 := D10;
        state := STATE_GRIP;
        leftVacuum := TRUE;
        rightVacuum := TRUE;
    END_IF;
    
ELSIF state = STATE_IDLE THEN
    // All outputs remain FALSE
    
ELSIF state = STATE_GRIP THEN
    // Both vacuums commanded; wait for both sides to be held
    IF X20 AND X21 THEN
        state := STATE_OPEN;
        openCmd := TRUE;
    END_IF;
    
ELSIF state = STATE_OPEN THEN
    // Opening axis commanded open; vacuums held to enable opening
    IF X22 THEN
        state := STATE_INSERT;
    END_IF;
    
ELSIF state = STATE_INSERT THEN
    // Insert content; vacuums held to maintain opening >= 150mm
    // Opening axis stays open (openCmd remains TRUE)
    insertCmd := TRUE;
    
    IF X25 THEN
        insertCmd := FALSE;
        state := STATE_RETRACT;
        retractCmd := TRUE;
    END_IF;
    
ELSIF state = STATE_RETRACT THEN
    // Retract tool; vacuums held until tool clears entrance at -200mm
    // Tool front = -770 + 900*slide, entrance = -200
    // Tool clears when -770 + 900*slide <= -200, i.e. slide <= 0.633 -> D21 <= 633
    retractCmd := TRUE;
    
    IF D21 < 633 THEN
        retractCmd := FALSE;
        state := STATE_RELEASE;
    END_IF;
    
ELSIF state = STATE_RELEASE THEN
    // Release vacuums once tool is clear of entrance
    leftVacuum := FALSE;
    rightVacuum := FALSE;
    // openCmd stays TRUE (axis mechanically at full open, no command = holds position)
    
    IF X26 THEN
        state := STATE_DONE;
    END_IF;
    
ELSIF state = STATE_DONE THEN
    // All actuator outputs OFF, completion asserted and maintained
    done := TRUE;
END_IF;

// Output assignments
Y22 := openCmd;
Y23 := closeCmd;
Y24 := insertCmd;
Y25 := retractCmd;
Y20 := leftVacuum;
Y21 := rightVacuum;
Y2 := done;

END_PROGRAM