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
    Y22 : BOOL;
    Y2 : BOOL;

    (* Internal variables *)
    reqEdge     : R_TRIG;
    stableTimer : TON;

    state       : INT := 0;   (* 0=idle, 2=sync-wait, 3=sync-run, 4=gearout-wait, 5=parking, 6=done *)

    cmdRatio    : DINT := 0;
    cmdPark     : DINT := 0;
    cmdSpan     : DINT := 0;

    originU     : DINT := 0;
    originS     : DINT := 0;
    syncOriginU : DINT := 0;

    parkMod     : DINT := 0;
    dirSign     : DINT := 1;
    targetS     : DINT := 0;

    diffPos     : DINT := 0;
    diffSpeed   : DINT := 0;
    withinTol   : BOOL := FALSE;
    resultAchieved : BOOL := FALSE;
END_VAR

(* --- edge detection for single task request --- *)
reqEdge(CLK := X10);

(* default pulse outputs each scan; kept FALSE unless explicitly commanded below *)
Y20 := FALSE;
Y21 := FALSE;

(* --- start of a new cycle on request rising edge --- *)
IF reqEdge.Q THEN
    cmdRatio := LIMIT(500, D15, 2500);
    cmdPark  := D13;
    cmdSpan  := D14;

    Y2 := FALSE;
    Y22 := FALSE;
    resultAchieved := FALSE;

    originU := D10;
    originS := D11;

    D20 := cmdRatio;
    Y20 := TRUE;      (* gear coupling rising edge request *)

    state := 2;       (* wait for InGear confirmation *)
END_IF;

(* --- state machine --- *)
CASE state OF

    2: (* SYNC_WAIT : waiting for actual InGear confirmation *)
        D20 := cmdRatio;
        IF X11 THEN
            syncOriginU := D10;
            state := 3;
        END_IF;

    3: (* SYNC_RUN : InGear confirmed, accumulate reference rotation *)
        D20 := cmdRatio;
        IF (D10 - syncOriginU) >= cmdSpan THEN
            Y21 := TRUE;   (* gear separation rising edge request *)
            state := 4;
        END_IF;

    4: (* GEAROUT_WAIT : waiting for mechanical separation confirmation *)
        D20 := cmdRatio;
        IF NOT X12 THEN
            D20 := 0;

            (* compute park target modulo 360 in 0.01 deg units *)
            parkMod := cmdPark MOD 36000;
            IF parkMod < 0 THEN
                parkMod := parkMod + 36000;
            END_IF;

            IF D12 >= 0 THEN
                dirSign := 1;
            ELSE
                dirSign := -1;
            END_IF;

            IF dirSign = 1 THEN
                targetS := (D11 / 36000) * 36000 + parkMod;
                IF targetS < D11 THEN
                    targetS := targetS + 36000;
                END_IF;
            ELSE
                targetS := (D11 / 36000) * 36000 + parkMod;
                IF targetS > D11 THEN
                    targetS := targetS - 36000;
                END_IF;
            END_IF;

            D21 := targetS;
            Y22 := TRUE;
            state := 5;
        END_IF;

    5: (* PARKING : independent position command, wait for stable arrival *)
        D20 := 0;
        Y22 := TRUE;
        D21 := targetS;

        diffPos   := ABS(D11 - targetS);
        diffSpeed := ABS(D12);
        withinTol := (diffPos <= 20) AND (diffSpeed <= 100);

        stableTimer(IN := withinTol, PT := T#100ms);

        IF stableTimer.Q THEN
            resultAchieved := TRUE;
            Y2 := TRUE;
            state := 6;
        END_IF;

    6: (* DONE : maintain parked position and completion output *)
        D20 := 0;
        Y22 := TRUE;
        D21 := targetS;
        Y2  := TRUE;

    ELSE
        (* idle : no drive command active *)
        D20 := 0;

END_CASE;

(* safety enforcement: never issue independent position command while gear is coupled *)
IF X12 THEN
    Y22 := FALSE;
END_IF;

END_PROGRAM