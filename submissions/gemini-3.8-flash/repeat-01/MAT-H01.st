### Control Architecture and Sequencing

1. **Overall Flow:**
   - Sequential processing of 4 parts: A1, A2, B1, B2 (or A1, B1, A2, B2).
   - Order:
     - Part 1: Source A (Pose 1) $\rightarrow$ Cell A (Pose 3) $\rightarrow$ Inspection (Pose 5) $\rightarrow$ Outfeed (Pose 7) or Reject Pocket 0..3 (Poses 8..11).
     - Part 2: Source A (Pose 1) $\rightarrow$ Cell A (Pose 3) $\rightarrow$ Inspection (Pose 5) $\rightarrow$ Outfeed or Reject Pocket.
     - Part 3: Source B (Pose 2) $\rightarrow$ Cell B (Pose 4) $\rightarrow$ Inspection (Pose 5) $\rightarrow$ Outfeed or Reject Pocket.
     - Part 4: Source B (Pose 2) $\rightarrow$ Cell B (Pose 4) $\rightarrow$ Inspection (Pose 5) $\rightarrow$ Outfeed or Reject Pocket.
   - Distinct reject pocket allocation: tracking variable `next_reject_pocket : INT := 8;` incremented each time a part is rejected (8, 9, 10, 11).

2. **Robot Movements & Handshakes:**
   - Movement handshake:
     To command robot to `target`: set `D100 := target`, increment `move_seq` (`D101 := D101 + 1`).
     Wait until `robot_busy` is FALSE and `D1 = D101` (or `at_pose = target` and not `robot_busy`).
   - Gripper:
     - Close: assert `Y10` (grip_close), deassert `Y11` (grip_open). Wait for `tool_closed` (`X12`) or `holding` (`X13`).
     - Open: assert `Y11` (grip_open), deassert `Y10` (grip_close). Wait for `tool_open` (`X11`).
     - Both `Y10` and `Y11` must never be TRUE simultaneously.

3. **Cell Operations (Cell A / Cell B):**
   - **Cell A Loading:**
     - Door open (`Y15`), clamp open (`Y18`). Wait until `a_door_open` (`X21`) and `a_clamp_open` (`X23`).
     - Robot moves to pose 3.
     - Open gripper (`Y11`). Wait `tool_open`.
     - Robot retreats to pose 0 (or home).
     - Close door (`Y16`), close clamp (`Y17`). Wait until `a_door_closed` (`X22`) and `a_clamp_closed` (`X24`).
     - Pulse `a_cycle` (`Y19`).
     - Wait until `a_done` (`X1F`) and not `a_busy` (`X20`).
   - **Cell A Unloading:**
     - Open clamp (`Y18`), open door (`Y15`). Wait until `a_door_open` (`X21`) and `a_clamp_open` (`X23`).
     - Robot moves to pose 3.
     - Close gripper (`Y10`). Wait `holding` (`X13`).
     - Robot retreats/moves to pose 5 (Inspection).
   - Same symmetrical logic applies to Cell B (`Y1A`, `Y1B`, `Y1C`, `Y1D`, `Y1E`, `X2A`..`X2F`).

4. **Inspection Station:**
   - Robot at pose 5. Open gripper (`Y11`). Wait `tool_open` and `inspection_present` (`X14`).
   - Robot moves clear (e.g. pose 0). Wait until `inspection_clear` (`X1C`) is TRUE and robot not busy.
   - Pulse `measure` (`Y12`).
   - Wait until `result_valid` (`X16`) and not `inspection_busy` (`X15`).
   - Check tolerances: `D4` (depth1) and `D5` (depth2).
     If `5800 <= D4 AND D4 <= 6200 AND 5800 <= D5 AND D5 <= 6200`, target destination is pose 7 (normal outfeed).
     Otherwise, target destination is `next_reject_pocket` (incrementing 8 -> 9 -> 10 -> 11).
   - Robot moves to pose 5.
   - Close gripper (`Y10`). Wait `holding` (`X13`).
   - Robot moves to target destination.
   - Open gripper (`Y11`). Wait `tool_open`.
   - If destination was pose 7, pulse/run `outfeed` (`Y13`) until part is cleared or exit ready.
   - Robot moves back to pose 0.

5. **Completion:**
   - Once all 4 parts are processed and delivered (or when `X1B` / `all_delivered` is TRUE), robot is at pose 0, idle, jaws open, cells idle and safe: assert `Y14 := TRUE`.

Here is the complete IEC 61131-3 Structured Text program implementing this robust sequencer.

```pascal
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
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT;
    D101 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;

    step : INT := 0;
    part_idx : INT := 0; (* 0, 1 -> A parts; 2, 3 -> B parts *)
    dest_pose : INT := 0;
    next_reject_pocket : INT := 8;
    timer_outfeed : TON;
    cycle_pulse : BOOL := FALSE;
    started : BOOL := FALSE;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

timer_outfeed(IN := (step = 70), PT := T#500ms);

CASE step OF
    0: (* Initialize and prepare to process 4 parts *)
        IF part_idx >= 4 OR X1B THEN
            step := 900; (* All parts completed *)
        ELSIF part_idx < 2 THEN
            (* Parts 0 and 1: Source A *)
            step := 10;
        ELSE
            (* Parts 2 and 3: Source B *)
            step := 110;
        END_IF;

    (* ==================== PART A FLOW ==================== *)
    10: (* Ensure gripper open, move to Source A (pose 1) *)
        Y10 := FALSE;
        Y11 := TRUE;
        IF X11 THEN
            D100 := 1;
            D101 := D101 + 1;
            step := 11;
        END_IF;

    11: (* Wait robot at Source A *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 1) THEN
            step := 12;
        END_IF;

    12: (* Grip workpiece at Source A *)
        Y11 := FALSE;
        Y10 := TRUE;
        IF X13 OR X12 THEN
            (* Ensure Cell A door and clamp are open before moving *)
            Y16 := FALSE;
            Y15 := TRUE;
            Y17 := FALSE;
            Y18 := TRUE;
            step := 13;
        END_IF;

    13: (* Wait Cell A door & clamp open *)
        IF X21 AND X23 THEN
            D100 := 3;
            D101 := D101 + 1;
            step := 14;
        END_IF;

    14: (* Wait robot at Cell A *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 3) THEN
            step := 15;
        END_IF;

    15: (* Release workpiece in Cell A *)
        Y10 := FALSE;
        Y11 := TRUE;
        IF X11 THEN
            (* Move robot to Home (pose 0) clear of Cell A *)
            D100 := 0;
            D101 := D101 + 1;
            step := 16;
        END_IF;

    16: (* Wait robot clear at pose 0 *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 0) AND X25 THEN
            (* Close clamp and door *)
            Y15 := FALSE;
            Y16 := TRUE;
            Y18 := FALSE;
            Y17 := TRUE;
            step := 17;
        END_IF;

    17: (* Wait Cell A door and clamp fully closed *)
        IF X22 AND X24 AND (NOT X20) THEN
            Y19 := TRUE; (* Trigger a_cycle *)
            step := 18;
        END_IF;

    18: (* Clear cycle command and wait for machining complete *)
        Y19 := FALSE;
        IF X1F AND (NOT X20) THEN
            (* Open clamp and open door *)
            Y16 := FALSE;
            Y15 := TRUE;
            Y17 := FALSE;
            Y18 := TRUE;
            step := 19;
        END_IF;

    19: (* Wait door and clamp fully open *)
        IF X21 AND X23 THEN
            D100 := 3;
            D101 := D101 + 1;
            step := 20;
        END_IF;

    20: (* Wait robot at Cell A *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 3) THEN
            step := 21;
        END_IF;

    21: (* Pick machined part from Cell A *)
        Y11 := FALSE;
        Y10 := TRUE;
        IF X13 OR X12 THEN
            (* Move to inspection station (pose 5) *)
            D100 := 5;
            D101 := D101 + 1;
            step := 200;
        END_IF;

    (* ==================== PART B FLOW ==================== *)
    110: (* Ensure gripper open, move to Source B (pose 2) *)
        Y10 := FALSE;
        Y11 := TRUE;
        IF X11 THEN
            D100 := 2;
            D101 := D101 + 1;
            step := 111;
        END_IF;

    111: (* Wait robot at Source B *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 2) THEN
            step := 112;
        END_IF;

    112: (* Grip workpiece at Source B *)
        Y11 := FALSE;
        Y10 := TRUE;
        IF X13 OR X12 THEN
            (* Ensure Cell B door and clamp open *)
            Y1B := FALSE;
            Y1A := TRUE;
            Y1C := FALSE;
            Y1D := TRUE;
            step := 113;
        END_IF;

    113: (* Wait Cell B door & clamp open *)
        IF X2C AND X2E THEN
            D100 := 4;
            D101 := D101 + 1;
            step := 114;
        END_IF;

    114: (* Wait robot at Cell B *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 4) THEN
            step := 115;
        END_IF;

    115: (* Release workpiece in Cell B *)
        Y10 := FALSE;
        Y11 := TRUE;
        IF X11 THEN
            (* Move robot to Home (pose 0) clear of Cell B *)
            D100 := 0;
            D101 := D101 + 1;
            step := 116;
        END_IF;

    116: (* Wait robot clear at pose 0 *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 0) AND X30 THEN
            (* Close clamp and door *)
            Y1A := FALSE;
            Y1B := TRUE;
            Y1D := FALSE;
            Y1C := TRUE;
            step := 117;
        END_IF;

    117: (* Wait Cell B door and clamp fully closed *)
        IF X2D AND X2F AND (NOT X2B) THEN
            Y1E := TRUE; (* Trigger b_cycle *)
            step := 118;
        END_IF;

    118: (* Clear cycle command and wait for machining complete *)
        Y1E := FALSE;
        IF X2A AND (NOT X2B) THEN
            (* Open clamp and open door *)
            Y1B := FALSE;
            Y1A := TRUE;
            Y1C := FALSE;
            Y1D := TRUE;
            step := 119;
        END_IF;

    119: (* Wait door and clamp fully open *)
        IF X2C AND X2E THEN
            D100 := 4;
            D101 := D101 + 1;
            step := 120;
        END_IF;

    120: (* Wait robot at Cell B *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 4) THEN
            step := 121;
        END_IF;

    121: (* Pick machined part from Cell B *)
        Y11 := FALSE;
        Y10 := TRUE;
        IF X13 OR X12 THEN
            (* Move to inspection station (pose 5) *)
            D100 := 5;
            D101 := D101 + 1;
            step := 200;
        END_IF;

    (* ==================== INSPECTION FLOW ==================== *)
    200: (* Wait robot at inspection station (pose 5) *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 5) THEN
            step := 201;
        END_IF;

    201: (* Release part onto inspection station *)
        Y10 := FALSE;
        Y11 := TRUE;
        IF X11 AND X14 THEN
            (* Move robot clear to home (pose 0) *)
            D100 := 0;
            D101 := D101 + 1;
            step := 202;
        END_IF;

    202: (* Wait robot clear of inspection station *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 0) AND X1C AND (NOT X15) AND X17 THEN
            Y12 := TRUE; (* Request measure *)
            step := 203;
        END_IF;

    203: (* Measurement in progress *)
        Y12 := FALSE;
        IF X16 AND (NOT X15) AND X17 THEN
            (* Evaluate measurement depths: 5800..6200 *)
            IF (D4 >= 5800) AND (D4 <= 6200) AND (D5 >= 5800) AND (D5 <= 6200) THEN
                dest_pose := 7; (* Normal outfeed *)
            ELSE
                dest_pose := next_reject_pocket;
                next_reject_pocket := next_reject_pocket + 1;
            END_IF;
            (* Move robot back to pose 5 to pick inspected part *)
            D100 := 5;
            D101 := D101 + 1;
            step := 204;
        END_IF;

    204: (* Wait robot at inspection (pose 5) *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 5) THEN
            step := 205;
        END_IF;

    205: (* Grip part from inspection *)
        Y11 := FALSE;
        Y10 := TRUE;
        IF X13 OR X12 THEN
            (* Move to destination pose *)
            D100 := dest_pose;
            D101 := D101 + 1;
            step := 206;
        END_IF;

    206: (* Wait robot at destination pose *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = dest_pose) THEN
            step := 207;
        END_IF;

    207: (* Release part at destination *)
        Y10 := FALSE;
        Y11 := TRUE;
        IF X11 THEN
            IF dest_pose = 7 THEN
                Y13 := TRUE; (* Trigger outfeed *)
                step := 70;
            ELSE
                (* Move robot back to home (pose 0) *)
                D100 := 0;
                D101 := D101 + 1;
                step := 80;
            END_IF;
        END_IF;

    70: (* Wait outfeed transfer *)
        IF timer_outfeed.Q OR X1A THEN
            Y13 := FALSE;
            D100 := 0;
            D101 := D101 + 1;
            step := 80;
        END_IF;

    80: (* Wait robot home *)
        IF (NOT X10) AND (D1 = D101) AND (D0 = 0) THEN
            part_idx := part_idx + 1;
            step := 0;
        END_IF;

    (* ==================== COMPLETION ==================== *)
    900: (* Final check: robot at pose 0, tool open, idle *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        IF (NOT X10) AND (D0 = 0) AND (NOT X13) THEN
            Y14 := TRUE;
        END_IF;

END_CASE;

END_PROGRAM
```