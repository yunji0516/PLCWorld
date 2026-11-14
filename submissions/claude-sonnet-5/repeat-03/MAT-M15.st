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

    (* internal state *)
    started        : BOOL := FALSE;
    requested      : INT  := 0;
    net_count      : INT  := 0;
    transfer_state : INT  := 0;   (* 0=empty,1=A,2=AB(fwd),3=B(fwd-near),4=B(rev entry),5=AB(rev),6=A(rev-near) *)
    startTrig      : R_TRIG;
    dispatch_phase : BOOL := FALSE;
    dispatched_done: BOOL := FALSE;
    a              : BOOL;
    b              : BOOL;
END_VAR

(* --- start latch --- *)
startTrig(CLK := X10);
IF startTrig.Q AND NOT started THEN
    started := TRUE;
    requested := D10;
END_IF;

a := X20;
b := X21;

(* --- passage state machine: forward passage increments net_count,
     reverse passage decrements net_count; partial entries/retreats
     do not change net_count --- *)
CASE transfer_state OF
    0: (* empty *)
        IF a AND NOT b THEN
            transfer_state := 1;
        ELSIF b AND NOT a THEN
            transfer_state := 4;
        END_IF;

    1: (* A only - forward entry *)
        IF a AND b THEN
            transfer_state := 2;
        ELSIF (NOT a) AND (NOT b) THEN
            transfer_state := 0; (* partial retreat, no count *)
        END_IF;

    2: (* both - forward path *)
        IF (NOT a) AND b THEN
            transfer_state := 3;
        ELSIF a AND (NOT b) THEN
            transfer_state := 1; (* retreat *)
        END_IF;

    3: (* B only - forward near complete *)
        IF (NOT a) AND (NOT b) THEN
            net_count := net_count + 1;
            transfer_state := 0;
        ELSIF a AND b THEN
            transfer_state := 2; (* retreat *)
        END_IF;

    4: (* B only - reverse entry *)
        IF a AND b THEN
            transfer_state := 5;
        ELSIF (NOT a) AND (NOT b) THEN
            transfer_state := 0; (* partial retreat, no count *)
        END_IF;

    5: (* both - reverse path *)
        IF a AND (NOT b) THEN
            transfer_state := 6;
        ELSIF (NOT a) AND b THEN
            transfer_state := 4; (* retreat *)
        END_IF;

    6: (* A only - reverse near complete *)
        IF (NOT a) AND (NOT b) THEN
            net_count := net_count - 1;
            transfer_state := 0;
        ELSIF a AND b THEN
            transfer_state := 5; (* retreat *)
        END_IF;
END_CASE;

(* --- feed control --- *)
IF started AND (NOT dispatch_phase) AND (net_count < requested) THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

(* --- dispatch trigger: only when net matches request, transfer empty,
     tray settled, no unfinished external return, feed off --- *)
IF (NOT dispatch_phase) AND started AND (net_count = requested)
   AND X23 AND X24 AND (NOT X22) AND (NOT Y20) THEN
    dispatch_phase := TRUE;
END_IF;

IF dispatch_phase AND (NOT dispatched_done) THEN
    Y21 := TRUE;
    IF X25 THEN
        dispatched_done := TRUE;
        Y21 := FALSE;
    END_IF;
ELSE
    Y21 := FALSE;
END_IF;

(* --- completion latch --- *)
IF dispatched_done AND X23 AND (net_count = requested)
   AND (NOT Y20) AND (NOT Y21) AND (NOT X22) THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM