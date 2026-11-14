PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    current_pouch_id : INT := 0;
    current_content_id : INT := 0;
    package_counter : INT := 0;
    complete_timer : TON;
    release_edge : R_TRIG;
    separator_hold_edge : R_TRIG;
    all_done_edge : R_TRIG;
END_VAR

// Logic to separate double sheets and acknowledgment
separator_hold_edge(CLK := X20 AND NOT X21 AND NOT Y10);
IF separator_hold_edge.Q THEN
    Y1B := TRUE; // Activate separator_hold
END_IF

IF X22 AND NOT X21 THEN
    Y1C := TRUE; // Activate separate command
ELSE
    Y1C := FALSE;
END_IF

// Accept pouch after separation
IF X23 AND NOT X21 AND NOT Y10 THEN
    Y10 := TRUE; // Trigger accept_pouch
ELSIF Y10 THEN
    Y10 := FALSE;
END_IF

// Accept content when pouch is ready and content is prepared
IF X15 AND (D2 = D0) AND (D0 <> 0) AND NOT Y11 AND NOT content_ready THEN
    Y11 := TRUE;
    current_content_id := D2;
ELSIF Y11 THEN
    Y11 := FALSE;
END_IF

// Align content when required and insert
IF X24 AND NOT X16 AND (current_content_id = D3) AND X25 THEN
    Y1D := TRUE; // Align side
    Y1E := TRUE; // Align front
    Y14 := TRUE; // Open stoppers
END_IF

IF X13 AND X24 AND NOT X16 AND (D5 >= 2) AND NOT X20 THEN
    Y16 := TRUE; // Trigger insert
END_IF

// Release content after contained
release_edge(CLK := X19);
IF release_edge.Q THEN
    Y18 := TRUE; // Release content
ELSIF X18 THEN
    Y18 := FALSE;
    IF package_counter < 4 THEN
        package_counter := package_counter + 1;
    END_IF
END_IF

// Return mechanisms home
IF package_counter = 4 AND X1E THEN
    Y17 := TRUE; // Retract
END_IF

// Acknowledge exit
IF X1D THEN
    Y19 := TRUE; // Trigger ack_exit
ELSE
    Y19 := FALSE;
END_IF

// Completion logic
all_done_edge(CLK := X1F);
complete_timer(IN := all_done_edge.Q, PT := T#500ms);

IF complete_timer.Q THEN
    Y1A := TRUE; // Assert complete
END_IF

END_PROGRAM