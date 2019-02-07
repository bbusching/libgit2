#lang scribble/manual

@(require (for-label racket))

@title{Refspec}

@defmodule[libgit2/include/refspec]


@defproc[(git_refspec_direction
          [spec refspec?])
         _git_direction]{
 Get the refspec's direction.

}

@defproc[(git_refspec_dst
          [refspec refspec?])
         string?]{
 Get the destination specifier

}

@defproc[(git_refspec_dst_matches
          [refspec refspec?]
          [refname string?])
         boolean?]{
 Check if a refspec's destination descriptor matches a reference

}

@defproc[(git_refspec_force
          [refspec refspec?])
         boolean?]{
 Get the force update setting

}

@defproc[(git_refspec_rtransform
          [out buf?]
          [spec refspec?]
          [name string?])
         integer?]{
 Transform a target reference to its source reference following the refspec's rules

}

@defproc[(git_refspec_src
          [refspec refspec?])
         string?]{
 Get the source specifier

}

@defproc[(git_refspec_src_matches
          [refspec refspec?]
          [refname string?])
         boolean?]{
 Check if a refspec's source descriptor matches a reference

}

@defproc[(git_refspec_string
          [refspec refspec?])
         string?]{
 Get the refspec's string

}

@defproc[(git_refspec_transform
          [out buf?]
          [spec refspec?]
          [name string?])
         integer?]{
 Transform a reference to its target following the refspec's rules
}
