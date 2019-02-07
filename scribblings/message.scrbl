#lang scribble/manual

@(require (for-label racket))

@title{Message}

@defmodule[libgit2/include/message]


@defproc[(git_message_prettify
          [out buf?]
          [message string?]
          [strip_comments boolean?]
          [comment_char char?])
         integer?]{
 Clean up message from excess whitespace and make sure that the last line ends with a '

 '.

 Optionally, can remove lines starting with a "#".
}
