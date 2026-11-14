PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    phase : INT := 0;              (* 0=idle,1=retract wait,2=rotate wait,3=approach/monitor *)
    jobDone : BOOL := FALSE;
    retractTarget : DINT := 0;     (* fully retracted, always <=500mm and <= any positive D16 *)
    edge_x10 : R_TRIG;
    completionTimer : TON;
    tableSettled : BOOL;
    slideTol : BOOL;
    combinedCond : BOOL;
END_VAR

edge_x10(CLK := X10);

CASE phase OF

0:
    (* Before request: no commanded movement, hold current actual positions *)
    Y20 := FALSE;
    Y21 := FALSE;
    D20 := D10;
    D21 := D12;
    IF edge_x10.Q THEN
        phase := 1;
    END_IF;

1:
    (* Retract slide first; keep table held at its current position *)
    Y20 := TRUE;
    D20 := D10;
    Y21 := TRUE;
    D21 := retractTarget;
    IF X11 THEN
        phase := 2;
    END_IF;

2:
    (* Slide confirmed retracted <=500mm & speed<=1mm/s: now rotate table,
       keep slide retracted throughout rotation *)
    Y20 := TRUE;
    D20 := D14;
    Y21 := TRUE;
    D21 := retractTarget;
    IF X12 THEN
        phase := 3;
    END_IF;

3:
    (* Table settled within tolerance: safe to re-approach slide *)
    Y20 := TRUE;
    D20 := D14;
    Y21 := TRUE;
    D21 := D15;

ELSE
    (* Fallback / maintained state *)
    Y20 := TRUE;
    D20 := D14;
    Y21 := TRUE;
    D21 := D15;

END_CASE;

(* Completion monitoring *)
tableSettled := X12;
slideTol := (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100);
combinedCond := tableSettled AND slideTol;

completionTimer(IN := combinedCond, PT := T#30ms);

IF (phase = 3) AND completionTimer.Q THEN
    jobDone := TRUE;
END_IF;

Y2 := jobDone;

END_PROGRAM