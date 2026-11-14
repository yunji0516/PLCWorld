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
    target_reached : BOOL := FALSE;
    head_positioned : BOOL := FALSE;
    return_started : BOOL := FALSE;
    completion_timer : TON;
    completion_confirmed : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
IF X0 THEN
    IF NOT target_reached THEN
        (* Retract the feeder to A = 0 *)
        Y20 := FALSE;  (* Disable to set target without motion *)
        D20 := 0;      (* Set feeder target position A = 0 *)
        D21 := 1000;   (* Set feeder rate to maximum *)
        Y20 := TRUE;   (* Enable motion *)
        
        (* Position the head: B = 90, C = request_target, D = 0 *)
        Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;  (* Disable axes to set targets *)
        D24 := 9000;  (* Set B target position (90 degrees * 100) *)
        D25 := 1000;  (* Set B rate to maximum *)
        D28 := D101;  (* Set C target position to requested target *)
        D29 := 1000;  (* Set C rate to maximum *)
        D32 := 0;     (* Set D target position to 0 *)
        D33 := 1000;  (* Set D rate to maximum *)
        Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;  (* Enable axis motion *)

        (* Check for target position reached *)
        IF ABS(D10 - 0) <= 20 THEN
            IF ABS(D12 - 9000) <= 20 AND ABS(D14 - D101) <= 20 AND ABS(D16 - 0) <= 20 THEN
                IF ABS(D11) <= 100 AND ABS(D13) <= 100 AND ABS(D15) <= 100 AND ABS(D17) <= 100 THEN
                    target_reached := TRUE;
                END_IF;
            END_IF;
        END_IF;
    ELSIF target_reached AND NOT head_positioned THEN
        (* Keep feeder stopped until head positioning completed *)
        IF ABS(D10 - 28000) <= 20 THEN
            head_positioned := TRUE;
            return_started := FALSE;
        END_IF;
    ELSE
        (* Begin return motion if within return valid states *)
        IF ((ABS(D12) <= 20 AND D16 = 10000) OR return_started) AND head_positioned THEN
            return_started := TRUE;
            (* Return to initial position A=280, B=C=0, D=100 *)
            Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;  (* Disable all axes *)
            D20 := 28000; D21 := 1000;  (* Set feeder target A = 280 *)
            D24 := 0; D25 := 1000;      (* Set B target position 0 *)
            D28 := 0; D29 := 1000;      (* Set C target position 0 *)
            D32 := 10000; D33 := 1000;  (* Set D target position 100 *)
            Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;  (* Enable motion *)
            
            (* Check for completion condition *)
            IF ABS(D10 - 28000) <= 20 AND ABS(D12) <= 20 AND ABS(D14) <= 20 AND ABS(D16 - 10000) <= 20 THEN
                completion_timer(IN := TRUE, PT := T#15s);
                IF completion_timer.Q THEN
                    completion_confirmed := TRUE;
                END_IF;
            ELSE
                completion_timer(IN := FALSE);
            END_IF;
        END_IF;
    END_IF;

    (* Assert completion signal when all conditions met *)
    IF completion_confirmed THEN
        Y2 := TRUE;
    END_IF;
ELSE
    (* Reset states when start isn't active or after completion *)
    target_reached := FALSE;
    head_positioned := FALSE;
    return_started := FALSE;
    completion_confirmed := FALSE;
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y2 := FALSE;
    completion_timer(IN := FALSE);
END_IF;

END_PROGRAM