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
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    aProbeTimer : TON;
    probeWaitTimer : TON;
    returnDriveTimer : TON;
    phase : INT;
    request_count : INT;
    net_count : INT;
    pass_state : INT;
    pat : INT;
    fwd_event : BOOL;
    rev_event : BOOL;
    partial_event : BOOL;
    waiting_settle : BOOL;
    return_drive : BOOL;
    probe_active : BOOL;
    probe_done : BOOL;
    retreat_waiting : BOOL;
    feed_cmd : BOOL;
END_VAR

startEdge(CLK := X10);

IF startEdge.Q AND (phase = 0) THEN
    IF D10 = 3 THEN
        request_count := 3;
    ELSE
        request_count := 2;
    END_IF;
    net_count := 0;
    pass_state := 0;
    waiting_settle := FALSE;
    return_drive := FALSE;
    probe_active := FALSE;
    probe_done := FALSE;
    retreat_waiting := FALSE;
    phase := 1;
END_IF;

fwd_event := FALSE;
rev_event := FALSE;
partial_event := FALSE;

IF X20 AND X21 THEN
    pat := 2;
ELSIF X20 THEN
    pat := 1;
ELSIF X21 THEN
    pat := 3;
ELSE
    pat := 0;
END_IF;

CASE pat OF
    0:
        IF pass_state = 3 THEN
            fwd_event := TRUE;
        ELSIF pass_state = 6 THEN
            rev_event := TRUE;
        ELSIF pass_state = 1 THEN
            partial_event := TRUE;
        END_IF;
        pass_state := 0;
    1:
        IF pass_state = 0 THEN
            pass_state := 1;
        ELSIF pass_state = 2 THEN
            pass_state := 6;
        ELSIF pass_state = 5 THEN
            pass_state := 6;
        END_IF;
    2:
        IF pass_state = 1 THEN
            pass_state := 2;
        ELSIF pass_state = 4 THEN
            pass_state := 5;
        END_IF;
    3:
        IF pass_state = 0 THEN
            pass_state := 4;
        ELSIF pass_state = 2 THEN
            pass_state := 3;
        ELSIF pass_state = 5 THEN
            pass_state := 4;
        END_IF;
ELSE
    pass_state := pass_state;
END_CASE;

IF phase = 1 THEN
    IF fwd_event THEN
        net_count := net_count + 1;
        probe_active := FALSE;
        probe_done := FALSE;
        retreat_waiting := FALSE;
        IF X22 THEN
            return_drive := TRUE;
            waiting_settle := FALSE;
        ELSE
            return_drive := FALSE;
            waiting_settle := TRUE;
        END_IF;
    END_IF;

    IF rev_event THEN
        IF net_count > 0 THEN
            net_count := net_count - 1;
        END_IF;
        return_drive := FALSE;
        waiting_settle := FALSE;
        probe_active := FALSE;
        probe_done := FALSE;
        IF X22 THEN
            retreat_waiting := TRUE;
        ELSE
            retreat_waiting := FALSE;
        END_IF;
    END_IF;

    IF partial_event THEN
        return_drive := FALSE;
        waiting_settle := FALSE;
        probe_active := FALSE;
        probe_done := FALSE;
        IF X22 THEN
            retreat_waiting := TRUE;
        ELSE
            retreat_waiting := FALSE;
        END_IF;
    END_IF;

    IF waiting_settle AND X23 AND X24 AND (NOT X22) AND (NOT X20) AND (NOT X21) THEN
        waiting_settle := FALSE;
    END_IF;

    IF return_drive AND ((pass_state = 4) OR (pass_state = 5) OR (pass_state = 6)) THEN
        return_drive := FALSE;
        retreat_waiting := TRUE;
    END_IF;

    IF NOT X22 THEN
        probe_active := FALSE;
        probe_done := FALSE;
        retreat_waiting := FALSE;
        return_drive := FALSE;
    END_IF;
END_IF;

aProbeTimer(IN := ((phase = 1) AND X22 AND (pass_state = 1) AND (NOT probe_done) AND (NOT probe_active) AND (NOT retreat_waiting) AND (NOT return_drive)), PT := T#380ms);

IF aProbeTimer.Q THEN
    probe_active := TRUE;
END_IF;

probeWaitTimer(IN := probe_active, PT := T#700ms);
returnDriveTimer(IN := return_drive, PT := T#700ms);

IF phase = 1 THEN
    IF probe_active THEN
        IF NOT X22 THEN
            probe_active := FALSE;
            probe_done := FALSE;
            retreat_waiting := FALSE;
        ELSIF (NOT X20) AND (NOT X21) THEN
            probe_active := FALSE;
            retreat_waiting := TRUE;
        ELSIF probeWaitTimer.Q AND (X20 OR X21) THEN
            probe_active := FALSE;
            probe_done := TRUE;
        END_IF;
    END_IF;

    IF retreat_waiting AND (NOT X22) THEN
        retreat_waiting := FALSE;
        probe_active := FALSE;
        probe_done := FALSE;
        return_drive := FALSE;
    END_IF;

    IF (net_count = request_count) AND (NOT X22) AND (NOT waiting_settle) AND (NOT return_drive) AND (NOT probe_active) AND (NOT retreat_waiting) AND X23 AND X24 AND (NOT X20) AND (NOT X21) THEN
        phase := 2;
    END_IF;
END_IF;

IF (phase = 2) AND X25 THEN
    phase := 3;
END_IF;

feed_cmd := FALSE;

IF phase = 1 THEN
    IF (net_count < request_count) OR X22 THEN
        IF waiting_settle THEN
            feed_cmd := FALSE;
        ELSIF probe_active OR retreat_waiting THEN
            feed_cmd := FALSE;
        ELSIF return_drive THEN
            IF (NOT returnDriveTimer.Q) AND X22 THEN
                feed_cmd := TRUE;
            ELSE
                feed_cmd := FALSE;
            END_IF;
        ELSIF X22 AND ((pass_state = 4) OR (pass_state = 5) OR (pass_state = 6)) THEN
            feed_cmd := FALSE;
        ELSE
            feed_cmd := TRUE;
        END_IF;
    END_IF;
END_IF;

Y20 := feed_cmd;
Y21 := (phase = 2);

IF phase = 3 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM