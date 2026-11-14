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
    D20 : INT;
    D21 : INT;
    D22 : INT;

    state : INT := 0;
    req_length : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF start_edge.Q THEN
            req_length := D10;
            state := 1;
        END_IF;

    1:
        Y22 := TRUE;
        
        (* Active steering to maintain edge within corridor *)
        IF D20 > 1 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < -1 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;

        (* Check if the target length is met (accounting for 4 mm/scan feed rate) *)
        IF D21 >= req_length - 1 THEN
            Y22 := FALSE;
            Y20 := FALSE;
            Y21 := FALSE;
            Y23 := TRUE;
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        (* Wait for clamp to report fully closed *)
        IF X20 THEN
            state := 3;
        END_IF;

    3:
        (* Terminate sequence and maintain success state *)
        Y2 := TRUE;
        Y23 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
END_CASE;

END_PROGRAM