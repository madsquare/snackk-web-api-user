# snackk-web-api-user

## require
* lodash

## not amd
```
window.snackkModule.user
```

## functions
user:
* registerUser
* loadUser
* updateUser
* deleteUser

provider:
* addProvider
* deleteProvider

profile:
* updateProfile
* deleteProfile
* loadDefaultProfile

password:
* updatePassword

validate:
* validateEmail

verify:
* sendVerifyEmail




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


