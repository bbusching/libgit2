#lang racket/base

(require ffi/unsafe
         ffi/unsafe/alloc
         ffi/file
         "errors.rkt"
         "define.rkt"
         syntax/parse/define
         (rename-in racket/contract [-> ->c])
         (for-meta 2 racket/base)
         (for-syntax racket/base
                     (rename-in syntax/parse [attribute $])
                     syntax/parse/lib/function-header))

(provide (protect-out _path/guard
                      define-libgit2/check ;; legacy only
                      define-libgit2/alloc
                      define-libgit2/dealloc))

(define (make-_path/guard-ctype #:who who modes)
  (make-ctype
   _path
   (λ (p)
     (cond
       [p
        (unless (path-string? p)
          (raise-argument-error '_path/guard "(or/c #f path-string?)" p))
        (let ([p (cleanse-path (path->complete-path p))])
          (security-guard-check-file who p modes)
          p)]
       [else
        #f]))
   #f))

(define/final-prop modes/c
  (listof (or/c 'read 'write 'execute 'delete 'exists)))

(define-module-boundary-contract _path/guard:contracted
  make-_path/guard-ctype
  (->c modes/c #:who symbol? any)
  #:name-for-blame _path/guard)

(define-syntax (_path/guard stx)
  (syntax-parse stx
    [:id
     #'_path/guard:contracted]
    [(_ (~alt (~optional (~var modes* (expr/c #'modes/c
                                              #:name "modes expression"))
                         #:name "modes expression")
              (~optional (~seq #:who (~var who* (expr/c #'symbol?
                                                        #:name "who expression")))
                         #:name "#:who"))
        ...)
     #:fail-unless (or ($ who*) (libgit2-local-who))
     "#:who required outside of define-libgit2"
     #:do [(define static-who
             (if ($ who*)
                 (syntax-parse #'who*
                   #:literals {quote quasiquote}
                   [(~or* ':id `:id) #'who*]
                   [_ #f])
                 #`'#,(libgit2-local-who)))]
     #:with who (or static-who #'who*.c)
     #:do [(define static-modes
             (if ($ modes*)
                 (syntax-parse #'modes*
                   #:literals {quote quasiquote}
                   [(~or* '(m:id ...) `(m:id ...))
                    (for ([id (in-list ($ m))]
                          #:unless (memq (syntax->datum id)
                                         '(read write execute delete exists)))
                      (raise-syntax-error #f "not a valid mode" stx id))
                    #'modes*]
                   [_ #f])
                 #''(read write delete exists)))]
     #:with modes (or static-modes #'modes*.c)
     #:with parsed #'(make-_path/guard-ctype #:who who modes)
     (if (and static-who static-modes)
         (syntax-local-lift-expression #'parsed)
         #'parsed)]))




(begin-for-syntax
  (define-literal-set fun-litset
    #:datum-literals {: :: =}
    {_fun ->})
  (define fun-literal?
    (literal-set->predicate fun-litset))
  (define (check-not-fun-literal stx)
    (and (identifier? stx)
         (fun-literal? stx)
         stx))
  (define-syntax-class fun-id
    #:description #f
    #:attributes {}
    (pattern x:id
             #:fail-when (check-not-fun-literal #'x)
             "_fun literal not allowed as an identifier"))
  (define-syntax-class fun-expr
    #:description #f
    #:attributes {}
    (pattern x:expr
             #:fail-when (check-not-fun-literal #'x)
             "_fun literal not allowed as an expression"))
  (define-syntax ~opt-seq
    (pattern-expander
     (lambda (stx)
       (syntax-case stx ()
         [(~opt-seq pat ...)
          #'(~optional (~seq pat ...))]))))
  (define-splicing-syntax-class fun-options
    #:description "_fun options"
    #:attributes {[parsed 1]}
    (pattern (~and (~seq parsed ...)
                   (~seq (~alt (~opt-seq #:abi abi:fun-expr)
                               (~opt-seq #:save-errno save-errno:fun-expr)
                               (~opt-seq #:keep keep:fun-expr)
                               (~opt-seq #:atomic? atomic?:fun-expr)
                               (~opt-seq #:async-apply async-apply:fun-expr)
                               (~opt-seq #:lock-name lock-name:fun-expr)
                               (~opt-seq #:in-original-place? in-original-place?:fun-expr)
                               (~opt-seq #:blocking? blocking?:fun-expr)
                               (~opt-seq #:retry (~and retry (:fun-id [:fun-id :fun-expr]))))
                         ...))))
  (define-syntax-class type-spec
    #:description "_fun type-spec"
    #:attributes {}
    (pattern [name:fun-id (~datum :) :fun-expr])
    (pattern [:fun-expr (~datum =) :fun-expr])
    (pattern [name:fun-id (~datum :) :fun-expr (~datum =) :fun-expr])
    (pattern :fun-id)
    (pattern (:fun-expr ...+)))
  #|END begin-for-syntax|#)


(define-syntax-parser define-libgit2/check
  ;; legacy only
  #:literal-sets [fun-litset]
  #:literals {_int}
  [(_ name:id (_fun options:fun-options
                    (~opt-seq wrap-args:formals ::)
                    arg:type-spec ...
                    -> _int
                    (~optional (~seq -> rslt:fun-expr))))
   #'(define-libgit2 name
       (_fun options.parsed ...
             (~? (~@ wrap-args ::))
             arg ...
             -> [code : (_git_error_code/check)]
             (~? (~@ -> rslt))))])
  

(define-syntax-parser define-libgit2/alloc
  #:literal-sets [fun-litset]
  #:literals {_int _git_error_code/check}
  [(_ name:id
      (_fun options:fun-options
            (~opt-seq raw-wrap-args:formals ::)
            _out-type:fun-id
            arg:type-spec ...
            -> (~or* _int ;; legacy only
                     (_git_error_code/check)))
      (~optional dealloc_fun:id))
   #:do [(define use-wrapper? (attribute raw-wrap-args))]
   #:with tmp-name (if use-wrapper?
                       ((make-syntax-introducer) #'name)
                       #'name)
   #:attr wrap-args (and use-wrapper?
                         #'raw-wrap-args.params)
   #:with base-def
   #'(define-libgit2 tmp-name
       (_fun options.parsed ...
             (~? (~@ wrap-args ::))
             [out : (_ptr o _out-type)]
             arg ...
             -> (_git_error_code/check)
             -> out)
       (~? (~@ #:wrap (allocator dealloc_fun))))
   (syntax-property
    (cond
      [use-wrapper?
       ;; workaround for https://github.com/racket/racket/issues/2484
       #`(begin base-def
                (define name
                  (λ raw-wrap-args
                    (tmp-name . wrap-args))))]
      [else
       #'base-def])
    'mouse-over-tooltips
    (vector #'_out-type
            (sub1 (syntax-position #'_out-type))
            (sub1 (+ (syntax-position #'_out-type)
                     (syntax-span #'_out-type)))
            (format "output: ~s"
                    `(_ptr o ,(syntax->datum #'_out-type)))))])
  
(define-syntax-parser define-libgit2/dealloc
  #:literal-sets [fun-litset]
  [(_ name:fun-id
      (_fun options:fun-options
            (~opt-seq wrap-args:formals ::)
            arg:type-spec ...+
            -> ffi-rslt:type-spec
            (~opt-seq -> output:fun-expr)))
   #'(define-libgit2 name
       (_fun options.parsed ...
             (~? (~@ wrap-args ::))
             arg ...
             -> ffi-rslt
             (~? (~@ -> output)))
       #:wrap (deallocator))])
