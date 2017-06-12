#lang scribble/manual

@(require (for-label racket))

@title{Signature}

@defmodule[libgit2/include/signature]


@defproc[(git_signature_default
          [repo repository?])
         signature?]{
 Create a new action signature with default user and now timestamp.

 This looks up the user.name and user.email from the configuration and uses the current time as the timestamp, and creates a new signature based on that information. It will return GIT_ENOTFOUND if either the user.name or user.email are not set.

}

@defproc[(git_signature_dup
          [sig signature?])
         signature?]{
 Create a copy of an existing signature. All internal strings are also duplicated.

 Call git_signature_free() to free the data.

}

@defproc[(git_signature_free
          [sig signature?])
         void?]{
 Free an existing signature.

 Because the signature is not an opaque structure, it is legal to free it manually, but be sure to free the "name" and "email" strings in addition to the structure itself.

}

@defproc[(git_signature_from_buffer
          [buf string?])
         signature?]{
 Create a new signature by parsing the given buffer, which is expected to be in the format "Real Name <email

 timestamp tzoffset", where timestamp is the number of seconds since the Unix epoch and tzoffset is the timezone offset in hhmm format (note the lack of a colon separator).

}

@defproc[(git_signature_new
          [name string?]
          [email string?]
          [time _git_time_t]
          [offset boolean?])
         signature?]{
 Create a new action signature.

 Call git_signature_free() to free the data.

 Note: angle brackets ('<' and '>') characters are not allowed to be used in either the name or the email parameter.

}

@defproc[(git_signature_now
          [name string?]
          [email string?])
         signature?]{
 Create a new action signature with a timestamp of 'now'.

 Call git_signature_free() to free the data.
}
