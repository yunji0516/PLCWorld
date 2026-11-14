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
    start_trig : R_TRIG;
    started    : BOOL := FALSE;
    state      : DINT := 0;
    req_spacing: INT   := 0;
    grip_hold  : BOOL  := FALSE;
END_VAR

(* -------- edge detect start request -------- *)
start_trig(CLK := X10);

IF start_trig.Q AND NOT started THEN
    started     := TRUE;
    req_spacing := D10;
    state       := 10;
END_IF;

(* -------- default outputs each scan (will be overridden below) -------- *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

(* Y24 (grip) is held true only while grip_hold is set *)
Y24 := grip_hold;

CASE state OF

0: (* idle - waiting for start, no actuator operation *)
    ; (* nothing to do *)

10: (* move down to reach low pose for pickup *)
    Y23 := TRUE;
    IF X23 THEN
        state := 20;
    END_IF;

20: (* close grip on both materials, needs low pose *)
    grip_hold := TRUE;
    Y24 := TRUE;
    IF X24 THEN
        state := 30;
    END_IF;

30: (* lift up to high position before any horizontal/spacing move *)
    Y22 := TRUE;
    IF X22 THEN
        state := 40;
    END_IF;

40: (* adjust spacing to requested target, only while high (lift >=220mm) *)
    IF D20 < req_spacing THEN
        Y25 := TRUE;
    ELSIF D20 > req_spacing THEN
        Y26 := TRUE;
    ELSE
        state := 50;
    END_IF;

50: (* move forward to target side, only while high *)
    Y20 := TRUE;
    IF X21 THEN
        state := 60;
    END_IF;

60: (* lower to placement pose at target *)
    Y23 := TRUE;
    IF X23 THEN
        state := 70;
    END_IF;

70: (* release materials into receiving nests, needs low pose *)
    grip_hold := FALSE;
    Y24 := FALSE;
    IF X25 THEN
        state := 80;
    END_IF;

80: (* lift empty tool back up to high position *)
    Y22 := TRUE;
    IF X22 THEN
        state := 90;
    END_IF;

90: (* return empty tool back to home/source side, only while high *)
    Y21 := TRUE;
    IF X20 THEN
        state := 100;
    END_IF;

100: (* finalize: all actuators off, assert completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    grip_hold := FALSE;
    Y2 := TRUE;
    state := 110;

110: (* maintain terminal result and completion claim *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    grip_hold := FALSE;
    Y2 := TRUE;

ELSE
    (* unknown state, hold safe: no actuator operation *)
    state := 0;

END_CASE;

END_PROGRAM