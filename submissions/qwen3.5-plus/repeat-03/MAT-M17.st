PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    branch_timer : TON;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
  0: (* Idle - Wait for start request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    IF start_edge.Q THEN
      state := 1;
    END_IF;

  1: (* Purge ID1 to waste *)
    Y20 := TRUE;
    Y21 := FALSE;
    IF D20 = 2 THEN
      state := 2;
    END_IF;

  2: (* Switch branch to target, wait for settling *)
    Y20 := FALSE;
    Y21 := TRUE;
    branch_timer(IN := TRUE, PT := T#300ms);
    IF branch_timer.Q THEN
      state := 3;
    END_IF;

  3: (* Transfer ID2 to target *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF X22 THEN
      state := 4;
    END_IF;

  4: (* Done - Maintain completion claim *)
    Y20 := FALSE;
    Y21 := TRUE;
    Y2 := TRUE;
END_CASE;

(* Reset timer when not in state 2 *)
IF state <> 2 THEN
  branch_timer(IN := FALSE, PT := T#300ms);
END_IF;

END_PROGRAM