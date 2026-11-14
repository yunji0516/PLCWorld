PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;

    (* internal *)
    req_latched     : BOOL := FALSE;
    initial_captured : BOOL := FALSE;
    initial_pos     : DINT := 0;
    pos_ok          : BOOL := FALSE;
    result_ok       : BOOL := FALSE;
    result_timer    : TON;
    obs_timer       : TON;
    y2_latched      : BOOL := FALSE;
    done            : BOOL := FALSE;
    pos_tol         : DINT := 20; (* 0.2 mm at x0.01 scaling *)
END_VAR

(* Capture the initial stopped height once, on the very first scan *)
IF NOT initial_captured THEN
    initial_pos := D11;
    initial_captured := TRUE;
END_IF;

(* Latch request acceptance; do not activate before X10 request accepted *)
IF X10 THEN
    req_latched := TRUE;
END_IF;

(* Function activation/retention: engage the brake once request accepted *)
Y20 := req_latched;

(* Evaluate maintained-result condition: brake engaged, torque support released,
   and actual height held within +/-0.2 mm of the initial value *)
pos_ok := (D11 >= (initial_pos - pos_tol)) AND (D11 <= (initial_pos + pos_tol));
result_ok := X11 AND (NOT X12) AND pos_ok;

(* 30 ms continuous stability timer and 100 ms total observation timer,
   both reset whenever the result condition is not held *)
result_timer(IN := result_ok, PT := T#30ms);
obs_timer(IN := result_ok, PT := T#100ms);

IF NOT done THEN
    IF result_timer.Q THEN
        y2_latched := TRUE;
    END_IF;

    IF NOT result_ok THEN
        y2_latched := FALSE;
    END_IF;

    IF obs_timer.Q THEN
        done := TRUE;
        y2_latched := TRUE;
    END_IF;

    Y2 := y2_latched;
ELSE
    (* Post-claim maintenance: hold the completed result *)
    Y2 := TRUE;
END_IF;

END_PROGRAM