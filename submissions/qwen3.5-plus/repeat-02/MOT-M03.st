```st
PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    compl_timer : TON;
    
    request_seen : BOOL;
    follow_active : BOOL;
    fork_inserting : BOOL;
    fork_inserted : BOOL;
    alignment_ok : BOOL;
    completion_ok : BOOL;
END_VAR

BEGIN
    (* Detect task request *)
    IF X10 AND NOT request_seen THEN
        request_seen := TRUE;
    END_IF;

    (* Alignment check: relative position <= 0.20mm (20 in 0.01mm units),
       relative speed <= 1mm/s (100 in 0.01mm/s units) *)
    alignment_ok := (ABS(D11 - D13) <= 20) AND (ABS(D12 - D14) <= 100);

    (* Activate following mode on request *)
    IF request_seen AND NOT follow_active THEN
        follow_active := TRUE;
    END_IF;

    (* Following outputs: S tracks U position and speed *)
    Y20 := follow_active;
    D20 := D13;
    D21 := D14;

    (* Start fork insertion once aligned while following *)
    IF follow_active AND alignment_ok AND NOT fork_inserting THEN
        fork_inserting := TRUE;
    END_IF;

    (* Fork insertion command *)
    Y21 := fork_inserting;

    (* Latch fork insertion complete when endpoint sensor triggers *)
    IF fork_inserting AND X11 THEN
        fork_inserted := TRUE;
    END_IF;

    (* Completion: synchronized (aligned) with fork fully inserted *)
    completion_ok := alignment_ok AND fork_inserted;

    (* Completion requires continuous satisfaction for 100ms observation period *)
    compl_timer(IN := completion_ok, PT := T#100ms);
    Y2 := compl_timer.Q;

END_PROGRAM
```