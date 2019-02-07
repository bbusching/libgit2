#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "errors.rkt"
         "define.rkt")
(provide (all-defined-out))

(define (check-lg2 val retval fun)
  (if (zero? val)
      (retval)
      (let [(err (giterr_last))]
        (unless (not err)
          (raise-result-error fun "0" (format "~a: ~a"
                                              (git_error-klass err)
                                              (git_error-message err)))))))
(define-syntax-rule
  (define-libgit2/check name (_fun ... -> _int))
  (define-libgit2 name (_fun ... -> (retval : _int)
                             -> (check-lg2 retval (λ () retval) 'name))))

(define-syntax define-libgit2/alloc
  (syntax-rules ()
    [(define-libgit2/alloc name (_fun _type args ... -> _int))
     (define-libgit2 name (_fun (out : (_ptr o _type)) args ... -> (retval : _int)
                                -> (check-lg2 retval (λ () out) 'name)))]
    [(define-libgit2/alloc name (_fun _type args ... -> _int) dealloc_fun)
     (define-libgit2 name (_fun (out : (_ptr o _type)) args ... -> (retval : _int)
                                -> (check-lg2 retval (λ () out) 'name))
       #:wrap (allocator dealloc_fun))]))

(define-syntax-rule
  (define-libgit2/dealloc name (_fun ...))
  (define-libgit2 name (_fun ...)
    #:wrap (deallocator)))
