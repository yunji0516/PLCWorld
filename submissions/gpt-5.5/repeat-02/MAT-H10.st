PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    (* Add internal variables here. *)
    started : BOOL;
    extract_state : INT;
    sentA : INT;
    sentB : INT;
    readyA : BOOL;
    readyB : BOOL;
    needMore : BOOL;
    extractClearWasFalse : BOOL;
    swapCommanded : BOOL;
    emptyTakeDone : BOOL;
    completionLatched : BOOL;
    assembleStartedA : BOOL;
    assembleStartedB : BOOL;
    assembleBusySeenA : BOOL;
    assembleBusySeenB : BOOL;
    releaseDoneA : BOOL;
    releaseDoneB : BOOL;
END_VAR

(* Implement the control logic here. *)

IF X0 THEN
    started := TRUE;
END_IF;

Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;

IF sentA <= D3 THEN
    assembleStartedA := FALSE;
    assembleBusySeenA := FALSE;
    releaseDoneA := FALSE;
END_IF;

IF sentB <= D4 THEN
    assembleStartedB := FALSE;
    assembleBusySeenB := FALSE;
    releaseDoneB := FALSE;
END_IF;

IF started AND (sentA > D3) THEN
    IF assembleStartedA AND X21 THEN
        assembleBusySeenA := TRUE;
    END_IF;

    IF NOT assembleStartedA THEN
        IF X1F AND X20 AND (NOT X21) THEN
            Y16 := TRUE;
            assembleStartedA := TRUE;
            assembleBusySeenA := FALSE;
        END_IF;
    ELSE
        IF assembleBusySeenA AND (NOT releaseDoneA) AND X22 AND X23 THEN
            Y18 := TRUE;
            releaseDoneA := TRUE;
        END_IF;
    END_IF;
END_IF;

IF started AND (sentB > D4) THEN
    IF assembleStartedB AND X27 THEN
        assembleBusySeenB := TRUE;
    END_IF;

    IF NOT assembleStartedB THEN
        IF X25 AND X26 AND (NOT X27) THEN
            Y17 := TRUE;
            assembleStartedB := TRUE;
            assembleBusySeenB := FALSE;
        END_IF;
    ELSE
        IF assembleBusySeenB AND (NOT releaseDoneB) AND X28 AND X29 THEN
            Y19 := TRUE;
            releaseDoneB := TRUE;
        END_IF;
    END_IF;
END_IF;

needMore := ((sentA < 3) OR (sentB < 4)) AND (NOT completionLatched);

readyA := started AND (sentA < 3) AND (D3 >= sentA) AND (NOT X1F) AND (NOT X21) AND X23;
readyB := started AND (sentB < 4) AND (D4 >= sentB) AND (NOT X25) AND (NOT X27) AND X29;

IF NOT started THEN
    extract_state := 0;
END_IF;

IF completionLatched THEN
    extract_state := 0;
END_IF;

IF started AND (NOT completionLatched) THEN
    CASE extract_state OF
        0:
            IF needMore AND (readyA OR readyB) AND X10 AND X11 AND X16 AND (NOT X17) AND X18 AND (D1 > 0) AND (NOT X19) AND ((D0 = 201) OR ((D0 = 202) AND X1C)) THEN
                extract_state := 10;
                extractClearWasFalse := FALSE;
            END_IF;

        10:
            IF NOT needMore THEN
                extract_state := 0;
            ELSIF X12 AND X14 AND X16 AND X11 THEN
                extract_state := 20;
                extractClearWasFalse := FALSE;
            END_IF;

        20:
            IF X17 THEN
                extract_state := 30;
                extractClearWasFalse := NOT X18;
            END_IF;

        30:
            IF NOT X18 THEN
                extractClearWasFalse := TRUE;
            END_IF;
            IF extractClearWasFalse AND X18 THEN
                extract_state := 40;
            END_IF;

        40:
            IF readyA OR readyB THEN
                IF readyA AND ((sentA <= sentB) OR (NOT readyB)) THEN
                    D200 := 1;
                    D201 := sentA + 1;
                    Y13 := TRUE;
                    sentA := sentA + 1;
                    assembleStartedA := FALSE;
                    assembleBusySeenA := FALSE;
                    releaseDoneA := FALSE;
                ELSE
                    D200 := 2;
                    D201 := sentB + 1;
                    Y13 := TRUE;
                    sentB := sentB + 1;
                    assembleStartedB := FALSE;
                    assembleBusySeenB := FALSE;
                    releaseDoneB := FALSE;
                END_IF;
                extract_state := 50;
            END_IF;

        50:
            IF X16 THEN
                extract_state := 0;
            END_IF;

    ELSE
        extract_state := 0;
    END_CASE;
END_IF;

IF NOT started THEN
    Y10 := TRUE;
    Y11 := TRUE;
ELSE
    CASE extract_state OF
        10:
            Y10 := TRUE;
            Y11 := TRUE;
        20:
            Y10 := FALSE;
            Y11 := TRUE;
        30:
            Y10 := FALSE;
            Y11 := TRUE;
            Y12 := TRUE;
    ELSE
        Y10 := TRUE;
        Y11 := FALSE;
    END_CASE;
END_IF;

IF completionLatched THEN
    Y10 := TRUE;
    Y11 := FALSE;
    Y12 := FALSE;
END_IF;

IF started AND (NOT completionLatched) AND (NOT swapCommanded) AND (D0 = 201) AND (D1 <= 0) AND X18 AND X14 AND X13 AND X1A AND X1B AND (NOT X19) THEN
    Y14 := TRUE;
    swapCommanded := TRUE;
END_IF;

IF started AND (NOT completionLatched) AND swapCommanded AND (NOT emptyTakeDone) AND (D0 = 202) AND X10 AND X1B AND (NOT X19) THEN
    Y15 := TRUE;
    emptyTakeDone := TRUE;
END_IF;

IF started AND (NOT completionLatched) AND (sentA >= 3) AND (sentB >= 4) AND (D3 >= 3) AND (D4 >= 4) AND X1D AND (D0 = 202) AND X10 AND (D1 = 1) AND X1C AND X16 AND X18 AND X14 AND X13 AND (NOT X19) THEN
    completionLatched := TRUE;
END_IF;

Y1A := completionLatched;

END_PROGRAM