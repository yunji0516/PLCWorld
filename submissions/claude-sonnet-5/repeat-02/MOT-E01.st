PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    request_accepted : BOOL := FALSE;
    y2_latch : BOOL := FALSE;
    pos_err : DINT := 0;
    pos_ok : BOOL := FALSE;
    speed_ok : BOOL := FALSE;
    both_ok : BOOL := FALSE;
    target_clamped : DINT := 0;
    stab_timer : TON;
    obs_timer : TON;
END_VAR

(* Latch request acceptance once X10 is seen TRUE *)
IF X10 THEN
    request_accepted := TRUE;
END_IF;

(* Function activation/retention and command output, gated by request acceptance *)
IF request_accepted THEN
    target_clamped := D10;
    IF target_clamped > 200000 THEN
        target_clamped := 200000;
    ELSIF target_clamped < -200000 THEN
        target_clamped := -200000;
    END_IF;

    D20 := target_clamped;
    Y20 := TRUE;
ELSE
    D20 := 0;
    Y20 := FALSE;
END_IF;

(* Compute position error (raw units, x0.01 mm) and speed check *)
pos_err := D11 - D10;
IF pos_err < 0 THEN
    pos_err := -pos_err;
END_IF;

pos_ok := pos_err <= 20;          (* <= 0.2 mm *)
speed_ok := ABS(D12) <= 100;      (* <= 1 mm/s *)
both_ok := pos_ok AND speed_ok;

(* Stability timer: require condition held for 30 ms while request is active *)
stab_timer(IN := (both_ok AND request_accepted), PT := T#30ms);

IF stab_timer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

(* Observation timer: once Y2 latched, observe retention for 100 ms *)
obs_timer(IN := y2_latch, PT := T#100ms);

END_PROGRAM