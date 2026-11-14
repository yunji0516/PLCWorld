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

    (* internal variables *)
    state : INT := 0;
    pos_tol : DINT := 20;   (* 0.2 mm * 100 *)
    vel_tol : DINT := 100;  (* 1 mm/s * 100 *)
    a_target_cmd : DINT;
    b_target_cmd : DINT;
    doneEdge : R_TRIG;
END_VAR

(* Clamp requested targets into permitted command ranges (raw *100 units) *)
a_target_cmd := LIMIT(0, D101, 30000);
b_target_cmd := LIMIT(0, D102, 12000);

(* Update edge detector for module completion every scan *)
doneEdge(CLK := X35);

CASE state OF

0: (* Wait for start approval before enabling any axis *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y30 := FALSE;
    Y2  := FALSE;
    D20 := a_target_cmd;
    D24 := b_target_cmd;
    D21 := 1000;
    D25 := 1000;
    IF X0 THEN
        Y20 := TRUE;
        Y21 := TRUE;
        state := 1;
    END_IF

1: (* Drive both axes to the disclosed access pose *)
    D20 := a_target_cmd;
    D24 := b_target_cmd;
    D21 := 1000;
    D25 := 1000;
    IF ABS(D10 - a_target_cmd) <= pos_tol AND ABS(D11) <= vel_tol AND
       ABS(D12 - b_target_cmd) <= pos_tol AND ABS(D13) <= vel_tol THEN
        state := 2;
    END_IF

2: (* Pose established, wait until module is idle before requesting *)
    D20 := a_target_cmd;
    D24 := b_target_cmd;
    IF NOT X34 THEN
        state := 3;
    END_IF

3: (* Issue module request rising edge *)
    D20 := a_target_cmd;
    D24 := b_target_cmd;
    Y30 := TRUE;
    state := 4;

4: (* End the request pulse *)
    D20 := a_target_cmd;
    D24 := b_target_cmd;
    Y30 := FALSE;
    state := 5;

5: (* Maintain pose while module round trip is in progress *)
    D20 := a_target_cmd;
    D24 := b_target_cmd;
    IF doneEdge.Q THEN
        state := 6;
    END_IF

6: (* Module operation confirmed done: retract B to 0, keep A at target *)
    D20 := a_target_cmd;
    D24 := 0;
    IF ABS(D10 - a_target_cmd) <= pos_tol AND ABS(D11) <= vel_tol AND
       ABS(D12 - 0) <= pos_tol AND ABS(D13) <= vel_tol THEN
        state := 7;
    END_IF

7: (* Final hold: A at target, B at 0, assert and maintain completion *)
    D20 := a_target_cmd;
    D24 := 0;
    Y2 := TRUE;

ELSE
    ;
END_CASE

END_PROGRAM