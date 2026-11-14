PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    start_edge : R_TRIG;  // Rising edge detector for start request
    task_started : BOOL := FALSE;  // Indicates if the task has been started
    task_completed : BOOL := FALSE;  // Indicates if the task has been completed
    scan_count : INT := 0;  // Counter for the scans after task completion
END_VAR

(* Implement the control logic here. *)

(* Detect the start rising edge *)
start_edge(CLK := X10);

IF start_edge.Q AND NOT task_started THEN
    // Start task on rising edge of X10
    Y20 := TRUE;  // Command gripper to close
    task_started := TRUE;
END_IF

IF task_started AND NOT task_completed THEN
    // Check if the product is being held
    IF X20 THEN
        Y2 := TRUE;  // Indicate task completion
        task_completed := TRUE;
        scan_count := 0;  // Reset scan counter
    END_IF
END_IF

IF task_completed THEN
    // Maintain completion claim for at least 50 scans after completion
    scan_count := scan_count + 1;
    IF scan_count >= 50 THEN
        Y2 := TRUE;  // Hold the task completion claim
    END_IF
    // The task should be completed by scan 1550
    IF scan_count >= 1550 THEN
        Y2 := FALSE;  // Reset completion claim
        Y20 := FALSE; // Open gripper if needed (not required here)
        task_started := FALSE;  // Reset task started flag
        task_completed := FALSE; // Reset task completed flag
    END_IF
END_IF

END_PROGRAM