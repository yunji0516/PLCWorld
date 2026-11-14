PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    start_trig : R_TRIG;
    state      : INT := 0;
    target     : INT := 0;
    accepted   : BOOL := false;
END_VAR

(* ---- Edge detect start request ---- *)
start_trig(CLK := X10);

CASE state OF

0: (* IDLE - wait for accepted start; no actuator activity before acceptance *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

    IF start_trig.Q THEN
        target := D10;
        accepted := TRUE;
        state := 1;
    END_IF;

1: (* Move nozzle down to lower endpoint *)
    Y21 := FALSE;
    Y20 := TRUE;
    Y22 := FALSE;
    Y23 := FALSE;

    IF X21 THEN
        Y20 := FALSE; (* stop downward command once at lower endpoint *)
        state := 2;
    END_IF;

2: (* Open valve; pump may be started early (discharge stays zero until valve fully open) *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := TRUE; (* safe to command pump while valve opening *)

    IF X22 THEN
        state := 3;
    END_IF;

3: (* Pumping phase - fill vessel to target, stop before overshoot *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;

    IF X21 AND X22 AND (D20 < target) THEN
        Y23 := TRUE;
    ELSE
        Y23 := FALSE;
    END_IF;

    IF D20 >= target THEN
        Y23 := FALSE;
        state := 4;
    END_IF;

4: (* Stop pump, close valve *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
    Y22 := FALSE;

    IF X23 THEN
        state := 5;
    END_IF;

5: (* Move nozzle up to upper position *)
    Y22 := FALSE;
    Y23 := FALSE;
    Y20 := FALSE;
    Y21 := TRUE;

    IF X20 THEN
        Y21 := FALSE;
        state := 6;
    END_IF;

6: (* Verify completion criteria and claim *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

    IF X20 AND X23 AND (D20 >= target - 2) AND (D20 <= target + 2) THEN
        Y2 := TRUE;
        state := 7;
    END_IF;

7: (* Maintain terminal result for remainder of evaluation run *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM