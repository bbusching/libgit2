#lang racket/base

(require ffi/unsafe
         ffi/unsafe/alloc
         "errors.rkt"
         "define.rkt"
         syntax/parse/define
         (rename-in racket/contract/base [-> ->c])
         (for-syntax racket/base))

(provide define-libgit2/check
         define-libgit2/alloc
         define-libgit2/dealloc
         (contract-out
          [check-git_error_code
           ;; prefer this to be private
           (->c (or/c exact-integer? symbol?) (->c any) symbol? any)]
          ))

(struct exn:fail:libgit2 exn:fail:contract (who code error)
  #:transparent)

#|
Reasons why check-git_error_code must be provided:
--------------------------------------------------
Multiple output pointers:
index.rkt: git_index_conflict_get git_index_conflict_next
branch.rkt: git_branch_next
patch.rkt: git_patch_get_hunk git_patch_line_stats
revparse.rkt: git_revparse_ext
remote.rkt: git_remote_ls
repository.rkt: git_repository_ident
graph.rkt: git_graph_ahead_behind

Handles things other than success/error:
repository.rkt: git_repository_head_unborn
graph.rkt: git_graph_descendant_of
|#

(define (check-git_error_code code retval who)
  (cond
    [(or (eq? 0 code) (eq? 'GIT_OK code))
     (retval)]
    [else
     (define err/null (git_error_last))
     (define e-klass (and err/null (git_error-klass err/null)))
     (define e-msg (and err/null (git_error-message err/null)))
     (define message
       (format "~a: ~a\n  error code: ~e\n  error class: ~e"
               who
               (or e-msg
                   (string-append "an error occurred;\n"
                                  " the foreign function returned an error code,\n"
                                  " but git_error_last returned a null pointer"))
               code
               e-klass))
     (raise
      (exn:fail:libgit2
       message
       (current-continuation-marks)
       who
       code
       (and err/null (cons e-klass e-msg))))]))

(define-syntax-parser define-libgit2/check
  #:literals {_fun -> _int _git_error_code}
  [(_ name:id (_fun fun-form ... -> (~or* _int _git_error_code)))
   #'(define-libgit2 name
       (_fun fun-form ...
             -> [code : _git_error_code]
             -> (check-git_error_code code void 'name)))])

(define-syntax-parser define-libgit2/alloc
  #:literals {_fun -> _int _git_error_code}
  [(_ name:id
      (_fun _out-type:expr fun-form ...
            -> (~or* _int _git_error_code))
      (~optional dealloc_fun:id))
   #'(define-libgit2 name
       (_fun [out : (_ptr o _out-type)] fun-form ...
             -> [code : _git_error_code]
             -> (check-git_error_code code (λ () out) 'name))
       (~? (~@ #:wrap (allocator dealloc_fun))))])
  
(define-simple-macro (define-libgit2/dealloc name:id
                       ((~literal _fun) fun-form ...))
  (define-libgit2 name
    (_fun fun-form ...)
    #:wrap (deallocator)))
