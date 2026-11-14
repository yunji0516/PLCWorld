PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    func_activated : BOOL;
    cond_met_timer : TON;
END_VAR

(* Function activation on request *)
IF X10 AND NOT func_activated THEN
    func_activated := TRUE;
END_IF;

Y20 := func_activated;

(* Command generation when activated *)
IF func_activated THEN
    (* Position command: master (S) position + requested offset *)
    D20 := D11 + D10;
    (* Feedforward velocity: master (S) velocity *)
    D21 := D12;
    
    (* Clamp D20 to permitted command bounds *)
    IF D20 > 200000 THEN
        D20 := 200000;
    ELSIF D20 < -200000 THEN
        D20 := -200000;
    END_IF;
    
    (* Clamp D21 to permitted command bounds *)
    IF D21 > 200000 THEN
        D21 := 200000;
    ELSIF D21 < -200000 THEN
        D21 := -200000;
    END_IF;
END_IF;

(* Completion monitoring *)
IF func_activated THEN
    (* Check relative position error <= 0.3 mm (=30 in raw x0.01 units)
       and relative velocity error <= 2 mm/s (=200 in raw x0.01 units) *)
    cond_met_timer(IN := (ABS(D11 + D10 - D13) <= 30) AND (ABS(D12 - D14) <= 200), PT := T#30ms);
    
    (* Once conditions maintained for 30 ms, set Y2 TRUE *)
    IF cond_met_timer.Q THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM