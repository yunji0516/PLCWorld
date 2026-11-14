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

    (* internal *)
    state      : INT := 0;
    started    : BOOL := FALSE;
    startTrig  : R_TRIG;
END_VAR

(* Detect the accepted start request *)
startTrig(CLK := X10);

IF (NOT started) AND startTrig.Q AND (D10 = 1) THEN
    started := TRUE;
    state := 1;
END_IF;

(* Default all actuator outputs OFF each scan; case below turns on only
   what is needed for the current state. This also enforces that no
   command is issued before Start is accepted (state = 0). *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF

0: (* idle - waiting for accepted start; nothing commanded *)
    ;

1: (* descend at source to low position, prior to alignment *)
    Y24 := TRUE;
    IF X22 THEN
        state := 2;
    END_IF;

2: (* close X/Z alignment fingers, contacting the unheld plate,
      until source datum alignment is reported *)
    Y25 := TRUE;
    Y26 := TRUE;
    IF X31 AND X32 THEN
        state := 3;
    END_IF;

3: (* grip the aligned plate while fingers remain closed to
      preserve the alignment during acquisition *)
    Y25 := TRUE;
    Y26 := TRUE;
    Y20 := TRUE;
    IF X24 THEN
        state := 4;
    END_IF;

4: (* retract fingers (command OFF) while holding the plate *)
    Y20 := TRUE;
    IF X29 THEN
        state := 5;
    END_IF;

5: (* lift to sufficient height before horizontal travel *)
    Y20 := TRUE;
    Y23 := TRUE;
    IF X23 THEN
        state := 6;
    END_IF;

6: (* travel to receiver; fingers already clear *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF X21 THEN
        state := 7;
    END_IF;

7: (* descend at receiver onto its flat support before release *)
    Y20 := TRUE;
    Y24 := TRUE;
    IF X22 THEN
        state := 8;
    END_IF;

8: (* release only while supported by the receiver's flat support *)
    IF X25 THEN
        state := 9;
    END_IF;

9: (* lift clear of the receiver *)
    Y23 := TRUE;
    IF X23 THEN
        state := 10;
    END_IF;

10: (* return to source *)
    Y22 := TRUE;
    IF X20 THEN
        state := 11;
    END_IF;

11: (* done: empty tool at source, upper position, all actuators OFF *)
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM