PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    (* Internal state *)
    step : INT := 5;

    admitPulseDone : BOOL;
    movePulseDone : BOOL;
    moveBusyLatch : BOOL;
    liftPulseDone : BOOL;
    liftBusyLatch : BOOL;
    inspectBusyLatch : BOOL;
    detachPulseDone : BOOL;

    expectedGen : INT;
    genCounter : INT := 0;
    productsAdmitted : INT := 0;
    productsReceived : INT := 0;
    roundsDone : INT := 0;

    exitEdge : R_TRIG;
    startEdge : R_TRIG;
    completeTimer : TON;
    completionConditions : BOOL;
END_VAR

(* External product reception handling (independent of jig sequence) *)
exitEdge(CLK := X16);
IF exitEdge.Q THEN
    productsReceived := productsReceived + 1;
END_IF;
Y18 := X16;

(* Start trigger *)
startEdge(CLK := X0);
IF (step = 5) AND startEdge.Q THEN
    step := 10;
END_IF;

CASE step OF

  5:
      ; (* waiting for start *)

  10: (* ensure left lift upper before loading, jig 101 present *)
      IF X17 THEN
          step := 20;
      ELSIF NOT liftPulseDone THEN
          IF (NOT X1B) AND (NOT X11) AND X1F THEN
              Y14 := TRUE;
              liftPulseDone := TRUE;
          END_IF;
      ELSE
          Y14 := FALSE;
          IF X1B THEN
              liftBusyLatch := TRUE;
          END_IF;
          IF liftBusyLatch AND (NOT X1B) AND X17 THEN
              liftPulseDone := FALSE;
              liftBusyLatch := FALSE;
              step := 20;
          END_IF;
      END_IF;

  20: (* wait admit *)
      IF admitPulseDone THEN
          Y10 := FALSE;
          productsAdmitted := productsAdmitted + 1;
          genCounter := genCounter + 1;
          admitPulseDone := FALSE;
          step := 21;
      ELSIF (productsAdmitted < 6) AND X10 AND (D0 = 101) AND (NOT X12) THEN
          Y10 := TRUE;
          admitPulseDone := TRUE;
      END_IF;

  21: (* wait load start *)
      IF X12 THEN
          step := 22;
      END_IF;

  22: (* wait load complete *)
      IF NOT X12 THEN
          D200 := 101;
          D201 := 1;
          D202 := genCounter;
          step := 30;
      END_IF;

  30: (* move to inspection (1) *)
      IF NOT movePulseDone THEN
          IF NOT X11 THEN
              Y13 := TRUE;
              movePulseDone := TRUE;
          END_IF;
      ELSE
          Y13 := FALSE;
          IF X11 THEN
              moveBusyLatch := TRUE;
          END_IF;
          IF moveBusyLatch AND (NOT X11) THEN
              movePulseDone := FALSE;
              moveBusyLatch := FALSE;
              step := 40;
          END_IF;
      END_IF;

  40: (* inspect trigger *)
      IF (NOT X14) AND (D1 = 101) THEN
          Y11 := TRUE;
          expectedGen := D8;
          step := 41;
      END_IF;

  41: (* inspect wait completion *)
      Y11 := FALSE;
      IF X14 THEN
          inspectBusyLatch := TRUE;
      END_IF;
      IF inspectBusyLatch AND (NOT X14) AND (D10 = expectedGen) THEN
          inspectBusyLatch := FALSE;
          D200 := 101;
          D201 := 2;
          step := 50;
      END_IF;

  50: (* move to extraction (2) *)
      IF NOT movePulseDone THEN
          IF NOT X11 THEN
              Y13 := TRUE;
              movePulseDone := TRUE;
          END_IF;
      ELSE
          Y13 := FALSE;
          IF X11 THEN
              moveBusyLatch := TRUE;
          END_IF;
          IF moveBusyLatch AND (NOT X11) THEN
              movePulseDone := FALSE;
              moveBusyLatch := FALSE;
              step := 60;
          END_IF;
      END_IF;

  60: (* wait exit clear *)
      IF X15 THEN
          step := 61;
      END_IF;

  61: (* detach trigger *)
      IF detachPulseDone THEN
          Y12 := FALSE;
          step := 62;
      ELSIF (NOT X13) AND (D2 = 101) THEN
          Y12 := TRUE;
          detachPulseDone := TRUE;
      END_IF;

  62: (* wait unload start *)
      IF X13 THEN
          step := 63;
      END_IF;

  63: (* wait unload complete / release *)
      IF NOT X13 THEN
          detachPulseDone := FALSE;
          D200 := 101;
          D201 := 3;
          D202 := 0;
          step := 70;
      END_IF;

  70: (* ensure right lift upper (empty, free) *)
      IF X19 THEN
          step := 71;
      ELSIF NOT liftPulseDone THEN
          IF (NOT X1C) AND (NOT X11) THEN
              Y16 := TRUE;
              liftPulseDone := TRUE;
          END_IF;
      ELSE
          Y16 := FALSE;
          IF X1C THEN
              liftBusyLatch := TRUE;
          END_IF;
          IF liftBusyLatch AND (NOT X1C) AND X19 THEN
              liftPulseDone := FALSE;
              liftBusyLatch := FALSE;
              step := 71;
          END_IF;
      END_IF;

  71: (* move to right lift (3) *)
      IF NOT movePulseDone THEN
          IF NOT X11 THEN
              Y13 := TRUE;
              movePulseDone := TRUE;
          END_IF;
      ELSE
          Y13 := FALSE;
          IF X11 THEN
              moveBusyLatch := TRUE;
          END_IF;
          IF moveBusyLatch AND (NOT X11) THEN
              movePulseDone := FALSE;
              moveBusyLatch := FALSE;
              step := 80;
          END_IF;
      END_IF;

  80: (* wait fully seated before lowering *)
      IF X1E THEN
          step := 81;
      END_IF;

  81: (* lower right lift *)
      IF NOT liftPulseDone THEN
          IF (NOT X1C) AND (NOT X11) AND X1E THEN
              Y17 := TRUE;
              liftPulseDone := TRUE;
          END_IF;
      ELSE
          Y17 := FALSE;
          IF X1C THEN
              liftBusyLatch := TRUE;
          END_IF;
          IF liftBusyLatch AND (NOT X1C) AND X1A THEN
              liftPulseDone := FALSE;
              liftBusyLatch := FALSE;
              D200 := 101;
              D201 := 4;
              D202 := 0;
              step := 90;
          END_IF;
      END_IF;

  90: (* move to lower center (4), lower return path *)
      IF NOT movePulseDone THEN
          IF NOT X11 THEN
              Y13 := TRUE;
              movePulseDone := TRUE;
          END_IF;
      ELSE
          Y13 := FALSE;
          IF X11 THEN
              moveBusyLatch := TRUE;
          END_IF;
          IF moveBusyLatch AND (NOT X11) THEN
              movePulseDone := FALSE;
              moveBusyLatch := FALSE;
              step := 100;
          END_IF;
      END_IF;

  100: (* lower left lift for return reception *)
      IF NOT liftPulseDone THEN
          IF (NOT X1B) AND (NOT X11) THEN
              Y15 := TRUE;
              liftPulseDone := TRUE;
          END_IF;
      ELSE
          Y15 := FALSE;
          IF X1B THEN
              liftBusyLatch := TRUE;
          END_IF;
          IF liftBusyLatch AND (NOT X1B) AND X18 THEN
              liftPulseDone := FALSE;
              liftBusyLatch := FALSE;
              D200 := 101;
              D201 := 0;
              D202 := 0;
              step := 101;
          END_IF;
      END_IF;

  101: (* move back to left lift (0) *)
      IF NOT movePulseDone THEN
          IF NOT X11 THEN
              Y13 := TRUE;
              movePulseDone := TRUE;
          END_IF;
      ELSE
          Y13 := FALSE;
          IF X11 THEN
              moveBusyLatch := TRUE;
          END_IF;
          IF moveBusyLatch AND (NOT X11) THEN
              movePulseDone := FALSE;
              moveBusyLatch := FALSE;
              step := 110;
          END_IF;
      END_IF;

  110: (* round complete, decide next *)
      roundsDone := roundsDone + 1;
      IF productsAdmitted >= 6 THEN
          step := 900;
      ELSE
          step := 10;
      END_IF;

  900:
      ; (* final resting state: jig101 parked at position 0, jig102 untouched at position 4 *)

END_CASE;

completionConditions := (productsAdmitted = 6) AND (step = 900) AND (productsReceived = 6)
    AND (NOT X11) AND (NOT X12) AND (NOT X13) AND (NOT X14) AND (NOT X1B) AND (NOT X1C)
    AND (NOT Y10) AND (NOT Y11) AND (NOT Y12) AND (NOT Y13)
    AND (NOT Y14) AND (NOT Y15) AND (NOT Y16) AND (NOT Y17)
    AND X20;

completeTimer(IN := completionConditions, PT := T#500ms);

IF completeTimer.Q THEN
    Y19 := TRUE;
END_IF;

END_PROGRAM