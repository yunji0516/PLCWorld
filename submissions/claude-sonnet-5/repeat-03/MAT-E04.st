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

    (* internal variables *)
    state : INT := 0;
    start_trig : R_TRIG;
    ack_trig : R_TRIG;
    rearm_timer : TON;
END_VAR

(* Detect the single Start rising edge and kick off the sequence *)
start_trig(CLK := X10);

IF state = 0 AND start_trig.Q THEN
    state := 1;
END_IF;

CASE state OF

    0:
        (* Idle: no actuation before Start *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2  := FALSE;

    1:
        (* REARM: hold Offer OFF continuously to lower any stale Ack
           and rearm the current transaction. Require minimum 0.12s
           (use 0.15s margin) hold time AND Ack observed low. *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2  := FALSE;
        rearm_timer(IN := TRUE, PT := T#150ms);
        IF rearm_timer.Q AND (NOT X21) THEN
            rearm_timer(IN := FALSE, PT := T#150ms);
            state := 2;
        END_IF;

    2:
        (* WAIT_READY: Offer stays OFF until Ready is observed *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2  := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;

    3:
        (* OFFER: with rearming done and Ready true, raise Offer.
           Wait for a fresh rising edge of Ack (valid acceptance
           of THIS transaction, since prior Ack was cleared). *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y2  := FALSE;
        ack_trig(CLK := X21);
        IF ack_trig.Q THEN
            state := 4;
        END_IF;

    4:
        (* RELEASE: valid acceptance confirmed -> release sender *)
        Y21 := TRUE;
        Y20 := TRUE;
        Y2  := FALSE;
        IF X20 THEN
            state := 5;
        END_IF;

    5:
        (* WAIT_RECEIVED: wait for receiver to own the product
           after sender release *)
        Y21 := TRUE;
        Y20 := TRUE;
        Y2  := FALSE;
        IF X23 THEN
            state := 6;
        END_IF;

    6:
        (* CLEAR_OFFER: turn Offer OFF; this lowers/resets Ack.
           Wait for Ack to actually reset before declaring done. *)
        Y21 := FALSE;
        Y20 := TRUE;
        Y2  := FALSE;
        IF NOT X21 THEN
            state := 7;
        END_IF;

    7:
        (* DONE: maintain handoff result; Offer OFF, Ack reset,
           sender released, completion claim held *)
        Y21 := FALSE;
        Y20 := TRUE;
        Y2  := TRUE;

    ELSE
        ;
END_CASE;

END_PROGRAM