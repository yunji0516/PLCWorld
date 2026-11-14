PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    state : INT := 0;
    prev_state : INT := 0;
    timer30 : TON;
    timer100 : TON;
    captured_val : DINT := 0;
END_VAR

prev_state := state;

IF state = 0 AND X10 THEN
    state := 1;
END_IF;

(* Wait for 1 scan in state 1 before accepting X11 to ensure Y20 has been physically applied and hardware has cleared any stale captures. *)
IF state = 1 AND X11 AND prev_state = 1 THEN
    captured_val := D14;
    state := 2;
END_IF;

timer30(IN := (state >= 2), PT := T#30ms);
IF state = 2 AND timer30.Q THEN
    state := 3;
END_IF;

timer100(IN := (state >= 3), PT := T#100ms);
IF state = 3 AND timer100.Q THEN
    state := 4;
END_IF;

(* Output mapping *)
Y20 := (state >= 1);
Y21 := (state >= 2);
Y2 := (state >= 3);

IF state >= 2 THEN
    D20 := captured_val;
END_IF;

END_PROGRAM