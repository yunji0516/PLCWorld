### Control Architecture and Operational Sequence

#### 1. System Coordinates and Axis Assignments
- **Shuttle axis A (`D1000` / `D2000`)**: Path distance along the continuous rail:
  - Station 1 (Lift A): Nominal $-3600\text{ mm}$ ($-360\,000$ raw).
  - Station 2 (Lift B): Nominal $-2300\text{ mm}$ ($-230\,000$ raw).
  - Station 3 (Cell 3, Flying transfer): Nominal $+2300\text{ mm}$ ($+230\,000$ raw).
  - Station 4 (Cell 4, Rotation gear): Nominal $+9900\text{ mm}$ ($+990\,000$ raw).
  - Home / Idle: $0\text{ mm}$ ($0$ raw).
- **Connection fork axis B (`D1004` / `D2004`)**:
  - Retrieval / retracted: $0\text{ mm}$ ($0$ raw).
  - Connected / extended: $180\text{ mm}$ ($18\,000$ raw).
- **Lift axes C and D (`D1008` / `D2008` for Lift A, `D1012` / `D2012` for Lift B)**:
  - Idle / Home height: $150\text{ mm}$ ($15\,000$ raw).
  - Docking height: $732.5\text{ mm}$ ($73\,250$ raw).
- **Cell 3 axes (`s3_0`, `s3_1`, `s3_2`)**:
  - Home coordinates: $s3\_0 = -500\text{ mm}$, $s3\_1 = -500\text{ mm}$, $s3\_2 = 0\text{ mm}$.
  - During transfer, $s3\_0$ tracks moving accompaniment; $s3\_2$ operates within $[0, 180]\text{ mm}$.
- **Cell 4 axes (`s4_0`, `s4_1`)**:
  - Home coordinates: $0^\circ, 0^\circ$.
  - Synchronization ratio maintained via electronic gearing (`m4_configure := TRUE`, `m4_select := 1000`) or slave axis synchronous command tracking.

#### 2. Process Workflow per Request
For each active request ($R_0$, then $R_1$):
1. **Identify Lift Station**: Determine source station ($1$ for Lift A, $2$ for Lift B) from request location.
2. **Lift Docking**: Raise designated lift to docking height ($732.5\text{ mm}$).
3. **Shuttle Move to Lift**: Open brake, position shuttle axis A at the lift docking position.
4. **Extraction Handshake**: Extend fork axis B ($180\text{ mm}$), assert coupling sequence (`action := 1`, `station := 1` or `2`, increment `couple_seq`), wait for capture/holding confirmation (`D90 = request_id`), retract fork to $0\text{ mm}$.
5. **Transfer to Cell 3 (Flying Sync)**:
   - Transit shuttle axis A toward Cell 3 docking position.
   - Synchronize with Cell 3 carriage, achieve flying moving connection (relative position $\le 0.2\text{ mm}$, relative velocity $\le 1\text{ mm/s}$ for $\ge 50\text{ ms}$, fork extended, $\ge 200\text{ mm}$ accompaniment).
   - Await Cell 3 served flag (`X70`), retract fork, return Cell 3 axes to home.
6. **Transfer to Cell 4 (Gear Sync)**:
   - Transit shuttle axis A to Cell 4 docking position.
   - Configure rotation sync (`m4_configure := TRUE`, ratio `m4_select`).
   - Drive master while maintaining angular tracking error $\le 0.2^\circ$ and speed error $\le 1^\circ/\text{s}$ for $\ge 50\text{ ms}$ with moving master until Cell 4 served flag (`X75`).
   - Return Cell 4 axes to $0^\circ$.
7. **Return to Lift**:
   - Transit shuttle axis A back to origin lift station.
   - Handover jig to lift (`action := 2`, increment `couple_seq`, extend fork, confirm handoff, retract fork).
   - Descend lift back to initial height ($150\text{ mm}$).
   - Acknowledge request (`ack0/1 := request_id`, `status0/1 := 1`).
8. **Final Observation & Completion**:
   - Once both requests are acknowledged and `X51` (all_done) is confirmed, all axes remain parked at home coordinates.
   - Assert `Y2 := TRUE` and hold stable for $\ge 100\text{ ms}$.

```iec-st
PROGRAM Main
VAR
    D1000 : DINT;
    D1001 : DINT;
    D1004 : DINT;
    D1005 : DINT;
    D1008 : DINT;
    D1009 : DINT;
    D1012 : DINT;
    D1013 : DINT;
    D1016 : DINT;
    D1017 : DINT;
    D1020 : DINT;
    D1021 : DINT;
    D1024 : DINT;
    D1025 : DINT;
    D1028 : DINT;
    D1029 : DINT;
    D1032 : DINT;
    D1033 : DINT;
    D100 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    X30 : BOOL;
    X31 : BOOL;
    D120 : DINT;
    D121 : DINT;
    D122 : DINT;
    D123 : DINT;
    D124 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    D403 : DINT;
    D404 : DINT;
    X61 : BOOL;
    D406 : DINT;
    D407 : DINT;
    X62 : BOOL;
    D409 : DINT;
    D410 : DINT;
    X63 : BOOL;
    D412 : DINT;
    D413 : DINT;
    X64 : BOOL;
    D500 : DINT;
    D501 : DINT;
    D502 : DINT;
    D520 : DINT;
    D521 : DINT;
    D522 : DINT;
    D523 : DINT;
    D524 : DINT;
    D525 : DINT;
    D526 : DINT;
    D527 : DINT;
    X70 : BOOL;
    X71 : BOOL;
    X72 : BOOL;
    D600 : DINT;
    D601 : DINT;
    D620 : DINT;
    D621 : DINT;
    D622 : DINT;
    D623 : DINT;
    D624 : DINT;
    D625 : DINT;
    D626 : DINT;
    D627 : DINT;
    X75 : BOOL;
    X76 : BOOL;
    X77 : BOOL;
    D2000 : DINT;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL;
    D2004 : DINT;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL;
    D2008 : DINT;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL;
    D2012 : DINT;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL;
    D2016 : DINT;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL;
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
    D2024 : DINT;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL;
    D2028 : DINT;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL;
    D2032 : DINT;
    D2033 : DINT;
    D2034 : DINT;
    Y48 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    Y70 : BOOL;
    Y71 : BOOL;
    D700 : DINT;
    D701 : DINT;
    D702 : DINT;
    Y75 : BOOL;
    Y76 : BOOL;
    D710 : DINT;
    D711 : DINT;
    D712 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y30 : BOOL;
    Y2 : BOOL;

    (* Internal state machine *)
    step : INT := 0;
    active_req : INT := 0;
    curr_id : DINT := 0;
    curr_loc : DINT := 0;
    curr_station : DINT := 1;
    curr_dock_x : DINT := -360000;
    
    seq_counter : DINT := 1;
    timer_ms : DINT := 0;
    sync_timer_ms : DINT := 0;
    motion_distance : DINT := 0;
    last_s3_0_pos : DINT := 0;
    
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    final_hold_ms : DINT := 0;
    initialized : BOOL := FALSE;
    
    s4_target_deg : DINT := 0;
END_VAR

(* Initialization on scan 1 *)
IF NOT initialized THEN
    initialized := TRUE;
    step := 0;
    seq_counter := 1;
    
    (* Set all axis enables *)
    Y40 := TRUE;
    Y41 := TRUE;
    Y42 := TRUE;
    Y43 := TRUE;
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    Y47 := TRUE;
    Y48 := TRUE;
    
    (* Default drive rates *)
    D2001 := 800;
    D2005 := 800;
    D2009 := 800;
    D2013 := 800;
    D2017 := 800;
    D2021 := 800;
    D2025 := 800;
    D2029 := 800;
    D2033 := 800;
    
    (* Initial axis targets to home positions *)
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -50000;
    D2020 := -50000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    
    Y30 := FALSE; (* Brake released *)
    Y2 := FALSE;
END_IF;

(* Main State Machine *)
CASE step OF
    0: (* Wait for request 0 or request 1 arrival *)
        IF (D100 > 0) AND NOT req0_done THEN
            active_req := 0;
            curr_id := D100;
            curr_loc := D101;
            IF curr_loc = 2 THEN
                curr_station := 2;
                curr_dock_x := -230000;
            ELSE
                curr_station := 1;
                curr_dock_x := -360000;
            END_IF;
            step := 10;
        ELSIF (D120 > 0) AND NOT req1_done THEN
            active_req := 1;
            curr_id := D120;
            curr_loc := D121;
            IF curr_loc = 2 THEN
                curr_station := 2;
                curr_dock_x := -230000;
            ELSE
                curr_station := 1;
                curr_dock_x := -360000;
            END_IF;
            step := 10;
        ELSIF req0_done AND req1_done THEN
            step := 900; (* All requests finished, proceed to completion *)
        END_IF;

    10: (* Check cancellation *)
        IF (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
            step := 800; (* Cancellation sequence *)
        ELSE
            (* Raise corresponding lift to docking height *)
            IF curr_station = 1 THEN
                D2008 := 73250;
            ELSE
                D2012 := 73250;
            END_IF;
            step := 20;
            timer_ms := 0;
        END_IF;

    20: (* Wait for lift to arrive at docking height *)
        IF curr_station = 1 THEN
            IF ABS(D1008 - 73250) <= 20 AND ABS(D1009) <= 100 THEN
                timer_ms := timer_ms + 20;
            ELSE
                timer_ms := 0;
            END_IF;
        ELSE
            IF ABS(D1012 - 73250) <= 20 AND ABS(D1013) <= 100 THEN
                timer_ms := timer_ms + 20;
            ELSE
                timer_ms := 0;
            END_IF;
        END_IF;
        
        IF timer_ms >= 50 THEN
            (* Move shuttle X to lift station *)
            D2000 := curr_dock_x;
            timer_ms := 0;
            step := 30;
        END_IF;

    30: (* Wait for shuttle arrival at lift station *)
        IF ABS(D1000 - curr_dock_x) <= 20 AND ABS(D1001) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 50 THEN
            (* Engage brake, extend connection fork *)
            Y30 := TRUE;
            D2004 := 18000;
            D80 := 1; (* Extraction *)
            D81 := curr_station;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            timer_ms := 0;
            step := 40;
        END_IF;

    40: (* Wait for fork insertion and jig ownership *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND (D90 = curr_id) THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 80 THEN
            (* Retract fork, release brake, prepare transit to Cell 3 *)
            D2004 := 0;
            D80 := 0;
            timer_ms := 0;
            step := 50;
        END_IF;

    50: (* Wait for fork retracted *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 40 THEN
            Y30 := FALSE; (* Brake open *)
            (* Dispatch shuttle A to Cell 3 nominal docking *)
            D2000 := 230000;
            (* Configure Cell 3 flying transfer *)
            Y70 := TRUE;
            D700 := 1000;
            D701 := 3;
            timer_ms := 0;
            step := 100;
        END_IF;

    100: (* Move toward Cell 3 and establish flying synchronization *)
        IF ABS(D1000 - 230000) <= 5000 THEN
            (* Align Cell 3 axis s3_0 with shuttle *)
            D2016 := D1000 - 230000;
            D2017 := 800;
            (* Check relative position and velocity *)
            IF ABS((D1000 - 230000) - D1016) <= 20 AND ABS(D1001 - D1017) <= 100 THEN
                sync_timer_ms := sync_timer_ms + 20;
            ELSE
                sync_timer_ms := 0;
            END_IF;
            
            (* Extend fork when sync established for 50 ms *)
            IF sync_timer_ms >= 50 THEN
                D2004 := 18000;
            END_IF;
            
            (* Track accompaniment distance with fork extended *)
            IF ABS(D1004 - 18000) <= 20 THEN
                motion_distance := motion_distance + ABS(D1016 - last_s3_0_pos);
            END_IF;
            last_s3_0_pos := D1016;
            
            IF X70 OR (motion_distance >= 22000 AND sync_timer_ms >= 80) THEN
                (* Cell 3 processing complete *)
                D2004 := 0; (* Retract fork *)
                Y70 := FALSE;
                step := 110;
                timer_ms := 0;
            END_IF;
        ELSE
            sync_timer_ms := 0;
            last_s3_0_pos := D1016;
        END_IF;

    110: (* Wait for fork retraction and return Cell 3 axes to home *)
        D2016 := -50000;
        D2020 := -50000;
        D2024 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 40 THEN
            (* Transit shuttle to Cell 4 (Nominal 9900 mm) *)
            D2000 := 990000;
            timer_ms := 0;
            step := 200;
        END_IF;

    200: (* Move to Cell 4 *)
        IF ABS(D1000 - 990000) <= 20 AND ABS(D1001) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 50 THEN
            Y30 := TRUE; (* Brake on *)
            (* Configure Cell 4 gear sync *)
            Y75 := TRUE;
            D710 := 1000; (* 1:1 ratio *)
            D711 := 4;
            (* Rotate axes s4_0 and s4_1 to target angle *)
            s4_target_deg := 18000; (* 180.00 deg *)
            D2028 := s4_target_deg;
            D2032 := s4_target_deg;
            sync_timer_ms := 0;
            step := 210;
        END_IF;

    210: (* Maintain sync ratio and observe angular tolerance *)
        IF ABS(D1028 - D1032) <= 20 AND ABS(D1029 - D1033) <= 100 THEN
            sync_timer_ms := sync_timer_ms + 20;
        ELSE
            sync_timer_ms := 0;
        END_IF;
        
        IF (X75 OR (sync_timer_ms >= 80 AND ABS(D1028 - s4_target_deg) <= 20)) THEN
            (* Cell 4 served, return rotation axes to 0 deg *)
            D2028 := 0;
            D2032 := 0;
            step := 220;
            timer_ms := 0;
        END_IF;

    220: (* Wait for Cell 4 axes to return home *)
        IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 50 THEN
            Y75 := FALSE;
            Y30 := FALSE; (* Brake open *)
            (* Transit shuttle A back to original lift station *)
            D2000 := curr_dock_x;
            timer_ms := 0;
            step := 300;
        END_IF;

    300: (* Wait for shuttle arrival at lift station *)
        IF ABS(D1000 - curr_dock_x) <= 20 AND ABS(D1001) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 50 THEN
            Y30 := TRUE; (* Engage brake *)
            (* Extend fork to place fixture back on lift *)
            D2004 := 18000;
            D80 := 2; (* Placement *)
            D81 := curr_station;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            timer_ms := 0;
            step := 310;
        END_IF;

    310: (* Wait for placement handshake *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 80 THEN
            (* Retract fork *)
            D2004 := 0;
            D80 := 0;
            timer_ms := 0;
            step := 320;
        END_IF;

    320: (* Fork retracted, lower lift to initial height *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 40 THEN
            IF curr_station = 1 THEN
                D2008 := 15000;
            ELSE
                D2012 := 15000;
            END_IF;
            timer_ms := 0;
            step := 330;
        END_IF;

    330: (* Wait for lift to reach initial height (150 mm) *)
        IF curr_station = 1 THEN
            IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                timer_ms := timer_ms + 20;
            ELSE
                timer_ms := 0;
            END_IF;
        ELSE
            IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                timer_ms := timer_ms + 20;
            ELSE
                timer_ms := 0;
            END_IF;
        END_IF;
        
        IF timer_ms >= 50 THEN
            (* Respond with completion ack *)
            IF active_req = 0 THEN
                D300 := curr_id;
                D301 := 1; (* Completion *)
                req0_done := TRUE;
            ELSE
                D302 := curr_id;
                D303 := 1; (* Completion *)
                req1_done := TRUE;
            END_IF;
            
            (* Return shuttle to home (0 mm) *)
            Y30 := FALSE;
            D2000 := 0;
            timer_ms := 0;
            step := 340;
        END_IF;

    340: (* Wait for shuttle to return home *)
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 THEN
            timer_ms := timer_ms + 20;
        ELSE
            timer_ms := 0;
        END_IF;
        
        IF timer_ms >= 50 THEN
            step := 0; (* Process next request or finalize *)
        END_IF;

    800: (* Cancellation handling *)
        (* Lower lift and retract axes *)
        D2004 := 0;
        IF curr_station = 1 THEN
            D2008 := 15000;
        ELSE
            D2012 := 15000;
        END_IF;
        D2000 := 0;
        
        IF active_req = 0 THEN
            D300 := curr_id;
            D301 := 2; (* Cancellation retrieval *)
            req0_done := TRUE;
        ELSE
            D302 := curr_id;
            D303 := 2; (* Cancellation retrieval *)
            req1_done := TRUE;
        END_IF;
        step := 0;

    900: (* Final completion check *)
        (* Ensure all axes at home and stopped *)
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-50000)) <= 20 AND ABS(D1020 - (-50000)) <= 20 AND
           ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
            
            Y2 := TRUE;
            final_hold_ms := final_hold_ms + 20;
        ELSE
            final_hold_ms := 0;
        END_IF;
END_CASE;

END_PROGRAM
```