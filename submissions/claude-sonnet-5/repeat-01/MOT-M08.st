PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    step        : INT := 0;
    started     : BOOL := FALSE;
    edgeTrig    : R_TRIG;
    stopTarget  : DINT := 0;
    originVal   : DINT := 0;
    aTargetLayer: DINT := 0;
    pitchR      : REAL := 0.0;
    indexR      : REAL := 0.0;
    originR     : REAL := 0.0;
    targetR     : REAL := 0.0;
END_VAR

(* update edge detector for the reference sensor every scan *)
edgeTrig(CLK := X34);

IF NOT started THEN
    IF X0 THEN
        started := TRUE;
    END_IF;
END_IF;

CASE step OF

0: (* idle : all actuators off until start request observed *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y30 := FALSE;
    Y2  := FALSE;
    IF started THEN
        (* prepare and start a slow forward search that will cross the
           60..90 mm sensor plane *)
        D20 := 10000;   (* target 100.00 mm, beyond sensor plane *)
        D21 := 50;      (* low rate for a precise capture *)
        Y20 := TRUE;
        step := 10;
    END_IF;

10: (* searching for a fresh X34 rising edge *)
    Y20 := TRUE;
    D20 := 10000;
    D21 := 50;
    IF edgeTrig.Q THEN
        (* freeze motion at (or very shortly after) the fresh edge *)
        stopTarget := D10;
        D20 := stopTarget;
        step := 20;
    END_IF;

20: (* wait until actually stopped within the 10 mm capture window *)
    Y20 := TRUE;
    D20 := stopTarget;
    IF (ABS(D10 - stopTarget) <= 20) AND (ABS(D11) <= 100) THEN
        step := 30;
    END_IF;

30: (* issue configure rising edge *)
    Y30 := TRUE;
    step := 40;

40: (* drop pulse, wait for device to confirm registration *)
    Y30 := FALSE;
    IF X35 THEN
        originVal := D90;
        step := 50;
    END_IF;

50: (* compute target layer position from origin, index and pitch *)
    pitchR  := INT_TO_REAL(D101) / 100.0;
    indexR  := INT_TO_REAL(D102) / 100.0;
    originR := INT_TO_REAL(originVal) / 100.0;
    targetR := originR + indexR * pitchR;
    aTargetLayer := DINT(ROUND(targetR * 100.0));
    D20 := aTargetLayer;
    D21 := 300;
    Y20 := TRUE;
    step := 60;

60: (* wait for arrival at the target layer *)
    D20 := aTargetLayer;
    IF (ABS(D10 - aTargetLayer) <= 20) AND (ABS(D11) <= 100) THEN
        step := 70;
    END_IF;

70: (* approach laterally to requested reach *)
    D24 := D103;
    D25 := 300;
    Y21 := TRUE;
    step := 80;

80: (* wait for B to arrive at reach *)
    D24 := D103;
    IF (ABS(D12 - D103) <= 20) AND (ABS(D13) <= 100) THEN
        step := 90;
    END_IF;

90: (* retract B back to 0 *)
    D24 := 0;
    step := 100;

100: (* wait for B to arrive back at 0 *)
    D24 := 0;
    IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
        Y2 := TRUE;
        step := 110;
    END_IF;

110: (* completed : hold positions and maintain completion output *)
    Y2   := TRUE;
    D20  := aTargetLayer;
    D24  := 0;
    Y20  := TRUE;
    Y21  := TRUE;

ELSE
    ;
END_CASE;

END_PROGRAM