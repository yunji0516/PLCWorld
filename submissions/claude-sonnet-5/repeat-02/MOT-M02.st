PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;

    (* internal *)
    step          : INT := 0;
    target_dock   : DINT;
    target_park   : DINT;
    posDiffAB     : DINT;
    adjAB         : DINT;
    a_rate_calc   : DINT;
    b_rate_calc   : DINT;
    c_rate_calc   : DINT := 1000;

    pos_tol       : DINT := 20;   // 0.2 mm * 100
    vel_tol       : DINT := 100;  // 1 mm/s * 100

    cmd_min       : DINT := 0;
    a_cmd_max     : DINT := 50000; // 500 mm * 100
    b_cmd_max     : DINT := 50000;
    c_cmd_max     : DINT := 90000; // 900 mm * 100

    latch_eng_timer : TON;
    latch_rel_timer : TON;
END_VAR

(* ---- clamp requested targets to permitted command ranges ---- *)
target_dock := LIMIT(cmd_min, a_cmd_max, D101);
target_park := LIMIT(cmd_min, c_cmd_max, D102);

(* ---- synchronization control for A/B rate to keep |A-B| small ---- *)
posDiffAB := D10 - D12;
adjAB := LIMIT(-500, 500, posDiffAB / 2);
a_rate_calc := LIMIT(100, 1000, 1000 - adjAB);
b_rate_calc := LIMIT(100, 1000, 1000 + adjAB);

(* ---- latch timers, updated once per scan ---- *)
latch_eng_timer(IN := (step = 15), PT := T#250ms);
latch_rel_timer(IN := (step = 40), PT := T#250ms);

(* ---- main state machine ---- *)
CASE step OF

0: (* wait for start; no actuator enabled *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;
    Y30 := FALSE; Y31 := FALSE;
    D20 := 0; D24 := 0; D28 := 0;
    D21 := 1000; D25 := 1000; D29 := 1000;
    IF X0 THEN
        step := 10;
    END_IF;

10: (* drive beam (A,B) to requested dock position, latch open *)
    Y20 := TRUE; Y21 := TRUE; Y22 := FALSE;
    Y30 := FALSE; Y31 := FALSE;
    D20 := target_dock; D24 := target_dock;
    D21 := a_rate_calc; D25 := b_rate_calc;
    D28 := 0; D29 := 1000;
    IF X4 THEN
        step := 15;
    END_IF;

15: (* engage latch, beam held (disabled) *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;
    Y30 := TRUE; Y31 := FALSE;
    D20 := target_dock; D24 := target_dock;
    IF latch_eng_timer.Q AND X2 AND NOT X3 THEN
        step := 30;
    END_IF;

30: (* cart crosses to park position, latch remains engaged *)
    Y20 := FALSE; Y21 := FALSE; Y22 := TRUE;
    Y30 := TRUE; Y31 := FALSE;
    D28 := target_park; D29 := c_rate_calc;
    IF (ABS(D14 - D28) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        step := 40;
    END_IF;

40: (* cart parked and held, release latch *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;
    Y30 := FALSE; Y31 := TRUE;
    D28 := target_park;
    IF latch_rel_timer.Q AND X1 THEN
        step := 50;
    END_IF;

50: (* return empty beam (A,B) to origin *)
    Y20 := TRUE; Y21 := TRUE; Y22 := FALSE;
    Y30 := FALSE; Y31 := FALSE;
    D20 := 0; D24 := 0;
    D21 := a_rate_calc; D25 := b_rate_calc;
    IF (ABS(D10 - D20) <= pos_tol) AND (ABS(D11) <= vel_tol) AND
       (ABS(D12 - D24) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        step := 60;
    END_IF;

60: (* completed - hold, only completion output active *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;
    Y30 := FALSE; Y31 := FALSE;
    Y2  := TRUE;

ELSE
    step := 0;

END_CASE;

END_PROGRAM