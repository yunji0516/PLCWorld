PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
    Y19 : BOOL := FALSE;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D200 : INT := 0;
    D201 : INT := 0;
    D202 : INT := 0;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    current_position : INT := 0;
    next_jig_position : INT := 0;
    jig_transition_requested : BOOL := FALSE;
    inspection_requested : BOOL := FALSE;
    product_detach_requested : BOOL := FALSE;
    cycle_complete : BOOL := FALSE;

    timer : TON;
    completion_timer : TON;
    move_timer : TON;
    observe_complete : BOOL := FALSE;
END_VAR

(* Perform state transitions based on planner position and operations *)
CASE current_position OF
    0: (* Upper Left - Start Position *)
        IF X10 AND NOT X11 AND NOT X12 AND NOT X13 AND NOT X1B THEN
            Y10 := TRUE; (* Admit product onto jig *)
            current_position := 1;
        END_IF
    1: (* Move to Inspection *)
        IF NOT X11 AND D0 = 101 THEN
            Y13 := TRUE; (* Request move *)
            Y10 := FALSE;
            D200 := D0;
            D201 := 1;
            current_position := 2;
        END_IF
    2: (* Inspection Position *)
        IF NOT X11 AND NOT X14 THEN
            IF D6 > 0 THEN
                Y11 := TRUE; (* Request inspection *)
                D202 := D8;
                inspection_requested := TRUE;
            ELSE
                current_position := 3;
            END_IF
        END_IF
    3: (* Move to Extraction *)
        IF NOT X11 THEN
            Y13 := TRUE; (* Request move *)
            Y11 := FALSE;
            D201 := 2;
            current_position := 4;
        END_IF
    4: (* Extraction - Detach product *)
        IF NOT X11 AND NOT X13 AND inspection_requested THEN
            IF D10 = D202 AND D9 = 1 THEN
                Y12 := TRUE; (* Detach product *)
                inspection_requested := FALSE;
                product_detach_requested := TRUE;
                IF X15 THEN
                    current_position := 5; 
                END_IF
            END_IF
        END_IF
    5: (* Return to Lower Center *)
        IF product_detach_requested THEN
            Y13 := TRUE;
            Y12 := FALSE;
            D201 := 3;
            current_position := 0;
            IF NOT X13 THEN
                Y18 := TRUE; (* Acknowledge exit reception *)
                IF X20 THEN
                    cycle_complete := TRUE;
                END_IF
            END_IF
        END_IF
END_CASE

(* Handle cycle completion and maintenance *)
IF cycle_complete THEN
    IF X16 THEN
        Y18 := FALSE;
        timer(IN := TRUE, PT := T#500ms);
        IF timer.Q THEN
            Y19 := TRUE;
            completion_timer(IN := TRUE, PT := T#500ms);
            observe_complete := TRUE;
        END_IF
    END_IF
END_IF

(* Maintain outputs if needed *)
IF observe_complete THEN
    IF completion_timer.Q THEN
        Y19 := FALSE;
    END_IF
END_IF

END_PROGRAM