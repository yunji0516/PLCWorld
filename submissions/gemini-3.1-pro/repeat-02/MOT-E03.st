PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    timer_30ms : TON;
    timer_100ms : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    (* Apply maximum permitted deceleration command to safely stop before the limit *)
    D20 := 400000; 
    
    (* Check if actual speed is at or below 1 mm/s (100 in 0.01 mm/s units) *)
    timer_30ms(IN := (ABS(D12) <= 100), PT := T#30ms);
    
    (* After maintaining the result for 30 ms, latch Y2 TRUE *)
    IF timer_30ms.Q THEN
        Y2 := TRUE;
    END_IF;
    
    (* Observe the hold result for 100 ms *)
    timer_100ms(IN := (Y2 AND (ABS(D12) <= 100)), PT := T#100ms);
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    timer_30ms(IN := FALSE, PT := T#30ms);
    timer_100ms(IN := FALSE, PT := T#100ms);
END_IF;

END_PROGRAM