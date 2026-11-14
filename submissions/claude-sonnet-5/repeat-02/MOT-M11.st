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
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    (* internal *)
    state   : DINT := 0;
    started : BOOL := FALSE;
END_VAR

(* Latch the start request. Enables are only ever driven true after this latch is set. *)
IF X0 THEN
    started := TRUE;
END_IF;

CASE state OF

0: (* idle : all actuators off, wait for start request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D20 := 0;
    D21 := 0;
    D24 := 0;
    D25 := 0;
    D28 := 0;
    D29 := 0;
    IF started THEN
        state := 1;
    END_IF;

1: (* rotate disk to first angle, tools stay retracted *)
    Y20 := TRUE;
    D20 := D101;
    D21 := 1000;
    IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
        state := 2;
    END_IF;

2: (* approach tool B to depth1 *)
    Y21 := TRUE;
    D24 := D103;
    D25 := 1000;
    IF ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 THEN
        state := 3;
    END_IF;

3: (* retract tool B fully *)
    D24 := 0;
    D25 := 1000;
    IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
        Y21 := FALSE;
        state := 4;
    END_IF;

4: (* rotate disk to second angle, both tools retracted *)
    D20 := D102;
    D21 := 1000;
    IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
        state := 5;
    END_IF;

5: (* approach tool C to depth2 *)
    Y22 := TRUE;
    D28 := D104;
    D29 := 1000;
    IF ABS(D14 - D28) <= 20 AND ABS(D15) <= 100 THEN
        state := 6;
    END_IF;

6: (* retract tool C fully *)
    D28 := 0;
    D29 := 1000;
    IF ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 THEN
        Y22 := FALSE;
        state := 7;
    END_IF;

7: (* final state : hold A at second, B and C fully retracted and disabled *)
    D20 := D102;
    D21 := 1000;
    D24 := 0;
    D25 := 0;
    D28 := 0;
    D29 := 0;
    Y21 := FALSE;
    Y22 := FALSE;

ELSE
    state := 0;

END_CASE;

(* Completion assertion : only valid once the sequence has reached the final state
   and the actual positions/speeds satisfy the required tolerances. *)
IF state = 7 AND
   ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 AND
   ABS(D12 - 0)    <= 20 AND ABS(D13) <= 100 AND
   ABS(D14 - 0)    <= 20 AND ABS(D15) <= 100 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM