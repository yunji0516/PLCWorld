PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal variables *)
    startEdge : R_TRIG;
    step      : INT := 0;
    target    : INT := 0;
END_VAR

(* detect the single rising edge of the start request *)
startEdge(CLK := X10);

CASE step OF

0: (* idle - wait for start request, do not initiate before it *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := FALSE;
    IF startEdge.Q THEN
        target := D10;
        step := 1;
    END_IF;

1: (* open the valve fully before running the pump *)
    Y20 := TRUE;
    Y21 := FALSE;
    IF X20 THEN
        step := 2;
    END_IF;

2: (* pump while valve fully open, monitor actual received volume *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF D20 >= (target - 2) THEN
        Y21 := FALSE;
        Y20 := FALSE;
        step := 3;
    END_IF;

3: (* wait for valve to be fully closed, pump already off *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X21 THEN
        step := 4;
    END_IF;

4: (* result holding: actuators off, evaluate and hold completion claim *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF (D20 >= (target - 2)) AND (D20 <= (target + 2)) THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;

END_CASE

END_PROGRAM