PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    started : BOOL;
    completed : BOOL;
    reqId : INT;
    state : INT;
    scanned : INT;
    targetIndex : INT;
    moveSteps : INT;
    seenUnaligned : BOOL;
END_VAR

(* Implement the control logic here. *)

startEdge(CLK := X10);

IF (NOT started) AND startEdge.Q THEN
    started := TRUE;
    reqId := D10;
    scanned := 0;
    moveSteps := 0;
    seenUnaligned := FALSE;
    state := 10;
END_IF;

IF completed THEN
    state := 100;
ELSE
    CASE state OF
        0:
            (* Wait for accepted start. *)

        10:
            (* Inspect the currently indexed reader position. *)
            IF X20 THEN
                IF (reqId <> 0) AND (D20 = reqId) THEN
                    moveSteps := 2;
                    state := 30;
                ELSE
                    scanned := scanned + 1;
                    state := 20;
                END_IF;
            END_IF;

        20:
            (* Prepare one CW index step while searching. *)
            targetIndex := D21 + 1;
            IF targetIndex >= 4 THEN
                targetIndex := targetIndex - 4;
            END_IF;
            seenUnaligned := FALSE;
            state := 21;

        21:
            (* Execute one CW index step. *)
            IF NOT X20 THEN
                seenUnaligned := TRUE;
            END_IF;

            IF seenUnaligned AND X20 AND (D21 = targetIndex) THEN
                state := 10;
            END_IF;

        30:
            (* Prepare a CW index step toward the ejector. *)
            targetIndex := D21 + 1;
            IF targetIndex >= 4 THEN
                targetIndex := targetIndex - 4;
            END_IF;
            seenUnaligned := FALSE;
            state := 31;

        31:
            (* Execute one CW index step toward the ejector. *)
            IF NOT X20 THEN
                seenUnaligned := TRUE;
            END_IF;

            IF seenUnaligned AND X20 AND (D21 = targetIndex) THEN
                moveSteps := moveSteps - 1;
                IF moveSteps > 0 THEN
                    state := 30;
                ELSE
                    state := 40;
                END_IF;
            END_IF;

        40:
            (* Push only at an indexed position. *)
            IF X20 AND X22 THEN
                state := 50;
            END_IF;

        50:
            (* Retract after the full push stroke. *)
            IF X21 THEN
                state := 60;
            END_IF;

        60:
            (* Claim only with receiver made, pusher home, indexed, and outputs off. *)
            IF X23 AND X21 AND X20 THEN
                completed := TRUE;
                state := 100;
            END_IF;

        100:
            completed := TRUE;

        ELSE
            state := 0;
    END_CASE;
END_IF;

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y2 := completed;

IF started AND (NOT completed) THEN
    CASE state OF
        21:
            IF X21 THEN
                Y20 := TRUE;
            ELSE
                Y23 := TRUE;
            END_IF;

        31:
            IF X21 THEN
                Y20 := TRUE;
            ELSE
                Y23 := TRUE;
            END_IF;

        40:
            IF X20 AND (NOT X22) THEN
                Y22 := TRUE;
            END_IF;

        50:
            IF NOT X21 THEN
                Y23 := TRUE;
            END_IF;

        ELSE
            (* All actuator outputs remain off. *)
    END_CASE;
END_IF;

END_PROGRAM