<think>
Let me analyze this task carefully:

1. **Sequence**: Start → Supply product into nest → Wait for pocket → Fire pusher → Retract pusher → Done

2. **Timing considerations**:
   - Supply: 0.4-0.9s to load product, then finger retracts
   - Fire: exactly 1.0s for pusher extension (900mm)
   - Pocket: 200-300mm/s, D20 is remaining arc distance
   - At full extension, pocket must be within 30mm of contact
   - Firing threshold: D20 ≈ speed × 1.0s ≈ 250mm (using midpoint of 200-300)

3. **Safety constraints**:
   - Don't fire before X23 (loaded) AND X24 (feeder home)
   - Don't advance supply while pusher away from home (X20)
   - Never fire and retract simultaneously

4. **State machine**:
   - State 0: Wait for start edge (X10 rising)
   - State 10: Supply extends (Y22=TRUE), wait for X23 AND X24
   - State 20: Supply retracted, wait for pocket (D20 ≤ 250)
   - State 30: Fire (Y20=TRUE), wait for X21 (pusher at end)
   - State 40: Retract (Y21=TRUE), wait for X20 (pusher home)
   - State 50: Complete (Y2=TRUE)

Let me write the complete program.
</think>

```
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
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        (* Idle - wait for start request rising edge *)
        IF start_edge.Q THEN
            state := 10;
        END_IF;
        
    10:
        (* Supply finger extends - push product into launch nest *)
        Y22 := TRUE;
        IF X23 AND X24 THEN
            Y22 := FALSE;
            state := 20;
        END_IF;
        
    20:
        (* Supply complete - finger retracted, wait for pocket alignment *)
        Y22 := FALSE;
        IF D20 <= 250 THEN
            state := 30;
        END_IF;
        
    30:
        (* Fire - extend launch pusher *)
        Y20 := TRUE;
        Y21 := FALSE;
        IF X21 THEN
            Y20 := FALSE;
            state := 40;
        END_IF;
        
    40:
        (* Retract - return pusher to home *)
        Y20 := FALSE;
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            state := 50;
        END_IF;
        
    50:
        (* Completion - all actuators home *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM
```