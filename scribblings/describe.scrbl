#lang scribble/manual

@(require (for-label racket))

@title{Describe}

@defmodule[libgit2/include/describe]


@defproc[(git_describe_commit
          [committish object?]
          [opts (or/c git_describe_options? #f)])
         describe_result?]{
 Describe a commit

 Perform the describe operation on the given committish object.

}

@defproc[(git_describe_format
          [out buf?]
          [result describe_result?]
          [opts (or/c git_describe_format_options? #f)])
         integer?]{
 Print the describe result to a buffer

}

@defproc[(git_describe_result_free
          [result describe_result?])
         void?]{
 Free the describe result.

}

@defproc[(git_describe_workdir
          [repo repository?]
          [opts (or/c git_describe_options? #f)])
         describe_result?]{
 Describe a commit

 Perform the describe operation on the current commit and the worktree. After peforming describe on HEAD, a status is run and the description is considered to be dirty if there are.
}
