PROGRAM Main
VAR
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D20 : DINT;
    D21 : DINT;
    D100 : DINT;
    X30 : BOOL;
    X32 : BOOL;
    D104 : DINT;
    D103 : DINT;
    D110 : DINT;
    X31 : BOOL;
    X33 : BOOL;
    D114 : DINT;
    D113 : DINT;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    D93 : DINT;
    D94 : DINT;
    D95 : DINT;
    D96 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    X54 : BOOL;
    X55 : BOOL;
    X56 : BOOL;
    X57 : BOOL;
    D150 : DINT;
    D151 : DINT;
    D200 : DINT;
    D201 : DINT;
    Y20 : BOOL;
    D204 : DINT;
    D205 : DINT;
    Y21 : BOOL;
    D208 : DINT;
    D209 : DINT;
    Y22 : BOOL;
    D212 : DINT;
    D213 : DINT;
    Y23 : BOOL;
    D216 : DINT;
    D217 : DINT;
    Y24 : BOOL;
    D220 : DINT;
    D221 : DINT;
    Y25 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y2 : BOOL;
    couple_seq_counter : DINT := 0;
    request_in_process_A : BOOL := FALSE;
    request_in_process_B : BOOL := FALSE;
    approach_timer_A : TON;
    approach_timer_B : TON;
    completion_timer : TON;
    post_approach_timer_A : TON;
    post_approach_timer_B : TON;
    r_served_A : BOOL := FALSE;
    r_served_B : BOOL := FALSE;
    safety_timer : TON;
END_VAR

// Initialize timers
approach_timer_A(IN := X30, PT := T#80ms);
approach_timer_B(IN := X31, PT := T#80ms);
completion_timer(IN := X51, PT := T#100ms);
post_approach_timer_A(IN := FALSE, PT := T#30ms);
post_approach_timer_B(IN := FALSE, PT := T#30ms);
safety_timer(IN := FALSE, PT := T#40ms);

// State Machine for Hoist A (Request A)
IF NOT request_in_process_A AND D100 <> 0 THEN
    // Start processing request A
    request_in_process_A := TRUE;
    D81 := 1; // Set to Lift A
    couple_seq_counter := couple_seq_counter + 1;
    D82 := couple_seq_counter;
    D80 := 2; // Set action to placement
ELSIF request_in_process_A AND X30 THEN
    // Handle completion conditions for request A
    r_served_A := X30;
    IF r_served_A AND X32 THEN
        D300 := D100;
        D301 := 1; // Completion status set to 1
        request_in_process_A := FALSE;
    END_IF
END_IF

// State Machine for Hoist B (Request B)
IF NOT request_in_process_B AND D110 <> 0 THEN
    // Start processing request B
    request_in_process_B := TRUE;
    D81 := 2; // Set to Lift B
    couple_seq_counter := couple_seq_counter + 1;
    D82 := couple_seq_counter;
    D80 := 2; // Set action to placement
ELSIF request_in_process_B AND X31 THEN
    // Handle completion conditions for request B
    r_served_B := X31;
    IF r_served_B AND X33 THEN
        D302 := D110;
        D303 := 1; // Completion status set to 1
        request_in_process_B := FALSE;
    END_IF
END_IF

// Motion Control Logic
IF request_in_process_A OR request_in_process_B THEN
    // Enable movement based on active requests
    IF request_in_process_A THEN
        Y20 := TRUE; // Enable shuttle
        D200 := 850; // Target position for shuttle
        D201 := 1000; // Maximum drive ratio
        IF X53 THEN
            Y25 := TRUE; // Enable approach
            D220 := D95; // Set slide target from request
            D221 := 650; // Drive ratio for approach
        END_IF
    END_IF
    IF request_in_process_B THEN
        Y21 := TRUE; // Enable lift
        IF X54 THEN
            Y22 := TRUE; // Enable lift A movement
            D208 := D150; // Set target height to return height
            D209 := 1000; // Maximum lift speed
        END_IF
    END_IF
ELSE
    // Establish defaults when no requests
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    D201 := 0;
    D205 := 0;
    D209 := 0;
    D213 := 0;
    D217 := 0;
    D221 := 0;
END_IF

// Completion and Safety Checks
IF X51 THEN
    completion_timer(IN := TRUE);
    IF completion_timer.Q THEN
        Y2 := TRUE;
    END_IF
ELSE
    completion_timer(IN := FALSE);
    Y2 := FALSE;
END_IF

// Safety conditions
safety_timer(IN := D13 >= 40);
IF safety_timer.Q THEN
    Y20 := FALSE; // Disable shuttle if fork entered more than 40 mm
END_IF

END_PROGRAM