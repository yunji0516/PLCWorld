PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT; // a_position
    D11 : DINT; // a_velocity
    D12 : DINT; // b_position
    D13 : DINT; // b_velocity
    D14 : DINT; // c_position
    D15 : DINT; // c_velocity
    D101 : DINT; // request_first
    D102 : DINT; // request_second
    D103 : DINT; // request_depth1
    D104 : DINT; // request_depth2
    D20 : DINT; // a_target
    D21 : DINT; // a_rate
    Y20 : BOOL; // a_enable
    D24 : DINT; // b_target
    D25 : DINT; // b_rate
    Y21 : BOOL; // b_enable
    D28 : DINT; // c_target
    D29 : DINT; // c_rate
    Y22 : BOOL; // c_enable
    Y2 : BOOL; // completion
    // Internal variables
    stage : INT := 0;
    ready_A : BOOL := FALSE;
    ready_B : BOOL := FALSE;
    ready_C : BOOL := FALSE;
    a_position_actual : REAL;
    b_position_actual : REAL;
    c_position_actual : REAL;
    disk_hole1_x : REAL;
    disk_hole1_y : REAL;
    disk_hole2_x : REAL;
    disk_hole2_y : REAL;
    distance_1 : REAL;
    distance_2 : REAL;
    interference : BOOL := FALSE;
    timer : TON;
END_VAR

// Calculate actual positions from inputs
a_position_actual := REAL(D10) / 100.0;
b_position_actual := REAL(D12) / 100.0;
c_position_actual := REAL(D14) / 100.0;

// Calculate disk hole positions
disk_hole1_x := 0.11 * COS(REAL(D101) / 100.0);
disk_hole1_y := 0.11 * SIN(REAL(D101) / 100.0);
disk_hole2_x := -0.11 * COS(REAL(D102) / 100.0);
disk_hole2_y := -0.11 * SIN(REAL(D102) / 100.0);

// Check for interference
distance_1 := SQRT((0.11 - disk_hole1_x)**2 + disk_hole1_y**2);
distance_2 := SQRT((0.11 - disk_hole2_x)**2 + disk_hole2_y**2);
IF (b_position_actual <= 35) THEN
    interference := (distance_1 + 0.0075 > 0.012);
ELSIF (c_position_actual <= 60) THEN
    interference := (distance_2 + 0.0075 > 0.012);
END_IF;

// Control logic based on the stage
CASE stage OF
    0: // Wait for start signal
        IF X0 THEN
            stage := 1;
        END_IF;

    1: // Prepare tool B for approach
        D20 := D101;
        D21 := 1000; // Set max speed
        Y20 := TRUE; // Enable axis A
        IF ABS(a_position_actual - REAL(D101) / 100.0) <= 0.2 AND ABS(REAL(D11) / 100.0) <= 1 THEN
            ready_A := TRUE;
            stage := 2;
        END_IF;

    2: // Move tool B to depth1
        IF ready_A THEN
            D24 := D103;
            D25 := 1000; // Set max speed
            Y21 := TRUE; // Enable axis B
            IF NOT interference AND ABS(b_position_actual - REAL(D103) / 100.0) <= 0.2 AND ABS(REAL(D13) / 100.0) <= 1 THEN
                ready_B := TRUE;
                stage := 3;
            END_IF;
        END_IF;

    3: // Retract tool B
        IF ready_B THEN
            D24 := 0;
            D25 := 1000;
            IF b_position_actual <= 0.2 THEN
                Y21 := FALSE; // Disable axis B
                ready_A := FALSE;
                stage := 4;
            END_IF;
        END_IF;

    4: // Prepare tool C for approach
        D20 := D102;
        D21 := 1000; // Set max speed
        Y20 := TRUE; // Enable axis A
        IF ABS(a_position_actual - REAL(D102) / 100.0) <= 0.2 AND ABS(REAL(D11) / 100.0) <= 1 THEN
            ready_A := TRUE;
            stage := 5;
        END_IF;

    5: // Move tool C to depth2
        IF ready_A THEN
            D28 := D104;
            D29 := 1000; // Set max speed
            Y22 := TRUE; // Enable axis C
            IF NOT interference AND ABS(c_position_actual - REAL(D104) / 100.0) <= 0.2 AND ABS(REAL(D15) / 100.0) <= 1 THEN
                ready_C := TRUE;
                stage := 6;
            END_IF;
        END_IF;

    6: // Retract tool C
        IF ready_C THEN
            D28 := 0;
            D29 := 1000;
            IF c_position_actual <= 0.2 THEN
                Y22 := FALSE; // Disable axis C
                ready_A := FALSE;
                ready_B := FALSE;
                ready_C := FALSE;
                stage := 7;
            END_IF;
        END_IF;

    7: // Completion check
        IF NOT Y21 AND NOT Y22 THEN
            Y2 := TRUE;
            timer(IN := TRUE, PT := T#100ms);
            IF timer.Q THEN
                Y2 := FALSE;
                stage := 0;
            END_IF;
        END_IF;

    ELSE
        // Do nothing
END_CASE;

END_PROGRAM