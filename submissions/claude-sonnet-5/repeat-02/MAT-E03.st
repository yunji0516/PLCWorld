PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    (* internal *)
    startEdge : R_TRIG;
    started   : BOOL := FALSE;
    sel_mask  : INT  := 0;
    bit0      : BOOL := FALSE;
    bit1      : BOOL := FALSE;
    bit2      : BOOL := FALSE;
    cond_ok   : BOOL := FALSE;
    y2_latch  : BOOL := FALSE;
END_VAR

(* Detect the single rising edge of the start request *)
startEdge(CLK := X10);

IF startEdge.Q AND NOT started THEN
    started  := TRUE;
    sel_mask := D10;
END_IF;

(* Decode selection bits once latched *)
IF started THEN
    bit0 := (sel_mask MOD 2) = 1;
    bit1 := ((sel_mask / 2) MOD 2) = 1;
    bit2 := ((sel_mask / 4) MOD 2) = 1;
ELSE
    bit0 := FALSE;
    bit1 := FALSE;
    bit2 := FALSE;
END_IF;

(* Drive release outputs only after the start request; unselected stay closed *)
IF started THEN
    Y20 := bit0;
    Y21 := bit1;
    Y22 := bit2;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

(* Evaluate physical completion:
   selected products must have released (holding = FALSE)
   unselected products must remain held (holding = TRUE) *)
cond_ok := ( (bit0 AND (NOT X20)) OR ((NOT bit0) AND X20) )
       AND ( (bit1 AND (NOT X21)) OR ((NOT bit1) AND X21) )
       AND ( (bit2 AND (NOT X22)) OR ((NOT bit2) AND X22) );

IF started AND cond_ok THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM