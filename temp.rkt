#lang racket

(require ffi/unsafe
         ffi/unsafe/define
         racket/runtime-path)
(provide (all-defined-out))

(define-runtime-path lib-path "lib")
(define win-dll-path (build-path lib-path (system-library-subpath) "git2"))

(define libgit2
  (case (system-type)
    [(windows) (or (ffi-lib win-dll-path #:fail (λ () #f))
                   (ffi-lib "git2" '(#f)))]
    [(unix) (ffi-lib "libgit2" '(#f))]))

(define-ffi-definer define-libgit2 libgit2
  #:default-make-fail make-not-available)


(define _git_error_code
  (_enum '(GIT_OK = 0
           GIT_ERROR = -1
           GIT_ENOTFOUND = -3
           GIT_EEXISTS = -4
           GIT_EAMBIGUOUS = -5
           GIT_EBUFS = -6
           GIT_EUSER = -7
           GIT_EBAREREPO = -8
           GIT_EUNBORNBRANCH = -9
           GIT_EUNMERGED = -10
           GIT_ENONFASTFORWARD = -11
           GIT_EINVALIDSPEC = -12
           GIT_ECONFLICT = -13
           GIT_ELOCKED = -14
           GIT_EMODIFIED = -15
           GIT_EAUTH = -16
           GIT_ECERTIFICATE = -17
           GIT_EAPPLIED = -18
           GIT_EPEEl = -19
           GIT_EEOF = -20
           GIT_EINVALID = -21
           GIT_EUNCOMMITTED = -22
           GIT_EDIRECTORY = -23
           GIT_EMERGECONFLICT = -24
           GIT_PASSTHROUGH = -30
           GIT_ITEROVER = -31)))

(define-cstruct _git_error
  ([message _string]
   [klass _int]))
(define _error _git_error-pointer/null)

(define _git_error_t
  (_enum '(GITERR_NONE
           GITERR_NOMEMORY
           GITERR_OS
           GITERR_INVALID
           GITERR_REFERENCE
           GITERR_ZLIB
           GITERR_REPOSITORY
           GITERR_CONFIG
           GITERR_REGEX
           GITERR_ODB
           GITERR_INDEX
           GITERR_OBJECT
           GITERR_NET
           GITERR_TAG
           GITERR_TREE
           GITERR_INDEXER
           GITERR_SSL
           GITERR_SUBMODULE
           GITERR_THREAD
           GITERR_STASH
           GITERR_CHECKOUT
           GITERR_FETCHHEAD
           GITERR_MERGE
           GITERR_SSH
           GITERR_FILTER
           GITERR_REVERT
           GITERR_CALLBACK
           GITERR_CHERRYPICK
           GITERR_DESCRIBE
           GITERR_REBASE
           GITERR_FILESYSTEM
           GITERR_PATCH)))

(define-libgit2 giterr_last
  (_fun -> _error))
(define-libgit2 giterr_clear
  (_fun -> _void))
(define-libgit2 giterr_set_str
  (_fun _int _string -> _void))
(define-libgit2 giterr_set_oom
  (_fun -> _void))

(define-libgit2 git_libgit2_init
  (_fun -> _int))
(define-libgit2 git_libgit2_shutdown
  (_fun -> _int))

(define (check-lg2 val fun)
  (unless (zero? val)
    (let [(err (giterr_last))]
      (unless (not err)
        (raise-result-error fun "0" (format "~a: ~a"
                                            (git_error-klass err)
                                            (git_error-message err)))))))

(define-syntax-rule
  (define-libgit2-checked name (_fun ... -> _int))
  #`(define-libgit2 name (_fun ... -> (r : _int) -> (check-lg2 r name))))


