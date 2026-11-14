PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    (* internal variables *)
    startEdge   : R_TRIG;
    started     : BOOL := FALSE;
    doneLatched : BOOL := FALSE;
    scanCount   : DINT := 0;
END_VAR

(* scan counter for deadline/window tracking *)
scanCount := scanCount + 1;

(* detect single rising edge on start request *)
startEdge(CLK := X10);

IF (NOT started) AND startEdge.Q AND (D10 = 1) THEN
    started := TRUE;
END_IF;

(* Grip command: ON (hold) until start; OFF (release) after start, never reacquire *)
IF NOT started THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

(* Completion detection: gripper fully open, product released and received by receiver *)
IF started AND (NOT doneLatched) THEN
    IF (X21 AND X22 AND (NOT X20)) THEN
        doneLatched := TRUE;
    END_IF;
END_IF;

(* Completion claim: hold once achieved through remaining evaluation window *)
IF doneLatched THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM