PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    timer_comp : TON;
END_VAR

Y20 := X10;
D20 := LIMIT(-200000, D10, 200000);

timer_comp(IN := X10 AND (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100), PT := T#30ms);
Y2 := Y2 OR timer_comp.Q;

END_PROGRAM