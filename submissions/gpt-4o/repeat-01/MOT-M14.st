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
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y2 : BOOL := FALSE;
    retractSlide : BOOL := FALSE;
    rotateTable : BOOL := FALSE;
    approachSlide : BOOL := FALSE;
    timer : TON;
    edge : R_TRIG;
    holdCounter : DINT := 0;
END_VAR

edge(CLK := X10);

IF edge.Q THEN
    (* Initial request: Decide actions based on current state and request. *)
    IF D12 > 5000 THEN
        retractSlide := TRUE;
    ELSE
        rotateTable := TRUE;
    END_IF;
END_IF;

(* Retraction Logic *)
IF retractSlide THEN
    D21 := 50000; (* Fully retract slide to 500 mm *)
    Y21 := TRUE;

    IF X11 THEN
        Y21 := FALSE;
        retractSlide := FALSE;
        rotateTable := TRUE;
    END_IF;
END_IF;

(* Rotation Logic *)
IF rotateTable THEN
    D20 := D14;
    Y20 := TRUE;

    IF X12 THEN
        Y20 := FALSE;
        rotateTable := FALSE;
        approachSlide := TRUE;
    END_IF;
END_IF;

(* Approach Logic *)
IF approachSlide THEN
    D21 := MIN(D15, D16); (* Approach slide within safe limit *)
    Y21 := TRUE;

    IF (ABS(D12 - D21) <= 20) AND (ABS(D13) <= 100) THEN
        IF holdCounter = 0 THEN
            timer(IN := TRUE, PT := INT_TO_TIME(3 * 10)); (* 30 ms hold time *)
        END_IF;

        IF timer.Q THEN
            holdCounter := holdCounter + 1;
            IF holdCounter = 10 THEN (* 100 ms hold time *)
                Y2 := TRUE;
                Y21 := FALSE;
                approachSlide := FALSE;
            END_IF;
        END_IF;
    ELSE
        holdCounter := 0;
    END_IF;
END_IF;

END_PROGRAM