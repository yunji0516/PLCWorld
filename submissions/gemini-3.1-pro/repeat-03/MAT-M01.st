PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    state : INT := 0;
    req_len : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            req_len := D10;
            state := 1;
        END_IF;

    1:
        (* Prepare buffer: Unwind until buffer is safely above the required extraction length.
           Using an offset of 150 mm ensures buffer remains > 80 mm after extraction 
           while safely avoiding the 900 mm maximum limit. *)
        IF D20 < (req_len + 150) THEN
            Y26 := TRUE;
        ELSE
            Y26 := FALSE;
            state := 2;
        END_IF;

    2:
        (* Feed web: Move forward while feed grip is fully closed.
           Stop when actual web extracted reaches the requested length. *)
        IF D21 >= req_len THEN
            Y20 := FALSE;
            state := 3;
        ELSIF X22 THEN
            Y20 := TRUE;
        END_IF;

    3:
        (* Wait for carriage to completely stop before commanding receiver. *)
        IF X21 THEN
            state := 4;
        END_IF;

    4:
        (* Close receiver clamp. Receiver closure is only permitted at rest. *)
        IF X24 THEN
            Y24 := FALSE;
            state := 5;
        ELSE
            Y24 := TRUE;
        END_IF;

    5:
        (* Open feed grip. Web is now securely held by the closed receiver. *)
        IF X23 THEN
            Y23 := FALSE;
            state := 6;
        ELSE
            Y23 := TRUE;
        END_IF;

    6:
        (* Return carriage to home. Requires feed grip to be fully open. *)
        IF X20 THEN
            Y21 := FALSE;
            state := 7;
        ELSIF X23 THEN
            Y21 := TRUE;
        END_IF;

    7:
        (* Wait for carriage to completely stop at the home position. *)
        IF X21 THEN
            state := 8;
        END_IF;

    8:
        (* Task complete. Maintain completion claim. Actuators remain safely OFF. *)
        Y2 := TRUE;

END_CASE;

END_PROGRAM