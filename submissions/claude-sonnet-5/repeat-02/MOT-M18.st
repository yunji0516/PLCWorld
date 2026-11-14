PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
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
    Y2 : BOOL;

    (* Internal state *)
    state : INT := 0;
    edge_trig : R_TRIG;
    direction_positive : BOOL := TRUE;
    latched_A : DINT := 0;
    stop_target : DINT := 0;
    final_a_target : DINT := 0;

    pos_tol : DINT := 20;   (* 0.2 mm * 100 *)
    vel_tol : DINT := 100;  (* 1 mm/s * 100 *)

    search_rate : DINT := 120; (* slow search rate to guarantee <=10mm braking distance *)
    fast_rate   : DINT := 1000;
END_VAR

(* Update rising-edge detector every scan, in every state, so an
   already-ON initial condition is consumed before search begins *)
edge_trig(CLK := X34);

CASE state OF

0: (* WAIT_START : no enable before X0 *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y2  := FALSE;
    D20 := D10;
    D21 := fast_rate;
    D24 := D12;
    D25 := fast_rate;
    D28 := D14;
    D29 := fast_rate;
    IF X0 THEN
        state := 1;
    END_IF;

1: (* RETRACT_B : retract tool before raising, keep A,C untouched *)
    Y20 := FALSE;
    Y22 := FALSE;
    D20 := D10;
    D28 := D14;
    Y21 := TRUE;
    D24 := 0;
    D25 := fast_rate;
    IF (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        state := 2;
    END_IF;

2: (* RAISE_C : after B fully retracted, raise C to clear guard *)
    Y21 := TRUE;
    D24 := 0;
    D25 := fast_rate;
    Y20 := FALSE;
    D20 := D10;
    Y22 := TRUE;
    D28 := 10000;
    D29 := fast_rate;
    IF (ABS(D14 - 10000) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        IF D10 < 9000 THEN
            direction_positive := TRUE;
        ELSE
            direction_positive := FALSE;
        END_IF;
        state := 3;
    END_IF;

3: (* SEARCH_A : sweep A slowly to cross the reference sensor *)
    Y21 := TRUE;
    D24 := 0;
    D25 := fast_rate;
    Y22 := TRUE;
    D28 := 10000;
    D29 := fast_rate;
    Y20 := TRUE;
    D21 := search_rate;
    IF direction_positive THEN
        D20 := 16000;
    ELSE
        D20 := 2000;
    END_IF;

    IF edge_trig.Q THEN
        latched_A := D10;
        IF direction_positive THEN
            stop_target := latched_A + 1000;
        ELSE
            stop_target := latched_A - 1000;
        END_IF;
        IF stop_target < 0 THEN
            stop_target := 0;
        END_IF;
        IF stop_target > 35000 THEN
            stop_target := 35000;
        END_IF;
        state := 4;
    END_IF;

4: (* STOP_AFTER_EDGE : stop within 10 mm past the latched edge *)
    Y21 := TRUE;
    D24 := 0;
    D25 := fast_rate;
    Y22 := TRUE;
    D28 := 10000;
    D29 := fast_rate;
    Y20 := TRUE;
    D20 := stop_target;
    D21 := search_rate;
    IF (ABS(D10 - stop_target) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        state := 5;
    END_IF;

5: (* CONFIGURE : issue configuration edge only after full history+stop *)
    Y21 := TRUE;
    D24 := 0;
    D25 := fast_rate;
    Y22 := TRUE;
    D28 := 10000;
    D29 := fast_rate;
    Y20 := TRUE;
    D20 := stop_target;
    D21 := fast_rate;
    Y30 := TRUE;
    IF X35 THEN
        final_a_target := D90 + D101;
        IF final_a_target < 0 THEN
            final_a_target := 0;
        END_IF;
        IF final_a_target > 35000 THEN
            final_a_target := 35000;
        END_IF;
        state := 6;
    END_IF;

6: (* FINAL_MOVE : go to reference-relative requested position *)
    Y21 := TRUE;
    D24 := 0;
    D25 := fast_rate;
    Y22 := TRUE;
    D28 := 10000;
    D29 := fast_rate;
    Y20 := TRUE;
    D20 := final_a_target;
    D21 := fast_rate;
    Y30 := TRUE;
    IF (ABS(D10 - final_a_target) <= pos_tol) AND (ABS(D11) <= vel_tol)
       AND (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol)
       AND (ABS(D14 - 10000) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        state := 7;
    END_IF;

7: (* DONE : maintain final position and completion *)
    Y21 := TRUE;
    D24 := 0;
    D25 := fast_rate;
    Y22 := TRUE;
    D28 := 10000;
    D29 := fast_rate;
    Y20 := TRUE;
    D20 := final_a_target;
    D21 := fast_rate;
    Y30 := TRUE;
    Y2  := TRUE;

ELSE
    ;
END_CASE;

END_PROGRAM