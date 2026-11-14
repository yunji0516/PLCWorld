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
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    
    (* Internal variables *)
    state : INT := 0;
    (* States: 0=wait, 1=move_A_to_100, 2=extend_pins, 3=move_D, 
               4=retract_D, 5=retract_all, 6=complete *)
END_VAR

(* Helper function-like logic inline: check if axis has arrived *)
(* Arrival: |position - target| <= 0.2*scale AND |velocity| <= 1*scale
   Scale = 100, so: abs(D - target) <= 20 AND abs(V) <= 100 *)

CASE state OF

    0: (* WAIT_FOR_START - wait for X0 *)
        (* Reset all outputs to safe state *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        D28 := 0;
        D29 := 0;
        D32 := 0;
        D33 := 0;
        
        IF X0 THEN
            state := 1;
        END_IF;

    1: (* MOVE_A_TO_100 - move guide to locking position *)
        Y20 := TRUE;
        D21 := 1000;
        D20 := 10000;  (* A=100mm *)
        
        (* Check arrival: |pos - 10000| <= 20 AND |vel| <= 100 *)
        IF (ABS(D10 - 10000) <= 20) AND (ABS(D11) <= 100) THEN
            state := 2;
        END_IF;

    2: (* EXTEND_BOTH_PINS - lock both sides at B=C=60 *)
        Y21 := TRUE;
        D25 := 1000;
        D24 := 6000;  (* B=60mm *)
        
        Y22 := TRUE;
        D29 := 1000;
        D28 := 6000;  (* C=60mm *)
        
        (* Check both pins arrived *)
        IF (ABS(D12 - 6000) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14 - 6000) <= 20) AND (ABS(D15) <= 100) THEN
            state := 3;
        END_IF;

    3: (* MOVE_D_TO_DEPTH - internal access to requested depth *)
        Y23 := TRUE;
        D33 := 1000;
        D32 := D101;  (* D = requested depth, already scaled by 100 *)
        
        (* Check arrival *)
        IF (ABS(D16 - D101) <= 20) AND (ABS(D17) <= 100) THEN
            state := 4;
        END_IF;

    4: (* RETRACT_D - retract internal access *)
        Y23 := TRUE;
        D33 := 1000;
        D32 := 0;
        
        (* Check D arrived at 0 *)
        IF (ABS(D16) <= 20) AND (ABS(D17) <= 100) THEN
            Y23 := FALSE;  (* D disable after retract *)
            state := 5;
        END_IF;

    5: (* RETRACT_ALL - retract pins and guide back to origin *)
        Y21 := TRUE;
        D25 := 1000;
        D24 := 0;
        
        Y22 := TRUE;
        D29 := 1000;
        D28 := 0;
        
        Y20 := TRUE;
        D21 := 1000;
        D20 := 0;
        
        (* Check all arrived at 0 *)
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14) <= 20) AND (ABS(D15) <= 100) AND
           (ABS(D10) <= 20) AND (ABS(D11) <= 100) THEN
            Y21 := FALSE;
            Y22 := FALSE;
            Y20 := FALSE;
            state := 6;
        END_IF;

    6: (* COMPLETE - all axes at origin, signal completion *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM