type operation =
    | ADD
    | SUB
    | MUL
    | DIV
    | SQUARE
    | LN
    | LOG
    | SIN
    | COS
    | TAN 
    | SQRT
    | POW
    | MOD


val calculate : float -> float -> operation -> float