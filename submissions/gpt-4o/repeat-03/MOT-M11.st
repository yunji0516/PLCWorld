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

    (* Internal variables *)
    stage : INT := 0;
    first_angle : DINT;
    second_angle : DINT;
    depth1 : DINT;
    depth2 : DINT;
    tool_retracted_b : BOOL := TRUE;
    tool_retracted_c : BOOL := TRUE;
    tool_approached_b : BOOL := FALSE;
    tool_approached_c : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
IF X0 THEN
    CASE stage OF
        0:
            (* Prepare for first approach *)
            first_angle := D101;
            second_angle := D102;
            depth1 := D103;
            depth2 := D104;

            (* Ensure tools are retracted to start *)
            D24 := 0;  (* Retract B to 0 *)
            D28 := 0;  (* Retract C to 0 *)
            D21 := 1000;  (* Max speed for A *)
            D25 := 1000;  (* Max speed for B *)
            D29 := 1000;  (* Max speed for C *)
            Y21 := TRUE;
            Y22 := TRUE;
            Y20 := TRUE;

            IF ABS(D12) <= 2 AND ABS(D14) <= 2 THEN
                tool_retracted_b := TRUE;
                tool_retracted_c := TRUE;
                stage := 1;
            END_IF
            
        1:
            (* Move tool B into position *)
            IF tool_retracted_b AND NOT tool_approached_b THEN
                D20 := first_angle;  (* First angle position for A *)
                D24 := depth1;  (* Approach depth for B *)
                IF ABS(D10 - first_angle) <= 2 AND ABS(D12 - depth1) <= 2 THEN
                    tool_approached_b := TRUE;
                END_IF
            END_IF
            
            (* Move tool C into position *)
            IF tool_retracted_c AND tool_approached_b AND NOT tool_approached_c THEN
                D20 := second_angle;  (* Second angle position for A *)
                D28 := depth2;  (* Approach depth for C *)
                IF ABS(D10 - second_angle) <= 2 AND ABS(D14 - depth2) <= 2 THEN
                    tool_approached_c := TRUE;
                    stage := 2;
                END_IF
            END_IF

        2:
            (* Retract both tools *)
            IF tool_approached_b THEN
                D24 := 0;  (* Retract B *)
                IF ABS(D12) <= 2 THEN
                    tool_retracted_b := TRUE;
                END_IF
            END_IF
            IF tool_approached_c THEN
                D28 := 0;  (* Retract C *)
                IF ABS(D14) <= 2 THEN
                    tool_retracted_c := TRUE;
                END_IF
            END_IF

            IF tool_retracted_b AND tool_retracted_c THEN
                stage := 3;
            END_IF

        3:
            (* Completion signal *)
            Y2 := TRUE;
    END_CASE
ELSE
    (* Reset system when start is not requested *)
    D20 := 0;
    D21 := 0;
    Y20 := FALSE;
    D24 := 0;
    D25 := 0;
    Y21 := FALSE;
    D28 := 0;
    D29 := 0;
    Y22 := FALSE;
    Y2 := FALSE;
    stage := 0;
END_IF

END_PROGRAM