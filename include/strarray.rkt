#lang racket

(require ffi/unsafe
         libgit2/private)
(provide (all-defined-out))

; Types

(define _char-ptrptr (_cpointer/null _string))
(define-cstruct _git_strarray
  ([strings _char-ptrptr]
   [count _size]))
(define _strarray _git_strarray-pointer)
(define _strarray/null _git_strarray-pointer/null)

; Functions

(define-libgit2/dealloc git_strarray_free
  (_fun _strarray -> _void))

(define-libgit2/check git_strarray_copy
  (_fun _strarray _strarray -> _int))

; misc

(define make-strarray
    (λ strs
      (let [(strs-ptr (malloc _string (length strs)))]
        (for ([i (range (length strs))])
          (ptr-set! strs-ptr _string i (list-ref strs i)))
        (make-git_strarray (cast strs-ptr _pointer _char-ptrptr) (length strs)))))
