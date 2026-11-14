PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    // Internal variables
    state : INT := 0;
    requestedAngle : REAL;
    requestedCounterweight : REAL;
    headTiltError : REAL;
    counterweightXError : REAL;
    ET_MaintainCompletion : TIME;
    timer : TON;
    edge_x10 : R_TRIG;

    (* Fixed values *)
    maxMoment : REAL := 25.0;
    moment : REAL;
    gravity : REAL := 9.81;
    headMass : REAL := 30.0;
    counterweightMass : REAL := 20.0;
    headDistance : REAL := 0.3;
    angularAccel : REAL;
END_VAR

// Function to calculate the moment
FUNCTION REAL CalculateMoment: REAL
VAR_INPUT
    A : REAL;
    B : REAL;
END_VAR
CalculateMoment := headMass * gravity * headDistance * SIN(A) + counterweightMass * gravity * B;
END_FUNCTION

// Function to calculate angular acceleration
FUNCTION REAL CalculateAngularAcceleration: REAL
VAR_INPUT
    A : REAL;
END_VAR
CalculateAngularAcceleration := 100 * SIN(A);
END_FUNCTION

// Adjust for the scan rate 
timer(IN := (state = 3), PT := T#30ms);
edge_x10(CLK := X10);

CASE state OF
    0: // Initial state or wait for request
        IF edge_x10.Q THEN
            requestedAngle := REAL(D10) / 100.0;
            requestedCounterweight := -450.0 * SIN(requestedAngle);
            state := 1;
        END_IF

    1: // Control head and counterweight positions
        headTiltError := ABS(REAL(D11) / 100.0 - requestedAngle);
        counterweightXError := ABS(REAL(D13) / 100.0 - requestedCounterweight);
        
        // Control logic
        IF headTiltError <= 0.2 AND ABS(REAL(D12) / 100.0) <= 1.0 AND
           counterweightXError <= 0.2 AND ABS(REAL(D14) / 100.0) <= 1.0 THEN
            Y20 := FALSE;
            D20 := D10;
            D21 := D17;
            Y21 := TRUE;
            state := 2; 
        ELSE
            Y20 := TRUE;
            D20 := D10;
            D21 := D17;
            Y21 := TRUE;
        END_IF

    2: // Engage brake if head stopped
        IF ABS(REAL(D12) / 100.0) <= 1.0 THEN
            Y22 := TRUE; // Engage brake
            Y21 := TRUE; // Maintain counterweight drive
            state := 3; 
        END_IF

    3: // Wait for brake full engagement
        IF X11 AND timer.Q THEN
            Y2 := TRUE; // Indicate completion
            state := 4;
        END_IF

    4: // Maintain completion state and moment constraint
        moment := CalculateMoment(REAL(D11) / 100.0, REAL(D13) / 1000.0);
        IF ABS(moment) <= 1.0 THEN
            // Keep the outputs stable for the observation period
        ELSE
            Y2 := FALSE; // Failure in maintaining moment
        END_IF

END_CASE

END_PROGRAM