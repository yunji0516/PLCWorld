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

    (* internal variables *)
    startTrig : R_TRIG;
    started   : BOOL;
    mask      : INT;
    tmp1      : INT;
    tmp2      : INT;
    sel1      : BOOL;
    sel2      : BOOL;
    sel3      : BOOL;
    completed : BOOL;
    completionNow : BOOL;
END_VAR

(* Detect the single rising edge of the start request *)
startTrig(CLK := X10);

IF startTrig.Q AND NOT started THEN
    started := TRUE;
    mask := D10;

    (* decode bits 0..2 using integer arithmetic *)
    sel1 := (mask MOD 2) = 1;
    tmp1 := mask / 2;
    sel2 := (tmp1 MOD 2) = 1;
    tmp2 := tmp1 / 2;
    sel3 := (tmp2 MOD 2) = 1;
END_IF;

(* Drive release commands only after Start; hold selected ones ON, others OFF *)
IF started THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

(* Evaluate completion condition:
   - selected products must have released (holding = FALSE)
   - unselected products must remain held (holding = TRUE) *)
completionNow := TRUE;

IF sel1 THEN
    completionNow := completionNow AND (NOT X20);
ELSE
    completionNow := completionNow AND X20;
END_IF;

IF sel2 THEN
    completionNow := completionNow AND (NOT X21);
ELSE
    completionNow := completionNow AND X21;
END_IF;

IF sel3 THEN
    completionNow := completionNow AND (NOT X22);
ELSE
    completionNow := completionNow AND X22;
END_IF;

IF started AND completionNow THEN
    completed := TRUE;
END_IF;

(* Once achieved, retain the completion claim through the remaining budget *)
Y2 := completed;

END_PROGRAM