PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;

    start_trig : R_TRIG;
    started : BOOL := FALSE;
    completed : BOOL := FALSE;
    violation : BOOL := FALSE;
    steer_cmd : INT := 0;
END_VAR

(* Detect the single Start rising edge *)
start_trig(CLK := X10);
IF start_trig.Q THEN
    started := TRUE;
END_IF;

(* Steering control law: bang-bang with hysteresis deadband.
   steer_cmd = 1  -> activate Y20 (left)  : used when edge error is high positive
   steer_cmd = -1 -> activate Y21 (right) : used when edge error is high negative
   steer_cmd = 0  -> both commands OFF
   Between 2 and 4 (in magnitude) the previous command is retained (hysteresis)
   to avoid chattering and to guarantee mutual exclusivity of Y20/Y21. *)
IF started AND NOT completed THEN

    IF D20 > 4 THEN
        steer_cmd := 1;
    ELSIF D20 < -4 THEN
        steer_cmd := -1;
    ELSIF (D20 >= -2) AND (D20 <= 2) THEN
        steer_cmd := 0;
    END_IF;
    (* else: keep previous steer_cmd (hysteresis band) *)

    CASE steer_cmd OF
        1:  Y20 := TRUE;  Y21 := FALSE;
        -1: Y20 := FALSE; Y21 := TRUE;
        0:  Y20 := FALSE; Y21 := FALSE;
    ELSE
        Y20 := FALSE; Y21 := FALSE;
    END_CASE;

ELSE
    (* Never actuate before Start, and force OFF once completion is claimed *)
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

(* Track corridor violation throughout the feed once started *)
IF started AND ((D20 > 12) OR (D20 < -12)) THEN
    violation := TRUE;
END_IF;

(* Completion claim: latch once satisfied, never revoke *)
IF NOT Y2 THEN
    IF started AND X20
       AND (NOT Y20) AND (NOT Y21)
       AND (NOT violation)
       AND (D20 >= -12) AND (D20 <= 12) THEN
        Y2 := TRUE;
        completed := TRUE;
    END_IF;
END_IF;

(* Post-claim maintenance: keep actuators OFF and Y2 held *)
IF Y2 THEN
    completed := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

END_PROGRAM