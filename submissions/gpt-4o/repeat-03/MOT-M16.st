PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT; (* a_target *)
    D21 : DINT; (* a_rate *)
    Y20 : BOOL; (* a_enable *)
    D24 : DINT; (* b_target *)
    D25 : DINT; (* b_rate *)
    Y21 : BOOL; (* b_enable *)
    Y30 : BOOL; (* module_request *)
    Y2 : BOOL; (* completion *)
    
    a_at_target : BOOL := FALSE;
    b_at_depth : BOOL := FALSE;
    request_sent : BOOL := FALSE;
    completion_confirmed : BOOL := FALSE;
    timer : TON;
    start_signal_edge : R_TRIG;
END_VAR

(* Detect rising edge of X0 start signal *)
start_signal_edge(CLK := X0);

(* Check if axes A and B are at target positions *)
a_at_target := (ABS(D10 - D101) <= 20) AND (ABS(D11) <= 100);
b_at_depth := (ABS(D12 - D102) <= 20) AND (ABS(D13) <= 100);

(* Control logic execution *)
IF start_signal_edge.Q THEN
    (* Activate axes if start is received *)
    Y20 := TRUE;
    Y21 := TRUE;

    D20 := D101; (* Set A target *)
    D21 := 1000; (* Set A rate to 100% *)

    D24 := D102; (* Set B target *)
    D25 := 1000; (* Set B rate to 100% *)
    
    request_sent := FALSE;
    completion_confirmed := FALSE;
    Y2 := FALSE;
ELSIF a_at_target AND b_at_depth AND NOT X34 AND NOT request_sent THEN
    (* Both axes at the target, module is not busy, and request not sent yet *)
    Y30 := TRUE;
    request_sent := TRUE;
ELSIF request_sent AND NOT X34 THEN
    (* Request sent and waiting for module *)
    Y30 := FALSE;
    IF X35 AND NOT completion_confirmed THEN
        (* Confirm module completion *)
        completion_confirmed := TRUE;
        timer(IN := TRUE, PT := T#100ms);
    END_IF
ELSIF completion_confirmed AND timer.Q THEN
    (* Retract B to 0 after confirming completion *)
    D24 := 0; (* Set B target to 0 *)
    D25 := 1000; (* Set B rate to 100% *)
    IF D12 = 0 AND ABS(D13) <= 100 THEN
        (* B is fully retracted *)
        Y2 := TRUE;
    END_IF
END_IF

(* Ensure Y2 is reset after the maintenance interval *)
IF Y2 THEN
    timer(IN := TRUE, PT := T#100ms);
    IF timer.Q THEN
        Y2 := FALSE;
    END_IF
END_IF
    
END_PROGRAM