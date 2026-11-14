PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    (* Internal variables *)
    startEdge : R_TRIG;
    started : BOOL := FALSE;
    running : BOOL := FALSE;
    seenBlock : BOOL := FALSE;
    passed : BOOL := FALSE;
END_VAR

(* Detect the single rising edge of the start request *)
startEdge(CLK := X10);

IF startEdge.Q AND NOT started THEN
    started := TRUE;
    running := TRUE;
END_IF;

(* While running, drive the conveyor forward and watch the photoeye
   for a full block-then-clear cycle, which indicates the trailing
   edge has passed the receiving boundary at x=120mm. An initially
   unblocked photoeye does NOT by itself indicate passage. *)
IF running THEN
    IF X20 THEN
        seenBlock := TRUE;
    END_IF;

    IF seenBlock AND NOT X20 THEN
        passed := TRUE;
        running := FALSE;
    END_IF;
END_IF;

(* Feed command: only ON while actively running toward the boundary *)
Y20 := running;

(* Completion claim: held once trailing edge has passed and feed is OFF *)
IF passed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM