
# OCaml Calculator

A desktop calculator built with OCaml and GTK3 (Lablgtk3).

## Features

- Basic arithmetic operations
- Addition, subtraction, multiplication and division
- Mode switcch for advanced arithmetic operations
- Graphical user interface
- Custom CSS styling
- Decimal number support

## Technologies

- OCaml 5.1.1
- Dune
- Lablgtk3
- GTK3

## Project Structure

```text
OCaml_Calculator/
├── bin/
│   ├── main.ml
│   ├── style.css
│   └── dune
├── lib/
│   ├── calculator.ml
│   ├── calculator.mli
│   └── dune
├── dune-project
└── README.md
```

## Installation

Install OCaml and OPAM, then install the dependencies:

```bash
opam install dune lablgtk3
```

## Build

```bash
dune build
```

## Run

```bash
dune exec calculator
```

## Author

Paul
