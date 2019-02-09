#lang racket

(define-syntax-rule (require-provide mod ...)
  (begin (require mod ...) (provide (all-from-out mod) ...)))

(require-provide "include/annotated_commit.rkt"
                 "include/blame.rkt"
                 "include/blob.rkt"
                 "include/branch.rkt"
                 "include/buffer.rkt"
                 "include/checkout.rkt"
                 "include/cherrypick.rkt"
                 "include/clone.rkt"
                 "include/commit.rkt"
                 "include/config.rkt"
                 "include/cred_helpers.rkt"
                 "include/describe.rkt"
                 "include/diff.rkt"
                 "include/errors.rkt"
                 "include/filter.rkt"
                 "include/graph.rkt"
                 "include/ignore.rkt"
                 "include/index.rkt"
                 "include/indexer.rkt"
                 "include/merge.rkt"
                 "include/message.rkt"
                 "include/net.rkt"
                 "include/notes.rkt"
                 "include/object.rkt"
                 "include/odb.rkt"
                 "include/odb_backend.rkt"
                 "include/oid.rkt"
                 "include/oidarray.rkt"
                 "include/pack.rkt"
                 "include/patch.rkt"
                 "include/pathspec.rkt"
                 "include/proxy.rkt"
                 "include/rebase.rkt"
                 "include/refdb.rkt"
                 "include/reflog.rkt"
                 "include/refs.rkt"
                 "include/refspec.rkt"
                 "include/remote.rkt"
                 "include/repository.rkt"
                 "include/reset.rkt"
                 "include/revert.rkt"
                 "include/revparse.rkt"
                 "include/revwalk.rkt"
                 "include/signature.rkt"
                 "include/status.rkt"
                 "include/strarray.rkt"
                 "include/submodule.rkt"
                 "include/tag.rkt"
                 "include/trace.rkt"
                 "include/transaction.rkt"
                 "include/transport.rkt"
                 "include/tree.rkt"
                 "include/types.rkt")

#|
;; These are private:
'("include/compiled" "include/define.rkt" "include/info.rkt"
  "include/stash.rkt" "include/utils.rkt")
|#

;; This should be done elsewhere: (then, "include/global.rkt" will also be private)
(require "include/global.rkt" ffi/unsafe/custodian)
(let ()
  (register-custodian-shutdown #f
                               (λ (arg) (git_libgit2_shutdown))
                               (current-custodian) ;; (make-custodian-at-root) ;; ??
                               #:at-exit? #t)
  (git_libgit2_init)
  (void))
