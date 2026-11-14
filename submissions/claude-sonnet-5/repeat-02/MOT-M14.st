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
    Y2  : BOOL;

    (* internal state *)
    reqEdge      : R_TRIG;
    requested    : BOOL := FALSE;
    phase        : INT := 0; // 0 idle, 1 retract, 2 rotate, 3 approach, 4 done
    reqAngle     : DINT := 0;
    reqEntry     : DINT := 0;
    retractTarget: DINT := 0; // full retraction (0 mm), always <=500mm and satisfies D16 bound

    tblCond      : BOOL;
    slideCond    : BOOL;
    combinedCond : BOOL;
    combinedTimer: TON;
END_VAR

(* Detect the single work request *)
reqEdge(CLK := X10);
IF reqEdge.Q THEN
    requested := TRUE;
    reqAngle  := D14;
    reqEntry  := D15;
    phase     := 1;
END_IF;

(* Sequencing state machine *)
CASE phase OF

    0: // Idle - no movement before request; hold current position at rest
        D20 := D10;
        D21 := D12;
        Y20 := TRUE;
        Y21 := TRUE;

    1: // Retract slide to secure rotation clearance before rotating table
        D20 := D10;          // hold table, do not rotate yet
        D21 := retractTarget;
        Y20 := TRUE;
        Y21 := TRUE;
        IF X11 THEN
            phase := 2;
        END_IF;

    2: // Rotate table while maintaining slide retraction
        D20 := reqAngle;
        D21 := retractTarget;
        Y20 := TRUE;
        Y21 := TRUE;
        IF X12 THEN
            phase := 3;
        END_IF;

    3: // Table settled: re-approach the slide to requested entry
        D20 := reqAngle;
        D21 := reqEntry;
        Y20 := TRUE;
        Y21 := TRUE;
        IF combinedTimer.Q THEN
            phase := 4;
        END_IF;

    4: // Done - maintain terminal state
        D20 := reqAngle;
        D21 := reqEntry;
        Y20 := TRUE;
        Y21 := TRUE;

    ELSE
        phase := 0;
END_CASE;

(* Terminal condition evaluation: table settled AND slide within tolerance *)
tblCond   := X12;
slideCond := (ABS(D12 - reqEntry) <= 20) AND (ABS(D13) <= 100);
combinedCond := requested AND tblCond AND slideCond;

combinedTimer(IN := combinedCond, PT := T#30ms);

Y2 := combinedTimer.Q;

END_PROGRAM