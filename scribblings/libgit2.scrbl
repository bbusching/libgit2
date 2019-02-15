#lang scribble/manual

@title{Libgit2: Bindings for the libgit2 git library}

@author[(author+email "Brad Busching" "bradley.busching@gmail.com")]

@(require "doc.rkt")

@defmodule[libgit2]

libgit2 is a portable, pure C implementation of the Git
core methods provided as a re-entrant linkable library with a solid API,
allowing you to write native speed custom Git applications in any language
which supports C bindings.

The @racketmodname[libgit2] Racket bindings begaas a senior project
at California Polytechnic State University, San Luis Obispo
under the guidance of John Clements (clements[at]brinckerhoff.org)

@;{
TODO:
  - note git_libgit2_init and git_libgit2_shutdown are handled automatically
  - don't shadow object? or blame?
  - note that error handling is built in
}

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
@include-section["oid.scrbl"]
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
