PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL := FALSE;

    state : INT := 0;
    request_accepted : BOOL := FALSE;
    start_rising_edge : R_TRIG;
    timer : TON;
END_VAR

start_rising_edge(CLK := X10);

CASE state OF
    0: (* Waiting for the start signal *)
        IF start_rising_edge.Q AND D10 = 1 THEN
            request_accepted := TRUE;
            state := 1;
        END_IF

    1: (* Lower the tool if at the source and in a high position *)
        IF X20 AND X23 THEN
            Y24 := TRUE;  (* Command down *)
            IF X22 THEN
                Y24 := FALSE;
                state := 2;
            END_IF
        END_IF

    2: (* Align and grip the workpiece *)
        IF X26 AND NOT X24 THEN
            Y25 := TRUE; (* Command align x *)
            Y26 := TRUE; (* Command align z *)
            timer(IN := TRUE, PT := T#380ms);
            IF timer.Q THEN
                Y25 := FALSE;
                Y26 := FALSE;
                Y20 := TRUE;  (* Command grip *)
                timer(IN := FALSE);
                state := 3;
            END_IF
        END_IF

    3: (* Raise the tool after gripping *)
        IF X24 THEN
            Y23 := TRUE;  (* Command up *)
            IF X23 THEN
                Y23 := FALSE;
                state := 4;
            END_IF
        END_IF

    4: (* Move to target if clear and high enough *)
        IF X29 AND X23 THEN
            Y21 := TRUE;  (* Command advance *)
            IF X21 THEN
                Y21 := FALSE;
                state := 5;
            END_IF
        END_IF

    5: (* Lower the tool at the target *)
        IF NOT X28 THEN
            Y24 := TRUE;  (* Command down *)
            IF X22 THEN
                Y24 := FALSE;
                state := 6;
            END_IF
        END_IF

    6: (* Release the workpiece at the target and retract fingers *)
        IF X27 THEN
            Y20 := FALSE;  (* Release grip *)
            Y22 := TRUE;   (* Command return *)
            IF X20 THEN
                Y22 := FALSE;
                state := 7;
            END_IF
        END_IF

    7: (* Finalize and claim completion *)
        IF X20 AND X23 AND X25 AND NOT X31 AND NOT X32 THEN
            Y2 := TRUE;   (* Claim completion *)
            (* Turn off all actuators *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
        END_IF
END_CASE

END_PROGRAM