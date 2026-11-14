PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    (* internal *)
    startTrig   : R_TRIG;
    started     : BOOL := FALSE;
    target      : INT := 0;
    state       : INT := 0;   (* 0=idle,1=feeding,2=clamping,3=done *)
    edgeDeadband : INT := 2;
END_VAR

(* --- edge detect start request --- *)
startTrig(CLK := X10);

IF (NOT started) AND startTrig.Q THEN
    started := TRUE;
    target  := D10;
    state   := 1;
END_IF;

CASE state OF

0: (* idle - nothing commanded before start accepted *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

1: (* feeding with concurrent steering correction *)

    (* steering correction: keep edge near zero, never opposing commands together *)
    IF D20 > edgeDeadband THEN
        Y20 := TRUE;
        Y21 := FALSE;
    ELSIF D20 < -edgeDeadband THEN
        Y20 := FALSE;
        Y21 := TRUE;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;

    (* feed command: stop before overshoot beyond tolerance *)
    IF D21 < (target - 3) THEN
        Y22 := TRUE;
    ELSE
        Y22 := FALSE;
        state := 2;
    END_IF;

    Y23 := FALSE; (* clamp stays open while feeding *)

2: (* stop feed & steering, close clamp, wait for secured feedback *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;

    IF X20 THEN
        state := 3;
    END_IF;

3: (* done - maintain terminal state *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;
    Y2  := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

END_CASE;

END_PROGRAM