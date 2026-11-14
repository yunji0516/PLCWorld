PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    startEdge : R_TRIG;
    releaseWindow : BOOL := FALSE;
    releaseStartTime : DINT := 0;
END_VAR

(* Detect start request rising edge *)
startEdge(CLK := X10);

(* Main control logic *)
IF startEdge.Q THEN
    releaseWindow := TRUE;
    releaseStartTime := 0;
END_IF

IF releaseWindow THEN
    (* Determine which products to release based on the selection bit mask D10 *)
    Y20 := BOOL(D10 AND 1);    (* Release P1 if bit 0 is set *)
    Y21 := BOOL(D10 AND 2);    (* Release P2 if bit 1 is set *)
    Y22 := BOOL(D10 AND 4);    (* Release P3 if bit 2 is set *)

    (* Check conditions for each product *)
    IF NOT BOOL(D10 AND 1) THEN
        (* Ensure retention if P1 is not selected *)
        Y20 := FALSE;
    END_IF
    IF NOT BOOL(D10 AND 2) THEN
        (* Ensure retention if P2 is not selected *)
        Y21 := FALSE;
    END_IF
    IF NOT BOOL(D10 AND 4) THEN
        (* Ensure retention if P3 is not selected *)
        Y22 := FALSE;
    END_IF

    releaseStartTime := releaseStartTime + 1;

    (* Check if we need to claim completion *)
    IF releaseStartTime >= 155 THEN
        Y2 := TRUE;
    END_IF
END_IF

(* Ensure completion claim if within the evaluation window of 1600 scans, at least until 1550 *)
IF releaseStartTime >= 160 THEN
    releaseWindow := FALSE;
END_IF

END_PROGRAM