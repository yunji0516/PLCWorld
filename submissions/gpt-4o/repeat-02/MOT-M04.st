PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;
    
    (* Internal variables *)
    hoistPositionTarget : DINT;
    trolleyPositionTarget : DINT;
    swayPositionTarget : DINT;
    hoistStable : BOOL := FALSE;
    trolleyStable : BOOL := FALSE;
    swayStable : BOOL := FALSE;
    requestActive : BOOL := FALSE;
    hoistRequest : BOOL := FALSE;
    
    hoistSettledTime : TIME;
    trolleySettledTime : TIME;
    swaySettledTime : TIME;
    
    hoistRequestTimer : TON;
    stabilityTimer : TON;
    executeEndTimer : TON;
    
    completed : BOOL := FALSE;
    
END_VAR

(* Initial setup for targets *)
hoistPositionTarget := D10;
trolleyPositionTarget := D17;
swayPositionTarget := D18;

(* Check if task request is active *)
hoistRequest := X10;

(* Control logic for hoist position *)
IF hoistRequest THEN
    D20 := hoistPositionTarget;
    (* Calculate required acceleration for hoist axis using PD control *)
    D21 := DINT(3500 * (REAL(D10) - REAL(D11)) + 2 * 35 * (REAL(0) - REAL(D12)));
    hoistStable := ABS(D10 - D11) <= 100 AND ABS(D12) <= 100;
ELSE
    D21 := 0;
    hoistStable := FALSE;
END_IF

(* Control logic for trolley position *)
IF hoistRequest THEN
    (* Calculate required acceleration for trolley axis using PD control *)
    D21 := DINT(3500 * (REAL(D17) - REAL(D13)) + 2 * 35 * (REAL(0) - REAL(D14)));
    trolleyStable := ABS(D17 - D13) <= 100 AND ABS(D14) <= 100;
ELSE
    trolleyStable := FALSE;
END_IF

(* Control logic to stabilize sway *)
IF hoistRequest THEN
    (* Calculate damping for sway, no direct control, hence focus on minimized sway through limits *)
    swayStable := ABS(D15) <= 20 AND ABS(D16) <= 10;
ELSE
    swayStable := FALSE;
END_IF

(* Assess overall system stability *)
IF hoistStable AND trolleyStable AND swayStable THEN
    stabilityTimer(IN := TRUE, PT := T#30ms);
    IF stabilityTimer.Q THEN
        Y2 := TRUE;  (* Result completion and retention *)
    END_IF
ELSE
    stabilityTimer(IN := FALSE);
    Y2 := FALSE;
END_IF

(* Completion and execution termination *)
IF hoistRequest THEN
    executeEndTimer(IN := Y2, PT := T#100ms);
    IF executeEndTimer.Q AND NOT completed THEN
        completed := TRUE;
    END_IF
ELSE
    executeEndTimer(IN := FALSE);
END_IF

(* Output assignment for hoisting *)
Y20 := hoistRequest AND NOT completed;

END_PROGRAM