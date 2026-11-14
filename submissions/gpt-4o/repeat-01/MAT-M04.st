PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
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
    Y2 : BOOL := FALSE;
    D20 : INT;

    start_trigger : R_TRIG;
    task_accepted : BOOL := FALSE;
    current_item_class : INT := -1;
    item_delivered_count : INT := 0;
    operating_state : INT := 0; // 0: Idle, 1: Pick, 2: Move, 3: Drop, 4: Return

END_VAR

start_trigger(CLK := X10);

IF start_trigger.Q AND NOT task_accepted THEN
    IF D10 = 2 THEN
        task_accepted := TRUE;
        Y2 := FALSE;
        operating_state := 0;
    END_IF;
END_IF;

IF task_accepted THEN
    CASE operating_state OF
        0: // Idle
            IF X26 AND X31 THEN
                current_item_class := D20;
                Y24 := TRUE; // Move down to pick
                IF X22 THEN
                    operating_state := 1; // Proceed to pick
                END_IF;
            END_IF;
        1: // Pick item
            Y20 := TRUE; // Close grip
            Y24 := FALSE;
            IF X24 THEN
                IF current_item_class = 1 THEN
                    Y25 := TRUE; // Set destination to reject
                ELSE
                    Y25 := FALSE; // Set destination to accept
                END_IF;
                Y23 := TRUE; // Lift item up
                operating_state := 2;
            END_IF;
        2: // Move to destination
            IF X23 THEN
                Y23 := FALSE;
                Y21 := TRUE; // Start advance to target
                operating_state := 3;
            END_IF;
        3: // Drop item
            IF X21 AND X27 THEN
                Y21 := FALSE;
                Y24 := TRUE; // Lower item for release
                IF X22 THEN
                    Y20 := FALSE; // Open grip to release
                    IF X25 THEN
                        Y24 := FALSE; // Stop lowering
                        Y22 := TRUE; // Return to home
                        item_delivered_count := item_delivered_count + 1;
                        IF item_delivered_count >= 2 THEN
                            Y2 := TRUE; // Completion claim
                            task_accepted := FALSE; // End task
                        ELSE
                            operating_state := 4; // Prepare for next item
                        END_IF;
                    END_IF;
                END_IF;
            END_IF;
        4: // Return and prepare for next item
            IF X20 THEN
                Y22 := FALSE;
                operating_state := 0; // Ready for next item
            END_IF;
    END_CASE;
END_IF;

END_PROGRAM