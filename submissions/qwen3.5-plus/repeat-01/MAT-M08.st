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
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    
    start_edge : R_TRIG;
    
    state : INT;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* IDLE — wait for start request edge *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1: (* SCANNING — move rack upward until aligned with a vacant slot *)
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X25 AND NOT X24 THEN
            (* Aligned and slot is vacant — stop rack, proceed to insert *)
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        ELSE
            (* Not aligned or slot occupied — keep moving rack up *)
            Y20 := TRUE;
            Y21 := FALSE;
        END_IF;

    2: (* PUSHING — extend pusher to insert plate into the vacant slot *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X23 THEN
            state := 3;
        END_IF;

    3: (* RETRACTING — retract pusher back to home *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y2 := FALSE;
        IF X22 THEN
            state := 4;
        END_IF;

    4: (* COMPLETE — hold completion claim, all actuators OFF *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM