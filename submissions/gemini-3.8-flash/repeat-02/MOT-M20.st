### Control Strategy

1. **Phase 0 — Initialization and Request Handling**:
   - Wait for request trigger (`X10`).
   - Retain request parameters: gear ratio `D15`, reference rotation span `D14`, and stop angle `D13`.
   - Set gear ratio output `D20 := D15`.
   - Pulse gear coupling command `Y20 := TRUE`.

2. **Phase 1 — Gear Coupling**:
   - Keep `Y20` high until gear coupling is confirmed active (`X12 = TRUE`). Once confirmed, reset `Y20 := FALSE` to allow subsequent edge detection for `GearOut`.
   - Wait for actual synchronization confirmation (`X11 = TRUE`, indicating InGear status).

3. **Phase 2 — Synchronized Span Tracking**:
   - Upon entering InGear (`X11 = TRUE`), latch the initial reference axis position `u_sync_start := D10`.
   - Continue coupled operation until the master reference axis has traversed the requested span:
     `D10 - u_sync_start >= D14`.

4. **Phase 3 — Gear Separation**:
   - Pulse `Y21 := TRUE` to initiate gear separation.
   - Hold `Y21` until coupling is disengaged (`X12 = FALSE`). Once disengaged, drop `Y21 := FALSE`.

5. **Phase 4 — Independent Positioning (Park)**:
   - Calculate the target cumulative angle `D21`:
     Compute the base target modulo 360° matching `D13`. To avoid abrupt reversals while the axis is coasting forward from synchronous speed, advance the target forward by 360° increments until it is sufficiently ahead of the current position to allow a smooth deceleration stop.
   - Assert `Y22 := TRUE` to engage independent position control.
   - Monitor arrival conditions:
     `ABS(D11 - D21) <= 20` (within ±0.20 deg) and `ABS(D12) <= 100` (within ±1.00 deg/s).
   - Maintain stability for at least 30 ms.

6. **Phase 5 — Completion & Observation Retention**:
   - Assert task completion `Y2 := TRUE`.
   - Maintain outputs and position holding for the required retention window (100 ms).

```iecst
PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    step : INT := 0;
    u_sync_start : DINT := 0;
    park_mod : DINT := 0;
    target_pos : DINT := 0;
    settle_count : DINT := 0;
    hold_count : DINT := 0;
    prev_x10 : BOOL := FALSE;
END_VAR

IF X10 AND NOT prev_x10 AND step = 0 THEN
    step := 1;
    settle_count := 0;
    hold_count := 0;
    Y2 := FALSE;
END_IF;
prev_x10 := X10;

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        D20 := 0;

    1:
        (* Command gear ratio and initiate coupling *)
        D20 := D15;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF X12 THEN
            Y20 := FALSE;
            step := 2;
        END_IF;

    2:
        (* Wait for synchronization confirmation (InGear) *)
        IF X11 THEN
            u_sync_start := D10;
            step := 3;
        END_IF;

    3:
        (* Confirm reference axis traverses the required span *)
        IF (D10 - u_sync_start) >= D14 THEN
            Y21 := TRUE;
            step := 4;
        END_IF;

    4:
        (* Wait for separation *)
        IF NOT X12 THEN
            Y21 := FALSE;
            
            (* Compute target cumulative angle matching D13 modulo 360 deg *)
            park_mod := D13 MOD 36000;
            IF park_mod < 0 THEN
                park_mod := park_mod + 36000;
            END_IF;

            (* Base target at current full rotations *)
            target_pos := (D11 / 36000) * 36000 + park_mod;
            
            (* Ensure target is ahead by at least 25 deg (stopping margin at max speed) *)
            WHILE (target_pos - D11) < 2500 DO
                target_pos := target_pos + 36000;
            END_WHILE;

            D21 := target_pos;
            Y22 := TRUE;
            step := 5;
        END_IF;

    5:
        (* Independent positioning to park angle *)
        Y22 := TRUE;
        IF (ABS(D11 - D21) <= 20) AND (ABS(D12) <= 100) THEN
            settle_count := settle_count + 1;
            IF settle_count >= 3 THEN (* 30 ms settling *)
                Y2 := TRUE;
                step := 6;
            END_IF;
        ELSE
            settle_count := 0;
        END_IF;

    6:
        (* Retention period *)
        Y2 := TRUE;
        Y22 := TRUE;
        hold_count := hold_count + 1;
        IF hold_count >= 10 THEN (* 100 ms retention *)
            step := 7;
        END_IF;

    7:
        (* Complete and hold final state *)
        Y2 := TRUE;
        Y22 := TRUE;
END_CASE;

END_PROGRAM
```