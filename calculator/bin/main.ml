let () =
  let _ = GMain.init () in

  (* Load CSS *)
let css_provider = GtkData.CssProvider.create () in

let css_file = open_in "bin/style.css" in
let css_length = in_channel_length css_file in
let css_content = really_input_string css_file css_length in
close_in css_file;

GtkData.CssProvider.load_from_data css_provider css_content;

(* Apply CSS globally *)
let screen = Gdk.Screen.default () in

GtkData.StyleContext.add_provider_for_screen
  screen
  css_provider
  GtkData.StyleContext.ProviderPriority.application;

  let window =
    GWindow.window
      ~title:"OCaml Calculator"
      ~width:520
      ~height:620
      ~border_width:12
      ()
  in

  let _ = window#connect#destroy ~callback:GMain.quit in

  
  let layout = 
    GPack.vbox
      ~spacing:8
      ~packing:window#add
      ()
  in

  let display =
    GEdit.entry
      ~text:"0"
      ~packing:layout#add
      ()
  in

  display#set_editable false;

  let current_input = ref "0" in
  let stored_value = ref 0.0 in
  let pending_operation = ref None in
  let start_new_number = ref true in

  let update_display () =
    display#set_text !current_input
  in

  let add_digit digit = 
    if !start_new_number then (
      current_input := digit;
      start_new_number := false
    )
    else if digit <> "." || not (String.contains !current_input '.') then (
      if !current_input = "0" && digit <> "." then
        current_input := digit
      else
        current_input := !current_input ^ digit
    );
    update_display()
  in

  let choose_operation operation = 
    try
      stored_value := float_of_string !current_input;
      pending_operation := Some operation;
      start_new_number := true
    with Failure _ ->
      current_input := "Error";
      update_display(); 
  in

  let calculate_result () =
    match !pending_operation with
    | None -> ()
    | Some operation ->
      (try
        let second_value = float_of_string !current_input in
        
        let result = Calculator.calculate !stored_value second_value operation
        in

        current_input := Printf.sprintf "%.10g" result;
        pending_operation := None;
        start_new_number := true;
        update_display()

      with Failure _ ->
        current_input := "Error";
        pending_operation := None;
        start_new_number := true;
        update_display())
  in

  let clear() =
    current_input := "0";
    stored_value := 0.0;
    pending_operation := None;
    start_new_number := true;
    update_display()
  in

  let handle_button label =
    match label with
    | "C" -> clear ()
    | "=" -> calculate_result ()
    | "+" -> choose_operation Calculator.ADD
    | "-" -> choose_operation Calculator.SUB
    | "*" -> choose_operation Calculator.MUL
    | "/" -> choose_operation Calculator.DIV
    | _ -> add_digit label

  in
  
  let add_row labels =
    let row = 
      GPack.hbox
        ~spacing:5
        ~packing:layout#add
        ()
    in
    
    List.iter 
      (fun label -> 
        let button = GButton.button
          ~label
          ~packing:row#add  
          ()
        in
        
        let _ = 
          button#connect#clicked
          ~callback:(fun () -> handle_button label)
        in
        ())
        labels
  in

  add_row["7"; "8"; "9"; "/"];
  add_row["4"; "5"; "6"; "*"];
  add_row["1"; "2"; "3"; "-"];
  add_row["C"; "0"; "."; "+"];
  add_row["="];

  window#show ();

  GMain.main ()