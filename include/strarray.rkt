#lang racket

(require ffi/unsafe
         "../private/base.rkt"
         (rename-in racket/contract
                    [-> ->/c]))

(provide git_strarray?
         (contract-out
          [make-git_strarray
           (->/c (listof (or/c string? bytes? path?))
                 git_strarray?)])
         (protect-out _git_strarray
                      _git_strarray-pointer
                      _git_strarray-pointer/alloc))

;; TODO: It seems like _git_strarray is used only for things
;; which really should be valid unicode, but we should think
;; more broadly about:
;;   a. how and when to deal with invalid unicode
;;   b. libgit2 expecting utf8 when Racket might provide
;;      other encodings, e.g. for paths on Windows

(struct git_strarray (raw))

(define-cstruct _git_strarray:raw
  ([strings _pointer]
   [count _size]))

(define make-git_strarray
  (let ([links (make-weak-hasheq)]) ; to keep list pointers live
    (define (make-git_strarray strs)
      ;; Thanks to Matthew Flatt:
      ;; https://racket.discourse.group/t/using-nonatomic-foreign-memory/787/3
      (define p (cast strs (_list i _string interior) _gcpointer))
      (define r (make-git_strarray:raw p (length strs)))
      (hash-set! links r p)
      (git_strarray r))
    make-git_strarray))

(define-values [_git_strarray _git_strarray-pointer]
  (let ()
    (define (mk who base)
      (make-ctype base
                  git_strarray-raw
                  (λ (gsa)
                    (raise-arguments-error who
                                           "reconstruction from C is not supported"
                                           "given" gsa))))
    (values (mk '_git_strarray _git_strarray:raw)
            (mk '_git_strarray-pointer _git_strarray:raw-pointer))))

(define-libgit2 git_strarray_dispose
  ;; > Free the strings contained in a string array.  This method should
  ;; > be called on `git_strarray` objects that were provided by the
  ;; > library.  Not doing so, will result in a memory leak.
  ;; >
  ;; > This does not free the `git_strarray` itself, since the library will
  ;; > never allocate that object directly itself.
  ;; https://github.com/libgit2/libgit2/commit/5eb48a1
  ;; > We should not be in the business of copying strings around for users.
  ;; > We either return a strarray that can be freed, or we take one (and do
  ;; > not mutate it).
  (_fun _git_strarray:raw-pointer -> _void))

;; In the very few cases when we receive values from C in a git_strarray,
;; we will need to copy the memory to do anything useful with them,
;; anyway. By doing that immediately, we can make git_strarray opaque,
;; simplifying the memory management. The strings are things like branch
;; names, small enough that libgit2 has freely strdup'ed them itself.

(define (consume-git_strarray gsa)
  (match-define (git_strarray:raw strings count) gsa)
  (begin0 (cblock->list strings _string count)
    (git_strarray_dispose gsa)))

(define-fun-syntax _git_strarray-pointer/alloc
  (syntax-parser
    [(_)
     #'(type:
        _git_strarray-pointer
        pre: (make-git_strarray:raw #f 0)
        post: (gsa => (consume-git_strarray gsa)))]))
