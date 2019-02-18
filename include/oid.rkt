#lang racket/base

(require ffi/unsafe
         ffi/unsafe/alloc
         libgit2/private
         (rename-in racket/contract
                    [-> ->c]))

(module+ test
  (require rackunit
           rackunit/spec
           (submod "..")))

(provide (protect-out (rename-out [git_oid?/c git_oid?])
                      git_oid_shorten?
                      git-oid-string/c
                      GIT_OID_HEXSZ
                      (contract-out
                       ;; Constructors
                       [git_oid_fromstr
                        (->c git-oid-string/c git_oid?/c)]
                       [git_oid_cpy
                        (->c git_oid?/c git_oid?/c)]
                       ;; Comparison
                       [git_oid_iszero
                        (->c git_oid?/c boolean?)]
                       [git_oid_equal
                        (->c git_oid?/c git_oid?/c boolean?)]
                       [git_oid_streq
                        (->c git_oid?/c git-oid-string/c boolean?)]
                       [git_oid_cmp
                        (->c git_oid?/c git_oid?/c (or/c '< '= '>))]
                       [git_oid_strcmp
                        (->c git_oid?/c git-oid-string/c (or/c '< '= '>))]
                       [git_oid_ncmp
                        (->c git_oid?/c git_oid?/c (integer-in 0 GIT_OID_HEXSZ)
                             (or/c '= #f))]
                       ;; Format
                       [git_oid_fmt
                        (->c git_oid?/c (and/c string? immutable?))]
                       [git_oid_nfmt
                        (->c git_oid?/c (integer-in 0 GIT_OID_HEXSZ)
                             (and/c string? immutable?))]
                       [git_oid_pathfmt
                        (->c git_oid?/c path?)]
                       ;; Shortening
                       [git_oid_shorten_new
                        (->* [] [(integer-in 0 GIT_OID_HEXSZ)] git_oid_shorten?)]
                       [git_oid_shorten_add
                        (->c git_oid_shorten? git-oid-string/c natural-number/c)]
                       )))

(module+ private
  (provide _git_oid-pointer
           _git_oid-pointer/null
           _git_oid))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types

;; Size (in bytes) of a raw/binary oid
(define GIT_OID_RAWSZ 20)
;; Size (in bytes) of a hex formatted oid
(define GIT_OID_HEXSZ (* GIT_OID_RAWSZ 2))
;; Minimum length (in number of hex characters,
;; i.e. packets of 4 bits) of an oid prefix
(define GIT_OID_MINPREFIXLEN 4)

(define-cstruct _git_oid
  ([id (_array _uint8 GIT_OID_RAWSZ)]))

(define/final-prop git_oid?/c
  (flat-named-contract 'git_oid? git_oid?))

(define _git-oid-string
  ;; We leave checking that the string is well-formed to libgit2.
  ;; (Given mutable Racket strings, checking that soundly would need
  ;;  an unfortunate amount of boilerplate here.)
  ;; However, libgit2 may not be able to check well that the string
  ;;   is the right size, which could have safety issues, 
  ;;   so we do check that here.
  (make-ctype _string/utf-8
              (λ (v)
                (unless (string? v)
                  (raise-argument-error '_git-oid-string "string?" v))
                (unless (= GIT_OID_HEXSZ (string-length v))
                  (raise-arguments-error
                   '_git-oid-string
                   "given string is the wrong length"
                   "length" (string-length v)
                   "expected" GIT_OID_HEXSZ
                   "string" v))
                v)
              #f))

(define/final-prop git-oid-string/c
  (flat-contract-with-explanation
   #:name 'git-oid-string/c
   (λ (v)
     (cond
       [(not (string? v))
        (λ (blame)
          (raise-blame-error blame v
                             '(expected: "string?" given: "~e")
                             v))]
       [(not (= GIT_OID_HEXSZ (string-length v)))
        (λ (blame)
          (raise-blame-error blame v
                             '(given "string is the wrong length"
                                     "\n  length: ~e"
                                     expected: "~e"
                                     "\n  " given " string: ~e")
                             (string-length v)
                             GIT_OID_HEXSZ
                             v))]
       [else
        #t]))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constructors

(define-libgit2 git_oid_fromstr
  (_fun [oid : (_ptr o _git_oid)]
        _git-oid-string
        -> (_git_error_code/check)
        -> oid))

(module+ test
  (describe
   "git_oid_fromstr"
   (context
    "given a non-string"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ () (git_oid_fromstr #"bytes")))))
   (context
    "given a string of the wrong size"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ () (git_oid_fromstr "12345")))
        (check-exn exn:fail:contract?
                   (λ () (git_oid_fromstr
                          (make-string (+ 10 GIT_OID_HEXSZ) #\0))))))
   (context
    "given a malformed string"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ ()
                     (git_oid_fromstr
                      (make-string GIT_OID_HEXSZ #\z))))))
   (context
    "given a well-formed string"
    (it "returns a value satisfying git_oid?"
        (check-pred git_oid?
                    (git_oid_fromstr (make-string GIT_OID_HEXSZ #\0))
                    "string of all 0s")
        (check-pred git_oid?
                    (git_oid_fromstr "555c0bd2b220e74e77a2d4ead659ffad79175dfa")
                    "real example string")))))


(define-libgit2 git_oid_cpy
  (_fun [oid : (_ptr o _git_oid)]
        _git_oid-pointer
        -> _void
        -> oid))

(module+ test
  (describe
   "git_oid_cpy"
   (context
    "given a git_oid?"
    (it "produces a git_oid_equal result"
        (define old
          (git_oid_fromstr "555c0bd2b220e74e77a2d4ead659ffad79175dfa"))
        (define new
          (git_oid_cpy old))
        (check-true (git_oid_equal old new))))
   (context
    "given a bad argument"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ () (git_oid_cpy "555c0bd2b220e74e77a2d4ead659ffad79175dfa")))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Comparison

(define-libgit2 git_oid_iszero
  (_fun _git_oid-pointer -> _bool))

(module+ test
  (describe
   "git_oid_iszero"
   (context
    "given an all-0 git_oid"
    (it "returns #true"
        (check-true (git_oid_iszero
                     (git_oid_fromstr (make-string GIT_OID_HEXSZ #\0))))))
   (context
    "given a non-0 git_oid"
    (it "returns #false"
        (check-false (git_oid_iszero
                      (git_oid_fromstr
                       "555c0bd2b220e74e77a2d4ead659ffad79175dfa")))))
   (context
    "given a bad argument"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ () (git_oid_iszero
                          (make-string GIT_OID_HEXSZ #\0))))))))
   
(define-libgit2 git_oid_cmp
  (_fun _git_oid-pointer _git_oid-pointer
        -> [rslt : _int]
        -> (cond
             [(< rslt 0) '<]
             [(= rslt 0) '=]
             [else '>])))

(define-libgit2 git_oid_strcmp
  (_fun [a : _git_oid-pointer]
        [b : _git-oid-string]
        -> [rslt : _int]
        -> (cond
             [(= rslt -1)
              (raise-argument-error 'git_oid_strcmp
                                    "a well-formed libgit2 oid string"
                                    1
                                    a
                                    b)]
             [(< rslt 0) '<]
             [(= rslt 0) '=]
             [else '>])))

(module+ test
  (define 555c0
    "555c0bd2b220e74e77a2d4ead659ffad79175dfa")
  (define 555c1
    "555c1bd2b220e74e77a2d4ead659ffad79175dfa")
  (describe
   "git_oid_cmp and git_oid_strcmp"
   (context
    "given equivalent values"
    (it "returns '="
        (define left-oid (git_oid_fromstr 555c0))
        (check-eq? (git_oid_cmp left-oid
                                (git_oid_fromstr 555c0))
                   '=
                   "git_oid_cmp")
        (check-eq? (git_oid_strcmp left-oid 555c0)
                   '=
                   "git_oid_strcmp")))
   (context
    "given strictly increasing values"
    (it "returns '<"
        (check-eq? (git_oid_cmp (git_oid_fromstr 555c0)
                                (git_oid_fromstr 555c1))
                   '<
                   "git_oid_cmp")
        (check-eq? (git_oid_strcmp (git_oid_fromstr 555c0)
                                   555c1)
                   '<
                   "git_oid_strcmp")))
   (context
    "given strictly decreasing values"
    (it "returns '>"
        (check-eq? (git_oid_cmp (git_oid_fromstr 555c1)
                                (git_oid_fromstr 555c0))
                   '>
                   "git_oid_cmp")
        (check-eq? (git_oid_strcmp (git_oid_fromstr 555c1)
                                   555c0)
                   '>
                   "git_oid_strcmp"))))
  (describe
   "git_oid_cmp"
   (context "given a (not/c git-oid?) first argument"
            (it "raises an exception"
                (check-exn exn:fail:contract?
                           (λ ()
                             (git_oid_cmp 555c0 (git_oid_fromstr 555c0))))))
   (context "given a (not/c git-oid?) second argument"
            (it "raises an exception"
                (check-exn exn:fail:contract?
                           (λ ()
                             (git_oid_cmp (git_oid_fromstr 555c0) 555c0)))))
   (context "given two (not/c git-oid?) arguments"
            (it "raises an exception"
                (check-exn exn:fail:contract?
                           (λ ()
                             (git_oid_cmp 555c0 555c0))))))
  (describe
   "git_oid_strcmp"
   (context
    "given a (not/c git-oid?) first argument"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ ()
                     (git_oid_strcmp 555c0 555c0)))))
   (context
    "given a non-string"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ ()
                     (git_oid_strcmp (git_oid_fromstr 555c0)
                                     (git_oid_fromstr 555c0))))))
   (context
    "given a string of the wrong size"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ ()
                     (git_oid_strcmp (git_oid_fromstr 555c0)
                                     "12345")))
        (check-exn exn:fail:contract?
                   (λ ()
                     (git_oid_strcmp (git_oid_fromstr 555c0)
                                     (make-string (+ 10 GIT_OID_HEXSZ) #\0))))))
   (context
    "given a malformed string"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ ()
                     (git_oid_strcmp (git_oid_fromstr 555c0)
                                     (make-string GIT_OID_HEXSZ #\z))))))))
                             
(define-libgit2 git_oid_ncmp
  ;; is this documented correctly upstream?
  ;; oid.h says it's different then git_oid_cmp or git_oid_strcmp
  (_fun _git_oid-pointer _git_oid-pointer _size
        -> [rslt : _int]
        -> (and (= 0 rslt) '=)))

(module+ test
  (describe
   "git_oid_ncmp"
   (context
    "given equivalent values"
    (it "always returns '="
        (for* ([str (in-list (list 555c0 555c1))]
               [n (in-range (add1 GIT_OID_HEXSZ))])
          (with-check-info
              (['string str]
               ['n n])
            (check-eq? (git_oid_ncmp (git_oid_fromstr str)
                                     (git_oid_fromstr str)
                                     n)
                       '=)))))
   (context
    "given different values"
    (for ([a (in-list (list 555c0 555c1))]
          [b (in-list (list 555c1 555c0))])
      (with-check-info (['a a]
                        ['b b])
        (define diff 5)
        (context
         "when n stops before the first difference"
         (it "returns '="
             (for ([n (in-range diff)])
               (with-check-info (['n n])
                 (check-eq? (git_oid_ncmp (git_oid_fromstr a)
                                          (git_oid_fromstr b)
                                          n)
                            '=)))))
        (context
         "when n goes beyond the first difference"
         (it "returns #false"
             (for ([n (in-range diff (add1 GIT_OID_HEXSZ))])
               (check-false (git_oid_ncmp (git_oid_fromstr a)
                                          (git_oid_fromstr b)
                                          n))))))))
   (context
    "given an n that is out of range"
    (it "raises an exception"
        (define oid (git_oid_fromstr 555c0))
        (for ([n (in-list `(-1 ,(add1 GIT_OID_HEXSZ) 0.25 1/2 not-a-num))])
          (with-check-info (['n n])
            (check-exn exn:fail:contract?
                       (λ () (git_oid_ncmp oid oid n)))))))))
  
(define-libgit2 git_oid_equal
  (_fun _git_oid-pointer _git_oid-pointer -> _bool))

(define-libgit2 git_oid_streq
  (_fun _git_oid-pointer
        _git-oid-string
        -> [rslt : _int]
        -> (case rslt
             [(0) #t]
             [(-1) #f]
             [else (error 'git_oid_streq
                          "~a\n  promised: ~a\n  produced: ~e"
                          "unexpected result from foreign function"
                          "(or/c 0 -1)"
                          rslt)])))

(module+ test
  (describe
   "git_oid_equal and git_oid_streq"
   (context
    "given equivalent values"
    (it "returns #true"
        (check-true
         (git_oid_equal (git_oid_fromstr 555c0)
                        (git_oid_fromstr 555c0))
         "git_oid_equal 555c0")
        (check-true
         (git_oid_equal (git_oid_fromstr (string-upcase 555c0))
                        (git_oid_fromstr 555c0))
         "git_oid_equal 555c0 (upcase)")
        (check-true
         (git_oid_equal (git_oid_fromstr 555c1)
                        (git_oid_fromstr 555c1))
         "git_oid_equal 555c1")
        (check-true
         (git_oid_streq (git_oid_fromstr 555c0) 555c0)
         "git_oid_streq 555c0")
        (check-true
         (git_oid_streq (git_oid_fromstr 555c0) (string-upcase 555c0))
         "git_oid_streq 555c0 (upcase)")
        (check-true
         (git_oid_streq (git_oid_fromstr 555c1) 555c1)
         "git_oid_streq 555c1")))
   (context
    "given distinct values"
    (it "returns #false"
        (check-false
         (git_oid_equal (git_oid_fromstr 555c0)
                        (git_oid_fromstr 555c1))
         "git_oid_equal 555c0 555c1")
        (check-false
         (git_oid_equal (git_oid_fromstr 555c1)
                        (git_oid_fromstr 555c0))
         "git_oid_equal 555c0 555c1")
        (check-false
         (git_oid_streq (git_oid_fromstr 555c0) 555c1)
         "git_oid_streq 555c0 555c1")
        (check-false
         (git_oid_streq (git_oid_fromstr 555c1) 555c0)
         "git_oid_streq 555c0 555c1"))))
  (describe
   "git_oid_streq"
   (define oid (git_oid_fromstr 555c0))
   (context
    "given a non-string"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ () (git_oid_streq oid oid)))))
   (context
    "given a string of the wrong size"
    (it "raises an exception"
        (check-exn exn:fail:contract?
                   (λ () (git_oid_streq oid "12345")))
        (check-exn exn:fail:contract?
                   (λ ()
                     (git_oid_streq oid
                                    (make-string (+ 10 GIT_OID_HEXSZ) #\0))))))
   (context
    "given a malformed string"
    (it "returns #false"
        (check-false
         (git_oid_streq oid
                        (make-string GIT_OID_HEXSZ #\j)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Format
;; (n.b. git_oid_tostr etc. are just a different API,
;;  implemented in terms of git_oid_fmt)

(define-libgit2 git_oid_fmt
  (_fun [bs : (_bytes o GIT_OID_HEXSZ)]
        _git_oid-pointer
        -> _void
        -> (string->immutable-string
            (bytes->string/utf-8 bs))))

(module+ test
  (define 0-oid-string (make-string GIT_OID_HEXSZ #\0))
  (describe
   "git_oid_fmt"
   (define caps
     "9B56475B03F2B7183B900B4B224FACBD4BA3F7BF")
   (it "returns the case-folded form of the argument to git_oid_fromstr"
       (for ([str (in-list (list 555c0 555c1 0-oid-string))])
         (with-check-info (['string str])
           (check-equal? (git_oid_fmt (git_oid_fromstr str))
                         (string-foldcase str)))))))

(define-libgit2 git_oid_nfmt
  (_fun [oid : _?]
        [n : _?]
        [bs : (_bytes o n)]
        [_size = n]
        [_git_oid-pointer = oid]
        -> _void
        -> (string->immutable-string
            (bytes->string/utf-8 bs))))

(module+ test
  (describe
   "git_oid_nfmt"
   (it "returns the correct substring"
       (for* ([str (in-list (list 555c0 555c1 0-oid-string))]
              [oid (in-value (git_oid_fromstr str))]
              [n (in-range (add1 GIT_OID_HEXSZ))])
         (with-check-info (['string str]
                           ['n n])
           (check-equal? (git_oid_nfmt oid n)
                         (substring str 0 n)))))
   (context
    "given an out-of-range n"
    (it "raises an exception"
        (define oid (git_oid_fromstr 555c0))
        (for ([n (in-list `(-1 ,(add1 GIT_OID_HEXSZ) 0.25 1/2 not-a-num))])
          (with-check-info (['n n])
            (check-exn exn:fail:contract?
                       (λ () (git_oid_nfmt oid n)))))))))

(define-libgit2 git_oid_pathfmt
  (_fun [bs : (_bytes o (add1 GIT_OID_HEXSZ))]
        _git_oid-pointer
        -> _void
        -> (bytes->path bs)))

(module+ test
  (describe
   "git_oid_pathfmt"
   (it "produces the correct path"
       (check-equal?
        (git_oid_pathfmt
         (git_oid_fromstr "9b56475b03f2b7183b900b4b224facbd4ba3f7bf"))
        (build-path "9b" "56475b03f2b7183b900b4b224facbd4ba3f7bf")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shortening

(define-cpointer-type _git_oid_shorten)

(define-libgit2/dealloc git_oid_shorten_free
  (_fun _git_oid_shorten -> _void))

(define-libgit2 git_oid_shorten_new
  (_fun ([min-length 0]) ::
        [_size = min-length]
        -> _git_oid_shorten)
  #:wrap (allocator git_oid_shorten_free))

(module+ test
  (describe
   "git_oid_shorten_new"
   (context "called with no arguments"
            (it "produces a git_oid_shorten? value"
                (check-pred git_oid_shorten?
                            (git_oid_shorten_new))))
   (context "called with a minimum length"
            (it "produces a git_oid_shorten? value"
                (check-pred git_oid_shorten?
                            (git_oid_shorten_new 6))))))

(define-libgit2 git_oid_shorten_add
  ;; n.b. adding the same string multiple times
  ;; produces unhelpful results
  (_fun _git_oid_shorten _git-oid-string
        -> [ret : (_git_error_code/check/int
                   #:handle '(0)
                   #:handle-positive? #t)]
        -> ret))

(module+ test
  (describe
   "git_oid_shorten_add"
   (define (string-set s i char)
     (let ([s (string-copy s)])
       (string-set! s i char)
       (string->immutable-string s)))
   (context
    "with a shortener with no minimum length"
    (define shortener (git_oid_shorten_new))
    (define a "9b56475b03f2b7183b900b4b224facbd4ba3f7bf")
    (context
     "called the first time"
     (it "returns 1"
         (check-eqv? (git_oid_shorten_add shortener a)
                     1)))
    (define b (string-set a 0 #\8))
    (context
     "called with a difference in the first digit"
     (it "returns 1"
         (check-eqv? (git_oid_shorten_add shortener b)
                     1)))
    (define c (string-set b 1 #\2))
    (context
     "called with a difference in the second digit"
     (it "returns 2"
         (check-eqv? (git_oid_shorten_add shortener c)
                     2)))
    (define d (string-set c (sub1 GIT_OID_HEXSZ) #\1))
    (context
     "called with a difference in the last digit"
     (it "returns GIT_OID_HEXSZ"
         (check-eqv? (git_oid_shorten_add shortener d)
                     GIT_OID_HEXSZ))))
   (context
    "with a shortener with minimum length 6"
    (define shortener (git_oid_shorten_new 6))
    (define a "9b56475b03f2b7183b900b4b224facbd4ba3f7bf")
    (context
     "called the first time"
     (it "returns 6"
         (check-eqv? (git_oid_shorten_add shortener a)
                     6)))
    (context
     "called with a difference in the fifth digit"
     (it "returns 6"
         (check-eqv? (git_oid_shorten_add shortener
                                          (string-set a 4 #\a))
                     6)))
    (context
     "called with a difference in the tenth digit"
     (it "returns 10"
         (check-eqv? (git_oid_shorten_add shortener
                                          (string-set a 9 #\a))
                     10))))))
