PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    X20 : BOOL;
    D20 : INT;
    (* Add internal variables here. *)
    start_triggered : BOOL := FALSE;
    withdrawal_started : BOOL := FALSE;
    evaluation_time : INT := 0;
    holding_time : INT := 0;
END_VAR

(* Implement the control logic here. *)

IF X10 AND NOT start_triggered THEN
    (* Detect start request on rising edge of X10 *)
    start_triggered := TRUE;
END_IF

IF start_triggered AND D10 = 1 THEN
    (* Withdrawal process starts when one interval is ready *)
    Y20 := TRUE;  (* Start unwinding to supply material *)
    withdrawal_started := TRUE;
END_IF

IF withdrawal_started THEN
    (* Check buffer inventory and keep it within limits by adjusting unwind *)
    IF (D20 < 200) THEN
        Y20 := TRUE;  (* Supply more material if inventory falls below minimum *)
    ELSIF (D20 >= 700) THEN
        Y20 := FALSE; (* Stop supplying material if inventory reaches maximum *)
    END_IF

    IF X20 THEN
        (* External withdrawal has ended *)
        Y20 := FALSE; (* Stop supplying material *)
        evaluation_time := 0;  (* Reset evaluation timer *)
        start_triggered := FALSE;  (* Reset start trigger *)
        withdrawal_started := FALSE;  (* Reset withdrawal flag *)
        Y2 := TRUE;  (* Claim completion *)
    END_IF
END_IF

IF Y2 THEN
    (* Maintain completion claim for evaluation period *)
    evaluation_time := evaluation_time + 1;
    IF evaluation_time >= 1550 THEN
        holding_time := holding_time + 1;
        IF holding_time >= 50 THEN
            Y2 := FALSE;  (* Release completion claim after holding time *)
            evaluation_time := 0;  (* Reset timers for next cycle *)
            holding_time := 0;
        END_IF
    END_IF
END_IF

END_PROGRAM