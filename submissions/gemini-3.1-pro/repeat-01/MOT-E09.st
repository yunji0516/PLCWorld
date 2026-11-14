PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    timer : TON;
    target_pos : DINT;
    target_vel : DINT;
    sum_angles : DINT;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    (* C joint target compensates for A and B joints to maintain sum at 0 *)
    target_pos := -(D13 + D15);
    target_vel := -(D14 + D16);
    
    (* Limit commands to permitted raw bounds *)
    D20 := LIMIT(-200000, target_pos, 200000);
    D21 := LIMIT(-200000, target_vel, 200000);
    
    (* Check if actual tool orientation A+B+C is within +/- 2 degrees (+/- 200) *)
    sum_angles := D13 + D15 + D11;
    timer(IN := ABS(sum_angles) <= 200, PT := T#30ms);
    
    Y2 := timer.Q;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
    timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM