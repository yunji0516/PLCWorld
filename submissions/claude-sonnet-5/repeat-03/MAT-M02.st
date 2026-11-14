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
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    edgeTrig     : R_TRIG;
    startAccepted: BOOL := FALSE;
    state        : INT := 0;
    req          : INT := 0;
    offset       : INT := 0;
    targetHead   : INT := 0;
    angErr       : INT := 0;
END_VAR

(* Detect single accepted start request *)
edgeTrig(CLK := X10);
IF edgeTrig.Q AND NOT startAccepted THEN
    startAccepted := TRUE;
    req := D10;
    state := 10;
END_IF;

CASE state OF

0: (* Idle: all actuators off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;

10: (* Descend to low pose at source to acquire *)
    Y23 := FALSE;
    Y24 := TRUE;
    IF X22 THEN
        Y24 := FALSE;
        (* capture relative angle offset while source is present/valid, before acquisition *)
        offset := ((D20 - D21) MOD 360 + 360) MOD 360;
        state := 20;
    END_IF;

20: (* Close grip to acquire the plate *)
    Y24 := FALSE;
    Y20 := TRUE;
    IF X24 THEN
        state := 30;
    END_IF;

30: (* Lift to required clearance before horizontal/rotation moves *)
    Y20 := TRUE;
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        state := 40;
    END_IF;

40: (* Rotate head so resulting plate angle equals requested angle *)
    Y20 := TRUE;
    targetHead := ((req - offset) MOD 360 + 360) MOD 360;
    angErr := ((targetHead - (D21 MOD 360)) MOD 360 + 360) MOD 360;
    IF angErr > 180 THEN
        angErr := angErr - 360;
    END_IF;
    IF angErr > 2 THEN
        Y25 := TRUE;
        Y26 := FALSE;
    ELSIF angErr < -2 THEN
        Y25 := FALSE;
        Y26 := TRUE;
    ELSE
        Y25 := FALSE;
        Y26 := FALSE;
        state := 50;
    END_IF;

50: (* Advance horizontally to receiver *)
    Y20 := TRUE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y21 := TRUE;
    IF X21 THEN
        Y21 := FALSE;
        state := 60;
    END_IF;

60: (* Descend to low pose over receiver *)
    Y20 := TRUE;
    Y21 := FALSE;
    Y24 := TRUE;
    IF X22 THEN
        Y24 := FALSE;
        state := 70;
    END_IF;

70: (* Release only with receiver support present *)
    IF X27 THEN
        Y20 := FALSE;
        IF X25 THEN
            state := 80;
        END_IF;
    ELSE
        Y20 := TRUE;
    END_IF;

80: (* Lift empty tool *)
    Y20 := FALSE;
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        state := 90;
    END_IF;

90: (* Return to source *)
    Y23 := FALSE;
    Y22 := TRUE;
    IF X20 THEN
        Y22 := FALSE;
        state := 100;
    END_IF;

100: (* Finalize: confirm empty tool at source & upper, grip released, outputs off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    IF X20 AND X23 AND X25 THEN
        Y2 := TRUE;
        state := 110;
    END_IF;

110: (* Done: maintain completion and terminal state *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM