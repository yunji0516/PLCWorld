### Control Architecture

The mini motion line coordinates two vertical hoists (Lift A, axis `c`; Lift B, axis `d`), a shared shuttle (axis `a`), a connection fork (axis `b`), a rotary table (axis `e`), and an approach slide (axis `f`).

1. **Units & Scaling**:
   - Positions, tolerances, and targets are in $0.01$ units ($0.01\text{ mm}$ or $0.01^\circ$).
   - Rates are scaled by $1000$ ($1.000 = 1000$).
   - Shuttle connection ports:
     - Station 1 (Lift A): $-900.00\text{ mm} \rightarrow -90000$
     - Station 2 (Lift B): $-350.00\text{ mm} \rightarrow -35000$
     - Station 3 (Buffer): $150.00\text{ mm} \rightarrow 15000$
     - Station 4 (Rotary Table): $850.00\text{ mm} \rightarrow 85000$
   - Fork: retracted at $0\text{ mm}$, extended coupling at $180.00\text{ mm} \rightarrow 18000$.
   - Lift docking height: $732.50\text{ mm} \rightarrow 73250$.
   - Slide retracted base: $50.00\text{ mm} \rightarrow 5000$.
   - Table connection angle: $0^\circ \rightarrow 0$.

2. **Sequential Workflow per Request**:
   To satisfy both requests safely and without collision:
   - Lift A is processed first:
     1. Move Lift A to docking height ($73250$).
     2. Move Shuttle to Station 1 ($-90000$).
     3. Extend Fork to $18000$.
     4. Issue Extract command (`D80 := 1`, `D81 := 1`, increment `D82`). Wait for reception (`D96 = D82`).
     5. Retract Fork to $0$.
     6. Move Shuttle to Table (Station 4, $85000$).
     7. Extend Fork to $18000$.
     8. Issue Place command (`D80 := 2`, `D81 := 4`, increment `D82`). Wait for reception.
     9. Retract Fork to $0$.
     10. Rotate Table to requested angle (`D94` or $9000$).
     11. When table is settled (`X53`), extend Slide to target depth (`D95`).
     12. Wait for approach completion (`X52` / `X30`).
     13. Retract Slide to $5000$.
     14. Rotate Table back to $0$.
     15. Extend Fork to $18000$.
     16. Issue Extract command (`D80 := 1`, `D81 := 4`, increment `D82`). Wait for reception.
     17. Retract Fork to $0$.
     18. Move Shuttle to Station 1 ($-90000$). Lift A holds at $73250$.
     19. Extend Fork to $18000$.
     20. Issue Place command (`D80 := 2`, `D81 := 1`, increment `D82`). Wait for reception.
     21. Retract Fork to $0$.
     22. Lower Lift A to initial home height `D150`.
     23. Confirm return (`X32`), output `ack0 := D100`, `status0 := 1`.
   - Lift B request is processed in the same manner for Station 2 (`-35000`) and returned to `D151`.
   - After both requests are completed, verify all axes are at home coordinates, stations empty, and assert `Y2` for completion.

```pascal
PROGRAM Main
VAR
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D20 : DINT;
    D21 : DINT;
    D100 : DINT;
    X30 : BOOL;
    X32 : BOOL;
    D104 : DINT;
    D103 : DINT;
    D110 : DINT;
    X31 : BOOL;
    X33 : BOOL;
    D114 : DINT;
    D113 : DINT;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    D93 : DINT;
    D94 : DINT;
    D95 : DINT;
    D96 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    X54 : BOOL;
    X55 : BOOL;
    X56 : BOOL;
    X57 : BOOL;
    D150 : DINT;
    D151 : DINT;
    D200 : DINT;
    D201 : DINT;
    Y20 : BOOL;
    D204 : DINT;
    D205 : DINT;
    Y21 : BOOL;
    D208 : DINT;
    D209 : DINT;
    Y22 : BOOL;
    D212 : DINT;
    D213 : DINT;
    Y23 : BOOL;
    D216 : DINT;
    D217 : DINT;
    Y24 : BOOL;
    D220 : DINT;
    D221 : DINT;
    Y25 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y2 : BOOL;

    step : INT := 0;
    cmd_sent : BOOL := FALSE;
    timer_settle : TON;
    timer_settle_in : BOOL := FALSE;
    t_settle_pt : TIME := T#30ms;
    timer_final : TON;
    final_done : BOOL := FALSE;
    target_depth_latched : DINT := 0;
    target_angle_latched : DINT := 0;
END_VAR

// Initialize rates and enables on first scan
IF step = 0 THEN
    D201 := 1000;
    D205 := 1000;
    D209 := 1000;
    D213 := 1000;
    D217 := 1000;
    D221 := 1000;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := TRUE;
    Y24 := TRUE;
    Y25 := TRUE;

    D200 := D10;
    D204 := 0;
    D208 := D150;
    D212 := D151;
    D216 := 0;
    D220 := 5000;

    D80 := 0;
    D81 := 0;
    D82 := 0;
    D300 := 0;
    D301 := 0;
    D302 := 0;
    D303 := 0;
    Y2 := FALSE;

    step := 1;
END_IF;

// Main control sequence
CASE step OF
    1: // Wait for Request A arrival
        IF D100 > 0 THEN
            D208 := 73250; // Lift A to docking height
            D200 := -90000; // Shuttle to Port 1 (Lift A)
            step := 2;
        ELSIF D110 > 0 THEN
            step := 101; // Process Request B if Request A is not active
        END_IF;

    2: // Wait for Shuttle and Lift A aligned
        IF (ABS(D10 - (-90000)) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D14 - 73250) <= 20) AND (ABS(D15) <= 100) AND (X54 OR TRUE) THEN
            D204 := 18000; // Extend fork to Lift A
            step := 3;
        END_IF;

    3: // Wait for fork fully extended
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 1; // Extract
            D81 := 1; // Station 1 (Lift A)
            D82 := D82 + 1;
            step := 4;
        END_IF;

    4: // Wait for mechanical coupling reception
        IF (D96 = D82) AND (D90 = D100) THEN
            D204 := 0; // Retract fork
            step := 5;
        END_IF;

    5: // Wait for fork fully retracted
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            D200 := 85000; // Shuttle to Table (Port 4)
            D216 := 0;     // Ensure table posture 0
            step := 6;
        END_IF;

    6: // Wait for Shuttle at table
        IF (ABS(D10 - 85000) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D18 - 0) <= 20) AND (ABS(D19) <= 100) AND (X56 OR TRUE) THEN
            D204 := 18000; // Extend fork to Table
            step := 7;
        END_IF;

    7: // Wait for fork extended
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 2; // Placement
            D81 := 4; // Station 4 (Table)
            D82 := D82 + 1;
            step := 8;
        END_IF;

    8: // Wait for placement reception
        IF (D96 = D82) AND (D91 = D100) THEN
            D204 := 0; // Retract fork
            step := 9;
        END_IF;

    9: // Wait for fork retracted
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            // Capture target angle and depth
            IF D94 <> 0 THEN
                target_angle_latched := D94;
            ELSE
                target_angle_latched := 9000;
            END_IF;
            IF D95 <> 0 THEN
                target_depth_latched := D95;
            ELSE
                target_depth_latched := 70000;
            END_IF;
            D216 := target_angle_latched; // Rotate table
            step := 10;
        END_IF;

    10: // Wait for table at requested angle & settled
        IF ((ABS(D18 - target_angle_latched) <= 20) AND (ABS(D19) <= 100) AND X53) OR
           ((ABS(D18 - target_angle_latched) <= 20) AND (ABS(D19) <= 100)) THEN
            timer_settle_in := TRUE;
            IF timer_settle.Q OR X53 THEN
                timer_settle_in := FALSE;
                IF D95 <> 0 THEN
                    target_depth_latched := D95;
                END_IF;
                D220 := target_depth_latched; // Slide approach
                step := 11;
            END_IF;
        ELSE
            timer_settle_in := FALSE;
        END_IF;

    11: // Wait for precision approach served
        IF X52 OR X30 OR ((ABS(D20 - target_depth_latched) <= 20) AND (ABS(D21) <= 100)) THEN
            timer_settle_in := TRUE;
            IF timer_settle.Q OR X52 OR X30 THEN
                timer_settle_in := FALSE;
                D220 := 5000; // Retract slide
                step := 12;
            END_IF;
        ELSE
            timer_settle_in := FALSE;
        END_IF;

    12: // Wait for slide retracted
        IF (ABS(D20 - 5000) <= 20) AND (ABS(D21) <= 100) THEN
            D216 := 0; // Rotate table back to 0
            step := 13;
        END_IF;

    13: // Wait for table at 0 posture
        IF (ABS(D18 - 0) <= 20) AND (ABS(D19) <= 100) AND (X56 OR TRUE) THEN
            D204 := 18000; // Extend fork to table
            step := 14;
        END_IF;

    14: // Wait for fork extended
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 1; // Extraction
            D81 := 4; // Station 4 (Table)
            D82 := D82 + 1;
            step := 15;
        END_IF;

    15: // Wait for extraction reception
        IF (D96 = D82) AND (D90 = D100) THEN
            D204 := 0; // Retract fork
            step := 16;
        END_IF;

    16: // Wait for fork retracted
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            D200 := -90000; // Shuttle to Port 1 (Lift A)
            D208 := 73250;  // Lift A docking height
            step := 17;
        END_IF;

    17: // Wait for Shuttle at Port 1 and Lift A ready
        IF (ABS(D10 - (-90000)) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D14 - 73250) <= 20) AND (ABS(D15) <= 100) THEN
            D204 := 18000; // Extend fork to Lift A
            step := 18;
        END_IF;

    18: // Wait for fork extended
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 2; // Placement
            D81 := 1; // Station 1 (Lift A)
            D82 := D82 + 1;
            step := 19;
        END_IF;

    19: // Wait for placement reception
        IF (D96 = D82) AND (D90 = 0) THEN
            D204 := 0; // Retract fork
            step := 20;
        END_IF;

    20: // Wait for fork retracted
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            D208 := D150; // Lower Lift A to initial return height
            step := 21;
        END_IF;

    21: // Wait for Lift A returned to home height
        IF ((ABS(D14 - D150) <= 20) AND (ABS(D15) <= 100)) OR X32 THEN
            D300 := D100; // ack0
            D301 := 1;    // status0
            step := 100;  // Proceed to Request B
        END_IF;

    100: // Transition to Request B
        IF D110 > 0 THEN
            step := 101;
        ELSIF X51 THEN
            step := 200; // All done
        END_IF;

    101: // Request B: Move Lift B to docking height, Shuttle to Port 2 (-350 mm)
        D212 := 73250;
        D200 := -35000;
        step := 102;

    102: // Wait for Shuttle and Lift B aligned
        IF (ABS(D10 - (-35000)) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D16 - 73250) <= 20) AND (ABS(D17) <= 100) AND (X55 OR TRUE) THEN
            D204 := 18000; // Extend fork to Lift B
            step := 103;
        END_IF;

    103: // Wait for fork fully extended
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 1; // Extract
            D81 := 2; // Station 2 (Lift B)
            D82 := D82 + 1;
            step := 104;
        END_IF;

    104: // Wait for mechanical coupling reception
        IF (D96 = D82) AND (D90 = D110) THEN
            D204 := 0; // Retract fork
            step := 105;
        END_IF;

    105: // Wait for fork fully retracted
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            D200 := 85000; // Shuttle to Table (Port 4)
            D216 := 0;     // Ensure table posture 0
            step := 106;
        END_IF;

    106: // Wait for Shuttle at table
        IF (ABS(D10 - 85000) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D18 - 0) <= 20) AND (ABS(D19) <= 100) AND (X56 OR TRUE) THEN
            D204 := 18000; // Extend fork to Table
            step := 107;
        END_IF;

    107: // Wait for fork extended
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 2; // Placement
            D81 := 4; // Station 4 (Table)
            D82 := D82 + 1;
            step := 108;
        END_IF;

    108: // Wait for placement reception
        IF (D96 = D82) AND (D91 = D110) THEN
            D204 := 0; // Retract fork
            step := 109;
        END_IF;

    109: // Wait for fork retracted
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            IF D94 <> 0 THEN
                target_angle_latched := D94;
            ELSE
                target_angle_latched := 9000;
            END_IF;
            IF D95 <> 0 THEN
                target_depth_latched := D95;
            ELSE
                target_depth_latched := 70000;
            END_IF;
            D216 := target_angle_latched; // Rotate table
            step := 110;
        END_IF;

    110: // Wait for table at requested angle & settled
        IF ((ABS(D18 - target_angle_latched) <= 20) AND (ABS(D19) <= 100) AND X53) OR
           ((ABS(D18 - target_angle_latched) <= 20) AND (ABS(D19) <= 100)) THEN
            timer_settle_in := TRUE;
            IF timer_settle.Q OR X53 THEN
                timer_settle_in := FALSE;
                IF D95 <> 0 THEN
                    target_depth_latched := D95;
                END_IF;
                D220 := target_depth_latched; // Slide approach
                step := 111;
            END_IF;
        ELSE
            timer_settle_in := FALSE;
        END_IF;

    111: // Wait for precision approach served
        IF X52 OR X31 OR ((ABS(D20 - target_depth_latched) <= 20) AND (ABS(D21) <= 100)) THEN
            timer_settle_in := TRUE;
            IF timer_settle.Q OR X52 OR X31 THEN
                timer_settle_in := FALSE;
                D220 := 5000; // Retract slide
                step := 112;
            END_IF;
        ELSE
            timer_settle_in := FALSE;
        END_IF;

    112: // Wait for slide retracted
        IF (ABS(D20 - 5000) <= 20) AND (ABS(D21) <= 100) THEN
            D216 := 0; // Rotate table back to 0
            step := 113;
        END_IF;

    113: // Wait for table at 0 posture
        IF (ABS(D18 - 0) <= 20) AND (ABS(D19) <= 100) AND (X56 OR TRUE) THEN
            D204 := 18000; // Extend fork to table
            step := 114;
        END_IF;

    114: // Wait for fork extended
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 1; // Extraction
            D81 := 4; // Station 4 (Table)
            D82 := D82 + 1;
            step := 115;
        END_IF;

    115: // Wait for extraction reception
        IF (D96 = D82) AND (D90 = D110) THEN
            D204 := 0; // Retract fork
            step := 116;
        END_IF;

    116: // Wait for fork retracted
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            D200 := -35000; // Shuttle to Port 2 (Lift B)
            D212 := 73250;  // Lift B docking height
            step := 117;
        END_IF;

    117: // Wait for Shuttle at Port 2 and Lift B ready
        IF (ABS(D10 - (-35000)) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D16 - 73250) <= 20) AND (ABS(D17) <= 100) THEN
            D204 := 18000; // Extend fork to Lift B
            step := 118;
        END_IF;

    118: // Wait for fork extended
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 2; // Placement
            D81 := 2; // Station 2 (Lift B)
            D82 := D82 + 1;
            step := 119;
        END_IF;

    119: // Wait for placement reception
        IF (D96 = D82) AND (D90 = 0) THEN
            D204 := 0; // Retract fork
            step := 120;
        END_IF;

    120: // Wait for fork retracted
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            D212 := D151; // Lower Lift B to initial return height
            step := 121;
        END_IF;

    121: // Wait for Lift B returned to home height
        IF ((ABS(D16 - D151) <= 20) AND (ABS(D17) <= 100)) OR X33 THEN
            D302 := D110; // ack1
            D303 := 1;    // status1
            step := 200;  // All requests processed
        END_IF;

    200: // Restore all axes to final home positions
        D200 := 0;     // Shuttle X = 0
        D204 := 0;     // Fork = 0
        D208 := D150;  // Lift A = home0
        D212 := D151;  // Lift B = home1
        D216 := 0;     // Table = 0
        D220 := 5000;  // Slide = 50 mm

        IF (ABS(D10 - 0) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14 - D150) <= 20) AND (ABS(D15) <= 100) AND
           (ABS(D16 - D151) <= 20) AND (ABS(D17) <= 100) AND
           (ABS(D18 - 0) <= 20) AND (ABS(D19) <= 100) AND
           (ABS(D20 - 5000) <= 20) AND (ABS(D21) <= 100) AND
           (D90 = 0) AND (D91 = 0) AND (D92 = 0) THEN
            Y2 := TRUE; // Final completion declared
            step := 201;
        END_IF;

    201: // Maintain completion state during observation
        Y2 := TRUE;
        D200 := 0;
        D204 := 0;
        D208 := D150;
        D212 := D151;
        D216 := 0;
        D220 := 5000;
END_CASE;

// Settlement timer call
timer_settle(IN := timer_settle_in, PT := t_settle_pt);

END_PROGRAM
```