PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    req_mem : BOOL;
    home_finished : BOOL;
    comp_cond : BOOL;
    stab_timer : TON;
END_VAR

(* Remember the work request *)
IF X10 THEN
    req_mem := TRUE;
END_IF;

(* Activate Home execution once requested, until it finishes *)
IF req_mem AND NOT home_finished THEN
    Y21 := TRUE;
END_IF;

(* Check for completion signaled by the drive, then deactivate Home command *)
IF Y21 AND X13 AND X11 THEN
    home_finished := TRUE;
    Y21 := FALSE;
END_IF;

(* 
   Completion condition definition: 
   - New reference setting (X11)
   - Home deactivation (NOT Y21 AND NOT X12)
   - Actual stop (ABS(D12) <= 100, which matches the 1 mm/s arrival speed tolerance)
*)
comp_cond := home_finished AND X11 AND NOT Y21 AND NOT X12 AND (ABS(D12) <= 100);

(* Maintain the completion condition for 30 ms *)
stab_timer(IN := comp_cond, PT := T#30ms);

IF stab_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM