#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))

; Types

(define _git_transport_cb
  (_fun (_cpointer _transport) _remote _bytes -> _int))

(define _git_cert_ssh_t
  (_bitmask '(GIT_CERT_SSH_MD5 = #x0001
              GIT_CERT_SSH_SHA1 = #x0002)))

(define-cstruct _git_cert_hostkey
  ([parent _cert]
   [type _git_cert_ssh_t]
   [hash_md5 (_array _uint8 16)]
   [hash_sha1 (_array _uint8 20)]))

(define-cstruct _git_cert_x509
  ([parent _cert]
   [data _bytes]
   [len _size]))

(define _git_credtype_t
  (_bitmask '(GIT_CREDTYPE_USERPASS_PLAINTEXT = #x0001
              GIT_CREDTYPE_SSH_KEY = #x0002
              GIT_CREDTYPE_SSH_CUSTOM = #x0004
              GIT_CREDTYPE_DEFAULT = #x0008
              GIT_CREDTYPE_SSH_INTERACTIVE = #x0010
              GIT_CREDTYPE_USERNAME = #x0020
              GIT_CREDTYPE_SSH_MEMORY = #x0040)))

(define _cred (_cpointer 'git_cred))

(define-cstruct _git_cred_userpass_plaintext
  ([parent _cred]
   [username _string]
   [password _string]))

(define _git_cred_sign_callback
  (_fun (_cpointer 'LIBSSH2_SESSION) (_cpointer _string) (_cpointer _size) _string _size (_cpointer _bytes) -> _int))
(define _git_cred_ssh_interactive_callback
  (_fun _string _int _string _int _int (_cpointer 'LIBSSH_USERAUTH_KBDINT_PROMPT) (_cpointer 'LIBSSH_USERAUTH_KBDINT_RESPONSE) (_cpointer _bytes) -> _void))

(define-cstruct _git_cred_ssh_key
  ([parent _cred]
   [username _string]
   [publickey _string]
   [privatekey _string]
   [passphrase _string]))

(define-cstruct _git_cred_ssh_interactive
  ([parent _cred]
   [username _string]
   [prompt_callback _git_cred_ssh_interactive_callback]
   [payload _bytes]))

(define-cstruct _git_cred_ssh_custom
  ([parent _cred]
   [username _string]
   [publickey _string]
   [publickey_len _size]
   [sign_callback _git_cred_sign_callback]
   [payload _bytes]))

(define-cstruct _git_cred_username
  ([parent _cred]
   [username (_array _int8 1)]))

(define _git_cred_acquire_cb
  (_fun (_cpointer _cred) _string _string _uint _bytes -> _int))

; Functions

(define-libgit2/dealloc git_cred_free
  (_fun _cred -> _void))

(define-libgit2/alloc git_cred_default_new
  (_fun _cred -> _int)
  git_cred_free)

(define-libgit2 git_cred_has_username
  (_fun _cred -> _bool))

(define-libgit2/alloc git_cred_ssh_custom_new
  (_fun _cred _string _string _size _git_cred_sign_callback _bytes -> _int)
  git_cred_free)

(define-libgit2/alloc git_cred_ssh_interactive_new
  (_fun _cred _string _git_cred_ssh_interactive_callback _bytes -> _int)
  git_cred_free)

(define-libgit2/alloc git_cred_ssh_key_from_agent
  (_fun _cred _string -> _int)
  git_cred_free)

(define-libgit2/alloc git_cred_ssh_key_memory_new
  (_fun _cred _string _string _string _string -> _int)
  git_cred_free)

(define-libgit2/alloc git_cred_ssh_key_new
  (_fun _cred _string _string _string _string -> _int)
  git_cred_free)

(define-libgit2/alloc git_cred_username_new
  (_fun _cred _string -> _int)
  git_cred_free)

(define-libgit2/alloc git_cred_userpass
  (_fun _cred _string _string _uint _bytes -> _int)
  git_cred_free)

(define-libgit2/alloc git_cred_userpass_plaintext_new
  (_fun _cred _string _string -> _int))
