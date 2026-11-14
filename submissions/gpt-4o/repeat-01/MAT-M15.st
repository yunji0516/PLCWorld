PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    (* Internal variables *)
    start_trigger : R_TRIG;
    feed_on : BOOL := FALSE;
    dispatch_on : BOOL := FALSE;
    product_count : INT := 0;
    forward_passages : INT := 0;
    reverse_passages : INT := 0;
    external_active : BOOL := FALSE;
    total_passages : INT := 0;
END_VAR

(* Control logic *)

(* Detect start request *)
start_trigger(CLK := X10);

IF start_trigger.Q THEN
    (* Reset state for new operation *)
    product_count := 0;
    forward_passages := 0;
    reverse_passages := 0;
    feed_on := FALSE;
    dispatch_on := FALSE;
    Y2 := FALSE;
END_IF

(* Handle feeding logic *)
IF X23 AND NOT X22 AND (product_count < D10) THEN
    feed_on := TRUE;
END_IF

IF feed_on THEN
    IF X20 AND NOT X21 THEN
        (* Product is at photoeye A only - forward detected *)
        IF NOT external_active AND NOT X22 THEN
            forward_passages := forward_passages + 1;
            product_count := product_count + 1;
            feed_on := FALSE; (* Stop feeding for forward passage *)
        END_IF
    END_IF
    IF NOT X20 AND X21 THEN
        (* Product is at photoeye B only - reverse detected *)
        IF NOT external_active AND NOT X22 THEN
            reverse_passages := reverse_passages + 1;
            feed_on := FALSE; (* Stop feeding for reverse passage *)
        END_IF
    END_IF
END_IF

IF external_pending THEN
    external_active := TRUE;
END_IF

IF external_active THEN
    IF NOT X20 AND NOT X21 THEN
        external_active := FALSE; (* External action completed *)
    END_IF
END_IF

(* Dispatch logic *)
IF (X24 OR (product_count = D10)) AND NOT feed_on AND NOT external_active THEN
    dispatch_on := TRUE;
ELSE
    dispatch_on := FALSE;
END_IF

(* Calculate total passages *)
total_passages := forward_passages - reverse_passages;

(* Handle outputs *)
Y20 := feed_on;
Y21 := dispatch_on;

(* Completion claim *)
IF X25 AND total_passages = D10 THEN
    Y2 := TRUE; (* Hold completion claim *)
END_IF

END_PROGRAM