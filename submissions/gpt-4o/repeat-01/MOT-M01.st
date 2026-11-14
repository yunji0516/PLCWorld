PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    currentState : INT := 0;
    targetA : DINT;
    targetB : DINT;
    timer : TON;
    completionTimer : TON;
END_VAR

(* Implement the control logic here. *)

timer(IN := FALSE, PT := T#100ms);
completionTimer(IN := FALSE, PT := T#130ms);

CASE currentState OF
    0: (* Initial state *)
        IF X10 THEN
            targetA := D13;
            targetB := D10;
            currentState := 1;
        END_IF

    1: (* Lift A to secure clearance *)
        D22 := 40000; (* Move A to 400 mm *)
        Y22 := TRUE;
        IF ABS(D16 - 40000) < 2 THEN (* If A has reached 400 mm *)
            currentState := 2;
        END_IF
    
    2: (* Swap A and B horizontally *)
        D20 := targetA;
        D21 := targetB;
        Y20 := TRUE;
        Y21 := TRUE;
        IF ABS(D11 - D13) < 2 AND ABS(D14 - D10) < 2 THEN (* If both A and B have reached their target positions *)
            currentState := 3;
        END_IF

    3: (* Lower A to working height *)
        D22 := 0;
        Y22 := TRUE;
        IF ABS(D16) < 2 THEN (* If A is at working height *)
            timer(IN := TRUE);
            IF timer.Q THEN (* Wait for settling time *)
                Y20 := FALSE;
                Y21 := FALSE;
                Y22 := FALSE;
                Y2 := TRUE; (* Task completion *)
                completionTimer(IN := TRUE);
                currentState := 4;
            END_IF
        END_IF

    4: (* Maintain completion signal for 30ms *)
        IF completionTimer.Q THEN
            Y2 := FALSE;
            currentState := 0;
        END_IF

END_CASE

END_PROGRAM