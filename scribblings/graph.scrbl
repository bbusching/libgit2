#lang scribble/manual

@(require (for-label racket))

@title{Graph}

@defmodule[libgit2/include/graph]


@defproc[(git_graph_ahead_behind
          [repo repository?]
          [local oid?]
          [upstream oid?])
         any]{
 Count the number of unique commits between two commit objects

 There is no need for branches containing the commits to have any upstream relationship, but it helps to think of one as a branch and the other as its upstream, the ahead and behind values will be what git would report for the branches.

 Returns @racket[(values (ahead : integer?) (behind : integer?))]. See @secref["values" #:doc '(lib "scribblings/reference/reference.scrbl")]
}

@defproc[(git_graph_descendant_of
          [repo repository?]
          [commit oid?]
          [ancestor oid?])
         boolean?]{
 Determine if a commit is the descendant of another commit.
}
