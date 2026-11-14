PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;

    (* Internal variables *)
    state : DINT := 0;
    started : BOOL := FALSE;
    targetCaptured : BOOL := FALSE;
    targetS : DINT := 0;

    posTolRaw : DINT := 20;   (* 0.2 mm/deg * 100 *)
    velTolRaw : DINT := 100;  (* 1 mm/s or deg/s * 100 *)

    aArrived : BOOL;
    bArrived : BOOL;
END_VAR

(* Latch start approval - never enable before X0 request *)
IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    (* Preparing targets with Enable off is allowed *)
    Y20 := FALSE;
    Y21 := FALSE;
    D20 := 20000;  (* 200.00 mm *)
    D21 := 0;
    D24 := 0;      (* 0.00 deg *)
    D25 := 0;
    Y2 := FALSE;
ELSE
    Y20 := TRUE;
    Y21 := TRUE;
    D21 := 1000;
    D25 := 1000;

    IF NOT targetCaptured THEN
        targetS := D101;
        targetCaptured := TRUE;
    END_IF;

    CASE state OF

        0: (* Move A: 200 -> 500, hold B at 0 *)
            D20 := 50000;
            D24 := 0;
            aArrived := (ABS(D10 - D20) <= posTolRaw) AND (ABS(D11) <= velTolRaw);
            bArrived := (ABS(D12 - D24) <= posTolRaw) AND (ABS(D13) <= velTolRaw);
            IF aArrived AND bArrived THEN
                state := 1;
            END_IF;

        1: (* Rotate B: 0 -> 90 at corner s=500 *)
            D20 := 50000;
            D24 := 9000;
            aArrived := (ABS(D10 - D20) <= posTolRaw) AND (ABS(D11) <= velTolRaw);
            bArrived := (ABS(D12 - D24) <= posTolRaw) AND (ABS(D13) <= velTolRaw);
            IF aArrived AND bArrived THEN
                state := 2;
            END_IF;

        2: (* Move A: 500 -> requested target, B held at 90 *)
            D20 := targetS;
            D24 := 9000;
            aArrived := (ABS(D10 - D20) <= posTolRaw) AND (ABS(D11) <= velTolRaw);
            bArrived := (ABS(D12 - D24) <= posTolRaw) AND (ABS(D13) <= velTolRaw);
            IF aArrived AND bArrived THEN
                state := 3;
            END_IF;

        3: (* Return A: target -> 500, B held at 90 *)
            D20 := 50000;
            D24 := 9000;
            aArrived := (ABS(D10 - D20) <= posTolRaw) AND (ABS(D11) <= velTolRaw);
            bArrived := (ABS(D12 - D24) <= posTolRaw) AND (ABS(D13) <= velTolRaw);
            IF aArrived AND bArrived THEN
                state := 4;
            END_IF;

        4: (* Rotate B: 90 -> 0 at corner s=500 *)
            D20 := 50000;
            D24 := 0;
            aArrived := (ABS(D10 - D20) <= posTolRaw) AND (ABS(D11) <= velTolRaw);
            bArrived := (ABS(D12 - D24) <= posTolRaw) AND (ABS(D13) <= velTolRaw);
            IF aArrived AND bArrived THEN
                state := 5;
            END_IF;

        5: (* Return A: 500 -> 200, B held at 0 *)
            D20 := 20000;
            D24 := 0;
            aArrived := (ABS(D10 - D20) <= posTolRaw) AND (ABS(D11) <= velTolRaw);
            bArrived := (ABS(D12 - D24) <= posTolRaw) AND (ABS(D13) <= velTolRaw);
            IF aArrived AND bArrived THEN
                state := 6;
            END_IF;

        6: (* Final resting state - hold and assert completion *)
            D20 := 20000;
            D24 := 0;

        ELSE
            state := 0;

    END_CASE;

    Y2 := (state = 6);

END_IF;

END_PROGRAM