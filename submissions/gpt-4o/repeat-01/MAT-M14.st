```iecst
PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Internal variables *)
    start_request_edge : R_TRIG;
    completed : BOOL;
    supplying : BOOL;
    launched : BOOL;
END_VAR

(* Detect rising edge of start request *)
start_request_edge(CLK := X10);

(* Initial conditions where no actions are being taken *)
IF NOT completed THEN
    (* Begin the operation on start request *)
    IF start_request_edge.Q THEN
        IF D10 = 1 THEN
            IF NOT supplying AND X20 AND X23 AND X24 THEN
                Y22 := TRUE; (* Begin supply *)
                supplying := TRUE;
            END_IF;
        END_IF;
    END_IF;

    (* Monitor supply completion and ensure safety *)
    IF supplying THEN
        IF X23 AND X24 THEN
            Y22 := FALSE; (* Stop supply after product is loaded and supply finger is retracted *)
            supplying := FALSE;
        END_IF;
    END_IF;

    (* Prepare to fire when supply and pusher are ready *)
    IF NOT supplying AND X23 AND NOT launched THEN
        IF X20 THEN
            (* Calculate time to start firing based on distance and speed *)
            IF D21 > 0 THEN
                IF (D20 <= 30) THEN
                    Y20 := TRUE; (* Start firing *)
                    launched := TRUE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

    (* Monitor launch completion *)
    IF launched THEN
        IF X21 THEN
            Y20 := FALSE; (* End firing when pusher is at end *)
            Y21 := TRUE; (* Start retracting *)
        END_IF;
        IF X20 THEN
            Y21 := FALSE; (* Stop retracting when home *)
            IF X22 THEN
                Y2 := TRUE; (* Completion claim *)
                completed := TRUE;
            END_IF;
        END_IF;
    END_IF;
ELSE
    (* Maintain completion condition and hold Y2 *)
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

END_PROGRAM
```