PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;
    
    req_latch : BOOL := FALSE;
    initial_pos : DINT := 0;
    maintain_timer : TON;
    retention_timer : TON;
    brake_engaged : BOOL := FALSE;
    y2_set : BOOL := FALSE;
END_VAR

IF X10 AND NOT req_latch THEN
    req_latch := TRUE;
    initial_pos := D11;
END_IF;

Y20 := req_latch;

IF req_latch AND X11 AND NOT X12 THEN
    brake_engaged := TRUE;
END_IF;

maintain_timer(IN := brake_engaged AND ABS(D11 - initial_pos) <= 2, PT := T#30ms);

IF maintain_timer.Q THEN
    y2_set := TRUE;
END_IF;

Y2 := y2_set;

retention_timer(IN := y2_set, PT := T#100ms);

END_PROGRAM