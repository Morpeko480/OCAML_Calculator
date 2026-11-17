(lang dune 3.16)

(name calculator)

(generate_opam_files true)

(source
 (github Morpeko480/OCAML_Calculator))

(authors "Paul Ionescu")

(maintainers "Paul Ionescu")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name calculator)
 (synopsis "A graphical calculator written in OCaml")
 (description "A desktop calculator application built with OCaml and GTK3.")
 (depends ocaml dune lablgtk3)
 (tags
  ("calculator")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
