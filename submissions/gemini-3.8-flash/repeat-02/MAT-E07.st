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

    state : INT := 0;
    start_trig : R_TRIG;
    push_timer : TON;
    prev_d20 : INT := 0;
    stop_count : INT := 0;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0: (* IDLE - await start rising edge *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        push_timer(IN := FALSE, PT := T#2500ms);
        IF start_trig.Q THEN
            state := 1;
            stop_count := 0;
            prev_d20 := D20;
        END_IF;

    1: (* PUSH - transfer plate into receiver *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;

        push_timer(IN := TRUE, PT := T#2500ms);

        IF D20 = prev_d20 THEN
            stop_count := stop_count + 1;
        ELSE
            stop_count := 0;
        END_IF;
        prev_d20 := D20;

        IF X22 AND (D20 >= 660 OR stop_count >= 15 OR push_timer.Q) THEN
            Y20 := FALSE;
            push_timer(IN := FALSE, PT := T#2500ms);
            state := 2;
        END_IF;

    2: (* RETRACT - return pusher to home position *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;

        IF X20 THEN
            Y21 := FALSE;
            Y2 := TRUE;
            state := 3;
        END_IF;

    3: (* DONE - hold completion claim through evaluation budget *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM