PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    startTrig : R_TRIG;
    riseTrig : R_TRIG;
    fallTrig : R_TRIG;
    started : BOOL;
    wasBlocked : BOOL;
    passed : BOOL;
    notX20 : BOOL;
END_VAR

(* Detect the single start rising edge and latch that the operation may begin *)
startTrig(CLK := X10);
IF startTrig.Q THEN
    started := TRUE;
END_IF;

(* Track that the photoeye actually became blocked (product arriving) *)
riseTrig(CLK := X20);
IF riseTrig.Q THEN
    wasBlocked := TRUE;
END_IF;

(* Detect the falling edge of the photoeye AFTER it was blocked:
   this indicates the trailing edge has passed x=120 mm *)
notX20 := NOT X20;
fallTrig(CLK := notX20);
IF fallTrig.Q AND wasBlocked THEN
    passed := TRUE;
END_IF;

(* Feed runs only after start and before the trailing edge has passed;
   once passed, feed is forced OFF permanently for the remainder of the run *)
Y20 := started AND NOT passed;

(* Completion claim: held once the passage condition is met, and retained *)
Y2 := passed;

END_PROGRAM