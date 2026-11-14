PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    activated : BOOL := FALSE;
    stable_count : INT := 0;
    y2_set : BOOL := FALSE;
    diff_vel : DINT;
    abs_diff_vel : DINT;
    abs_d17 : DINT;
    ratio_captured : DINT;
END_VAR

(* Compute velocity error metric: |1000*D12 - ratio_captured*D14| *)
(* vS = D12/100, vU = D14/100, ratio = ratio_captured/1000 *)
(* |vS - ratio*vU| = |1000*D12 - ratio_captured*D14| / 100000 *)
(* Limit: <= 2 deg/s  =>  |...| <= 200000 *)
diff_vel := 1000 * D12 - ratio_captured * D14;
IF diff_vel < 0 THEN
    abs_diff_vel := -diff_vel;
ELSE
    abs_diff_vel := diff_vel;
END_IF;

(* Compute phase error magnitude: |D17| *)
(* D17 is relationship error x0.01, limit 0.3 deg => |D17| <= 30 *)
IF D17 < 0 THEN
    abs_d17 := -D17;
ELSE
    abs_d17 := D17;
END_IF;

IF X10 AND NOT activated THEN
    (* First acceptance of request: activate function and capture ratio *)
    activated := TRUE;
    ratio_captured := D10;
    Y20 := TRUE;
    D20 := D10;
    stable_count := 0;
    y2_set := FALSE;
ELSIF X10 AND activated THEN
    (* Keep ratio command current *)
    D20 := ratio_captured;
    
    (* Check completion conditions *)
    IF abs_d17 <= 30 AND abs_diff_vel <= 200000 THEN
        stable_count := stable_count + 1;
        IF stable_count >= 3 THEN
            (* 30 ms stability achieved (3 scans x 10 ms) *)
            y2_set := TRUE;
            Y2 := TRUE;
        END_IF;
    ELSE
        (* Conditions lost, reset counters *)
        stable_count := 0;
        y2_set := FALSE;
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM