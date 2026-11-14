PROGRAM Main
VAR
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
    D20 : DINT;
    D21 : DINT;
    D100 : DINT;
    X30 : BOOL;
    X32 : BOOL;
    D104 : DINT;
    D103 : DINT;
    D110 : DINT;
    X31 : BOOL;
    X33 : BOOL;
    D114 : DINT;
    D113 : DINT;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    D93 : DINT;
    D94 : DINT;
    D95 : DINT;
    D96 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    X54 : BOOL;
    X55 : BOOL;
    X56 : BOOL;
    X57 : BOOL;
    D150 : DINT;
    D151 : DINT;
    D200 : DINT;
    D201 : DINT;
    Y20 : BOOL;
    D204 : DINT;
    D205 : DINT;
    Y21 : BOOL;
    D208 : DINT;
    D209 : DINT;
    Y22 : BOOL;
    D212 : DINT;
    D213 : DINT;
    Y23 : BOOL;
    D216 : DINT;
    D217 : DINT;
    Y24 : BOOL;
    D220 : DINT;
    D221 : DINT;
    Y25 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y2 : BOOL;
    (* Internal Variables *)
    currentRequest : DINT := 0;
    operationMode : DINT := 0; // 0: Idle, 1: Processing Request A, 2: Processing Request B
    requestCompleted : BOOL := FALSE;
    ackSequence : DINT := 0;
    requestTimer : TIME := T#0ms;
    observeCompletionTimer : TIME := T#0ms;
    observeCompletion : BOOL := FALSE;
END_VAR

(* Control logic begins here *)

IF NOT X51 THEN
    CASE operationMode OF
        0: // Idle state
            // Check for new requests and decide operation mode
            IF r0_location = 0 AND NOT X30 AND requestCompleted = FALSE THEN
                currentRequest := D100;
                operationMode := 1; // Process Request A
            ELSIF r1_location = 0 AND NOT X31 AND requestCompleted = FALSE THEN
                currentRequest := D110;
                operationMode := 2; // Process Request B
            END_IF;

        1: // Process Request A
            (* Check for specific conditions and execute steps for Request A *)
            // Example: Move shuttle or execute specific commands...
            IF X30 THEN // Request A complete
                D300 := currentRequest;
                D301 := 1; // Indicate completion
                operationMode := 0; // Set back to idle
            END_IF;

        2: // Process Request B
            (* Check for specific conditions and execute steps for Request B *)
            // Example: Move shuttle or execute specific commands...
            IF X31 THEN // Request B complete
                D302 := currentRequest;
                D303 := 1; // Indicate completion
                operationMode := 0; // Set back to idle
            END_IF;
    END_CASE;
ELSE
    // All requests including future ones are done, prepare for completion
    IF observeCompletion = FALSE THEN
        observeCompletion := TRUE;
        observeCompletionTimer := T#0ms;
    END_IF;

    IF observeCompletion THEN
        observeCompletionTimer := observeCompletionTimer + T#10ms;
        
        IF observeCompletionTimer >= T#100ms THEN
            Y2 := TRUE; // Indicate final completion
        END_IF;
    END_IF;
END_IF;

END_PROGRAM