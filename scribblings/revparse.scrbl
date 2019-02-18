#lang scribble/manual

@(require (for-label racket))

@title{Revparse}

@defmodule[libgit2/include/revparse]


@defproc[(git_revparse
          [revspec revspec?]
          [repo repository?]
          [spec string?])
         integer?]{
 Parse a revision string for from, to, and intent.

 See man gitrevisions or http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for information on the syntax accepted.

}

@defproc[(git_revparse_ext
          [repo repository?]
          [spec string?])
         reference?]{
 Find a single object and intermediate reference by a revision string.

 See man gitrevisions, or http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for information on the syntax accepted.

 In some cases (@"@{<-n>}" or @"<branchname>@{upstream}"), the expression may point to an intermediate reference. When such expressions are being passed in, reference_out will be valued as well.

 The returned object should be released with git_object_free and the returned reference with git_reference_free when no longer needed.

}

@defproc[(git_revparse_single
          [repo repository?]
          [spec string?])
         object?]{
 Find a single object, as specified by a revision string.

 See man gitrevisions, or http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for information on the syntax accepted.

 The returned object should be released with git_object_free when no longer needed.
}
