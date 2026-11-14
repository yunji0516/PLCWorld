Looking at this task, I need to implement a liquid volume transfer system with the following sequence:
1. Wait for start request (X10 rising edge)
2. Move nozzle to lower position (X21)
3. Open valve, wait for confirmation (X22)
4. Start pump, monitor discharge (D21) until target reached (accounting for 20 mL line fill)
5. Stop pump, close valve, wait for confirmation (X23)
6. Raise nozzle to upper position (X20)
7. Assert completion (Y2)

```st
PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    start_edge : R_TRIG;
    valve_timer : TON;
    target_volume : DINT;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* State 0: Wait for start request *)
        IF start_edge.Q THEN
            target_volume := DINT(D10) + 20;
            state := 1;
            Y20 := TRUE;
        END_IF;

    1: (* State 1: Lowering nozzle - wait for X21 *)
        IF X21 THEN
            state := 2;
            Y20 := FALSE;
            Y22 := TRUE;
            valve_timer(IN := TRUE, PT := T#250ms);
        END_IF;

    2: (* State 2: Opening valve - wait for valve open *)
        valve_timer(IN := TRUE, PT := T#250ms);
        IF valve_timer.Q OR X22 THEN
            state := 3;
            Y22 := FALSE;
            Y23 := TRUE;
        END_IF;

    3: (* State 3: Pumping - wait until D21 >= target *)
        IF DINT(D21) >= target_volume THEN
            state := 4;
            Y23 := FALSE;
            Y22 := FALSE;
        END_IF;

    4: (* State 4: Waiting for valve to close *)
        IF X23 THEN
            state := 5;
            Y21 := TRUE;
        END_IF;

    5: (* State 5: Raising nozzle - wait for X20 *)
        IF X20 THEN
            state := 6;
            Y21 := FALSE;
        END_IF;

    6: (* State 6: Complete *)
        Y2 := TRUE;

END_CASE;

END_PROGRAM
```