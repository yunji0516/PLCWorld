```iec-st
PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    run_active : BOOL := FALSE;
    tank_safe : BOOL := FALSE;

    swap_trig_cond : BOOL := FALSE;
    swap_edge : R_TRIG;

    a_state : INT := 0;
    b_state : INT := 0;
    a_feed_count : INT := 0;
    b_feed_count : INT := 0;
    a_pumping_active : BOOL := FALSE;
    b_pumping_active : BOOL := FALSE;

    a_valve_ton : TON;
    b_valve_ton : TON;

    capper_state : INT := 0;

    a_rel_state : INT := 0;
    b_rel_state : INT := 0;

    complete_hold : BOOL := FALSE;
END_VAR

IF X0 THEN
    run_active := TRUE;
END_IF;

IF NOT run_active THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    RETURN;
END_IF;

(* ---------------- Tank Replenishment and Batch Swap ---------------- *)
IF X2F AND (D1 > 0) AND NOT X30 AND (D0 < 1300) THEN
    Y10 := TRUE;
ELSIF (D0 >= 1400) OR NOT X2F OR (D1 <= 0) OR X30 THEN
    Y10 := FALSE;
END_IF;

swap_trig_cond := X31 AND NOT X30 AND NOT X2F AND (D1 = 0) AND NOT Y10;
swap_edge(CLK := swap_trig_cond);
Y11 := swap_edge.Q;

tank_safe := (D0 > 300) OR (NOT X31 AND NOT X2F AND (D1 = 0) AND (D0 > 20));

(* ---------------- Line A Filling Sequence ---------------- *)
a_valve_ton(IN := (a_state = 4 AND X16), PT := T#150ms);

CASE a_state OF
    0: (* IDLE / READY TO FEED *)
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        a_pumping_active := FALSE;
        IF X11 AND NOT X10 AND (a_feed_count < 3) THEN
            a_feed_count := a_feed_count + 1;
            Y14 := TRUE;
            a_state := 1;
        END_IF;

    1: (* FEEDING *)
        IF X10