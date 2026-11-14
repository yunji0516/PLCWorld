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

    (* Internal variables *)
    initialA : INT;
    initialB : INT;
    requestAccepted : BOOL := FALSE;
    movingUp : BOOL := FALSE;
    movingSwapped : BOOL := FALSE;
    taskCompleted : BOOL := FALSE;

    tonA : TON;
    tonB : TON;
    tonV : TON;

    targetA : DINT := 0;
    targetB : DINT := 0;
    midPositionA : DINT := 40000; (* 400 mm up *)
    handshake : BOOL := FALSE;
END_VAR

(* Initial Positions *)
initialA := DINT_TO_INT(D11);
initialB := DINT_TO_INT(D14);

(* Input must be high to start task *)
IF X10 THEN
    IF NOT requestAccepted THEN
        (* Accept request and set targets *)
        targetA := D13;
        targetB := D10;
        requestAccepted := TRUE;
        handshake := FALSE;
    END_IF;
ELSE
    (* Reset if no task requested *)
    requestAccepted := FALSE;
    taskCompleted := FALSE;
    handshake := FALSE;
END_IF;

IF requestAccepted THEN
    IF NOT movingUp THEN
        (* Move Head A up by 400 mm first for clearance *)
        D20 := midPositionA;
        Y20 := TRUE;

        tonA(IN := (ABS(D16 - midPositionA) <= 20 AND ABS(D17) <= 1), PT := T#30ms);
        IF tonA.Q THEN
            movingUp := TRUE; (* Proceed to swap once head A reaches safe elevation *)
        END_IF;
    ELSIF NOT movingSwapped THEN
        (* Exchange A and B once A is up *)
        D20 := targetB;
        D21 := targetA;
        Y20 := TRUE;
        Y21 := TRUE;
        
        tonB(IN := (ABS(D11 - targetB) <= 20 AND ABS(D12) <= 1)
              AND (ABS(D14 - targetA) <= 20 AND ABS(D15) <= 1), PT := T#30ms);
        IF tonB.Q THEN
            movingSwapped := TRUE; (* Both heads swapped position without collision *)
        END_IF;
    ELSE
        (* Lower A back to working height *)
        D22 := 0;
        Y22 := TRUE;

        tonV(IN := (ABS(D16) <= 20 AND ABS(D17) <= 1), PT := T#30ms);
        IF tonV.Q THEN
            taskCompleted := TRUE;
        END_IF;
    END_IF;
END_IF;

(* Task Completion *)
IF taskCompleted THEN
    Y2 := TRUE;
    (* Retain Y2 for 30ms after completion *)
    IF NOT handshake THEN
        handshake := TRUE;
        tonA(IN := TRUE, PT := T#30ms);
    ELSE
        IF tonA.Q THEN
            Y2 := FALSE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM