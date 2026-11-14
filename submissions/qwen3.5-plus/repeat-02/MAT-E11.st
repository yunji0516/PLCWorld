PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Internal variables *)
    started : BOOL := FALSE;
    complete_claimed : BOOL := FALSE;
    edge_val : INT;
END_VAR

(* Detect start rising edge on X10 *)
IF NOT started AND X10 THEN
    started := TRUE;
END_IF;

(* Active control: keep edge within ±12 mm during feed *)
IF started AND NOT complete_claimed THEN
    edge_val := D20;  (* Current edge error measurement *)
    
    IF edge_val > 12 THEN
        (* Edge too far right, steer left *)
        Y20 := TRUE;
        Y21 := FALSE;
    ELSIF edge_val < -12 THEN
        (* Edge too far left, steer right *)
        Y20 := FALSE;
        Y21 := TRUE;
    ELSE
        (* Edge within bounds, no steering needed *)
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;
END_IF;

(* Completion check: external feed done, steering OFF, edge valid *)
IF NOT complete_claimed AND X20 AND NOT Y20 AND NOT Y21 THEN
    edge_val := D20;
    IF edge_val >= -12 AND edge_val <= 12 THEN
        complete_claimed := TRUE;
        Y2 := TRUE;
    END_IF;
END_IF;

(* Ensure steering commands are OFF when not in active control *)
IF NOT started OR complete_claimed THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

END_PROGRAM