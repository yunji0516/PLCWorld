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
    D18 : DINT;
    D19 : DINT;
    D101 : DINT;
    D102 : DINT;
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
    D36 : DINT := 0;
    D37 : DINT := 0;
    Y24 : BOOL := FALSE;
    Y2 : BOOL := FALSE;
    cycle_started : BOOL := FALSE;
    phase : INT := 0;
    target_reached : BOOL := FALSE;
    docking_position : DINT := 70 * 100;
    timer : TON;
    safety_violation : BOOL := FALSE;
END_VAR

(* Control logic implementation *)

timer(IN := cycle_started AND NOT safety_violation, PT := T#15100ms);

CASE phase OF
    0: (* Wait for start signal *)
        IF X0 THEN
            cycle_started := TRUE;
            phase := 1;
        END_IF;

    1: (* Open vertical opening plates A and B *)
        Y20 := TRUE; // Enable axis A
        D20 := 100 * 100; // Move A to 100 mm
        
        Y21 := TRUE; // Enable axis B
        D24 := 100 * 100; // Move B to 100 mm
        
        D21 := 1000; // 100% rate for A
        D25 := 1000; // 100% rate for B

        IF ABS(D10 - D20) <= 20 AND ABS(D12 - D24) <= 20 THEN
            phase := 2;
        END_IF;
    
    2: (* Stop C at the request target *)
        Y22 := TRUE; // Enable axis C
        D28 := D101; // Set C target to request target
        D29 := 1000; // 100% rate for C

        IF ABS(D14 - D101) <= 20 THEN
            phase := 3;
        END_IF;
    
    3: (* Lower the D support to docking position *)
        Y23 := TRUE; // Enable axis D
        D32 := docking_position; // Move D to 70 mm
        D33 := 1000; // 100% rate for D

        IF ABS(D16 - docking_position) <= 20 THEN
            phase := 4;
        END_IF;
    
    4: (* Lower the E tool to the stroke position *)
        Y24 := TRUE; // Enable axis E
        D36 := D102; // Set E target to stroke position
        D37 := 1000; // 100% rate for E

        IF ABS(D18 - D102) <= 20 THEN
            phase := 5;
        END_IF;

    5: (* Retract E tool *)
        D36 := 0; // Retract E to 0 mm

        IF ABS(D18 - 0) <= 20 THEN
            phase := 6;
        END_IF;

    6: (* Lower dock and retract transfer jig *)
        D32 := 0; // Lower D to 0 mm
        D28 := 0; // Retract C to 0 mm

        IF ABS(D16 - 0) <= 20 AND ABS(D14 - 0) <= 20 THEN
            phase := 7;
        END_IF;

    7: (* Check for completion *)
        IF timer.Q THEN
            Y2 := TRUE; // Signal completion
        END_IF;
END_CASE;

(* Safety violation check *)
IF (D10 < 0 OR D10 > 100 * 100 OR D12 < 0 OR D12 > 100 * 100 OR
    D14 < 0 OR D14 > 400 * 100 OR D16 < 0 OR D16 > 80 * 100 OR
    D18 < 0 OR D18 > 210 * 100) THEN
    safety_violation := TRUE;
    cycle_started := FALSE;
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
END_IF;

END_PROGRAM