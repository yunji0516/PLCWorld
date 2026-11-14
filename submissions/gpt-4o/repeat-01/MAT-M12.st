PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
    Y27 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;
    D21 : INT;

    startRequest : BOOL := FALSE;
    productAcquired : BOOL := FALSE;
    scrapAcquired : BOOL := FALSE;
    edgeStart : R_TRIG;
    timerVacuum : TON;
    timerScrapVacuum : TON;
END_VAR

(* Detect start request *)
edgeStart(CLK := X10);
IF edgeStart.Q THEN
    startRequest := TRUE;
END_IF

(* If start request accepted and D10 = 1 *)
IF startRequest AND D10 = 1 THEN

    (* Step 1: Acquire Product *)
    IF NOT productAcquired THEN
        (* Move to source if not at source *)
        IF NOT X25 THEN
            Y25 := TRUE; (* Command: back to source *)
        ELSE
            Y25 := FALSE;
            Y22 := TRUE; (* Command: lower head *)
        END_IF

        IF X23 THEN (* If head is low *)
            Y20 := TRUE;  (* Command: head vacuum *)
            timerVacuum(IN := TRUE, PT := T#200ms);
            IF timerVacuum.Q THEN
                productAcquired := X20; (* Verify product held *)
            END_IF
        END_IF

    (* Step 2: Transport Product *)
    ELSIF productAcquired AND NOT X24 THEN
        Y20 := TRUE;  (* Ensure vacuum is on *)
        Y22 := TRUE;  (* Command: raise head *)
        IF X22 THEN  (* If full lift *)
            Y22 := FALSE;
            Y24 := TRUE;  (* Command: move forward to home *)
        END_IF

    (* Step 3: Release and Lower Product Head *)
    ELSIF X24 AND NOT X26 THEN
        Y24 := FALSE;
        Y23 := TRUE;  (* Command: lower head to place product *)
        IF X23 THEN
            Y20 := FALSE; (* Release product vacuum *)
        END_IF
        IF NOT X20 THEN (* Confirm product released *)
            Y23 := FALSE;
            Y22 := TRUE;  (* Command: raise head *)
        END_IF

    (* Step 4: Acquire Scrap *)
    ELSIF NOT scrapAcquired THEN
        IF NOT X28 THEN
            Y27 := TRUE; (* Command: lower scrap carrier *)
        ELSE
            Y27 := FALSE;
            Y21 := TRUE; (* Command: scrap vacuum *)
            timerScrapVacuum(IN := TRUE, PT := T#300ms);
            IF timerScrapVacuum.Q THEN
                scrapAcquired := X21; (* Verify scrap held *)
            END_IF
        END_IF

    (* Step 5: Raise Scrap *)
    ELSIF scrapAcquired THEN
        Y26 := TRUE;  (* Command: raise scrap carrier *)
        IF X27 THEN (* If scrap carrier high *)
            Y26 := FALSE;
            (* Completion claim *)
            Y2 := X26 AND X24 AND X27 AND NOT X20;
        END_IF

    END_IF
END_IF

(* Ensure no opposing commands are given simultaneously *)
IF Y24 THEN Y25 := FALSE; END_IF
IF Y22 THEN Y23 := FALSE; END_IF
IF Y26 THEN Y27 := FALSE; END_IF
IF startRequest AND D10 <> 1 THEN
    Y2 := FALSE;  (* Only complete if conditions met *)
END_IF

END_PROGRAM