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
    D20 : INT;
    D21 : INT;

    start_edge : R_TRIG;
    push_timer : TON;
    retract_timer : TON;
    state : INT := 0;
    target_id : INT := 0;
    search_away : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);
push_timer(IN := (state = 4), PT := T#500ms);
retract_timer(IN := (state = 5), PT := T#500ms);

CASE state OF
    0: (* WAIT_START *)
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y2 := FALSE;
        IF start_edge.Q THEN
            target_id := D10;
            state := 1;
        END_IF;

    1: (* SEARCH_CHECK *)
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        IF X20 THEN
            IF D20 = target_id THEN
                state := 3;
            ELSE
                state := 2;
            END_IF;
        END_IF;

    2: (* SEARCH_ROTATE *)
        Y20 := TRUE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        IF NOT X20 THEN
            search_away := TRUE;
        END_IF;
        IF search_away AND X20 THEN
            search_away := FALSE;
            state := 1;
        END_IF;

    3: (* MOVE_TO_EJECT *)
        Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        IF D21 = 2 AND X20 THEN
            Y20 := FALSE;
            state := 4;
        ELSE
            Y20 := TRUE;
        END_IF;

    4: (* PUSH *)
        Y20 := FALSE; Y21 := FALSE; Y23 := FALSE;
        Y22 := TRUE;
        IF push_timer.Q THEN
            Y22 := FALSE;
            state := 5;
        END_IF;

    5: (* RETRACT *)
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;
        Y23 := TRUE;
        IF retract_timer.Q OR X21 THEN
            Y23 := FALSE;
            state := 6;
        END_IF;

    6: (* DONE *)
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM