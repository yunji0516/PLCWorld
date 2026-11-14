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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal control state *)
    phaseRun       : BOOL := FALSE;
    startTrig      : R_TRIG;

    lockCmd        : BOOL := TRUE;

    loadState      : INT := 0;
    loadedCount    : INT := 0;

    insState       : INT := 0;
    insDoneCount   : INT := 0;
    insDoneThisCycle  : BOOL := FALSE;

    inspState      : INT := 0;
    inspDoneCount  : INT := 0;
    inspDoneThisCycle : BOOL := FALSE;

    ejState        : INT := 0;
    goodCount      : INT := 0;
    ejDoneThisCycle   : BOOL := FALSE;

    reworkCount    : INT := 0;
    reworkClampTimer : TON;

    rotState       : INT := 0;

    genCounter     : INT := 0;

    cycleReady     : BOOL := FALSE;
    allDone        : BOOL := FALSE;
    toolsHome      : BOOL := FALSE;
    completionCriteria : BOOL := FALSE;
    completeHeld   : BOOL := FALSE;
    completeTimer  : TON;
END_VAR

(* ---- start edge ---- *)
startTrig(CLK := X0);
IF startTrig.Q THEN
    phaseRun := TRUE;
END_IF;

(* ================= LOAD STATION (position 0) ================= *)
IF phaseRun THEN
    CASE loadState OF
        0:
            IF X11 THEN
                ; (* no more bodies : nothing to load *)
            ELSIF X10 AND (NOT X14) AND (D0 = 0) AND X19 AND (NOT X18) THEN
                loadState := 1;
            END_IF;
        1:
            Y10 := TRUE;
            loadState := 2;
        2:
            Y10 := FALSE;
            IF X14 THEN
                loadState := 3;
            END_IF;
        3:
            IF NOT X14 THEN
                loadedCount := loadedCount + 1;
                loadState := 0;
            END_IF;
    END_CASE;
END_IF;

(* ================= INSERT STATION (position 1) ================= *)
IF phaseRun THEN
    CASE insState OF
        0:
            IF D1 = 0 THEN
                Y11 := FALSE;
                insDoneThisCycle := TRUE;
            ELSIF X21 THEN
                Y11 := FALSE;
                insDoneThisCycle := TRUE;
            ELSE
                IF X12 THEN
                    Y11 := TRUE;
                END_IF;
                IF X13 AND (NOT X15) AND X19 AND (NOT X18) THEN
                    insState := 1;
                END_IF;
            END_IF;
        1:
            Y12 := TRUE;
            insState := 2;
        2:
            Y12 := FALSE;
            IF X15 THEN
                insState := 3;
            END_IF;
        3:
            IF NOT X15 THEN
                Y11 := FALSE;
                insDoneCount := insDoneCount + 1;
                insDoneThisCycle := TRUE;
                insState := 0;
            END_IF;
    END_CASE;
END_IF;

(* ================= INSPECT STATION (position 2) ================= *)
IF phaseRun THEN
    CASE inspState OF
        0:
            IF D2 = 0 THEN
                inspDoneThisCycle := TRUE;
            ELSIF X22 THEN
                inspDoneThisCycle := TRUE;
            ELSE
                IF X19 AND (NOT X18) AND (NOT X16) THEN
                    D200 := genCounter;
                    inspState := 1;
                END_IF;
            END_IF;
        1:
            Y13 := TRUE;
            inspState := 2;
        2:
            Y13 := FALSE;
            IF X16 THEN
                inspState := 3;
            END_IF;
        3:
            IF NOT X16 THEN
                inspDoneCount := inspDoneCount + 1;
                inspDoneThisCycle := TRUE;
                inspState := 0;
            END_IF;
    END_CASE;
END_IF;

(* ================= EJECT / OUTPUT / REWORK (position 3) ================= *)
IF phaseRun THEN
    CASE ejState OF
        0:
            IF D3 = 0 THEN
                ejDoneThisCycle := TRUE;
            ELSIF NOT X23 THEN
                ; (* wait for current inspection result to be valid *)
            ELSIF X19 AND (NOT X18) THEN
                IF X24 THEN
                    ejState := 20;
                ELSE
                    ejState := 1;
                END_IF;
            END_IF;

        (* ---- good product : eject to belt and release ---- *)
        1:
            IF X1B AND X1D THEN
                Y14 := TRUE;
                ejState := 2;
            END_IF;
        2:
            IF X1C THEN
                Y14 := FALSE;
                Y15 := TRUE;
                ejState := 3;
            END_IF;
        3:
            IF X1B THEN
                Y15 := FALSE;
                ejState := 4;
            END_IF;
        4:
            IF X20 AND X1D AND X1B THEN
                Y16 := TRUE;
                ejState := 5;
            END_IF;
        5:
            Y16 := FALSE;
            IF X1E THEN
                Y19 := TRUE;
                ejState := 6;
            END_IF;
        6:
            Y19 := FALSE;
            IF NOT X1E THEN
                goodCount := goodCount + 1;
                ejDoneThisCycle := TRUE;
                ejState := 0;
            END_IF;

        (* ---- NG product : rework path ---- *)
        20:
            IF X1B THEN
                Y1B := TRUE;
                ejState := 21;
            END_IF;
        21:
            Y1B := FALSE;
            IF X26 THEN
                ejState := 22;
            END_IF;
        22:
            Y1C := TRUE;
            IF X27 THEN
                ejState := 23;
            END_IF;
        23:
            IF reworkClampTimer.Q THEN
                Y1D := TRUE;
                ejState := 24;
            END_IF;
        24:
            Y1D := FALSE;
            IF X28 THEN
                ejState := 25;
            END_IF;
        25:
            Y1E := TRUE;
            ejState := 26;
        26:
            Y1E := FALSE;
            IF X29 THEN
                Y1C := FALSE;
                ejState := 27;
            END_IF;
        27:
            IF NOT X27 THEN
                ejState := 28;
            END_IF;
        28:
            IF X19 AND (D0 = 0) THEN
                Y1F := TRUE;
                ejState := 29;
            END_IF;
        29:
            Y1F := FALSE;
            IF X2A THEN
                reworkCount := reworkCount + 1;
                genCounter := genCounter + 1;
                ejDoneThisCycle := TRUE;
                ejState := 0;
            END_IF;
    END_CASE;
END_IF;

reworkClampTimer(IN := (ejState = 23), PT := T#300ms);

(* ================= ROTATION / LOCK CONTROL ================= *)
cycleReady := insDoneThisCycle AND inspDoneThisCycle AND ejDoneThisCycle AND (loadState = 0);
allDone := (goodCount >= 6) AND (reworkCount >= 2);

CASE rotState OF
    0:
        lockCmd := TRUE;
        IF phaseRun AND cycleReady AND X19 AND (NOT allDone) THEN
            rotState := 1;
        END_IF;
    1:
        lockCmd := FALSE;
        IF X1A THEN
            rotState := 2;
        END_IF;
    2:
        IF X1B AND (ejState = 0) THEN
            Y18 := TRUE;
            rotState := 3;
        END_IF;
    3:
        Y18 := FALSE;
        IF X18 THEN
            rotState := 4;
        END_IF;
    4:
        IF NOT X18 THEN
            rotState := 5;
        END_IF;
    5:
        lockCmd := TRUE;
        IF X19 THEN
            insDoneThisCycle := FALSE;
            inspDoneThisCycle := FALSE;
            ejDoneThisCycle := FALSE;
            genCounter := genCounter + 1;
            rotState := 0;
        END_IF;
END_CASE;

Y17 := lockCmd;

(* ================= COMPLETION ================= *)
toolsHome := X1B AND X19 AND (NOT X18) AND (ejState = 0) AND (rotState = 0)
             AND (loadState = 0) AND (insState = 0) AND (inspState = 0);

completionCriteria := allDone AND toolsHome;

completeTimer(IN := completionCriteria, PT := T#500ms);

IF completeTimer.Q THEN
    completeHeld := TRUE;
END_IF;

Y1A := completeHeld;

END_PROGRAM