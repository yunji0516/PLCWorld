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

    (* internal state *)
    start_edge : R_TRIG;
    state      : INT := 0;
    d10_stored : INT := 0;
END_VAR

(* Detect the single accepted start request *)
start_edge(CLK := X10);

(* Default: all motion/grip/align outputs OFF unless explicitly commanded below.
   Y2 is never included here so its claim persists once set. *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF

0: (* IDLE: wait for accepted start, no actuator commands before Start *)
    IF start_edge.Q THEN
        d10_stored := D10;
        state := 1;
    END_IF;

1: (* Move to lower endpoint while aligning X/Z fingers against the
      unheld plate on the source support (before it is rigidly held) *)
    Y25 := TRUE;
    Y26 := TRUE;
    IF NOT X22 THEN
        Y24 := TRUE;
    END_IF;
    IF X22 AND X31 AND X32 THEN
        state := 2;
    END_IF;

2: (* Acquire (grip) at the lower endpoint while fingers still hold
      the plate at the datum, preserving the aligned offset *)
    Y25 := TRUE;
    Y26 := TRUE;
    Y20 := TRUE;
    IF X24 THEN
        state := 3;
    END_IF;

3: (* Retract fingers (command OFF) and wait until fully clear
      before any travel past them *)
    IF X29 THEN
        state := 4;
    END_IF;

4: (* Lift to upper position (>= 360 mm) before horizontal travel *)
    Y23 := TRUE;
    IF X23 THEN
        state := 5;
    END_IF;

5: (* Horizontal travel toward receiver; fingers already clear and
      lift already high, satisfying travel safety constraints *)
    Y21 := TRUE;
    IF X21 THEN
        state := 6;
    END_IF;

6: (* Lower onto the receiver support before releasing *)
    Y24 := TRUE;
    IF X22 THEN
        state := 7;
    END_IF;

7: (* Release only once workpiece is supported at the receiver (lowered) *)
    IF X25 THEN
        state := 8;
    END_IF;

8: (* Raise tool, now empty, back to upper position *)
    Y23 := TRUE;
    IF X23 THEN
        state := 9;
    END_IF;

9: (* Return empty tool to source *)
    Y22 := TRUE;
    IF X20 THEN
        state := 10;
    END_IF;

10: (* Terminal state: empty tool at source & upper, all actuator
       outputs OFF (via default reset above), claim and hold completion *)
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM