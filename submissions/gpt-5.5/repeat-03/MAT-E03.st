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
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    started : BOOL;
    latchedMask : INT;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
    resultOK : BOOL;
END_VAR

(* Implement the control logic here. *)

startEdge(CLK := X10);

IF startEdge.Q AND NOT started THEN
    started := TRUE;
    latchedMask := D10;
END_IF;

sel1 := (latchedMask = 1) OR (latchedMask = 3) OR (latchedMask = 5) OR (latchedMask = 7);
sel2 := (latchedMask = 2) OR (latchedMask = 3) OR (latchedMask = 6) OR (latchedMask = 7);
sel3 := (latchedMask = 4) OR (latchedMask = 5) OR (latchedMask = 6) OR (latchedMask = 7);

Y20 := started AND sel1;
Y21 := started AND sel2;
Y22 := started AND sel3;

resultOK := started
            AND ((sel1 AND NOT X20) OR ((NOT sel1) AND X20))
            AND ((sel2 AND NOT X21) OR ((NOT sel2) AND X21))
            AND ((sel3 AND NOT X22) OR ((NOT sel3) AND X22));

IF resultOK THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM