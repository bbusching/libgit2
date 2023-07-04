#lang scribble/manual

@title{Libgit2: Bindings for the libgit2 Git Library}
@author[(author+email "Brad Busching" "bradley.busching@gmail.com")]
@defmodule[libgit2]

@(require "doc.rkt")

This package provides Racket bindings to
@hyperlink["https://libgit2.org"]{libgit2},
a portable, pure C implementation of the Git
core methods provided as a re-entrant linkable library.

The Racket bindings are fairly low-level and closely
follow the libgit2 C API: the goal is to provide a foundation
for higher-level Git applications or libraries.
Racket identifiers containing underscores directly correspond to
the @hyperlink["https://libgit2.org/libgit2/"]{C-level functions, types, @etc}
with the same names.
Many functions have different signatures, however,
as this library protects Racket programmers from C-level details
like memory management and checking error codes.

@nested[#:style 'inset]{
 @bold{Status of this library:}
 The Racket interface to libgit2 is not yet stable:
 @bold{backwards-incompatible changes are planned}.
 This package already has extensive coverage of the libgit2 C API,
 but the signatures of some functions should be changed,
 either to handle memory management automatically
 or to use more correct @tech[#:doc '(lib "scribblings/foreign/foreign.scrbl")]{C types}
 at the FFI level.

 Additionally, this package was initially developed against
 libgit2 v0.26.0. It has mostly been updated to support
 libgit2 v1.4.2---all API removals up to that point have
 been dealt with, for example---but some additions and
 modifications remain to be addressed.

 Hopefully these details can be addressed and this package
 stabilized around the API of libgit2 v1.4 series.
 You can contribute to the development effort
 @hyperlink["https://github.com/bbusching/libgit2/"]{on Github}.
}

In addition to the Racket interface, the native libgit2
library is distributed via platform-specific dependencies in
the Racket package system, currently for GNU/Linux (x86_64),
Windows (x86_64 and i386), and Mac OS (x86_64 and Aarch64).

The libgit2 Racket bindings began as a senior project
at California Polytechnic State University, San Luis Obispo
under the guidance of John Clements
(@(hyperlink "mailto:clements@racket-lang.org" "clements@racket-lang.org")).

@;--------------------------------------------

@table-of-contents[]

@include-section["annotated_commit.scrbl"]
@include-section["blame.scrbl"]
@include-section["blob.scrbl"]
@include-section["branch.scrbl"]
@include-section["buffer.scrbl"]
@include-section["checkout.scrbl"]
@include-section["cherrypick.scrbl"]
@include-section["clone.scrbl"]
@include-section["commit.scrbl"]
@include-section["config.scrbl"]
@include-section["cred.scrbl"]
@include-section["describe.scrbl"]
@include-section["diff.scrbl"]
@include-section["fetch.scrbl"]
@include-section["filter.scrbl"]
@include-section["graph.scrbl"]
@include-section["ignore.scrbl"]
@include-section["index.scrbl"]
@include-section["indexer.scrbl"]
@include-section["merge.scrbl"]
@include-section["message.scrbl"]
@include-section["note.scrbl"]
@include-section["object.scrbl"]
@include-section["odb.scrbl"]
@include-section["oid.scrbl"] @; updated
@include-section["packbuilder.scrbl"]
@include-section["patch.scrbl"]
@include-section["pathspec.scrbl"]
@include-section["proxy.scrbl"]
@include-section["push.scrbl"]
@include-section["rebase.scrbl"]
@include-section["refdb.scrbl"]
@include-section["refs.scrbl"]
@include-section["reflog.scrbl"]
@include-section["refspec.scrbl"]
@include-section["remote.scrbl"]
@include-section["repository.scrbl"]
@include-section["reset.scrbl"]
@include-section["revert.scrbl"]
@include-section["revparse.scrbl"]
@include-section["revwalk.scrbl"]
@include-section["signature.scrbl"]
@include-section["stash.scrbl"]
@include-section["status.scrbl"]
@include-section["strarray.scrbl"]
@include-section["submodule.scrbl"]
@include-section["tag.scrbl"]
@include-section["tree.scrbl"]
@include-section["treebuilder.scrbl"]

@(bibliography
  (bib-entry #:key "Busching17"
             #:author "Brad Busching"
             #:title "Libgit2 Racket Interface"
             #:location "California Polytechnic State University, San Luis Obispo"
             #:date "2017"))

@index-section[]
