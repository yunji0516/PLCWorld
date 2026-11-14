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
    startEdge : R_TRIG;
    scrapAcquired : BOOL := FALSE;
    productAcquired : BOOL := FALSE;
    movingProductToReceiver : BOOL := FALSE;
    movingScrapUp : BOOL := FALSE;
    returnToHome : BOOL := FALSE;
    preTurnOffVacuum : BOOL := FALSE;
END_VAR

(* Detect the rising edge of X10 to start the process. *)
startEdge(CLK := X10);

(* Main process logic *)
IF startEdge.Q AND D10 = 1 THEN
    (* If not yet acquired the product, move to source and acquire it *)
    IF NOT productAcquired THEN
        IF NOT X25 THEN
            Y23 := TRUE; (* Move head to source *)
            Y24 := FALSE;
        ELSE
            Y23 := FALSE;
            IF NOT X23 THEN
                Y23 := TRUE; (* Lower head to acquire product *)
                Y22 := FALSE;
            ELSE
                Y23 := FALSE;
                Y20 := TRUE; (* Turn on product vacuum *)
                productAcquired := TRUE; (* Product is now considered held *)
            END_IF
        END_IF
    END_IF

    (* If product is acquired, move it to receiver *)
    IF productAcquired AND NOT movingProductToReceiver THEN
        IF NOT X22 THEN
            Y22 := TRUE; (* Lift the product to safe height for horizontal travel *)
            Y23 := FALSE;
        ELSE
            Y22 := FALSE;
            IF NOT X24 THEN
                Y24 := TRUE; (* Move head to receiver *)
                Y25 := FALSE;
            ELSE
                Y24 := FALSE;
                movingProductToReceiver := TRUE; (* Mark as moved to receiver *)
            END_IF
        END_IF
    END_IF

    (* If moved to receiver, release product and return head to home *)
    IF movingProductToReceiver THEN
        IF X26 THEN
            IF NOT preTurnOffVacuum THEN
                Y20 := FALSE; (* Turn off product vacuum to release at receiver *)
                preTurnOffVacuum := TRUE;
            ELSE
                preTurnOffVacuum := FALSE;
                IF NOT X22 THEN
                    Y22 := TRUE; (* Ensure lift to home upper position *)
                    Y23 := FALSE;
                ELSE
                    Y22 := FALSE;
                    IF NOT X24 THEN
                        Y25 := TRUE; (* Return to home *)
                        Y24 := FALSE;
                    ELSE
                        Y25 := FALSE;
                        returnToHome := TRUE; (* Mark as returned to home *)
                    END_IF
                END_IF
            END_IF
        END_IF
    END_IF

    (* Now handle scrap acquisition with carrier *)
    IF returnToHome AND NOT scrapAcquired THEN
        IF NOT X28 THEN
            Y27 := TRUE; (* Lower carrier to acquire scraps *)
            Y26 := FALSE;
        ELSE
            Y27 := FALSE;
            Y21 := TRUE; (* Acquire scrap vacuum *)
            scrapAcquired := TRUE;
        END_IF
    END_IF

    (* If scrap acquired, lift the scraps *)
    IF scrapAcquired AND NOT movingScrapUp THEN
        IF NOT X27 THEN
            Y26 := TRUE; (* Lift the scrap carrier to full height *)
            Y27 := FALSE;
        ELSE
            Y26 := FALSE;
            movingScrapUp := TRUE;
        END_IF
    END_IF

    (* End of process: checking conditions for completion claim *)
    IF returnToHome AND movingScrapUp THEN
        IF X24 AND X22 AND X27 AND X21 THEN
            Y21 := TRUE; (* Only scrap vacuum remains ON *)
            Y2 := TRUE; (* Completion claim for valid terminal result *)
        END_IF
    END_IF
ELSE
    (* Stop all outputs if not started or any condition is broken *)
    Y20 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;
    preTurnOffVacuum := FALSE;
    movingProductToReceiver := FALSE;
    movingScrapUp := FALSE;
    returnToHome := FALSE;
    scrapAcquired := FALSE;
    productAcquired := FALSE;
    IF NOT Y2 THEN
        Y21 := FALSE; (* Ensure scrap vacuum is turned off unless in completion state *)
    END_IF
END_IF

END_PROGRAM