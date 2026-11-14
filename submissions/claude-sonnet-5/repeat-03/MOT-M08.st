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
    state       : INT := 0;
    startedLatch: BOOL := FALSE;
    startTrig   : R_TRIG;
    edgeTrig    : R_TRIG;
    edgePos     : DINT := 0;
    targetFinal : DINT := 0;
    rateSearch  : DINT := 200;
    rateMove    : DINT := 500;
    rateApproach: DINT := 500;
    rateRetract : DINT := 500;
    posTol      : DINT := 20;   (* 0.2 mm * 100 *)
    velTol      : DINT := 100;  (* 1 mm/s * 100 *)
END_VAR

(* edge detection - update every scan *)
startTrig(CLK := X0);
IF startTrig.Q THEN
    startedLatch := TRUE;
END_IF;

edgeTrig(CLK := X34);

CASE state OF

0: (* idle - before start, actuators off, prepare nothing active *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y30 := FALSE;
    Y2  := FALSE;
    D20 := 0;
    D21 := 0;
    D24 := 0;
    D25 := 0;
    IF startedLatch THEN
        D20 := 10000; (* search target: 100 mm *)
        D21 := rateSearch;
        Y20 := TRUE;
        state := 1;
    END_IF;

1: (* search for reference sensor rising edge *)
    Y20 := TRUE;
    D20 := 10000;
    D21 := rateSearch;
    IF edgeTrig.Q THEN
        edgePos := D10;
        D20 := edgePos + 500; (* stop 5 mm past captured edge, within 10mm window *)
        state := 2;
    END_IF;

2: (* wait until stopped within capture window *)
    Y20 := TRUE;
    D20 := edgePos + 500;
    D21 := rateSearch;
    IF (ABS(D10 - D20) <= posTol) AND (ABS(D11) <= velTol) THEN
        state := 3;
    END_IF;

3: (* issue configure rising edge pulse *)
    Y30 := TRUE;
    state := 4;

4: (* clear pulse, wait for confirmation *)
    Y30 := FALSE;
    IF X35 THEN
        state := 5;
    END_IF;

5: (* compute registered shelf target and command move *)
    targetFinal := D90 + (D102 * D101) / 100;
    D20 := targetFinal;
    D21 := rateMove;
    Y20 := TRUE;
    state := 6;

6: (* wait for A arrival at shelf target *)
    D20 := targetFinal;
    D21 := rateMove;
    IF (ABS(D10 - targetFinal) <= posTol) AND (ABS(D11) <= velTol) THEN
        state := 7;
    END_IF;

7: (* command lateral approach *)
    D24 := D103;
    D25 := rateApproach;
    Y21 := TRUE;
    state := 8;

8: (* wait for B arrival at reach *)
    D24 := D103;
    D25 := rateApproach;
    IF (ABS(D12 - D103) <= posTol) AND (ABS(D13) <= velTol) THEN
        state := 9;
    END_IF;

9: (* command retract *)
    D24 := 0;
    D25 := rateRetract;
    Y21 := TRUE;
    state := 10;

10: (* wait for B to return to 0 *)
    D24 := 0;
    D25 := rateRetract;
    IF (ABS(D12) <= posTol) AND (ABS(D13) <= velTol) THEN
        state := 11;
    END_IF;

11: (* completed - hold position and maintain completion *)
    D20 := targetFinal;
    D21 := rateMove;
    Y20 := TRUE;
    D24 := 0;
    D25 := rateRetract;
    Y21 := TRUE;
    Y2  := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM