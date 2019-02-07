#lang scribble/manual

@(require (for-label racket))

@title{Oid}

@defmodule[libgit2/include/oid]


@defproc[(git_oid_cmp
          [a oid?]
          [b oid?])
         integer?]{
 Compare two oid structures.

}

@defproc[(git_oid_cpy
          [out oid?]
          [src oid?])
         integer?]{
 Copy an oid from one structure to another.

}

@defproc[(git_oid_equal
          [a oid?]
          [b oid?])
         boolean?]{
 Compare two oid structures for equality

}

@defproc[(git_oid_fmt
          [out string?]
          [id oid?])
         void?]{
 Format a git_oid into a hex string.

}

@defproc[(git_oid_fromraw
          [out oid?]
          [raw bytes?])
         void?]{
 Copy an already raw oid into a git_oid structure.

}

@defproc[(git_oid_fromstr
          [out oid?]
          [str string?])
         integer?]{
 Parse a hex formatted object id into a git_oid.

}

@defproc[(git_oid_fromstrn
          [out oid?]
          [str string?]
          [length integer?])
         integer?]{
 Parse N characters of a hex formatted object id into a git_oid

 If N is odd, N-1 characters will be parsed instead. The remaining space in the git_oid will be set to zero.

}

@defproc[(git_oid_fromstrp
          [out oid?]
          [str string?])
         integer?]{
 Parse a hex formatted null-terminated string into a git_oid.

}

@defproc[(git_oid_iszero
          [id oid?])
         boolean?]{
 Check is an oid is all zeros.

}

@defproc[(git_oid_ncmp
          [a oid?]
          [b oid?]
          [len integer?])
         integer?]{
 Compare the first 'len' hexadecimal characters (packets of 4 bits) of two oid structures.

}

@defproc[(git_oid_nfmt
          [out string?]
          [n integer?]
          [id oid?])
         void?]{
 Format a git_oid into a partial hex string.

}

@defproc[(git_oid_pathfmt
          [out string?]
          [id oid?])
         void?]{
 Format a git_oid into a loose-object path string.

 The resulting string is "aa/...", where "aa" is the first two hex digits of the oid and "..." is the remaining 38 digits.

}

@defproc[(git_oid_shorten_add
          [os oid_shorten?]
          [text_id string?])
         integer?]{
 Add a new OID to set of shortened OIDs and calculate the minimal length to uniquely identify all the OIDs in the set.

 The OID is expected to be a 40-char hexadecimal string. The OID is owned by the user and will not be modified or freed.

 For performance reasons, there is a hard-limit of how many OIDs can be added to a single set (around ~32000, assuming a mostly randomized distribution), which should be enough for any kind of program, and keeps the algorithm fast and memory-efficient.

 Attempting to add more than those OIDs will result in a GITERR_INVALID error

}

@defproc[(git_oid_shorten_free
          [os oid_shorten?])
         void?]{
 Free an OID shortener instance

}

@defproc[(git_oid_shorten_new
          [min_length integer?])
         integer?]{
 Create a new OID shortener.

 The OID shortener is used to process a list of OIDs in text form and return the shortest length that would uniquely identify all of them.

 E.g. look at the result of git log --abbrev.

}

@defproc[(git_oid_strcmp
          [id oid?]
          [str string?])
         integer?]{
 Compare an oid to an hex formatted object id.

}

@defproc[(git_oid_streq
          [id oid?]
          [str string?])
         boolean?]{
 Check if an oid equals an hex formatted object id.

}

@defproc[(git_oid_tostr
          [out ?]
          [n size_t]
          [id oid?])
         string?]{
 Format a git_oid into a buffer as a hex format c-string.

 If the buffer is smaller than GIT_OID_HEXSZ+1, then the resulting oid c-string will be truncated to n-1 characters (but will still be NUL-byte terminated).

 If there are any input parameter errors (out == NULL, n == 0, oid == NULL), then a pointer to an empty string is returned, so that the return value can always be printed.

}

@defproc[(git_oid_tostr_s
          [oid oid?])
         string?]{
 Format a git_oid into a statically allocated c-string.

 The c-string is owned by the library and should not be freed by the user. If libgit2 is built with thread support, the string will be stored in TLS (i.e. one buffer per thread) to allow for concurrent calls of the function.
}
