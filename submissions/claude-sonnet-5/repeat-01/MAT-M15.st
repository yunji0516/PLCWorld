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

    (* internal variables *)
    start_trig : R_TRIG;
    started : BOOL := FALSE;
    requested_count : INT := 0;
    net_count : INT := 0;
    path_state : INT := 0;
    code : INT := 0;
    dispatch_started : BOOL := FALSE;
    y2_latch : BOOL := FALSE;
END_VAR

(* ---- start request handling ---- *)
start_trig(CLK := X10);

IF start_trig.Q AND (NOT started) AND (D10 = 2 OR D10 = 3) THEN
    started := TRUE;
    requested_count := D10;
END_IF;

(* ---- photoeye occupancy code ---- *)
IF X20 AND X21 THEN
    code := 2;
ELSIF X20 THEN
    code := 1;
ELSIF X21 THEN
    code := 3;
ELSE
    code := 0;
END_IF;

(* ---- passage tracking state machine ---- *)
CASE path_state OF
    0:
        IF code = 1 THEN
            path_state := 1;
        ELSIF code = 3 THEN
            path_state := 11;
        END_IF;

    1:
        IF code = 2 THEN
            path_state := 2;
        ELSIF code = 0 THEN
            path_state := 0;
        END_IF;

    2:
        IF code = 3 THEN
            path_state := 3;
        ELSIF code = 1 THEN
            path_state := 1;
        END_IF;

    3:
        IF code = 0 THEN
            net_count := net_count + 1;
            path_state := 0;
        ELSIF code = 2 THEN
            path_state := 2;
        END_IF;

    11:
        IF code = 2 THEN
            path_state := 12;
        ELSIF code = 0 THEN
            path_state := 0;
        END_IF;

    12:
        IF code = 1 THEN
            path_state := 13;
        ELSIF code = 3 THEN
            path_state := 11;
        END_IF;

    13:
        IF code = 0 THEN
            net_count := net_count - 1;
            path_state := 0;
        ELSIF code = 2 THEN
            path_state := 12;
        END_IF;

    ELSE
        path_state := 0;
END_CASE;

(* ---- feed control ---- *)
IF started AND (NOT dispatch_started) AND (net_count < requested_count) THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

(* ---- dispatch trigger conditions ---- *)
IF started AND (NOT dispatch_started)
   AND (net_count = requested_count)
   AND (NOT Y20)
   AND X23
   AND (NOT X22)
   AND X24 THEN
    dispatch_started := TRUE;
END_IF;

(* ---- dispatch actuator control ---- *)
IF dispatch_started AND (NOT X25) THEN
    Y21 := TRUE;
ELSE
    Y21 := FALSE;
END_IF;

(* ---- completion evaluation and latch ---- *)
IF (NOT y2_latch)
   AND dispatch_started
   AND X25
   AND (net_count = requested_count)
   AND X23
   AND (NOT Y20)
   AND (NOT Y21)
   AND (NOT X22) THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM