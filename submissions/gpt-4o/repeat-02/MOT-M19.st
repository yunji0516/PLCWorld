PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT := 0;
    D21 : DINT := 0;
    Y20 : BOOL := FALSE;
    D24 : DINT := 0;
    D25 : DINT := 0;
    Y21 : BOOL := FALSE;
    D28 : DINT := 0;
    D29 : DINT := 0;
    Y22 : BOOL := FALSE;
    D32 : DINT := 0;
    D33 : DINT := 0;
    Y23 : BOOL := FALSE;
    Y2 : BOOL := FALSE;

    // Internal Variables
    state : INT := 0;
    setPointAchieved : BOOL := FALSE;
    timeCounter : TIME := T#0s;
    enableCounter : TIME := T#0s;
    retractCounter : TIME := T#0s;
    bRetractDone : BOOL := FALSE;
    
    firstStopAchieved : BOOL := FALSE;
    secondStopAchieved : BOOL := FALSE;
    jigReturned : BOOL := FALSE;
    bRetracted : BOOL := FALSE;
    
    edgeTrigX0 : R_TRIG;
    timer : TON;
    retractTimer : TON;
END_VAR

// Implement the control logic

// edge detection for start signal
edgeTrigX0(CLK := X0);

// State machine
CASE state OF
    0: // Initial State
        IF edgeTrigX0.Q THEN
            // Prepare jig base and head position
            // Move C to 0 and D to requested lane alignment
            D28 := 0; // Target position for C in raw units (0 mm)
            D29 := 500; // Rate for C movement
            Y22 := TRUE; // Enable C axis
            
            D32 := D103; // Set D target to requested lane
            D33 := 500; // Rate for D movement
            Y23 := TRUE; // Enable D axis

            // Enable A and B but don't move yet
            Y20 := TRUE; // Enable A axis
            Y21 := TRUE; // Enable B axis
            
            state := 1;
        END_IF
    
    1: // Moving to first stop
        IF ABS(D14 - 0) <= 20 AND D15 <= 100 THEN // Jig base C has reached 0 ±0.2
            IF ABS(D16 - D103) <= 20 AND D17 <= 100 THEN // Head D is aligned to request lane ±0.2
                D20 := D101; // Move A to first request
                D21 := 500; // Set A rate movement
                D24 := 7000; // B move to 70 (7000)
                D25 := 500; // Set B rate movement
            END_IF
        END_IF
        
        IF ABS(D10 - D101) <= 20 AND D11 <= 100 THEN // A has reached first request ±0.2
            IF ABS(D12 - 7000) <= 20 AND D13 <= 100 THEN // B has reached 70 ±0.2
                firstStopAchieved := TRUE;
                state := 2;
            END_IF
        END_IF
    
    2: // First stop reached, move to second stop
        IF firstStopAchieved THEN
            D20 := D102; // Move A to second request
            firstStopAchieved := FALSE;
            
            IF ABS(D10 - D102) <= 20 AND D11 <= 100 THEN
                secondStopAchieved := TRUE;
                Y2 := TRUE; // Signal completion
                timer(IN := TRUE, PT := T#15s); // Start 15000 ms timer
            END_IF
        END_IF
        
        IF timer.Q THEN
            state := 3;
        END_IF
    
    3: // After completion, retract B and return C=80, A=60, D=0
        IF secondStopAchieved THEN
            IF NOT bRetractDone THEN
                D24 := 0; // Retract B
                D25 := 500; // Set B rate movement
                secondStopAchieved := FALSE;
                Y2 := FALSE; // Turn off completion signal
            END_IF
            
            IF ABS(D12 - 0) <= 20 AND D13 <= 100 THEN // B is retracted
                bRetractDone := TRUE;
            END_IF
        END_IF
        
        IF bRetractDone THEN
            // Move A, C, and D to initial positions
            D20 := 6000; // Move A to 60 (6000)
            D28 := 8000; // Move C to 80 (8000)
            D32 := 0;    // Move D to 0
            state := 4;
        END_IF
    
    4: // Waiting for everything to return to initial positions
        IF ABS(D10 - 6000) <= 20 AND D11 <= 100 THEN // A is at 60
            IF ABS(D14 - 8000) <= 20 AND D15 <= 100 THEN // C is at 80
                IF ABS(D16) <= 20 AND D17 <= 100 THEN // D is at 0
                    // All axes returned, end the cycle
                    Y20 := FALSE; // Disable A
                    Y21 := FALSE; // Disable B
                    Y22 := FALSE; // Disable C
                    Y23 := FALSE; // Disable D
                    bRetractDone := FALSE;
                    state := 0; // Reset state
                END_IF
            END_IF
        END_IF
END_CASE

END_PROGRAM