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
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
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
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    load_edge : R_TRIG;
    insert_edge : R_TRIG;
    inspect_edge : R_TRIG;
    eject_edge : R_TRIG;
    rework_edge : R_TRIG;
    release_edge : R_TRIG;
    return_edge : R_TRIG;
    timer_complete : TON;
    complete_timer_triggered : BOOL;
    products_received : INT := 0;
    completed : BOOL := FALSE;
END_VAR

// Rising edge detection for operations
load_edge(CLK := X10 AND NOT X14 AND X0);
insert_edge(CLK := X12 AND NOT X15 AND X0);
inspect_edge(CLK := X16 AND X22 AND NOT X14 AND NOT X15 AND NOT X17);
eject_edge(CLK := X20 AND NOT X17 AND X1B AND X0);
rework_edge(CLK := X25 AND X24);
release_edge(CLK := X16 AND X1B AND X20);
return_edge(CLK := X2A AND X0);

// Load body
IF load_edge.Q THEN
    Y10 := TRUE;
ELSE
    Y10 := FALSE;
END_IF

// Prepare and insert body
IF insert_edge.Q THEN
    Y11 := TRUE;
    Y12 := TRUE;
ELSE
    Y11 := FALSE;
    Y12 := FALSE;
END_IF

// Start inspection
IF inspect_edge.Q THEN
    Y13 := TRUE;
ELSE
    Y13 := FALSE;
END_IF

// Ejector sequence
IF eject_edge.Q THEN
    Y14 := TRUE;
    IF NOT X23 THEN
        Y14 := FALSE;
        Y15 := TRUE;
    END_IF
ELSE
    Y14 := FALSE;
    Y15 := FALSE;
END_IF

// To rework
IF rework_edge.Q THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF

// Release output
IF release_edge.Q THEN
    IF X1B AND X1D AND NOT X1F THEN
        Y16 := TRUE;
        products_received := products_received + 1;
    ELSE
        Y16 := FALSE;
    END_IF
ELSE
    Y16 := FALSE;
END_IF

// Return body
IF return_edge.Q THEN
    Y1F := TRUE;
ELSE
    Y1F := FALSE;
END_IF

// Turn table
IF NOT X18 AND X1A AND NOT X1C AND not (Y10 OR Y11 OR Y12 OR Y13 OR Y14 OR Y15 OR Y16 OR Y1B OR Y1C OR Y1D OR Y1E) AND X27 THEN
    Y18 := TRUE;
ELSE
    Y18 := FALSE;
END_IF

// Completion and observation timer
IF products_received >= 6 AND X1C AND NOT X26 THEN
    IF NOT complete_timer_triggered THEN
        timer_complete(IN := TRUE, PT := T#500ms);
        IF timer_complete.Q THEN
            Y1A := TRUE;
            completed := TRUE;
            complete_timer_triggered := TRUE;
        END_IF
    END_IF
ELSE
    Y1A := FALSE;
    completed := FALSE;
    complete_timer_triggered := FALSE;
END_IF

END_PROGRAM