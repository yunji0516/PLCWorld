PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;
    (* Internal variables. *)
    a_position_target : DINT := 20000; (* Starting position 200 mm x 100 for scaling *)
    b_position_target : DINT := 9000;  (* Starting angle 90 degrees x 100 for scaling *)
    moving_forward : BOOL := TRUE;     (* Movement direction flag *)
    timer : TON;
    completion_timer : TON;
    edge : R_TRIG;
END_VAR

IF NOT X0 THEN
    (* When start is not pressed, ensure axes are disabled. *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
ELSE
    IF NOT Y20 THEN
        (* Initial command on start: enable axes. *)
        Y20 := TRUE;
        Y21 := TRUE;
    END_IF

    IF moving_forward THEN
        IF D10 >= 50000 THEN
            (* Set target for turn at corner. *)
            a_position_target := 50000;
            b_position_target := 9000;
            timer(IN := TRUE, PT := T#10ms); (* Stop at corner *)
        ELSE
            (* Forward movement towards request target *)
            a_position_target := D101;
            b_position_target := 9000;
        END_IF

        (* Check arrival at the forward target position *)
        IF ABS(D10 - a_position_target) <= 20 AND ABS(D11) <= 100 THEN
            moving_forward := FALSE;  (* Switch direction to backward *)
        END_IF
    ELSE
        IF D10 <= 20000 THEN
            (* Set target for home. *)
            a_position_target := 20000;
            b_position_target := 0;
        ELSE
            (* Move backward towards the initial position *)
            a_position_target := 20000;
            b_position_target := 9000;
        END_IF

        (* Check arrival at the backward target position *)
        IF ABS(D10 - a_position_target) <= 20 AND ABS(D11) <= 100 THEN
            IF NOT edge.Q THEN
                timer(IN := TRUE, PT := T#15s); (* Start completion timer *)
                edge(CLK := TRUE);
            END_IF

            completion_timer(IN := TRUE, PT := T#100ms); (* Completion hold duration *)
            IF completion_timer.Q THEN
                Y2 := TRUE; (* Mark completion *)
            END_IF
        ELSE
            edge(CLK := FALSE);
            Y2 := FALSE; (* Reset completion signal if not complete *)
        END_IF
    END_IF

    (* Apply targets to outputs *)
    D20 := a_position_target;
    D21 := 1000; (* Full speed rate *)
    D24 := b_position_target;
    D25 := 1000; (* Full speed rate *)
END_IF

END_PROGRAM