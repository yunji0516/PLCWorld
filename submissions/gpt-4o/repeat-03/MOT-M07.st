PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    current_task : INT := 0;
    first_task_done : BOOL := FALSE;
    second_task_done : BOOL := FALSE;

    timer : TON;
    completion_timer: TON;
    completion_request: BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* Set completion to false initially *)
Y2 := FALSE;

(* Safety condition: start only when X0 is TRUE *)
IF X0 THEN
    CASE current_task OF

        0: (* Prepare for first task: Moving to first port *)
            Y20 := FALSE;
            Y21 := TRUE; 
            Y22 := FALSE;

            D20 := D101 * 100;
            D24 := 0;
            D28 := 0;

            D21 := 1000; (* 100% rate *)
            D25 := 1000;
            D29 := 1000;

            IF ABS(D10 - D20) <= 20 AND ABS(D12) <= 20 AND ABS(D14) <= 20 THEN
                Y20 := TRUE;
                Y22 := TRUE;
                timer(IN := TRUE, PT := INT_TO_TIME(0)); 
            ELSE
                timer(IN := FALSE, PT := INT_TO_TIME(0)); 
            END_IF

            IF timer.Q THEN
                first_task_done := TRUE;
                current_task := 1;
            END_IF

        1: (* Prepare for second task: Moving to second port *)
            Y20 := FALSE;
            Y21 := TRUE; 
            Y22 := FALSE;

            D20 := D102 * 100;
            D24 := D103 * 100;
            D28 := D104 * 100;

            D21 := 1000; (* 100% rate *)
            D25 := 1000;
            D29 := 1000;

            IF ABS(D10 - D20) <= 20 AND ABS(D12 - D24) <= 20 AND ABS(D14 - D28) <= 20 THEN
                Y20 := TRUE;
                Y22 := TRUE;
                timer(IN := TRUE, PT := INT_TO_TIME(0)); 
            ELSE
                timer(IN := FALSE, PT := INT_TO_TIME(0)); 
            END_IF

            IF timer.Q THEN
                second_task_done := TRUE;
                current_task := 2;
            END_IF

        2: (* Move back to initial position A=B=C=0 *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;

            D20 := 0;
            D24 := 0;
            D28 := 0;

            D21 := 1000; (* 100% rate *)
            D25 := 1000;
            D29 := 1000;

            IF ABS(D10) <= 20 AND ABS(D12) <= 20 AND ABS(D14) <= 20 THEN
                Y20 := TRUE;
                Y21 := TRUE;
                Y22 := TRUE;
                timer(IN := TRUE, PT := INT_TO_TIME(0)); 
            ELSE
                timer(IN := FALSE, PT := INT_TO_TIME(0)); 
            END_IF

            IF timer.Q THEN
                completion_request := TRUE;
                current_task := 3;
            END_IF

        3: (* Completion check *)
            completion_timer(IN := completion_request, PT := T#100ms);
            IF completion_timer.Q THEN
                Y2 := TRUE;
            ELSE
                Y2 := FALSE;
            END_IF
    END_CASE
ELSE
    (* Reset all outputs if start signal is not activated *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D20 := 0;
    D21 := 0;
    D24 := 0;
    D25 := 0;
    D28 := 0;
    D29 := 0;
    Y2 := FALSE;
    first_task_done := FALSE;
    second_task_done := FALSE;
    current_task := 0;
    timer(IN := FALSE, PT := INT_TO_TIME(0)); 
    completion_timer(IN := FALSE, PT := T#100ms);
    completion_request := FALSE;
END_IF

END_PROGRAM