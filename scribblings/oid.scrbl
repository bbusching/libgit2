#lang scribble/manual

@title{Object IDs}
@(require "doc.rkt")

@defmodule-lg2[libgit2/include/oid]

@deftogether[
 (@defproc[(git_oid_fromstr [str git-oid-string/c])
           git_oid?]
   @defproc[(git_oid? [v any/c]) boolean?]
   @defthing[git-oid-string/c flat-contract?]
   @defthing[GIT_OID_HEXSZ exact-positive-integer?
             #:value 40])]{
 An @deftech{object ID} (or @deftech{OID}) value
 uniquely identifies any Git object,
 including commits, trees, blobs, tags.
 An @tech{object id} is usually written as a hexidecimal string,
 but @tt{libgit2} uses a binary representation internally,
 which is recognized by the predicate @racket[git_oid?].

 The function @racket[git_oid_fromstr] parses a string into
 an @tech{object ID} value, case-insensitively.
 The string form of an @tech{OID} must be @racket[GIT_OID_HEXSZ]
 characters long, which is enforced by the contract @racket[git-oid-string/c].

 @examples[
 #:eval (make-libgit2-eval) #:once
 (git_oid_fromstr "555c0bd2b220e74e77a2d4ead659ffad79175dfa")
 (code:comment "too short")
 (eval:error (git_oid_fromstr "bda0839"))
 (code:comment "not a hex string")
 (eval:error (git_oid_fromstr (make-string GIT_OID_HEXSZ #\z)))
 ]}

@defproc[(git_oid_cpy [src git_oid?])
         git_oid?]{
 Returns a new @tech{object ID} value equivalent to @racket[src].
 @examples[
 #:eval (make-libgit2-eval) #:once
 (define a
   (git_oid_fromstr "555c0bd2b220e74e77a2d4ead659ffad79175dfa"))
 (eval:check (git_oid_equal a (git_oid_cpy a)) #t)
 ]}


@section{Object ID Comparisons}

@defproc[(git_oid_iszero [id git_oid?])
         boolean?]{
 Recognizes @tech{object ID} values equivalent to the
 hex string @racket["0000000000000000000000000000000000000000"].
 @examples[
 #:eval (make-libgit2-eval) #:once
 (eval:check (git_oid_iszero (git_oid_fromstr (make-string GIT_OID_HEXSZ #\0))) #t)
 (eval:check (git_oid_iszero
              (git_oid_fromstr "555c0bd2b220e74e77a2d4ead659ffad79175dfa"))
             #f)
 ]}

@deftogether[
 (@defproc[(git_oid_equal [a git_oid?] [b git_oid?]) boolean?]
   @defproc[(git_oid_streq [a git_oid?] [b git-oid-string/c]) boolean?])]{
 Equivalence test on @tech{object ID} values,
 where @racket[git_oid_streq] is like @racket[git_oid_equal],
 except that @racket[git_oid_streq] takes its second argument in string form.
 @examples[
 #:eval (make-libgit2-eval) #:once
 (define str
   "7b70fdd9970245505229ef2127586350aaa8ad38")
 (eval:check (git_oid_equal (git_oid_fromstr str) (git_oid_fromstr str)) #t)
 (eval:check (git_oid_streq (git_oid_fromstr str) str) #t)
 (eval:check (git_oid_streq (git_oid_fromstr str)
                            "ad1b3cc099b788dcb066c56346fc8854e70e821c")
             #f)                           
 ]}

@deftogether[
 (@defproc[(git_oid_cmp [a git_oid?] [b git_oid?])
           (or/c '< '= '>)]
   @defproc[(git_oid_strcmp [id git_oid?] [str git-oid-string/c])
            (or/c '< '= '>)])]{
 Like @racket[git_oid_equal] and @racket[git_oid_streq],
 respectively, but tests the ordering of the @tech{OIDs}.
}

@defproc[(git_oid_ncmp [a git_oid?] [b git_oid?] [n (integer-in 0 GIT_OID_HEXSZ)])
         (or/c '= #f)]{
 Like @racket[git_oid_equal], but only considers the first @racket[n]
 hexidecimal digits.
 Note that, unlike @racket[git_oid_cmp], @racket[git_oid_ncmp]
 @bold{does not} report the ordering of the @tech{OIDs}.
}



@section{Formatting Object IDs}

@defproc[(git_oid_fmt [id git_oid?])
         (and/c string? immutable?)]{
 Converts the @tech{object ID} @racket[id] to a hexidecimal string.
 Any letters in the resulting string will be in lower case.
 @examples[
 #:eval (make-libgit2-eval) #:once
 (eval:check (git_oid_fmt (git_oid_fromstr "AD1B3CC099B788DCB066C56346FC8854E70E821C"))
             "ad1b3cc099b788dcb066c56346fc8854e70e821c")
 ]}



@defproc[(git_oid_nfmt [id git_oid?] [n (integer-in 0 GIT_OID_HEXSZ)])
         (and/c string? immutable?)]{
 Like @racket[git_oid_fmt], but only converts the first @racket[n]
 hexidecimal digits of @racket[id].
 @examples[
 #:eval (make-libgit2-eval) #:once
 (define id
   (git_oid_fromstr "AD1B3CC099B788DCB066C56346FC8854E70E821C"))
 (eval:check (git_oid_nfmt id 6)
             "ad1b3c")
 ]}

@defproc[(git_oid_pathfmt [id git_oid?])
         path?]{
 Like @racket[git_oid_fmt], but converts @racket[id] to
 a relative loose-object path (for the current platform).

 The first two hexidecimal digits of @racket[id] are used
 as a directory name, and the remaining 38 digits are treated as
 a path within that directory.

 @examples[
 #:eval (make-libgit2-eval) #:once
 (git_oid_pathfmt (git_oid_fromstr "40dc88bde003670bae6df1f0cffb1ffb5d93dee4"))
 ]}


@section{Short Object IDs}

@deftogether[
 (@defproc[(git_oid_shorten_new [min-length (integer-in 0 GIT_OID_HEXSZ) 0])
           git_oid_shorten?]
   @defproc[(git_oid_shorten? [v any/c]) boolean?]
   @defproc[(git_oid_shorten_add [shortener git_oid_shorten?]
                                 [oid-str git-oid-string/c])
            natural-number/c])]{
 An @deftech{OID shortener} consumes a set of @tech{object IDs}
 in string form and computes the minimum string length needed to
 distinguish all of them.

 Calling @racket[git_oid_shorten_add] with a hex string @tech{OID} @racket[oid-str]
 returns the minimum number of digits needed to distinguish all of
 the strings that have been supplied to @racket[git_oid_shorten_add]
 so far with the same @racket[shortener] argument.
 If the @tech{OID shortener} is created with a non-zero @racket[min-length],
 @racket[git_oid_shorten_add] will never return a length less than @racket[min-length].
 
 Calling @racket[git_oid_shorten_add] more than once with the same @racket[shortener]
 and equivalent @racket[oid-str] arguments will produce unhelpful results.

 Note that, ``for performance reasons, [@tt{libgit2} imposes] a hard limit
 of how many @tech{OIDs} can be added to a single set (around 32000,
 assuming a mostly randomized distribution),
 which should be enough for any kind of program,
 and keeps the algorithm fast and memory-efficient.''
 
 @examples[
 #:eval (make-libgit2-eval) #:once
 (define oid-strings
   (set "ad1b3cc099b788dcb066c56346fc8854e70e821c"
        "db775d20c1655c72a95dd40d1a75c0ad4f243461"
        "821ac0038a6b196a93c48182bdde5ac42c6f5b6e"
        "0000000000000000000000000000000000000000"
        "db785d20c1655c72a95dd40d1a75c0ad4f243461"
        "ad1b3cc099c788dcb066c56346fc8854e70e821c"))
 (define min-length
   (let ([shortener (git_oid_shorten_new)])
     (for/last ([str (in-set oid-strings)])
       (git_oid_shorten_add shortener str))))
 (sort (for/list ([str (in-set oid-strings)])
         (substring str 0 min-length))
       string<?)
 ]}

