#lang racket

(require ffi/unsafe/custodian
         "include/annotated_commit.rkt"
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
         "include/global.rkt"
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

(provide (all-from-out "include/annotated_commit.rkt")
         (all-from-out "include/blame.rkt")
         (all-from-out "include/blob.rkt")
         (all-from-out "include/branch.rkt")
         (all-from-out "include/buffer.rkt")
         (all-from-out "include/checkout.rkt")
         (all-from-out "include/cherrypick.rkt")
         (all-from-out "include/clone.rkt")
         (all-from-out "include/commit.rkt")
         (all-from-out "include/config.rkt")
         (all-from-out "include/cred_helpers.rkt")
         (all-from-out "include/describe.rkt")
         (all-from-out "include/diff.rkt")
         (all-from-out "include/errors.rkt")
         (all-from-out "include/filter.rkt")
         (all-from-out "include/global.rkt")
         (all-from-out "include/graph.rkt")
         (all-from-out "include/ignore.rkt")
         (all-from-out "include/index.rkt")
         (all-from-out "include/indexer.rkt")
         (all-from-out "include/merge.rkt")
         (all-from-out "include/message.rkt")
         (all-from-out "include/net.rkt")
         (all-from-out "include/notes.rkt")
         (all-from-out "include/object.rkt")
         (all-from-out "include/odb.rkt")
         (all-from-out "include/odb_backend.rkt")
         (all-from-out "include/oid.rkt")
         (all-from-out "include/oidarray.rkt")
         (all-from-out "include/pack.rkt")
         (all-from-out "include/patch.rkt")
         (all-from-out "include/pathspec.rkt")
         (all-from-out "include/proxy.rkt")
         (all-from-out "include/rebase.rkt")
         (all-from-out "include/refdb.rkt")
         (all-from-out "include/reflog.rkt")
         (all-from-out "include/refs.rkt")
         (all-from-out "include/refspec.rkt")
         (all-from-out "include/remote.rkt")
         (all-from-out "include/repository.rkt")
         (all-from-out "include/reset.rkt")
         (all-from-out "include/revert.rkt")
         (all-from-out "include/revparse.rkt")
         (all-from-out "include/revwalk.rkt")
         (all-from-out "include/signature.rkt")
         (all-from-out "include/status.rkt")
         (all-from-out "include/strarray.rkt")
         (all-from-out "include/submodule.rkt")
         (all-from-out "include/tag.rkt")
         (all-from-out "include/trace.rkt")
         (all-from-out "include/transaction.rkt")
         (all-from-out "include/transport.rkt")
         (all-from-out "include/tree.rkt")
         (all-from-out "include/types.rkt"))

(register-custodian-shutdown #f (λ (arg) (git_libgit2_shutdown)) #:at-exit? #t)
(git_libgit2_init)
