PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    D20 : INT;
    (* Internal variables *)
    start_triggered : BOOL := FALSE;
    opening_required : BOOL := FALSE;
    target_gap : INT;
    completion_claimed : BOOL := FALSE;
    current_scan : INT := 0;
    open_command : BOOL := FALSE;
    close_command : BOOL := FALSE;
    edge_detector : R_TRIG;
END_VAR

(* Detect the start request using edge detection *)
edge_detector(CLK := X10);

(* Calculate the target gap based on D10 for opening *)
target_gap := D10;

(* Maintain both vacuum commands ON from the first scan *)
Y20 := TRUE;
Y21 := TRUE;

(* Detect rising edge of the start request *)
IF edge_detector.Q THEN
    start_triggered := TRUE;
END_IF;

(* Only proceed if the start has been triggered and both vacuum attachments are held *)
IF start_triggered AND X20 AND X21 THEN
    (* Check if the current gap is less than the target gap, and an opening is required *)
    IF D20 < target_gap THEN
        opening_required := TRUE;
    END_IF;

    (* Initiate the opening sequence if required *)
    IF opening_required THEN
        open_command := TRUE;
        close_command := FALSE;
    ELSE
        open_command := FALSE;
        close_command := FALSE;
    END_IF;

    (* Do not assert both open and close commands simultaneously *)
    IF open_command THEN
        Y22 := TRUE;
        Y23 := FALSE;
    ELSEIF close_command THEN
        Y22 := FALSE;
        Y23 := TRUE;
    ELSE
        Y22 := FALSE;
        Y23 := FALSE;
    END_IF;

    (* Check completion conditions after opening has reached the target *)
    IF D20 >= target_gap AND open_command = FALSE AND X20 AND X21 THEN
        completion_claimed := TRUE;
        Y2 := TRUE;
    END_IF;
    
    (* Track the scan number to ensure conditions are met within the deadline *)
    IF current_scan < 1600 THEN
        current_scan := current_scan + 1;
    ELSE
        start_triggered := FALSE; (* Reset the start trigger to prevent re-running the task *)
    END_IF;
END_IF;

IF completion_claimed AND current_scan >= 1550 THEN
    (* Maintain completion hold for at least 50 scans after claim *)
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM