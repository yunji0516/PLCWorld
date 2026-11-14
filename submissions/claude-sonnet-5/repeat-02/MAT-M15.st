PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;

    (* internal *)
    start_trig  : R_TRIG;
    started     : BOOL;
    requested   : INT;
    cur_state   : INT;      (* 0=clear,1=A only,2=both,3=B only *)
    seq         : INT;      (* 0=idle,1..3 forward progress,4..6 reverse progress *)
    net_count   : INT;

    dispatch_active : BOOL;
    dispatch_done   : BOOL;
    completed       : BOOL;
END_VAR

(* ---- start latch ---- *)
start_trig(CLK := X10);
IF start_trig.Q AND NOT started THEN
    started := TRUE;
    requested := D10;
    IF requested < 2 THEN
        requested := 2;
    ELSIF requested > 3 THEN
        requested := 3;
    END_IF;
END_IF;

(* ---- compute current photoeye combination ---- *)
IF (NOT X20) AND (NOT X21) THEN
    cur_state := 0;
ELSIF X20 AND (NOT X21) THEN
    cur_state := 1;
ELSIF X20 AND X21 THEN
    cur_state := 2;
ELSE
    cur_state := 3;
END_IF;

(* ---- passage sequence tracking : forward / reverse / partial ---- *)
CASE cur_state OF
0:
    IF seq = 3 THEN
        net_count := net_count + 1;
    ELSIF seq = 6 THEN
        net_count := net_count - 1;
    END_IF;
    seq := 0;
1:
    IF (seq = 4) OR (seq = 5) OR (seq = 6) THEN
        seq := 6;
    ELSE
        seq := 1;
    END_IF;
2:
    IF (seq = 4) OR (seq = 5) OR (seq = 6) THEN
        seq := 5;
    ELSE
        seq := 2;
    END_IF;
3:
    IF (seq = 2) OR (seq = 3) THEN
        seq := 3;
    ELSE
        seq := 4;
    END_IF;
END_CASE;

(* ---- feed control ---- *)
IF started AND (NOT completed) AND (NOT dispatch_active) AND (NOT dispatch_done) AND (net_count < requested) THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

(* ---- dispatch initiation ---- *)
IF (NOT dispatch_active) AND (NOT dispatch_done) AND started
   AND (net_count = requested) AND (NOT X22) AND X23 AND X24 AND (NOT Y20) THEN
    dispatch_active := TRUE;
END_IF;

IF dispatch_active AND (NOT dispatch_done) THEN
    Y21 := TRUE;
    IF X25 THEN
        dispatch_done := TRUE;
        dispatch_active := FALSE;
        Y21 := FALSE;
    END_IF;
ELSE
    Y21 := FALSE;
END_IF;

(* ---- completion evaluation ---- *)
IF NOT completed THEN
    IF dispatch_done AND (net_count = requested) AND X23 AND (NOT X22)
       AND (NOT Y20) AND (NOT Y21) THEN
        completed := TRUE;
    END_IF;
END_IF;

Y2 := completed;

END_PROGRAM