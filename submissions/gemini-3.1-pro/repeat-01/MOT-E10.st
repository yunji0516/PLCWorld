PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    State : INT := 0;
    InternalPos : DINT := 0;
    CmdVel : DINT := 0;
    Target_Internal : DINT := 0;
    Error_Internal : DINT := 0;
    V_target : DINT := 0;
    delta_V : DINT := 0;
    
    Settled : BOOL := FALSE;
    SettledTimer : TON;
END_VAR

IF NOT X10 THEN
    State := 0;
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := LIMIT(-200000, D11, 200000);
    InternalPos := D11 * 100;
    CmdVel := 0;
ELSE
    IF State = 0 THEN
        InternalPos := D11 * 100;
        CmdVel := 0;
        State := 1;
        Y20 := TRUE;
        Y2 := FALSE;
    END_IF;
END_IF;

IF State > 0 THEN
    Target_Internal := D10 * 100;
    Error_Internal := Target_Internal - InternalPos;
    
    (* Proportional velocity command with K = 12 scans (120 ms time constant) *)
    V_target := Error_Internal / 12;
    V_target := LIMIT(-24000, V_target, 24000);
    
    delta_V := V_target - CmdVel;
    
    (* Apply acceleration and braking limits based on direction *)
    IF CmdVel >= 0 THEN
        delta_V := LIMIT(-2400, delta_V, 1800);
    ELSE
        delta_V := LIMIT(-1800, delta_V, 2400);
    END_IF;
    
    CmdVel := CmdVel + delta_V;
    InternalPos := InternalPos + CmdVel;
    
    (* Round the internal position to the nearest 0.01 degree unit for D20 *)
    IF InternalPos >= 0 THEN
        D20 := (InternalPos + 50) / 100;
    ELSE
        D20 := (InternalPos - 50) / 100;
    END_IF;
    D20 := LIMIT(-200000, D20, 200000);
    
    Y20 := TRUE;
END_IF;

(* Completion Condition: Angle error <= 0.2 deg (20 units), speed <= 1 deg/s (100 units) *)
Settled := (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100);
SettledTimer(IN := Settled AND (State > 0), PT := T#30ms);

IF SettledTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM