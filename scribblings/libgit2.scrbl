#lang scribble/manual

@title{Libgit2: Bindings for the libgit2 git library}

@author[(author+email "Brad Busching" "bradley.busching@gmail.com")]

@(require (for-label racket))

@defmodule[libgit2]{libgit2 is a portable, pure C implementation of the Git
 core methods provided as a re-entrant linkable library with a solid API,
 allowing you to write native speed custom Git applications in any language
 which supports C bindings.}

@section{Background}

This project is being done as a senior project under the guidance of John
Clements (clements[at]brinckerhoff.org)

@;--------------------------------------------

@table-of-contents[]

@include-section["functions.scrbl"]

@(bibliography
  (bib-entry #:key "Busching17"
             #:author "Brad Busching"
             #:title "Libgit2 Racket Interface"
             #:location "California Polytechnic State University, San Luis Obispo"
             #:date "2017"))

@index-section[]
