type operation =
    | ADD
    | SUB
    | MUL
    | DIV

val calculate : float -> float -> operation -> float