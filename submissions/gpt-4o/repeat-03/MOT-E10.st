PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Internal variables *)
    target_position : DINT;
    reached_target : BOOL := FALSE;
    speed_within_limit : BOOL := FALSE;
    holding_timer : TON;
    result_timer : TON;
    command_value : DINT;
    commanded_position : DINT;
END_VAR

(* Implement the control logic here. *)

(* Check if the function request is active *)
IF X10 THEN
    (* Calculate the target position in raw units *)
    target_position := D10;

    (* Ensure the target is within request and command bounds *)
    target_position := LIMIT(-4500, 9000, target_position);

    (* Calculate the commanded position in raw units *)
    commanded_position := target_position * 1;  (* response coefficient assumed to be 1 for simplicity *)

    (* Ensure commanded position is within the Permitted commands range *)
    command_value := LIMIT(-200000, 200000, commanded_position);

    (* Drive active state and command value *)
    Y20 := TRUE;
    D20 := command_value;

    (* Check for completion conditions: angle error and speed *)
    reached_target := ABS(D11 - target_position) <= 20;  (* Error ≤ 0.2°, scaled by 0.01 *)
    speed_within_limit := ABS(D12) <= 100;                (* Speed ≤ 1°/s, scaled by 0.01 *)

    IF reached_target AND speed_within_limit THEN
        (* Start holding timer for 30ms *)
        holding_timer(IN := TRUE, PT := T#30ms);
    ELSE
        holding_timer(IN := FALSE);
    END_IF;

    (* Check if holding condition is met *)
    IF holding_timer.Q THEN
        (* Activate function result retention *)
        Y2 := TRUE;

        (* Start result observation timer for 100ms *)
        result_timer(IN := TRUE, PT := T#100ms);
    ELSE
        result_timer(IN := FALSE);
    END_IF;

    (* Deactivate function if result retention observation is completed *)
    IF result_timer.Q THEN
        Y20 := FALSE;
    END_IF;
ELSE
    (* Reset outputs if function request is not active *)
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    holding_timer(IN := FALSE);
    result_timer(IN := FALSE);
END_IF;

END_PROGRAM