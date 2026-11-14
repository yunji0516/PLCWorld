<think>
The user wants me to write a PLC control program in IEC 61131-3 Structured Text for a reel exchange and cut-piece production system.

Let me analyze the requirements carefully:

1. **Batch Processing**: Accept 5 batches (1400,1400,1400,1400,400mm), confirm when batch_remaining=0
2. **Orders**: A=[600,1000,800], B=[900,700,1100] - 6 normal slices total 5100mm
3. **Splice**: When fed=2800mm (splice_needed), advance spare, dock, lock, hold ends, thread, press, joined
4. **Waste**: If order > safe_length_mm, generate waste instead
5. **Piece Processing**: Feed → Hold → Cut → Release → Receive → Ack
6. **Completion**: 6 normal slices + 1 waste + splice + maintain 0.5s

Let me trace through the logic:
- States for batch handling, order processing, splice sequence, and completion
- Edge detection for key transitions
- Timers for cut (0.6s), hold (0.15s), release, advance, lock, ack

Key constraints:
- Pull only when holder_open
- Cut only when stopped, holder_closed, target±2mm
- Release only after separation, blade return, holder release
- Waste requires ack_exit

Let me write a clean, complete implementation with proper state machine logic.

I need to be careful about:
- State numbering (avoid duplicates)
- Proper edge detection
- Timer usage
- Output management
- The splice sequence timing
- Waste handling integration

Let me write this properly now.
</think>

```st
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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    st : INT := 0;
    batch_n : INT := 0;
    ord_n : INT := 0;
    n_done : INT := 0;
    w_done : INT := 0;
    splice_done : BOOL := FALSE;
    tgt : INT := 0;
    side_v : INT := 1;
    is_waste : BOOL := FALSE;
    waste_from_order : BOOL := FALSE;

    e0 : R_TRIG;
    e10 : R_TRIG;
    e17 : R_TRIG;
    e19 : R_TRIG;
    e27 : R_TRIG;
    e20 : R_TRIG;
    e21 : R_TRIG;
    e25 : R_TRIG;
    e26 : R_TRIG;
    e1D : R_TRIG;
    eX28 : R_TRIG;

    th : TON;
    tc : TON;
    tr : TON;
    ta : TON;
    tl : TON;
    tb : TON;
    te : TON;
    tcomp : TON;

    ba : BOOL := FALSE;
    pa : BOOL := FALSE;
    sa : BOOL := FALSE;
    ehold : BOOL := FALSE;
    splice_spoke : BOOL := FALSE;
    comp_start : INT := 0;
END_VAR

e0(CLK := X0);
e10(CLK := X10);
e17(CLK := X17);
e19(CLK := X19);
e27(CLK := X27);
e20(CLK := X20);
e21(CLK := X21);
e25(CLK := X25);
e26(CLK := X26);
e1D(CLK := X1D);
eX28(CLK := X28);

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
D200 := 0;

CASE st OF

0: (* WAIT_START *)
    IF e0.Q THEN
        st := 1;
    END_IF;

1: (* BATCH_ACCEPT *)
    IF e10.Q AND batch_n < 5 AND NOT ba THEN
        Y10 := TRUE;
        ba := TRUE;
    END_IF;
    IF ba AND D1 <= 0 THEN
        Y11 := TRUE;
        tb(IN := TRUE, PT := T#500ms);
    END_IF;
    IF tb.Q THEN
        Y11 := FALSE;
        tb(IN := FALSE);
        batch_n := batch_n + 1;
        ba := FALSE;
        IF batch_n >= 5 THEN
            st := 2;
        END_IF;
    END_IF;

2: (* ORDER_SETUP *)
    IF ord_n < 6 THEN
        tgt := 0;
        side_v := 1;
        IF ord_n = 0 THEN
            tgt := 600; side_v := 1;
        ELSIF ord_n = 1 THEN
            tgt := 1000; side_v := 1;
        ELSIF ord_n = 2 THEN
            tgt := 800; side_v := 1;
        ELSIF ord_n = 3 THEN
            tgt := 900; side_v := 2;
        ELSIF ord_n = 4 THEN
            tgt := 700; side_v := 2;
        ELSIF ord_n = 5 THEN
            tgt := 1100; side_v := 2;
        END_IF;

        is_waste := FALSE;
        waste_from_order := FALSE;
        IF tgt > D10 AND splice_done THEN
            is_waste := TRUE;
            waste_from_order := TRUE;
            tgt := D11;
        END_IF;

        D200 := side_v;
        IF side_v = 1 THEN
            Y12 := TRUE;
        ELSE
            Y13 := TRUE;
        END_IF;
        IF is_waste THEN
            Y22 := TRUE;
        END_IF;

        IF X17 AND NOT pa THEN
            Y14 := TRUE;
            pa := TRUE;
        END_IF;
    ELSE
        IF splice_done AND w_done >= 1 THEN
            st := 99;
        ELSIF NOT splice_done AND NOT splice_spoke THEN
            st := 10;
        ELSIF NOT splice_done AND splice_spoke THEN
            st := 2;
        ELSE
            st := 99;
        END_IF;
    END_IF;

3: (* FEED *)
    Y15 := TRUE;
    Y16 := X1F;
    IF D8 >= tgt - 2 THEN
        Y15 := FALSE;
        Y17 := TRUE;
        th(IN := TRUE, PT := T#150ms);
        st := 4;
    END_IF;

4: (* HOLD_FOR_CUT *)
    IF th.Q AND X1B AND D8 >= tgt - 2 AND D8 <= tgt + 2 THEN
        Y18 := TRUE;
        tc(IN := TRUE, PT := T#600ms);
        st := 5;
    END_IF;

5: (* CUT *)
    IF tc.Q THEN
        Y18 := FALSE;
        tc(IN := FALSE);
        st := 6;
    END_IF;

6: (* RELEASE *)
    IF X19 AND NOT X1A AND X1F THEN
        Y19 := TRUE;
        tr(IN := TRUE, PT := T#500ms);
        st := 7;
    END_IF;

7: (* RELEASE_WAIT *)
    IF tr.Q THEN
        Y19 := FALSE;
        tr(IN := FALSE);
        st := 8;
    END_IF;

8: (* WAIT_RECEIVE *)
    IF X1D THEN
        Y1A := TRUE;
        te(IN := TRUE, PT := T#500ms);
        st := 9;
    END_IF;

9: (* ACK_RECEIVE *)
    IF te.Q THEN
        Y1A := FALSE;
        te(IN := FALSE);
        pa := FALSE;
        IF is_waste THEN
            w_done := w_done + 1;
        ELSE
            n_done := n_done + 1;
        END_IF;
        ord_n := ord_n + 1;

        IF n_done >= 6 AND w_done >= 1 AND splice_done AND X29 THEN
            st := 99;
        ELSIF ord_n < 6 THEN
            st := 2;
        ELSIF NOT splice_done THEN
            st := 10;
        ELSE
            st := 99;
        END_IF;
    END_IF;

10: (* SPLICE_CHECK *)
    splice_spoke := TRUE;
    IF e27.Q THEN
        st := 11;
    END_IF;

11: (* SPARE_ADVANCE *)
    Y1C := TRUE;
    sa := TRUE;
    ta(IN := TRUE, PT := T#2000ms);
    IF e21.Q OR ta.Q THEN
        st := 12;
    END_IF;

12: (* SPARE_LOCK *)
    Y1D := TRUE;
    tl(IN := TRUE, PT := T#1000ms);
    IF tl.Q THEN
        Y1C := FALSE;
        st := 13;
    END_IF;

13: (* HOLD_ENDS *)
    Y1E := TRUE;
    Y1F := TRUE;
    ehold := TRUE;
    IF X23 AND X24 THEN
        st := 14;
    END_IF;

14: (* THREAD *)
    Y20 := TRUE;
    IF e25.Q THEN
        Y20 := FALSE;
        st := 15;
    END_IF;

15: (* PRESS *)
    Y21 := TRUE;
    IF e26.Q THEN
        Y21 := FALSE;
        splice_done := TRUE;
        st := 16;
    END_IF;

16: (* RESUME *)
    IF X28 THEN
        st := 2;
    END_IF;

99: (* COMPLETE *)
    Y1B := TRUE;
    tcomp(IN := TRUE, PT := T#500ms);

END_CASE;
END_PROGRAM
```