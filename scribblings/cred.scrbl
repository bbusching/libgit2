#lang scribble/manual

@(require (for-label racket))

@title{Credentials}

@defmodule[libgit2/include/cred]


@defproc[(git_cred_default_new)
         cred?]{
 Create a "default" credential usable for Negotiate mechanisms like NTLM or Kerberos authentication.

}

@defproc[(git_cred_free
          [cred cred?])
         void?]{
 Free a credential.

 This is only necessary if you own the object; that is, if you are a transport.

}

@defproc[(git_cred_has_username
          [cred cred?])
         boolean?]{
 Check whether a credential object contains username information.

}

@defproc[(git_cred_ssh_custom_new
          [username string?]
          [publickey string?]
          [publickey_len integer?]
          [sign_callback git_cred_sign_callback]
          [payload bytes?])
         cred?]{
 Create an ssh key credential with a custom signing function.

 This lets you use your own function to sign the challenge.

 This function and its credential type is provided for completeness and wraps libssh2_userauth_publickey(), which is undocumented.

 The supplied credential parameter will be internally duplicated.

}

@defproc[(git_cred_ssh_interactive_new
          [username string?]
          [prompt_callback git_cred_ssh_interactive_callback]
          [payload bytes?])
         cred?]{
 Create a new ssh keyboard-interactive based credential object. The supplied credential parameter will be internally duplicated.

}

@defproc[(git_cred_ssh_key_from_agent
          [username string?])
         cred?]{
 Create a new ssh key credential object used for querying an ssh-agent. The supplied credential parameter will be internally duplicated.

}

@defproc[(git_cred_ssh_key_memory_new
          [username string?]
          [publickey string?]
          [privatekey string?]
          [passphrase string?])
         cred?]{
 Create a new ssh key credential object reading the keys from memory.

}

@defproc[(git_cred_ssh_key_new
          [username string?]
          [publickey string?]
          [privatekey string?]
          [passphrase string?])
         cred?]{
 Create a new passphrase-protected ssh key credential object. The supplied credential parameter will be internally duplicated.

}

@defproc[(git_cred_username_new
          [username string?])
         cred?]{
 Create a credential to specify a username.

 This is used with ssh authentication to query for the username if none is specified in the url.

}

@defproc[(git_cred_userpass
          [url string?]
          [user_from_url string?]
          [allowed_types integer?]
          [payload bytes?])
         cred?]{
 Stock callback usable as a git_cred_acquire_cb. This calls git_cred_userpass_plaintext_new unless the protocol has not specified GIT_CREDTYPE_USERPASS_PLAINTEXT as an allowed type.

}

@defproc[(git_cred_userpass_plaintext_new
          [username string?]
          [password string?])
         cred?]{
 Create a new plain-text username and password credential object. The supplied credential parameter will be internally duplicated.
}
