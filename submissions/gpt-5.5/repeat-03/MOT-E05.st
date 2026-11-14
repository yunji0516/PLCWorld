PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    state : INT;
    valid_cleared : BOOL;
    captured_value : DINT;
    result_hold_timer : TON;
END_VAR

IF NOT X10 THEN
    state := 0;
    valid_cleared := FALSE;
    captured_value := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    D20 := 0;
ELSE
    CASE state OF
        0:
            Y20 := TRUE;
            Y21 := FALSE;
            Y2 := FALSE;
            D20 := 0;
            valid_cleared := FALSE;
            state := 1;

        1:
            Y20 := TRUE;
            Y21 := FALSE;
            Y2 := FALSE;
            D20 := 0;

            IF NOT X11 THEN
                valid_cleared := TRUE;
            END_IF;

            IF valid_cleared AND X11 THEN
                captured_value := D14;
                D20 := captured_value;
                Y21 := TRUE;
                state := 2;
            END_IF;

        2:
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := captured_value;
            Y2 := FALSE;

        3:
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := captured_value;
            Y2 := TRUE;

        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := FALSE;
            D20 := 0;
            valid_cleared := FALSE;
            state := 0;
    END_CASE;
END_IF;

result_hold_timer(IN := (state = 2), PT := T#30ms);

IF state = 2 THEN
    Y20 := TRUE;
    Y21 := TRUE;
    D20 := captured_value;
    IF result_hold_timer.Q THEN
        Y2 := TRUE;
        state := 3;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSIF state = 3 THEN
    Y20 := TRUE;
    Y21 := TRUE;
    D20 := captured_value;
    Y2 := TRUE;
END_IF;

END_PROGRAM