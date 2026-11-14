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

    State : INT := 0;
    TargetLen : INT := 0;
    r_trig_Start : R_TRIG;
END_VAR

r_trig_Start(CLK := X10);

IF r_trig_Start.Q AND State = 0 THEN
    TargetLen := D10;
    State := 1;
END_IF

CASE State OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;

    1: (* Build sufficient buffer before starting extraction *)
        IF D20 >= 700 THEN
            State := 2;
        END_IF

    2: (* Move carriage forward to extract web *)
        IF D21 >= (TargetLen - 2) THEN
            Y20 := FALSE;
            State := 3;
        ELSE
            Y20 := X22; (* Forward movement requires feed grip fully closed *)
        END_IF

    3: (* Wait for the carriage to come to a complete stop *)
        IF X21 THEN
            State := 4;
        END_IF

    4: (* Close the receiver when within tolerance *)
        IF ABS(D21 - TargetLen) <= 3 THEN
            Y24 := TRUE;
            IF X24 THEN
                Y24 := FALSE; (* Maintain position without active command *)
                State := 5;
            END_IF
        END_IF

    5: (* Open feed grip to hand over custody and prepare for return *)
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            State := 6;
        END_IF

    6: (* Return carriage home *)
        IF X20 THEN
            Y21 := FALSE;
            State := 7;
        ELSE
            Y21 := X23; (* Reverse movement requires feed grip fully open *)
        END_IF

    7: (* Wait for the carriage to come to a stop at home *)
        IF X21 THEN
            State := 8;
        END_IF

    8: (* Task completed, maintain terminal state *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;

END_CASE

(* Background logic for buffer inventory preservation (limits: 80 - 900 mm) *)
IF State >= 1 AND State <= 7 THEN
    IF D20 < 700 THEN
        Y26 := TRUE;
    ELSIF D20 >= 850 THEN
        Y26 := FALSE;
    END_IF
ELSIF State = 0 OR State = 8 THEN
    Y26 := FALSE;
END_IF

END_PROGRAM