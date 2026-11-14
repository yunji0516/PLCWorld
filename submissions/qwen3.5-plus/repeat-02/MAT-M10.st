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
    X28 : BOOL;
    D20 : INT;
    
    (* Internal variables *)
    startEdge : R_TRIG;
    gripTimer : TON;
    selectedMask : INT;
    state : INT;
END_VAR

(* State definitions:
   0: IDLE - wait for X10 rising edge
   1: MOVE_DOWN - lower head to source low position
   2: RELEASE_UNSELECTED - release materials NOT selected for target
   3: MOVE_UP - raise head to high position (must be high before horizontal move)
   4: MOVE_FORWARD - move to target (only if any materials selected)
   5: MOVE_DOWN_TARGET - lower head to target low position
   6: RELEASE_SELECTED - release materials selected for target
   7: MOVE_UP_TARGET - raise head to high position at target
   8: MOVE_BACK - return to source
   9: DONE - set completion
*)

startEdge(CLK := X10);

CASE state OF
0: (* IDLE - wait for start request *)
    (* All outputs remain FALSE until start *)
    IF startEdge.Q THEN
        selectedMask := D10 AND 7;  (* extract bits 0-2 *)
        state := 1;
    END_IF;

1: (* MOVE_DOWN - lower from source upper to source low *)
    Y23 := TRUE;   (* down *)
    Y22 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y24 := FALSE;  (* grips closed - materials still held *)
    Y25 := FALSE;
    Y26 := FALSE;
    IF X23 THEN
        state := 2;
    END_IF;

2: (* RELEASE_UNSELECTED - release materials staying at source *)
    Y23 := TRUE;   (* remain at low *)
    Y22 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    
    (* Release outputs for materials NOT in selectedMask *)
    Y24 := NOT BOOL(selectedMask AND 1);
    Y25 := NOT BOOL(selectedMask AND 2);
    Y26 := NOT BOOL(selectedMask AND 4);
    
    (* Wait for grip response time 0.12s = 120ms *)
    gripTimer(IN := TRUE, PT := T#120ms);
    IF gripTimer.Q THEN
        gripTimer(IN := FALSE);
        state := 3;
    END_IF;

3: (* MOVE_UP - raise to high position before horizontal travel *)
    Y22 := TRUE;   (* up *)
    Y23 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y24 := FALSE;  (* close grips - selected materials still held *)
    Y25 := FALSE;
    Y26 := FALSE;
    IF X22 THEN
        IF selectedMask > 0 THEN
            state := 4;  (* some materials need to go to target *)
        ELSE
            state := 9;  (* no materials selected, all at source already *)
        END_IF;
    END_IF;

4: (* MOVE_FORWARD - travel to target position *)
    Y20 := TRUE;   (* forward *)
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X21 THEN
        state := 5;
    END_IF;

5: (* MOVE_DOWN_TARGET - lower to target low position *)
    Y23 := TRUE;   (* down *)
    Y22 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    IF X23 THEN
        state := 6;
    END_IF;

6: (* RELEASE_SELECTED - release materials at target *)
    Y23 := TRUE;   (* remain at low *)
    Y22 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    
    (* Release outputs for materials in selectedMask *)
    Y24 := BOOL(selectedMask AND 1);
    Y25 := BOOL(selectedMask AND 2);
    Y26 := BOOL(selectedMask AND 4);
    
    (* Wait for grip response time 0.12s = 120ms *)
    gripTimer(IN := TRUE, PT := T#120ms);
    IF gripTimer.Q THEN
        gripTimer(IN := FALSE);
        state := 7;
    END_IF;

7: (* MOVE_UP_TARGET - raise to high position at target *)
    Y22 := TRUE;   (* up *)
    Y23 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y24 := FALSE;  (* close grips - head now empty *)
    Y25 := FALSE;
    Y26 := FALSE;
    IF X22 THEN
        state := 8;
    END_IF;

8: (* MOVE_BACK - return to source position *)
    Y21 := TRUE;   (* back *)
    Y20 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X20 THEN
        Y21 := FALSE;
        state := 9;
    END_IF;

9: (* DONE - completion condition met *)
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;

END_CASE;

END_PROGRAM