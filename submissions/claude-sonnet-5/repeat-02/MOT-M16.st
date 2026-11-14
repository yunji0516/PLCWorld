PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    state : INT := 0;
    pos_tol : DINT := 20;   (* 0.2 mm * 100 *)
    vel_tol : DINT := 100;  (* 1 mm/s * 100 *)
    valid_request : BOOL;
    r_trig_done : R_TRIG;
END_VAR

(* ---- validate the incoming request against published domains ---- *)
valid_request := (D101 >= 20000) AND (D101 <= 21000) AND
                  (D102 >= 7000)  AND (D102 <= 8000);

(* ---- defaults each scan, overridden by specific states below ---- *)
D21 := 1000;
D25 := 1000;
D20 := D101;
D24 := D102;
Y30 := FALSE;
Y2  := FALSE;

r_trig_done(CLK := X35);

CASE state OF

0: (* INIT: wait for start approval; targets may be prepared while disabled *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X0 AND valid_request THEN
        state := 1;
    END_IF;

1: (* MOVE_TO_POSE: drive A to target, B to depth *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF (ABS(D10 - D101) <= pos_tol) AND (ABS(D11) <= vel_tol) AND
       (ABS(D12 - D102) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        state := 2;
    END_IF;

2: (* POSE_READY: request module only if both axes at pose and module idle *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF NOT ((ABS(D10 - D101) <= pos_tol) AND (ABS(D12 - D102) <= pos_tol)) THEN
        state := 1; (* alignment lost before request - go re-establish pose *)
    ELSIF NOT X34 THEN
        state := 3;
    END_IF;

3: (* REQUEST_SENT: pulse Y30 for one scan (rising edge) *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y30 := TRUE;
    state := 4;

4: (* WAIT_MODULE: preserve pose until module operation physically finishes *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF r_trig_done.Q THEN
        state := 5;
    END_IF;

5: (* RETRACT: bring B back to 0 while keeping A at target *)
    Y20 := TRUE;
    Y21 := TRUE;
    D24 := 0;
    IF (ABS(D10 - D101) <= pos_tol) AND (ABS(D11) <= vel_tol) AND
       (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        state := 6;
    END_IF;

6: (* DONE: hold A at target and B at 0, assert and maintain completion *)
    Y20 := TRUE;
    Y21 := TRUE;
    D24 := 0;
    Y2  := TRUE;

ELSE
    state := 0;
END_CASE;

END_PROGRAM