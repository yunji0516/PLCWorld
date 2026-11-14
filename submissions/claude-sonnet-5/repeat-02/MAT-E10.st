PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;

    (* Internal state *)
    startEdge : R_TRIG;
    started : BOOL := FALSE;
    withdrawal_active : BOOL := FALSE;
    withdrawal_done : BOOL := FALSE;
    band_ok : BOOL := TRUE;
    completed : BOOL := FALSE;

    LOW_THRESH : INT := 250;
    HIGH_THRESH : INT := 650;
END_VAR

(* Detect single start rising edge *)
startEdge(CLK := X10);

IF startEdge.Q AND NOT started THEN
    started := TRUE;
    withdrawal_active := TRUE;
END_IF;

(* Band monitoring while withdrawal is active *)
IF withdrawal_active THEN
    IF (D20 < 200) OR (D20 > 700) THEN
        band_ok := FALSE;
    END_IF;
END_IF;

(* Unwind control: never before Start; hysteresis while withdrawal active; forced OFF otherwise *)
IF NOT started THEN
    Y20 := FALSE;
ELSIF withdrawal_active THEN
    IF D20 <= LOW_THRESH THEN
        Y20 := TRUE;
    ELSIF D20 >= HIGH_THRESH THEN
        Y20 := FALSE;
    END_IF;
    (* else: hold previous Y20 state (retained variable) *)
ELSE
    Y20 := FALSE;
END_IF;

(* Detect end of withdrawal (latched) *)
IF withdrawal_active AND X20 THEN
    withdrawal_active := FALSE;
    withdrawal_done := TRUE;
END_IF;

(* Completion evaluation and latch *)
IF NOT completed THEN
    IF started AND withdrawal_done AND (NOT withdrawal_active) AND band_ok AND (NOT Y20) THEN
        completed := TRUE;
    END_IF;
END_IF;

Y2 := completed;

END_PROGRAM