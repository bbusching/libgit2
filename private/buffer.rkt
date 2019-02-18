#lang racket/base

(require ffi/unsafe
         racket/match
         "base.rkt")

(module+ test
  (require rackunit
           rackunit/spec))

(provide (protect-out _git_buf/bytes-or-null))

(define-cstruct _git_buf
  ([ptr (_or-null _pointer)]
   [asize _size]
   [size _size]))

(define-fun-syntax _git_buf/bytes-or-null
  (syntax-parser
    [(_)
     #`(type: _git_buf-pointer
              pre: (maybe-bs => (_git_buf/bytes-or-null:pre maybe-bs))
              post: (buf => (_git_buf/bytes-or-null:post buf)))]))

(define (_git_buf/bytes-or-null:pre maybe-bs)
  (define buf (make-git_buf #f 0 0))
  (when maybe-bs
    (git_buf_set buf maybe-bs))
  buf)
  
(define (_git_buf/bytes-or-null:post buf)
  (match-define (git_buf ptr _ size) buf)
  (cond
    [ptr
     (define bs (make-bytes size))
     (memcpy bs 0 ptr 0 size _byte)
     (git_buf_dispose buf)
     bs]
    [else
     #f]))

(module+ test
  (describe
   "_git_buf/bytes-or-null"
   (context
    "given a byte string"
    (define buf (_git_buf/bytes-or-null:pre #"abc"))
    (it "initializes the buffer properly"
        (match-define (git_buf ptr asize size) buf)
        (check-pred cpointer? ptr)
        (check-eqv? size 3)
        (check-true (>= asize 3)))
    (it "reads the buffer properly"
        (check-equal? (_git_buf/bytes-or-null:post buf)
                      #"abc"))
    (it "clears the buffer properly"
        (match-define (git_buf _ asize size) buf)
        ;; ptr is set to a well-known pointer, not null
        (check-eqv? size 0 "size")
        (check-eqv? asize 0 "asize")))
   (context
    "given #f"
    (define buf (_git_buf/bytes-or-null:pre #f))
    (it "initializes the buffer properly"
        (match-define (git_buf ptr asize size) buf)
        (check-false ptr)
        (check-eqv? size 0 "size")
        (check-eqv? asize 0 "asize"))
    (it "reads the buffer properly"
        (check-false (_git_buf/bytes-or-null:post buf)))
    (it "clears the buffer properly"
        (match-define (git_buf _ asize size) buf)
        (check-eqv? size 0 "size")
        (check-eqv? asize 0 "asize")))))
   
    
(define-libgit2 git_buf_dispose
  (_fun _git_buf-pointer -> _void))

(define-libgit2 git_buf_set
  (_fun _git_buf-pointer
        [bs : _bytes]
        [_size = (bytes-length bs)]
        -> (_git_error_code/check)))


#|
;; these are not currently used

(define-libgit2 git_buf_grow
  (_fun _git_buf-pointer _size -> (_git_error_code/check)))

(define-libgit2 git_buf_is_binary
  (_fun _git_buf-pointer -> _bool))

(define-libgit2 git_buf_contains_nul
  (_fun _git_buf-pointer -> _bool))

(module+ test
  (test-case
   "buf"
   (let [(buf (make-git_buf #f 0 0))]
     (check-not-exn (λ () (git_buf_grow buf 10)))
     (check-not-exn (λ () (git_buf_set buf (bytes 5 66 37 187 0 0 0) 7)))
     (check-true (git_buf_is_binary buf))
     (check-true (git_buf_contains_nul buf))
     (check-not-exn (λ () (git_buf_dispose buf))))))
|#
