#lang racket/base

(require ffi/unsafe
         (rename-in racket/contract [-> ->c])
         syntax/parse/define
         (for-syntax racket/base))

(provide (all-from-out racket/contract)
         (all-from-out syntax/parse/define)
         GIT_PATH_LIST_SEPARATOR
         1<<
         define-enum
         define-bitmask
         (for-syntax (all-from-out racket/base)))

(define GIT_PATH_LIST_SEPARATOR
  (case (system-type)
    [(windows) #";"]
    [else #":"]))

(define (1<< x)
  (arithmetic-shift 1 x))

(begin-for-syntax
  (define-syntax-class enum/bitmap-member
    #:description "member declaration"
    #:attributes {name [let*-clause 1] [parsed 1] [bound-name 1]}
    #:datum-literals {=}
    (pattern [name:id (~optional =) rhs:expr]
             #:with (bound-name ...) #'(name)
             #:with (let*-clause ...) #'([name rhs])
             #:with (parsed ...) #'('name '= name))
    (pattern name:id
             #:with (bound-name ...) #'()
             #:with (let*-clause ...) #'()
             #:with (parsed ...) #'('name))))

(define-syntax-parser define-enum
  [(_ name:id
      (~alt (~optional (~seq #:unknown unknown:expr))
            (~optional (~seq #:base base:id))
            (~optional (~seq #:contract name/c:id)))
      ...
      member:enum/bitmap-member ...+)
   #'(begin
       (define name
         (let* ((~@ member.let*-clause ...) ...)
           (unless (~? base #f)
             (when (or (~@ (negative? member.bound-name) ...)
                       ...)
               (error 'name
                      "negative values present;\n  should use \"#:base _fixint\"")))
           (_enum (list (~@ member.parsed ...) ...)
                  (~? base)
                  (~? (~@ #:unknown unknown)))))
       (~? (define/final-prop name/c
             (or/c 'member.name ...))))])

(define-syntax-parser define-bitmask
  [(_ name:id
      (~alt (~optional (~seq #:base base:expr))
            (~optional (~seq #:contract name/c:id)))
      ...
      member:enum/bitmap-member ...+)
   #'(begin
       (define name
         (let* ((~@ member.let*-clause ...) ...)
           (_bitmask (list (~@ member.parsed ...) ...)
                     (~? base))))
       (~?(define/final-prop name/c
            (let ([sym/c (or/c 'member.name ...)])
              (or/c sym/c (listof sym/c))))))])
