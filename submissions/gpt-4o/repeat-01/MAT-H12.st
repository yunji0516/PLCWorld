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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    
    // Internal Variables
    total_occupancy : INT;
    next_a_start : BOOL := FALSE;
    next_b_start : BOOL := FALSE;
    eject_a_ready : BOOL := FALSE;
    eject_b_ready : BOOL := FALSE;
    swap_condition : BOOL := FALSE;

    a_start_edge : R_TRIG;
    b_start_edge : R_TRIG;
    eject_a_edge : R_TRIG;
    eject_b_edge : R_TRIG;
    swap_edge : R_TRIG;

END_VAR

// Calculate total occupancy with pending
total_occupancy := D0 + D1;

// Determine if next A batch can start
a_start_edge(CLK := next_a_start);
next_a_start := X16 AND NOT X17 AND X10 AND (total_occupancy + D6 <= 6);

// Determine if next B batch can start
b_start_edge(CLK := next_b_start);
next_b_start := X1C AND NOT X1D AND X10 AND (total_occupancy + D8 <= 6);

// Manage A batch start
IF a_start_edge.Q THEN
    Y13 := TRUE;
    Y14 := TRUE;
ELSE
    Y13 := FALSE;
    Y14 := FALSE;
END_IF;

// Manage B batch start
IF b_start_edge.Q THEN
    Y16 := TRUE;
    Y17 := TRUE;
ELSE
    Y16 := FALSE;
    Y17 := FALSE;
END_IF;

// Eject good products only when exits are clear
eject_a_edge(CLK := eject_a_ready);
eject_a_ready := X1A AND X1B;

IF eject_a_edge.Q THEN
    Y15 := TRUE;
ELSE
    Y15 := FALSE;
END_IF;

eject_b_edge(CLK := eject_b_ready);
eject_b_ready := X20 AND X21;

IF eject_b_edge.Q THEN
    Y18 := TRUE;
ELSE
    Y18 := FALSE;
END_IF;

// Manage bin exchange conditions
swap_condition := X15 AND D4 > 0 AND X12 AND NOT X11;

swap_edge(CLK := swap_condition);
IF swap_edge.Q THEN
    Y10 := TRUE;
    Y11 := FALSE; // Assure bin exchange is prioritized
ELSE
    Y10 := FALSE;
END_IF;

// Handle bin retrieval when ready
IF X13 AND NOT X14 AND NOT swap_condition THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF;

// Manage completion status
IF (D4 = 3) AND (X15 = TRUE) AND NOT (X18 OR X19 OR X1E OR X1F) THEN
    Y12 := TRUE;
ELSE
    Y12 := FALSE;
END_IF;

END_PROGRAM