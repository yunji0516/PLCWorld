PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := TRUE; (* Initially maintain grip ON to preserve holding *)
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    start_edge : R_TRIG;
    request_started : BOOL := FALSE;
    release_commanded : BOOL := FALSE;
    timer : TON;
    scan_counter : INT := 0;
END_VAR

(* Implement the control logic here. *)
start_edge(CLK := X10);

// Check for the start request
IF start_edge.Q THEN
    request_started := TRUE;
    Y20 := FALSE; (* Release the product *)
    release_commanded := TRUE;
    timer(IN := TRUE, PT := T#200ms); (* Start timer for opening delay *)
END_IF

// When the start request has been initiated, increment the scan counter
IF request_started THEN
    scan_counter := scan_counter + 1;
END_IF

// Only acknowledge completion if all conditions are met
IF release_commanded AND timer.Q THEN
    IF X21 AND X22 THEN
        Y2 := TRUE; (* Completion claim when product is released and received *)
    END_IF
END_IF

// Enforce completion conditions
IF scan_counter > 1550 THEN
    Y20 := FALSE; (* Ensure grip remains OFF *)
END_IF

END_PROGRAM