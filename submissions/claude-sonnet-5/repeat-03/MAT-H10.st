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
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;

    (* internal state *)
    step : INT := 0;
    extract_count : INT := 0;
    assembled_a : INT := 0;
    assembled_b : INT := 0;
    pending_release_a : BOOL := FALSE;
    pending_release_b : BOOL := FALSE;
    mag201_recovered : BOOL := FALSE;
    complete_latched : BOOL := FALSE;
    cur_side : INT := 0;
    cur_req : INT := 0;

    (* edge / pulse helpers *)
    start_edge : R_TRIG;
    edge_a : R_TRIG;
    edge_b : R_TRIG;
    done_a_edge : R_TRIG;
    done_b_edge : R_TRIG;
    rel_a_trig : R_TRIG;
    rel_b_trig : R_TRIG;
    swap_trig : R_TRIG;
    take_trig : R_TRIG;

    cond_a : BOOL;
    cond_b : BOOL;
    rel_a_cond : BOOL;
    rel_b_cond : BOOL;
    swap_cond : BOOL;
    take_cond : BOOL;

    comp_cond : BOOL;
    comp_timer : TON;
END_VAR

(* ---------- edge detectors used every scan ---------- *)
start_edge(CLK := X0);

(* assembly request logic *)
cond_a := X1F AND X20 AND NOT X21;
edge_a(CLK := cond_a);
Y16 := edge_a.Q;

cond_b := X25 AND X26 AND NOT X27;
edge_b(CLK := cond_b);
Y17 := edge_b.Q;

(* assembly completion -> count + schedule discharge *)
done_a_edge(CLK := X22);
IF done_a_edge.Q THEN
    assembled_a := assembled_a + 1;
    pending_release_a := TRUE;
END_IF;

done_b_edge(CLK := X28);
IF done_b_edge.Q THEN
    assembled_b := assembled_b + 1;
    pending_release_b := TRUE;
END_IF;

(* discharge only after exit actually clear *)
rel_a_cond := pending_release_a AND X23;
rel_a_trig(CLK := rel_a_cond);
Y18 := rel_a_trig.Q;
IF rel_a_trig.Q THEN
    pending_release_a := FALSE;
END_IF;

rel_b_cond := pending_release_b AND X29;
rel_b_trig(CLK := rel_b_cond);
Y19 := rel_b_trig.Q;
IF rel_b_trig.Q THEN
    pending_release_b := FALSE;
END_IF;

(* ---------- main extraction / swap sequencer ---------- *)
CASE step OF

0: (* idle - safe closed state *)
    Y10 := TRUE;
    Y11 := TRUE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    IF start_edge.Q THEN
        step := 1;
    END_IF;

1: (* dispatch *)
    IF extract_count >= 7 THEN
        step := 200;
    ELSIF D1 <= 0 THEN
        step := 50;
    ELSE
        step := 2;
    END_IF;

2: (* start extraction : open lower, upper must already be closed *)
    IF X16 AND X11 AND X12 AND NOT X19 THEN
        Y10 := FALSE;
        step := 3;
    END_IF;

3: (* wait item on shuttle then move it out *)
    IF X17 THEN
        Y12 := TRUE;
        step := 4;
    END_IF;

4: (* extraction cleared: restore lower, release upper, prepare send data *)
    IF X18 THEN
        Y12 := FALSE;
        Y10 := TRUE;
        Y11 := FALSE;
        IF extract_count < 3 THEN
            cur_side := 1;
            cur_req := extract_count + 1;
        ELSE
            cur_side := 2;
            cur_req := extract_count - 3 + 1;
        END_IF;
        D200 := cur_side;
        D201 := cur_req;
        step := 5;
    END_IF;

5: (* one-scan send pulse *)
    Y13 := TRUE;
    extract_count := extract_count + 1;
    step := 6;

6: (* end pulse, wait upper actually opened then re-close it *)
    Y13 := FALSE;
    IF X13 THEN
        Y11 := TRUE;
        step := 7;
    END_IF;

7:
    IF X12 THEN
        step := 8;
    END_IF;

8: (* ensure shuttle really leaves home before allowing next cycle *)
    IF NOT X16 THEN
        step := 9;
    END_IF;

9:
    IF X16 THEN
        step := 1;
    END_IF;

50: (* swap prep: open upper and hold it open for the whole exchange *)
    Y11 := FALSE;
    IF X13 THEN
        step := 51;
    END_IF;

51: (* fire swap on rising edge of full precondition set *)
    swap_cond := X18 AND X14 AND X1A AND X1B;
    swap_trig(CLK := swap_cond);
    Y14 := swap_trig.Q;
    IF swap_trig.Q THEN
        step := 52;
    END_IF;

52: (* wait new magazine docked *)
    Y14 := FALSE;
    IF X10 AND (D0 = 202) THEN
        step := 53;
    END_IF;

53: (* take away the empty magazine *)
    take_cond := X1B;
    take_trig(CLK := take_cond);
    Y15 := take_trig.Q;
    IF take_trig.Q THEN
        step := 54;
    END_IF;

54:
    Y15 := FALSE;
    IF X1C THEN
        mag201_recovered := TRUE;
        step := 55;
    END_IF;

55: (* close upper again, exchange finished *)
    Y11 := TRUE;
    IF X12 THEN
        step := 1;
    END_IF;

200: (* all 7 items extracted: enforce final safe state *)
    Y10 := TRUE;
    Y11 := FALSE;
    Y12 := FALSE;
    IF X14 AND X13 AND X16 THEN
        step := 201;
    END_IF;

201: (* hold final state *)
    Y10 := TRUE;
    Y11 := FALSE;

ELSE
    step := 0;

END_CASE;

(* ---------- completion evaluation ---------- *)
comp_cond := (extract_count = 7)
    AND (assembled_a >= 3)
    AND (assembled_b >= 4)
    AND (D3 >= 3)
    AND (D4 >= 4)
    AND mag201_recovered
    AND X10
    AND (D0 = 202)
    AND (D1 = 1)
    AND X16
    AND X14
    AND X13
    AND Y10
    AND NOT Y11;

comp_timer(IN := comp_cond, PT := T#500ms);

IF comp_timer.Q THEN
    complete_latched := TRUE;
END_IF;

Y1A := complete_latched;

END_PROGRAM