#lang racket

(require libgit2
         rackunit
         rackunit/text-ui
         ffi/unsafe)

(define temp-dir
  (make-temporary-file "rkttmp-libgit2-test~a" 'directory))

(define clone-dir (build-path temp-dir "libgit2-clone"))
(define (clear-clone-dir)
  (delete-directory/files clone-dir #:must-exist? #f))

(define repo-dir (build-path temp-dir "test-libgit2"))
(define (clear-repo-dir)
  (delete-directory/files repo-dir #:must-exist? #f))

(test-case
 "clone"
 (clear-clone-dir)
   
 (test-case
  "git clone"
  (check-not-exn
   (λ ()
     (git_repository_free
      (git_clone "https://github.com/bbusching/libgit2.git"
                 (path->string (build-path temp-dir "libgit2-clone"))
                 #f)))))
 #|(test-case
    "git clone options"
    (check-not-exn
     (λ ()
       (let [(opts (malloc _git_clone_opts))]
         (git_clone_init_options opts 1)
         (free opts)))))|#)


(test-case
 "repository"
 (clear-repo-dir)
 (make-directory repo-dir)
   
 (test-case
  "git repo init"
  (check-not-exn (λ () (git_repository_free
                        (git_repository_init (path->string repo-dir) #f)))))

 #|(test-case
    "git repo options"
    (clear-repo-dir)
    (make-directory repo-dir)
    (let [(init_opts (malloc _git_repository_init_opts))]
      (check-not-exn (λ () (git_repository_init_init_options init_opts 1)))
      (check-not-exn (λ () (git_repository_free
                            (git_repository_init_ext (path->string repo-dir) init_opts))))))
 |#
 (let [(repo (git_repository_open (path->string repo-dir)))]
   (check-false (git_repository_is_bare repo) "is bare")
   (test-case "git repo is_empty" (check-true (git_repository_is_empty repo) "is empty"))
   (test-case "git repo is_shallow" (check-false (git_repository_is_shallow repo) "is shallow"))
   (test-case "git repo namespace"
              (let [(ns "namespace")]
                (check-not-exn (λ () (git_repository_set_namespace repo ns)))
                (check-equal? (git_repository_get_namespace repo) ns)))
   (test-case "git repo workdir"
              (check-not-exn (λ () (git_repository_set_workdir repo (path->string repo-dir) #f)))
              (check-not-exn (λ () (git_repository_workdir repo))))
   (test-case "git repo odb"
              (let [(odb (git_repository_odb repo))]
                (check-not-exn (λ () (git_repository_set_odb repo odb)))
                (git_odb_free odb)))
   (test-case "git repo refdb"
              (let [(refdb (git_repository_refdb repo))]
                (check-not-exn (λ () (git_repository_set_refdb repo refdb)))
                (git_refdb_free refdb)))
   (test-case "git repo config"
              (let [(config (git_repository_config repo))]
                (check-not-exn (λ () (git_repository_set_config repo config)))
                (git_config_free config)))
   (test-case "git repo config_snapshot" (check-not-exn (λ () (git_config_free (git_repository_config_snapshot repo)))))
   (test-case "git repo state" (check-equal? (git_repository_state repo) 'GIT_REPOSITORY_STATE_NONE))
   
   (test-case "git repo path"
              ;; don't compare these as paths:
              ;;   the actual result may be syntactically different as the expected path,
              ;;   but refer to the same directory
              ;;   (e.g. on Mac the actual result seems to be prefixed with "/private")
              (check-eqv? (file-or-directory-identity (string->path (git_repository_path repo)))
                          (file-or-directory-identity (build-path repo-dir ".git"))))
   
   (test-case "git repo index"
              (let [(index (git_repository_index repo))]
                (check-not-exn (λ () (git_repository_set_index repo index))) ;??? git_repository_set_index not found
                (git_index_free index)))
   (test-case "git repo ident"
              (let [(name "Brad Busching")
                    (email "bradley.busching@gmail.com")]
                (check-not-exn (λ () (git_repository_set_ident repo name email)))
                (let-values ([(x y) (git_repository_ident repo)])
                  (begin (check-equal? name x)
                         (check-equal? email y)))))
   (test-case "git repo new"
              (check-not-exn (λ () (git_repository_free (git_repository_new)))))
   (git_repository_free repo))
   
 (test-case
  "git repo open bare"
  (clear-repo-dir)
  (make-directory repo-dir)
  (git_repository_free (git_repository_init (path->string repo-dir) #t))
  (check-not-exn (λ () (git_repository_free (git_repository_open_bare (path->string repo-dir))))))

 ; This test breaks a lot of stuff for some reason
 #|(let [(repo (git_repository_open (path->string clone-dir)))]
     (test-case "git repo head" (check-not-exn (λ () (git_reference_free (git_repository_head repo)))))
     (test-case "git repo detach head"
                (check-not-exn (λ () (git_repository_detach_head repo)))
                (check-true (git_repository_head_detached repo)))
     (test-case "git repo head unborn" (check-false (git_repository_head_unborn repo)))
     (git_repository_free repo))
 |#)



(test-case
 "signature"
 (clear-repo-dir)
 (make-directory repo-dir)
 (let [(repo (git_repository_init (path->string repo-dir) #f))]
   (test-case "default"
              (check-not-exn (λ () (git_signature_free (git_signature_default repo)))))
   (test-case "new"
              (check-not-exn (λ () (git_signature_free (git_signature_new "brad busching"
                                                                          "bradley.busching@gmail.com"
                                                                          0
                                                                          0)))))
   (test-case "now"
              (check-not-exn (λ () (git_signature_free (git_signature_now "brad busching"
                                                                          "bradley.busching@gmail.com")))))
   (let [(sig (git_signature_default repo))]
     (check-not-exn (λ () (git_signature_free (git_signature_dup sig))))
     (git_signature_free sig))
   (git_repository_free repo)))


(test-case
 "buf"
 (let [(buf (make-git_buf #f 0 0))]
   (check-not-exn (λ () (git_buf_grow buf 10)))
   (check-not-exn (λ () (git_buf_set buf (bytes 5 66 37 187 0 0 0) 7)))
   (check-true (git_buf_is_binary buf))
   (check-true (git_buf_contains_nul buf))
   #|
   ;; Why does this fail?
   ;;  "git_buf_free: implementation not found; "
   ;; But it should be git_buf_dispose (and maybe kept private) anyway
   (check-not-exn (λ () (git_buf_free buf)))
   |#))


(test-case
 "ignore"
 (let [(repo (git_repository_open (path->string repo-dir)))]
   (test-case "add rule"
              (check-not-exn (λ () (git_ignore_add_rule repo ".gitignore")))
              (check-true (git_ignore_path_is_ignored repo ".gitignore"))
              (check-false (git_ignore_path_is_ignored repo "*.rkt")))
   (test-case "clear rules"
              (check-not-exn (λ () (git_ignore_clear_internal_rules repo)))
              (check-false (git_ignore_path_is_ignored repo ".gitignore"))
              (check-false (git_ignore_path_is_ignored repo "*.rkt")))
   (git_repository_free repo)))


(test-case
 "strarray"
 (let [(strarr1 (make-strarray "hello" "world"))
       (strarr2 (make-strarray))]
   (check-not-exn (λ () (git_strarray_copy strarr2 strarr1)))
   (check-eq? (git_strarray-count strarr2) 2)
   (check-equal? (ptr-ref (git_strarray-strings strarr2) _string 0) "hello")
   (check-equal? (ptr-ref (git_strarray-strings strarr2) _string 1) "world")
   (git_strarray_free strarr2)))


(test-case
 "config"
 (test-case "new" (check-not-exn (λ () (git_config_free (git_config_new)))))
 (test-case "open default" (check-not-exn (λ () (git_config_free (git_config_open_default)))))
 (test-case
  "parse"
  (test-case "bool"
             (check-true (git_config_parse_bool "true"))
             (check-true (git_config_parse_bool "yes"))
             (check-true (git_config_parse_bool "on"))
             (check-true (git_config_parse_bool "1"))
             (check-false (git_config_parse_bool "false"))
             (check-false (git_config_parse_bool "no"))
             (check-false (git_config_parse_bool "off"))
             (check-false (git_config_parse_bool "0")))
  (test-case "int32"
             (check-eq? (git_config_parse_int32 "1k") 1024)
             (check-eq? (git_config_parse_int32 "1m") 1048576)
             (check-eq? (git_config_parse_int32 "-2g") -2147483648))
  (test-case "int64"
             (check-eq? (git_config_parse_int64 "1k") 1024)
             (check-eq? (git_config_parse_int64 "1m") 1048576)
             (check-eq? (git_config_parse_int64 "2g") 2147483648))
  (test-case "path"
             (let [(buf (make-git_buf #f 0 0))]
               (check-not-exn (λ () (git_config_parse_path buf "asdf")))
               (check-equal? (git_buf-ptr buf) "asdf")
               #|
               ;; see above re git_buf_free failing
               (git_buf_free buf)
               |#)))
 #|
 ; These break stuff likely because they require these files to exist on the filesystem
 #;(test-case
    "find"
    (test-case "global"
               (check-not-exn (λ () (let [(buf (make-git_buf #f 0 0))]
                                      (git_config_find_global buf)
                                      (git_buf_free buf)))))
    (test-case "programdata"
               (check-not-exn (λ () (let [(buf (make-git_buf #f 0 0))]
                                      (git_config_find_programdata buf)
                                      (git_buf_free buf)))))
    (test-case "system"
               (check-not-exn (λ () (let [(buf (make-git_buf #f 0 0))]
                                      (git_config_find_system buf)
                                      (git_buf_free buf)))))
    (test-case "xdg"
               (check-not-exn (λ () (let [(buf (make-git_buf #f 0 0))]
                                      (git_config_find_xdg buf)
                                      (git_buf_free buf))))))
 |#
 (let* [(repo (git_repository_open (path->string repo-dir)))
        (config (git_repository_config repo))]
   (test-case "open global" (git_config_free (git_config_open_global config)))
   ;; why does this fail?????
   ;; "giterr_last: implementation not found; no arguments provided"
   ;; (test-case "open level" (git_config_free (git_config_open_level config 'GIT_CONFIG_LEVEL_PROGRAM_DATA)))
   (test-case "set/get bool"
              (check-not-exn (λ () (git_config_set_bool config "core.filemode" #t)))
              (check-true (git_config_get_bool config "core.filemode")))
   (test-case "set/get int32"
              (check-not-exn (λ () (git_config_set_int32 config "core.bigFileThreshold" (* 512 1024))))
              (check-eq? (git_config_get_int32 config "core.bigFileThreshold") (* 512 1024)))
   (test-case "set/get int64"
              (check-not-exn (λ () (git_config_set_int64 config "core.bigFileThreshold" (* 512 1024))))
              (check-eq? (git_config_get_int64 config "core.bigFileThreshold") (* 512 1024)))
   #|
   ; This one breaks. I think it's because
   #;(test-case "iterator"
                (check-not-exn (λ ()
                                 (let [(iter (git_config_iterator_new config))]
                                   (git_config_entry_free (git_config_next iter))
                                   (git_config_iterator_free iter)))))
   #;(test-case "transaction"
                (check-not-exn (λ () (git_transaction_free (git_config_lock config)))))
   |#
   (git_config_free config)
   (git_repository_free repo)))


(test-case
 "index"
 (clear-repo-dir)
 (make-directory repo-dir)
 (let* [(repo (git_repository_init (path->string repo-dir) #f))
        (index (git_repository_index repo))]
   (check-not-exn (λ () (git_index_add_all index (make-strarray ".")
                                           'GIT_INDEX_ADD_DEFAULT
                                           #f
                                           #f)))
   (check-not-exn (λ () (git_index_clear index)))
   (check-not-exn (λ () (git_index_caps index)))
   (check-not-exn (λ () (git_index_checksum index)))
   (git_index_free index)
   (git_repository_free repo)))

#|
#;(test-case
   "reference"
   (clear-repo-dir)
   (make-directory repo-dir)
   (let [(repo (git_repository_init (path->string repo-dir #f)))]
     ))
|#
