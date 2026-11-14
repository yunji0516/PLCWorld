<think>
Looking at the task, I need to:
1. Control 3 axes (A, B, C) to visit two ports then return to zero
2. Port 1: A=first, B=0, C=0
3. Port 2: A=second, B=depth, C=reach
4. Keep B≥100 when moving A or C to avoid deck collision
5. Return to A=B=C=0, then assert completion Y2

Safety sequence:
- B high (100mm) before any A/C movement
- Lower B only when A and C are at target for that port
- Raise B after port access before moving to next position

```st
PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    state : INT;
    port1_done : BOOL;
    port2_done : BOOL;
    done : BOOL;
END_VAR

(* Enable all axes after start, keep enabled for position holding *)
IF state = 0 THEN
    a_en : BOOL := TRUE;
    b_en : BOOL := TRUE;
    c_en : BOOL := TRUE;
END_IF;

(* State machine for two-port access sequence *)
(* B must be >=100mm when moving A or C to avoid deck collision *)
CASE state OF
    0: (* Wait for start signal *)
        IF X0 THEN
            state := 1;
        END_IF;
        
    1: (* Move B high to clear deck surface *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;
        
    2: (* Move A to first port position, C stays at 0 *)
        D20 := D101;
        D21 := 500;
        D28 := 0;
        D29 := 500;
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 THEN
            state := 3;
        END_IF;
        
    3: (* Lower B to port 1 depth (B=0) *)
        D24 := 0;
        D25 := 500;
        IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
            port1_done := TRUE;
            state := 4;
        END_IF;
        
    4: (* Move B high after port 1 access *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 5;
        END_IF;
        
    5: (* Move A to second port, C to reach simultaneously *)
        D20 := D102;
        D21 := 500;
        D28 := D104;
        D29 := 500;
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 THEN
            state := 6;
        END_IF;
        
    6: (* Lower B to port 2 depth *)
        D24 := D103;
        D25 := 500;
        IF ABS(D12 - D103) <= 20 AND ABS(D13) <= 100 THEN
            port2_done := TRUE;
            state := 7;
        END_IF;
        
    7: (* Move B high after port 2 access *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 8;
        END_IF;
        
    8: (* Return A and B to zero, C stays at reach *)
        D20 := 0;
        D21 := 500;
        D24 := 0;
        D25 := 500;
        IF ABS(D10 - 0) <= 20 AND ABS(D11) <= 100 THEN
            state := 9;
        END_IF;
        
    9: (* Return C to zero *)
        D28 := 0;
        D29 := 500;
        IF ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 THEN
            done := TRUE;
            state := 10;
        END_IF;
        
    10: (* Hold final position *)
        NULL;
END_CASE;

(* Assign outputs *)
a_en := TRUE;
b_en := TRUE;
c_en := TRUE;
Y20 := a_en;
Y21 := b_en;
Y22 := c_en;

(* Assert completion after all targets reached at zero *)
IF done THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM
```

Wait, I need to fix a bug - the enable variables need proper declaration and assignment. Let me rewrite properly:

```st
PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    state : INT;
    port1_done : BOOL;
    port2_done : BOOL;
    done : BOOL;
END_VAR

(* State machine: visit port1 (A=first, B=0, C=0), then port2 (A=second, B=depth, C=reach), return to 0 *)
(* Safety: keep B >= 100mm when moving A or C to avoid deck collision *)
(* Positions are scaled x100, arrival tolerance: position +/-20 (0.2mm), speed +/-100 (1mm/s) *)

CASE state OF
    0: (* Wait for start signal - no enables before X0 *)
        IF X0 THEN
            state := 1;
        END_IF;
        
    1: (* Move B high to clear deck *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;
        
    2: (* Move A to first port, keep C at 0 *)
        D20 := D101;
        D21 := 500;
        D28 := 0;
        D29 := 500;
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 THEN
            state := 3;
        END_IF;
        
    3: (* Lower B to port 1 *)
        D24 := 0;
        D25 := 500;
        IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
            port1_done := TRUE;
            state := 4;
        END_IF;
        
    4: (* Move B high after port 1 *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 5;
        END_IF;
        
    5: (* Move A to second port, C to reach simultaneously *)
        D20 := D102;
        D21 := 500;
        D28 := D104;
        D29 := 500;
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 THEN
            state := 6;
        END_IF;
        
    6: (* Lower B to port 2 depth *)
        D24 := D103;
        D25 := 500;
        IF ABS(D12 - D103) <= 20 AND ABS(D13) <= 100 THEN
            port2_done := TRUE;
            state := 7;
        END_IF;
        
    7: (* Move B high after port 2 *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 8;
        END_IF;
        
    8: (* Return A and B to zero *)
        D20 := 0;
        D21 := 500;
        D24 := 0;
        D25 := 500;
        IF ABS(D10 - 0) <= 20 AND ABS(D11) <= 100 THEN
            state := 9;
        END_IF;
        
    9: (* Return C to zero *)
        D28 := 0;
        D29 := 500;
        IF ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 THEN
            done := TRUE;
            state := 10;
        END_IF;
        
    10: (* Done - hold position *)
        NULL;
END_CASE;

(* Enable all axes for motion and position holding *)
Y20 := TRUE;
Y21 := TRUE;
Y22 := TRUE;

(* Assert completion when all axes at zero *)
IF done THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM
```

Wait, I can't just set Y20/Y21/Y22 to TRUE unconditionally - I need to only enable them after X0. Let me fix this. Also the initial state check needs to be cleaner.

Let me reconsider the approach. The enables should only be active after X0 is pressed. Let me track this properly.

```st
PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    state : INT;
    started : BOOL;
    done : BOOL;
END_VAR

(* 
 * Sequence: B high -> A to first -> B low (port1) -> B high -> A to second + C to reach -> B to depth (port2) -> B high -> A,B to 0 -> C to 0
 * Safety: B >= 10000 when moving A or C
 * Arrival: |pos - target| <= 20 AND |vel| <= 100
 *)

CASE state OF
    0: (* Wait for start *)
        IF X0 THEN
            started := TRUE;
            state := 1;
        END_IF;
        
    1: (* Move B high to clear deck *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;
        
    2: (* Move A to first port position *)
        D20 := D101;
        D21 := 500;
        D28 := 0;
        D29 := 500;
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 THEN
            state := 3;
        END_IF;
        
    3: (* Lower B to port 1 depth = 0 *)
        D24 := 0;
        D25 := 500;
        IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
            state := 4;
        END_IF;
        
    4: (* Move B high *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 5;
        END_IF;
        
    5: (* Move A to second port, C to reach *)
        D20 := D102;
        D21 := 500;
        D28 := D104;
        D29 := 500;
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 THEN
            state := 6;
        END_IF;
        
    6: (* Lower B to port 2 depth *)
        D24 := D103;
        D25 := 500;
        IF ABS(D12 - D103) <= 20 AND ABS(D13) <= 100 THEN
            state := 7;
        END_IF;
        
    7: (* Move B high *)
        D24 := 10000;
        D25 := 500;
        IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 8;
        END_IF;
        
    8: (* Return A and B to zero *)
        D20 := 0;
        D21 := 500;
        D24 := 0;
        D25 := 500;
        IF ABS(D10 - 0) <= 20 AND ABS(D11) <= 100 THEN
            state := 9;
        END_IF;
        
    9: (* Return C to zero *)
        D28 := 0;
        D29 := 500;
        IF ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 THEN
            done := TRUE;
            state := 10;
        END_IF;
        
    10: (* Hold *)
        NULL;
END_CASE;

(* Output assignment - enables only after start *)
IF started THEN
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

IF done THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM
```

This looks correct. Let me verify:
1. State 0: Wait for X0, no enables
2. State 1: Move B to 100mm (10000)
3. State 2: Move A to first port (D101), C stays at 0
4. State 3: Lower B to 0 for port 1 access
5. State 4: Move B high to 100mm
6. State 5: Move A to second (D102), C to reach (D104)
7. State 6: Lower B to depth (D103) for port 2
8. State 7: Move B high to 100mm
9. State 8: Return A and B to 0
10. State 9: Return C to 0, mark done
11. State 10: Hold

All targets are set before enabling (except state 0 which has no motion).
Enables are only active after X0 is detected.
Completion Y2 asserted when done is TRUE and maintained.
Position tolerance is 20 raw units (= 0.2mm), speed tolerance is 100 raw units (= 1mm/s).
Rate is 500 (50%) for all movements.

This should complete well within 15000ms.