PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    (* Internal variables *)
    state : INT := 0;
    position_tolerance : REAL := 0.2;
    speed_tolerance : REAL := 1.0;
    a_position_actual : REAL;
    b_position_actual : REAL;
    c_position_actual : REAL;
    d_position_actual : REAL;
    b_retraction : BOOL := FALSE;
    timer : TON;
    assert_completion_time : TIME := T#15s;
    stabilize_time : TIME := T#100ms;
    completed_mark : BOOL := FALSE;
END_VAR

(* Helper function to check position and velocity tolerance *)
FUNCTION IsPositionInTolerance
VAR_INPUT
    target : DINT;
    actual : REAL;
END_VAR_INPUT
VAR_OUTPUT
    result : BOOL;
END_VAR_OUTPUT
result := ABS(REAL(target) - actual) <= position_tolerance;
END_FUNCTION

(* Helper function to check velocity tolerance *)
FUNCTION IsVelocityInTolerance
VAR_INPUT
    velocity : DINT;
END_VAR_INPUT
VAR_OUTPUT
    result : BOOL;
END_VAR_OUTPUT
result := ABS(velocity) <= speed_tolerance;
END_FUNCTION

(* Main control logic *)

IF NOT X0 THEN
    (* Disable all axes when start signal is not active *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    state := 0;
    b_retraction := FALSE;
ELSE
    (* Read actual positions *)
    a_position_actual := REAL(D10) / 100.0;
    b_position_actual := REAL(D12) / 100.0;
    c_position_actual := REAL(D14) / 100.0;
    d_position_actual := REAL(D16) / 100.0;

    CASE state OF
        0: (* Prepare for start *)
            IF X0 THEN
                (* Set targets for base and lateral alignment *)
                D28 := 0 * 100; (* C=0 *)
                D29 := 1000; (* Full rate *)
                Y22 := TRUE;

                D32 := D103; (* D=lane *)
                D33 := 1000; (* Full rate *)
                Y23 := TRUE;

                state := 1;
            END_IF

        1: (* Move to first position *)
            IF IsPositionInTolerance(D28, c_position_actual) AND
               IsVelocityInTolerance(D15) AND
               IsPositionInTolerance(D32, d_position_actual) AND
               IsVelocityInTolerance(D17) THEN

                D20 := D101; (* A=first *)
                D21 := 1000; (* Full rate *)
                Y20 := TRUE;

                D24 := 70 * 100; (* B=70 *)
                D25 := 1000; (* Full rate *)
                Y21 := TRUE;

                state := 2;
            END_IF

        2: (* Confirm first position reached *)
            IF IsPositionInTolerance(D20, a_position_actual) AND
               IsVelocityInTolerance(D11) AND
               IsPositionInTolerance(D24, b_position_actual) AND
               IsVelocityInTolerance(D13) AND
               NOT b_retraction THEN

                D20 := D102; (* A=second *)
                state := 3;
            END_IF

        3: (* Confirm second stop *)
            IF IsPositionInTolerance(D20, a_position_actual) AND
               IsVelocityInTolerance(D11) THEN
                b_retraction := TRUE;
                state := 4;
                TON(timer(IN := TRUE, PT := assert_completion_time));
            END_IF

        4: (* Retract after confirmation *)
            IF b_retraction THEN
                D24 := 0; 
                D25 := 1000;
                Y21 := TRUE;

                D28 := 80 * 100;
                D29 := 1000;
                Y22 := TRUE;

                D32 := 0;
                D33 := 1000;
                Y23 := TRUE;

                IF timer.Q THEN
                    completed_mark := TRUE;
                    state := 5;
                END_IF
            END_IF

        5: (* Maintain completion marking *)
            TON(timer(IN := completed_mark, PT := stabilize_time));
            IF timer.Q THEN
                Y2 := TRUE;
            ELSE
                Y2 := FALSE;
            END_IF
    END_CASE
END_IF

END_PROGRAM