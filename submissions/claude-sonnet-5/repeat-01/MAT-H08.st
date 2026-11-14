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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal state *)
    state        : INT := 0;
    recState     : INT := 0;
    pitchCount   : INT := 0;
    exitAckCount : INT := 0;
    recBatchCount: INT := 0;
    rollCount    : INT := 0;
    started      : BOOL := FALSE;

    rStart       : R_TRIG;
    tFeed        : TON;
    tClampResp   : TON;
    tCutCycle    : TON;
    tEdgeHold    : TON;
    tThread      : TON;
    tComplete    : TON;

    completionReady : BOOL := FALSE;
    allProductsDone : BOOL := FALSE;
    allRecoveryDone : BOOL := FALSE;
    allRollsDone    : BOOL := FALSE;
    noActiveOps     : BOOL := FALSE;
END_VAR

(* ---- start latch ---- *)
rStart(CLK := X0);
IF rStart.Q THEN
    started := TRUE;
END_IF;

(* ---- default clear of pulse-style outputs (re-asserted below if needed) ---- *)
Y10 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y17 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
Y20 := FALSE;

(* cut mask continuously reflects the current attached connection edges *)
D200 := D1;

(* =========================================================
   MAIN PRODUCT SEQUENCE : pitch accept -> feed -> cut -> pickup
   -> bed descent -> transfer -> exit -> return
   ========================================================= *)
IF started THEN
    CASE state OF

    0: (* idle / cycle start *)
        Y11 := FALSE;
        IF pitchCount < 6 THEN
            state := 10;
        END_IF;

    10: (* wait accept_pitch conditions: next pitch arrived, no current pitch, head job finished *)
        IF X10 AND (NOT X18) THEN
            Y10 := TRUE; (* rising edge pulse *)
            state := 11;
        END_IF;

    11:
        pitchCount := pitchCount + 1;
        tFeed(IN := FALSE, PT := T#2000ms);
        state := 20;

    20: (* feed 300 mm at 150 mm/s = 2.0 s, respect 600 mm storage cap *)
        IF D3 < 600 THEN
            Y11 := TRUE;
        ELSE
            Y11 := FALSE;
        END_IF;
        tFeed(IN := Y11, PT := T#2000ms);
        IF tFeed.Q THEN
            Y11 := FALSE;
            tFeed(IN := FALSE, PT := T#2000ms);
            state := 30;
        END_IF;

    30: (* clamp, holder response 0.2 s *)
        Y12 := TRUE;
        tClampResp(IN := TRUE, PT := T#200ms);
        IF tClampResp.Q THEN
            tClampResp(IN := FALSE, PT := T#200ms);
            state := 31;
        END_IF;

    31: (* cut rising edge, mask already set to D1 *)
        Y13 := TRUE;
        tCutCycle(IN := TRUE, PT := T#600ms);
        state := 32;

    32: (* die contact 0.3s, return 0.6s ; wait full cycle + edges cut *)
        tCutCycle(IN := TRUE, PT := T#600ms);
        IF tCutCycle.Q AND X23 THEN
            tCutCycle(IN := FALSE, PT := T#600ms);
            state := 40;
        END_IF;

    40: (* pickup rising edge *)
        Y14 := TRUE;
        state := 41;

    41: (* wait actual vacuum hold *)
        IF X16 THEN
            state := 50;
        END_IF;

    50: (* bed descent only while actually held *)
        IF X16 THEN
            Y15 := TRUE;
        ELSE
            Y15 := FALSE;
        END_IF;
        IF X17 THEN
            state := 60;
        END_IF;

    60: (* transfer only after 4-edge separation, bed low, held, exit margin *)
        IF X23 AND X17 AND X16 AND X19 THEN
            Y16 := TRUE;
            state := 61;
        END_IF;

    61: (* exit takeover *)
        IF X1A THEN
            Y1A := TRUE;
            exitAckCount := exitAckCount + 1;
            state := 62;
        END_IF;

    62: (* return head, release outputs *)
        Y16 := FALSE;
        Y15 := FALSE;
        Y14 := FALSE;
        Y12 := FALSE;
        IF NOT X18 THEN
            state := 0;
        END_IF;

    ELSE
        state := 0;
    END_CASE;
END_IF;

(* =========================================================
   RECOVERY / WASTE ROLL EXCHANGE SEQUENCE
   ========================================================= *)
IF started THEN
    CASE recState OF

    0: (* wait next recovery batch acceptance *)
        Y18 := FALSE;
        IF (recBatchCount < 4) AND X1B THEN
            Y17 := TRUE; (* accept_recovery rising edge *)
            recState := 1;
        END_IF;

    1:
        recState := 2;

    2: (* run recovery until batch done or waste_full *)
        IF X21 THEN
            Y18 := FALSE;
            recState := 5;
        ELSE
            Y18 := TRUE;
        END_IF;
        IF X1D THEN
            Y19 := TRUE; (* ack_recovery pulse *)
            recState := 3;
        END_IF;

    3:
        Y18 := FALSE;
        recBatchCount := recBatchCount + 1;
        recState := 0;

    5: (* waste full: stop recovery, hold residue bands *)
        Y18 := FALSE;
        Y1C := TRUE;
        tEdgeHold(IN := TRUE, PT := T#300ms);
        IF tEdgeHold.Q THEN
            recState := 6;
        END_IF;

    6: (* cut both side connections *)
        Y1D := TRUE;
        Y1E := TRUE;
        recState := 7;

    7:
        IF X23 THEN
            recState := 8;
        END_IF;

    8: (* remove waste roll *)
        Y1F := TRUE;
        recState := 9;

    9:
        rollCount := rollCount + 1;
        recState := 10;

    10: (* wait empty core, dock *)
        IF X25 THEN
            Y20 := TRUE;
            recState := 11;
        END_IF;

    11:
        IF X26 THEN
            recState := 12;
        END_IF;

    12: (* thread both sides 0.7 - 2.0 s *)
        Y21 := TRUE;
        Y22 := TRUE;
        tThread(IN := TRUE, PT := T#700ms);
        IF (tThread.ET >= T#700ms) AND X27 AND X28 THEN
            recState := 13;
        END_IF;

    13: (* release hold, resume recovery once reconnected *)
        Y21 := FALSE;
        Y22 := FALSE;
        Y1C := FALSE;
        tThread(IN := FALSE, PT := T#700ms);
        recState := 14;

    14:
        IF X29 THEN
            recState := 2;
        END_IF;

    ELSE
        recState := 0;
    END_CASE;
END_IF;

(* =========================================================
   COMPLETION EVALUATION
   ========================================================= *)
allProductsDone := (pitchCount >= 6) AND (exitAckCount >= 6) AND (state = 0);
allRecoveryDone := (recBatchCount >= 4) AND (D4 >= 3200) AND (recState = 0);
allRollsDone    := (rollCount >= 2);
noActiveOps     := (state = 0) AND (recState = 0) AND (NOT Y16) AND (NOT Y14) AND (NOT Y1A) AND (NOT Y13);

completionReady := started AND allProductsDone AND allRecoveryDone AND allRollsDone AND noActiveOps;

tComplete(IN := completionReady, PT := T#500ms);
Y1B := tComplete.Q;

END_PROGRAM