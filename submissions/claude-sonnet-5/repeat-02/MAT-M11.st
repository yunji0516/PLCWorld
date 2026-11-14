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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal state *)
    startEdge      : R_TRIG;
    accepted       : BOOL := FALSE;
    state          : INT := 0;
    fullOpenAchieved : BOOL := FALSE;
END_VAR

(* Detect the single accepted start request *)
startEdge(CLK := X10);

IF (NOT accepted) AND startEdge.Q THEN
    accepted := TRUE;
    state := 1;
END_IF;

CASE state OF

0:
    (* Idle - no actuator operation before Start is accepted *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;

1:
    (* Grip both sides of the receiver *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X20 AND X21 THEN
        state := 2;
    END_IF;

2:
    (* Drive opening axis to full open, holding vacuum grip *)
    Y22 := TRUE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X22 THEN
        fullOpenAchieved := TRUE;
        Y22 := FALSE;
        state := 3;
    END_IF;

3:
    (* Insert content forward into the receiver until seated.
       Opening axis stays mechanically at the reached full-open
       position (axis OFF only stops motion, does not retract),
       and both vacuum sides remain held, keeping actual gap
       at 185 mm which satisfies the >=150 mm safety margin
       while fronts are beyond the entrance. *)
    Y24 := TRUE;
    Y25 := FALSE;
    IF X25 THEN
        Y24 := FALSE;
        state := 4;
    END_IF;

4:
    (* Retract insertion tool while content stays seated and
       both vacuum sides remain held until the tool clears (home). *)
    Y25 := TRUE;
    Y24 := FALSE;
    IF X23 THEN
        Y25 := FALSE;
        state := 5;
    END_IF;

5:
    (* Tool is clear (home) - release both vacuum sides *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X26 THEN
        state := 6;
    END_IF;

6:
    (* Verify completion conditions and latch claim *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X25 AND X23 AND X26 AND fullOpenAchieved THEN
        Y2 := TRUE;
        state := 7;
    END_IF;

7:
    (* Post-claim maintenance: keep all actuator outputs OFF
       and hold the completion claim for the remainder of the run. *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM