PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
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
    D20 : INT;

    (* internal *)
    state : INT := 0;
    startReq : R_TRIG;
    reqSpacing : INT := 0;
    spacingTol : INT := 2;
END_VAR

(* Default all outputs off every scan; explicit states re-assert what is needed *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

startReq(CLK := X10);

CASE state OF

0: (* IDLE - wait for accepted start; no actuator commands *)
    IF startReq.Q THEN
        reqSpacing := D10;
        state := 10;
    END_IF;

10: (* Descend at source to low pose (pickup) *)
    IF NOT X23 THEN
        Y23 := TRUE;
    ELSE
        state := 20;
    END_IF;

20: (* Close grip to acquire both materials *)
    Y24 := TRUE;
    IF X24 THEN
        state := 30;
    END_IF;

30: (* Lift to high before any horizontal/spacing motion *)
    Y24 := TRUE;
    IF NOT X22 THEN
        Y22 := TRUE;
    ELSE
        state := 40;
    END_IF;

40: (* Adjust spacing to requested value while lifted high, grip held *)
    Y24 := TRUE;
    IF D20 < (reqSpacing - spacingTol) THEN
        Y25 := TRUE;
    ELSIF D20 > (reqSpacing + spacingTol) THEN
        Y26 := TRUE;
    ELSE
        state := 50;
    END_IF;

50: (* Move forward to target/receiver location *)
    Y24 := TRUE;
    IF NOT X21 THEN
        Y20 := TRUE;
    ELSE
        state := 60;
    END_IF;

60: (* Descend at target to low pose (release) *)
    Y24 := TRUE;
    IF NOT X23 THEN
        Y23 := TRUE;
    ELSE
        state := 70;
    END_IF;

70: (* Open grip to release both materials into nests *)
    IF X25 THEN
        state := 80;
    END_IF;

80: (* Lift empty tool back to high *)
    IF NOT X22 THEN
        Y22 := TRUE;
    ELSE
        state := 90;
    END_IF;

90: (* Return to source/home position *)
    IF NOT X20 THEN
        Y21 := TRUE;
    ELSE
        state := 100;
    END_IF;

100: (* Terminal: empty tool at source upper position, all actuators off *)
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM