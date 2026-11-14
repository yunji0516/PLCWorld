PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    captured      : BOOL := FALSE;
    dir           : DINT := 0;      (* +1 if moving in increasing position direction, -1 if decreasing *)
    active        : BOOL := FALSE; (* latched once request accepted *)
    exceeded_lim  : BOOL := FALSE;
    condition_met : BOOL := FALSE;
    achieved30    : BOOL := FALSE;

    v_phys        : REAL := 0.0;
    remaining_phys: REAL := 0.0;
    a_req         : REAL := 0.0;

    stab_timer    : TON;
END_VAR

(* --- capture initial direction of motion on the first scan --- *)
IF NOT captured THEN
    IF D12 > 0 THEN
        dir := 1;
    ELSIF D12 < 0 THEN
        dir := -1;
    ELSE
        dir := 0;
    END_IF;
    captured := TRUE;
END_IF;

(* --- activation latch: only activate after X10 request is accepted --- *)
IF X10 THEN
    active := TRUE;
END_IF;

Y20 := active;

(* --- determine whether limit has been exceeded, based on captured direction --- *)
IF dir = 1 THEN
    exceeded_lim := D11 > D13;
ELSIF dir = -1 THEN
    exceeded_lim := D11 < D13;
ELSE
    exceeded_lim := FALSE;
END_IF;

(* --- compute deceleration command while active --- *)
IF active THEN
    v_phys := REAL(D12) * 0.01;
    remaining_phys := REAL(ABS(D13 - D11)) * 0.01;

    IF remaining_phys > 0.01 THEN
        a_req := (v_phys * v_phys) / (2.0 * remaining_phys);
    ELSE
        a_req := 6000.0;
    END_IF;

    a_req := LIMIT(0.0, a_req, 6000.0);

    D20 := DINT(a_req * 100.0);

    IF D20 > 400000 THEN
        D20 := 400000;
    ELSIF D20 < 0 THEN
        D20 := 0;
    END_IF;
ELSE
    D20 := 0;
END_IF;

(* --- completion condition: speed at or below 1 mm/s and limit not exceeded --- *)
condition_met := active AND (ABS(D12) <= 100) AND (NOT exceeded_lim);

stab_timer(IN := condition_met, PT := T#30ms);

IF stab_timer.Q THEN
    achieved30 := TRUE;
END_IF;

IF achieved30 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM