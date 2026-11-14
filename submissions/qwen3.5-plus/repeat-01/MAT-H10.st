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
    step : INT := 0;
    mag_exchanged : BOOL := FALSE;
    req_a : INT := 1;
    req_b : INT := 1;
    last_side_a : BOOL := TRUE;
    trg_swap : R_TRIG;
    trg_take_empty : R_TRIG;
    trg_assemble_a : R_TRIG;
    trg_assemble_b : R_TRIG;
    trg_release_a : R_TRIG;
    trg_release_b : R_TRIG;
END_VAR

Y10 := TRUE;
Y11 := TRUE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;

trg_assemble_a(CLK := X1E AND X20 AND NOT X21);
Y16 := trg_assemble_a.Q;
trg_assemble_b(CLK := X24 AND X26 AND NOT X27);
Y17 := trg_assemble_b.Q;
trg_release_a(CLK := X22 AND X23);
Y18 := trg_release_a.Q;
trg_release_b(CLK := X28 AND X29);
Y19 := trg_release_b.Q;

CASE step OF
  0: IF X0 AND X16 AND X11 AND X12 AND D0=201 AND NOT mag_exchanged THEN
       Y10 := FALSE;
       step := 1;
     END_IF;
  1: IF X17 THEN
       Y12 := TRUE;
       Y13 := TRUE;
       IF req_a <= 3 AND req_b <= 4 THEN
         IF last_side_a THEN
           D200 := 1; D201 := req_a; req_a := req_a + 1; last_side_a := FALSE;
         ELSE
           D200 := 2; D201 := req_b; req_b := req_b + 1; last_side_a := TRUE;
         END_IF;
       ELSIF req_a <= 3 THEN
         D200 := 1; D201 := req_a; req_a := req_a + 1;
       ELSIF req_b <= 4 THEN
         D200 := 2; D201 := req_b; req_b := req_b + 1;
       END_IF;
       step := 2;
     END_IF;
  2: IF X18 THEN
       Y12 := FALSE;
       Y13 := FALSE;
       Y10 := TRUE;
       step := 3;
     END_IF;
  3: Y11 := FALSE;
     trg_swap(CLK := X18 AND X14 AND X13 AND X1A AND X1B);
     Y14 := trg_swap.Q;
     IF trg_swap.Q THEN step := 4; END_IF;
  4: IF NOT X19 AND D0=202 THEN step := 5; END_IF;
  5: trg_take_empty(CLK := X1B);
     Y15 := trg_take_empty.Q;
     IF trg_take_empty.Q THEN
       mag_exchanged := TRUE;
       step := 6;
     END_IF;
  6: IF D3>=3 AND D4>=4 THEN step := 10; ELSE step := 7; END_IF;
  7: Y11 := TRUE; step := 8;
  8: IF X12 THEN Y10 := FALSE; step := 1; END_IF;
  10: IF D3=3 AND D4=4 AND D0=202 AND D1=1 AND X16 AND X14 AND X13 THEN Y1A := TRUE; END_IF;
END_CASE;

END_PROGRAM