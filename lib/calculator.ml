type operation = 
  | ADD
  | SUB
  | MUL
  | DIV

let calculate a b op = 
  match op with
  | ADD -> a +. b
  | SUB -> a -. b
  | MUL -> a *. b
  | DIV -> if b = 0.0 then failwith "Division by zero" else a /. b