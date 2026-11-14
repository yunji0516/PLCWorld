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

    start_trigger : R_TRIG;
    positioned : BOOL;
    delivering : BOOL;
    selected1 : BOOL;
    selected2 : BOOL;
    selected3 : BOOL;
    state : INT := 0;
END_VAR

start_trigger(CLK := X10);

IF start_trigger.Q THEN
    selected1 := (D10 AND 1) <> 0;
    selected2 := (D10 AND 2) <> 0;
    selected3 := (D10 AND 4) <> 0;
    state := 1;  (* Initiate the process *)
END_IF

CASE state OF
    1:  (* Move to lift up for motion clearance *)
        IF NOT X22 THEN
            Y22 := TRUE;  (* Command up *)
        ELSE
            Y22 := FALSE;
            state := 2;
        END_IF
        
    2:  (* Horizontal motion to the target/receiver *)
        IF (selected1 AND NOT X26) OR (selected2 AND NOT X27) OR (selected3 AND NOT X28) THEN
            IF NOT X21 THEN
                Y20 := TRUE;  (* Command forward *)
            ELSE
                Y20 := FALSE;
                state := 3;
            END_IF 
        ELSE
            IF NOT X20 THEN
                Y21 := TRUE;  (* Command back *)
            ELSE
                Y21 := FALSE;
                Y23 := TRUE;  (* Command down *)
                state := 5;
            END_IF
        END_IF

    3:  (* Place selected materials at the target *)
        IF X23 THEN
            Y23 := FALSE;
            IF selected1 AND X26 THEN
                Y24 := TRUE; (* Release1 *)
            END_IF
            IF selected2 AND X27 THEN
                Y25 := TRUE; (* Release2 *)
            END_IF
            IF selected3 AND X28 THEN
                Y26 := TRUE; (* Release3 *)
            END_IF
            state := 4;
        ELSE
            Y23 := TRUE;
        END_IF

    4:  (* Return to source, lift up *)
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X22 THEN
            state := 2;
        ELSE
            Y22 := TRUE;
        END_IF

    5:  (* Place non-selected materials back at source *)
        IF X23 THEN
            Y23 := FALSE;
            IF NOT selected1 AND X26 THEN
                Y24 := TRUE;  (* Release1 *)
            END_IF
            IF NOT selected2 AND X27 THEN
                Y25 := TRUE;  (* Release2 *)
            END_IF
            IF NOT selected3 AND X28 THEN
                Y26 := TRUE;  (* Release3 *)
            END_IF
            state := 6;
        ELSE
            Y23 := TRUE;
        END_IF

    6:  (* Completion, turn off all motions *)
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF NOT X24 THEN
            state := 7;
        ELSE
            Y22 := TRUE;
        END_IF

    7:  (* Set completion claim *)
        Y2 := TRUE;
END_CASE

END_PROGRAM