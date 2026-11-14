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
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    state : INT := 0;
    req_ID : INT := 0;
    target_D21 : INT := 0;
    next_scan_D21 : INT := 0;
    edge_X10 : R_TRIG;
END_VAR

edge_X10(CLK := X10);

(* Default all actuator outputs to OFF. Active states will override them to TRUE. *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

CASE state OF
  0:
    (* Wait for the start request *)
    IF edge_X10.Q THEN
      req_ID := D10;
      state := 1;
    END_IF

  1:
    (* Read and evaluate the pocket currently at the reader *)
    IF X20 THEN
      IF D20 = req_ID THEN
        (* Found the requested item. The ejector (station 2) is exactly 180 degrees (2 indexes) away from the reader (station 0). *)
        target_D21 := (D21 + 2) MOD 4;
        state := 3;
      ELSE
        (* Item not found at current pocket, step to the next index *)
        next_scan_D21 := (D21 + 1) MOD 4;
        state := 2;
      END_IF
    ELSE
      (* Initial condition is not aligned to a detent, rotate to the nearest reported index first *)
      next_scan_D21 := D21;
      state := 2;
    END_IF

  2:
    (* Rotate CW until the next index is reached and aligned *)
    IF D21 = next_scan_D21 AND X20 THEN
      state := 1;
    ELSE
      Y20 := TRUE;
    END_IF

  3:
    (* Rotate CW until the target pocket reaches the ejector *)
    IF D21 = target_D21 AND X20 THEN
      state := 4;
    ELSE
      Y20 := TRUE;
    END_IF

  4:
    (* Push the item out *)
    IF X22 THEN
      state := 5;
    ELSE
      Y22 := TRUE;
    END_IF

  5:
    (* Retract the pusher back to home position *)
    IF X21 THEN
      state := 6;
    ELSE
      Y23 := TRUE;
    END_IF

  6:
    (* Delivery complete, hold claim *)
    Y2 := TRUE;

END_CASE

END_PROGRAM