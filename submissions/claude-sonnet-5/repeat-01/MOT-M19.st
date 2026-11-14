PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    (* internal working variables *)
    x0_trig : R_TRIG;
    holdTimer : TON;
    approved : BOOL := FALSE;
    state : INT := 0;
    firstTarget : DINT := 0;
    secondTarget : DINT := 0;
    laneTarget : DINT := 0;
    c_ok : BOOL;
    d_ok : BOOL;
    a_first_ok : BOOL;
    a_second_ok : BOOL;
    b_engaged : BOOL;
    pos_tol : DINT := 20;
    vel_tol : DINT := 100;
    rate_full : DINT := 1000;
    b_engage_target : DINT := 7000;
    c_work_target : DINT := 0;
    c_final_target : DINT := 8000;
    a_final_target : DINT := 6000;
    d_final_target : DINT := 0;
END_VAR

(* Approval latch: enabling only permitted after X0 request has been seen *)
IF X0 THEN
    approved := TRUE;
END_IF;

x0_trig(CLK := X0);
IF x0_trig.Q THEN
    firstTarget := D101;
    secondTarget := D102;
    laneTarget := D103;
END_IF;

(* Status flags derived from currently sampled inputs *)
c_ok := (ABS(D14 - c_work_target) <= pos_tol) AND (ABS(D15) <= vel_tol);
d_ok := (ABS(D16 - laneTarget) <= pos_tol) AND (ABS(D17) <= vel_tol);
a_first_ok := (ABS(D10 - firstTarget) <= pos_tol) AND (ABS(D11) <= vel_tol);
a_second_ok := (ABS(D10 - secondTarget) <= pos_tol) AND (ABS(D11) <= vel_tol);
b_engaged := (D12 >= 6000) AND (D12 <= 7500);

(* State transitions *)
IF NOT approved THEN
    state := 0;
ELSE
    CASE state OF
        0:
            state := 1;
        1:
            IF c_ok AND d_ok THEN
                state := 2;
            END_IF;
        2:
            IF NOT (c_ok AND d_ok) THEN
                state := 1;
            ELSIF a_first_ok AND b_engaged THEN
                state := 3;
            END_IF;
        3:
            IF NOT (c_ok AND d_ok AND b_engaged) THEN
                state := 2;
            ELSIF a_second_ok THEN
                state := 4;
            END_IF;
        4:
            IF NOT (c_ok AND d_ok AND b_engaged AND a_second_ok) THEN
                state := 2;
            END_IF;
        5:
            ; // hold final state
    END_CASE;
END_IF;

(* Completion hold timer: Y2 must remain valid for 100 ms while at second stop *)
holdTimer(IN := (state = 4), PT := T#100ms);
IF (state = 4) AND holdTimer.Q THEN
    state := 5;
END_IF;

(* Output assignment based on current state *)
CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2  := FALSE;
        D20 := firstTarget;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        D28 := c_work_target;
        D29 := 0;
        D32 := laneTarget;
        D33 := 0;
    1:
        Y20 := TRUE;
        D20 := firstTarget;
        D21 := rate_full;
        Y22 := TRUE;
        D28 := c_work_target;
        D29 := rate_full;
        Y23 := TRUE;
        D32 := laneTarget;
        D33 := rate_full;
        Y21 := FALSE;
        D24 := 0;
        D25 := 0;
        Y2 := FALSE;
    2, 3:
        Y20 := TRUE;
        D21 := rate_full;
        IF state = 2 THEN
            D20 := firstTarget;
        ELSE
            D20 := secondTarget;
        END_IF;
        Y22 := TRUE;
        D28 := c_work_target;
        D29 := rate_full;
        Y23 := TRUE;
        D32 := laneTarget;
        D33 := rate_full;
        Y21 := TRUE;
        D24 := b_engage_target;
        D25 := rate_full;
        Y2 := FALSE;
    4:
        Y20 := TRUE;
        D20 := secondTarget;
        D21 := rate_full;
        Y22 := TRUE;
        D28 := c_work_target;
        D29 := rate_full;
        Y23 := TRUE;
        D32 := laneTarget;
        D33 := rate_full;
        Y21 := TRUE;
        D24 := b_engage_target;
        D25 := rate_full;
        Y2 := TRUE;
    5:
        Y2 := TRUE;
        Y21 := TRUE;
        D24 := 0;
        D25 := rate_full;
        Y22 := TRUE;
        D28 := c_final_target;
        D29 := rate_full;
        Y20 := TRUE;
        D20 := a_final_target;
        D21 := rate_full;
        Y23 := TRUE;
        D32 := d_final_target;
        D33 := rate_full;
END_CASE;

END_PROGRAM