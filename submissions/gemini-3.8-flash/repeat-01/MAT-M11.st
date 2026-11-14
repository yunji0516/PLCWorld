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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;

    state : INT := 0;
    trig_start : R_TRIG;
    ton_vac : TON;
END_VAR

trig_start(CLK := X10);
ton_vac(IN := (state = 50), PT := T#300ms);

CASE state OF
    0: // Idle: wait for start request
        IF trig_start.Q THEN
            state := 10;
        END_IF;

    10: // Grip receiver sides with vacuum
        IF X20 AND X21 THEN
            state := 20;
        END_IF;

    20: // Drive opening axis to mechanical full open
        IF X22 AND (D20 >= 160) THEN
            state := 30;
        END_IF;

    30: // Insert content until seated at full forward
        IF X24 AND X25 THEN
            state := 40;
        END_IF;

    40: // Retract insertion slide until tool is fully home
        IF X23 THEN
            state := 50;
        END_IF;

    50: // Release vacuums with tool clear
        IF (NOT X20) AND (NOT X21) AND (X26 OR ton_vac.Q) THEN
            state := 60;
        END_IF;

    60: // Completed: maintain terminal claim
        ;
END_CASE;

// Actuator command mapping
Y20 := (state = 10) OR (state = 20) OR (state = 30) OR (state = 40);
Y21 := (state = 10) OR (state = 20) OR (state = 30) OR (state = 40);
Y22 := (state = 20);
Y23 := FALSE;
Y24 := (state = 30);
Y25 := (state = 40);

// Completion claim
Y2 := (state = 60);

END_PROGRAM