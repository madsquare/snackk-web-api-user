# snackk-web-api-user

## require
* lodash

## not amd
```
window.snackkModule.user
```

## functions
user:
* registerUser (user, callback, options)
* loadUser (options, callback)
* updateUser (user, callback, options)
* deleteUser (callback)

provider:
* addProvider (sns, token, callback)
* deleteProvider (sns, callback)

profile:
* updateProfile (fileInput, callback)
* deleteProfile (callback)
* loadDefaultProfile (callback)

password:
* updatePassword (oldPasswd, newPasswd, callback, options)

validate:
* validateEmail (email, callback)

verify:
* sendEmail (callback)

managing:
* setUser (User)
* getUser



### validate email ERROR CODE
```
DUPLICATED: 'error_duplicated'
INVALID: 'error_invalid'
UN_KNOWN: 'error_unknown'
```

## example
```
userModule.init server
userModule.loadMe {
  'success': (res) =>
    debugger
  'error': (er) =>
    debugger
}
```


