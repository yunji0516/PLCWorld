PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    // Internal variables
    state : INT := 0; 
    sensor_edge_detected : BOOL := FALSE;
    current_reference_position : DINT := 0;
    park_position : DINT;
    timer : TON;
    edge_detector : R_TRIG;
END_VAR

(* Initialize internal variables *)
park_position := D101;

(* Define a TON and R_TRIG *)
timer(IN := FALSE, PT := T#15s);
edge_detector(CLK := X34);

CASE state OF
    0: // Wait for start
        IF X0 THEN
            state := 1;
        END_IF
    
    1: // Retract to avoid upper jaw, raise C
        D24 := 0; // Retract B
        D25 := 1000; // 100% rate
        Y21 := TRUE; // Enable B axis

        D28 := 100 * 100; // Raise C to 100
        D29 := 1000; // 100% rate
        Y22 := TRUE; // Enable C axis

        IF D12 <= 2 AND D14 >= (100 * 100 - 2) THEN
            // B retracted and C raised
            Y21 := FALSE; // Disable B axis
            Y22 := FALSE; // Disable C axis
            state := 2;
        END_IF

    2: // Detect sensor edge and latch position
        IF edge_detector.Q AND NOT sensor_edge_detected THEN
            current_reference_position := D10;
            sensor_edge_detected := TRUE;
            state := 3;
        END_IF

    3: // Stop after detecting the sensor edge
        IF ABS(D10 - current_reference_position) <= (10 * 100) THEN
            D20 := current_reference_position + park_position * 100; // Park at reference + request
            D21 := 500; // Move at 50% rate
            Y20 := TRUE; // Enable A axis

            IF D11 <= 1 AND ABS(D10 - D20) <= 2 THEN
                Y20 := FALSE; // Disable A axis
                state := 4;
            END_IF
        END_IF

    4: // Configure
        Y30 := TRUE;
        timer(IN := TRUE); // Start timer
        IF timer.Q THEN
            Y30 := FALSE;
            Y2 := TRUE; // Set completion
            state := 5;
        END_IF

    5: // Maintain completion
        timer(IN := FALSE);
        Y2 := TRUE;
        // Condition to end state
        // Implement any necessary logic here
END_CASE

END_PROGRAM