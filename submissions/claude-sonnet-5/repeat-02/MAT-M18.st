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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D200 : INT;

    (* internal *)
    step : INT := 0;
    started : BOOL := FALSE;
    doneLatch : BOOL := FALSE;
    startTrig : R_TRIG;
    pos_tol : INT := 1;
END_VAR

startTrig(CLK := X0);

IF startTrig.Q AND (NOT started) AND (NOT doneLatch) THEN
    started := TRUE;
    step := 10;
END_IF;

CASE step OF

0:
    ; // idle, waiting for start

10: // secure feed grip on segment side, ensure stopper open for movement
    Y10 := TRUE;
    Y11 := FALSE;
    IF X12 AND (NOT X14) THEN
        step := 20;
    END_IF;

20: // extend carriage to make protrusion equal requested length
    D200 := D0;
    Y12 := TRUE;
    IF X11 AND (ABS(D1 - D0) <= pos_tol) THEN
        Y12 := FALSE;
        step := 30;
    END_IF;

30: // clamp stopper to hold raw material side before cutting
    Y11 := TRUE;
    IF X14 THEN
        step := 40;
    END_IF;

40: // descend blade fully (severs connection at 97% descent along the way)
    Y13 := TRUE;
    IF X16 THEN
        step := 50;
    END_IF;

50: // retract blade fully, confirm valid separation
    Y13 := FALSE;
    IF X15 AND X17 THEN
        step := 60;
    END_IF;

60: // open feed grip to release segment from grip (required before extraction/return)
    Y10 := FALSE;
    IF X13 THEN
        step := 70;
    END_IF;

70: // return carriage/grip to origin (blade already fully retracted, grip open)
    D200 := 100;
    Y12 := TRUE;
    IF X11 AND X10 AND (ABS(D1 - 100) <= pos_tol) THEN
        Y12 := FALSE;
        step := 80;
    END_IF;

80: // pad down to contact at source (cutting table) position
    Y14 := TRUE;
    IF X19 THEN
        step := 90;
    END_IF;

90: // form vacuum retention at source contact position
    Y16 := TRUE;
    IF X1C THEN
        step := 100;
    END_IF;

100: // lift pad to top before horizontal move
    Y14 := FALSE;
    IF X18 THEN
        step := 110;
    END_IF;

110: // move pad horizontally to receiver (extraction, allowed: cut done + grip open)
    Y15 := TRUE;
    IF X1B THEN
        step := 120;
    END_IF;

120: // lower pad to contact at receiving support
    Y14 := TRUE;
    IF X19 THEN
        step := 130;
    END_IF;

130: // release vacuum at receiver contact height
    Y16 := FALSE;
    IF (NOT X1C) AND X1D AND (ABS(D3 - D0) <= 1) THEN
        step := 140;
    END_IF;

140: // lift empty pad back to top
    Y14 := FALSE;
    IF X18 THEN
        step := 150;
    END_IF;

150: // return empty pad to start position
    Y15 := FALSE;
    IF X1A THEN
        step := 160;
    END_IF;

160: // completion: hold final state
    Y17 := TRUE;
    doneLatch := TRUE;
    ;

ELSE
    ;
END_CASE;

END_PROGRAM