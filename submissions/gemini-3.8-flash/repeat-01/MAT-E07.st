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
    D20 : INT;

    r_trig_start : R_TRIG;
    state : INT;
    last_d20 : INT;
    stall_count : INT;
    stable_count : INT;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        IF r_trig_start.Q THEN
            state := 1;
            stall_count := 0;
            last_d20 := D20;
        END_IF;

    1:
        IF D20 = last_d20 THEN
            stall_count := stall_count + 1;
        ELSE
            stall_count := 0;
            last_d20 := D20;
        END_IF;

        IF X22 AND ((D20 >= 660) OR (stall_count >= 20)) THEN
            state := 2;
        END_IF;

    2:
        IF X20 THEN
            state := 3;
            stable_count := 0;
        END_IF;

    3:
        IF X20 AND X22 AND (D20 >= 650) AND (D20 <= 700) THEN
            IF stable_count < 10 THEN
                stable_count := stable_count + 1;
            ELSE
                Y2 := TRUE;
            END_IF;
        ELSE
            stable_count := 0;
        END_IF;
END_CASE;

IF state = 1 THEN
    Y20 := TRUE;
    Y21 := FALSE;
ELSIF state = 2 THEN
    Y20 := FALSE;
    Y21 := TRUE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

END_PROGRAM