#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt")
(provide (all-defined-out))


(define GIT_DEFAULT_PORT 9418)

(define _git_direction
  (_enum '(GIT_DIRECTION_FETCH
           GIT_DIRECTION_PUSH)))

(define-cstruct _git_remote_head
  ([local _int]
   [oid _oid]
   [name _string]
   [symref_target _string]))

(define _git_headlist_cb
  (_fun _remote_head _bytes -> _int))
