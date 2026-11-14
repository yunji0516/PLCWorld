PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    state : INT := 0;
    startEdge : R_TRIG;
    accepted : BOOL := FALSE;
    reqVal : INT := 0;
    gripHold : BOOL := FALSE;
END_VAR

startEdge(CLK := X10);

IF (NOT accepted) AND startEdge.Q THEN
    reqVal := D10;
    IF reqVal = 1 THEN
        accepted := TRUE;
        state := 1;
    END_IF;
END_IF;

// Default OFF for movement/finger outputs each scan; grip is
// re-applied at the end from gripHold so it is never left un-driven.
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF

    0: // idle, waiting for accepted start; no actuator commands allowed
        ;

    1: // align fingers close on the unheld source plate to bring it to datum
        Y25 := TRUE;
        Y26 := TRUE;
        IF X31 AND X32 THEN
            state := 2;
        END_IF;

    2: // retract fingers fully before any travel
        // Y25/Y26 already FALSE from the top-of-scan reset
        IF X29 THEN
            state := 3;
        END_IF;

    3: // descend to grip height at source (low, fingers already clear)
        Y24 := TRUE;
        IF X22 THEN
            state := 4;
        END_IF;

    4: // close grip on the now-aligned plate (offset acquisition)
        gripHold := TRUE;
        IF X24 THEN
            state := 5;
        END_IF;

    5: // lift to a safe travel height before horizontal motion
        Y23 := TRUE;
        IF X23 THEN
            state := 6;
        END_IF;

    6: // travel to receiver; fingers stay retracted throughout
        Y21 := TRUE;
        IF X21 THEN
            state := 7;
        END_IF;

    7: // descend at receiver so the plate is supported before release
        Y24 := TRUE;
        IF X22 THEN
            state := 8;
        END_IF;

    8: // release grip only once supported on the receiver
        gripHold := FALSE;
        IF X25 THEN
            state := 9;
        END_IF;

    9: // lift the now-empty tool back up
        Y23 := TRUE;
        IF X23 THEN
            state := 10;
        END_IF;

    10: // return empty tool to source, fingers remain retracted
        Y22 := TRUE;
        IF X20 THEN
            state := 11;
        END_IF;

    11: // terminal: claim completion, keep all actuators except Y2 off
        Y2 := TRUE;

    ELSE
        ;
END_CASE;

Y20 := gripHold;

END_PROGRAM