define [
    'server'
], (
    server
) ->
    _user = null

    _ERROR_CODE = 
        DUPLICATED: 'error_duplicated'
        INVALID: 'error_invalid'
        UN_KNOWN: 'error_unknown'

    _callbackObj = 
        success: (res) =>
            callback.success(res) if callback && callback.success
        error: (er) =>
            callback.error(er) if callback && callback.error
        complete: () ->
            callback.complete() if callback && callback.complete


    User = 
        ###
         * set user
         * @param {User} user  :user object
        ###
        setUser: (user) ->
            _user = user


        ###
         * 회원가입
         * @param  {User}   user     : user object
         * @param  {Function} callback 
         * @param  {Object} options  
         * @return {ajax}
        ###
        registUser: (user, callback, options) ->
            options = {} if not options
            server.request server.TAG.user.user, _.assign(
                    'data': _.assign(
                            'user': user
                        , options)
                    'type': 'POST'
                , _callbackObj)


        ###
         * 로그인 provider추가.
         * @param {String}   sns      : sns 종류.
         * @param {String}   token    : sns access token
         * @param {Function} callback 
        ###
        addProvider: (sns, token, callback) ->
            tag = server.TAG.user.provider.replace(':us_no',_user.us_no).replace ':provider', sns

            server.request tag, _.aasign(
                    'type': 'POST'
                    'data':
                        'token': token
                , _callbackObj)


        ###
         * 내 정보 반환
         * @param  {Object}   filter   : http://api.snackk.tv/api/user.html#GET /user
         * @param  {Function} callback 
         * @param  {Object}   options  
         * @return {ajax}
        ###
        loadMe: (callback, options) ->
            options = {} if not options
            server.request server.TAG.user.user, _.assign(
                    'data': options
                , _callbackObj)


        ###
         * 해당 유저의 디폴트 이미지 로드.
         * @param  {Function} callback 
         * @return {ajax}           
        ###
        loadDefaultPicture: (callback) ->
            tag = server.TAG.user.profileDefault.replace ':us_no', _user.us_no
            server.request tag, _callbackObj


        ###
         * 내 정보 수정.
         * 프로필은 제외됨.
         * @param  {User}     user     
         * @param  {Function} callback 
         * @param  {Object}   options  
         * @return {ajax}            
        ###
        updateUser: (user, callback, options) ->
            if not _user
                console.log 'updateUser] user object is empty.'
                return

            options = {} if not options
            tag = server.TAG.user.aUser.replace ':us_no', _user.us_no
            server.request tag, _.assign(
                'type': 'PUT'
                'data': _.assign(
                        'user': user
                    , options)
                , _callbackObj)


        ###
         * 프로필 사진 수정.
         * @param  {File}     fileInput [description]
         * @param  {Function} callback  [description]
         * @return {[type]}             [description]
        ###
        updateProfile: (fileInput, callback) ->
            tag = server.TAG.user.profile.replace ':us_no', _user.us_no

            server.request tag, _.assign(
                    'fileInput': fileInput
                    'dataType': 'iframe json'
                , _callbackObj)


        ###
         * 비밀번호 변경.
         * @param  {String}   oldPasswd : 이전 비밀번호 입력.(optional)
         * @param  {String}   newPasswd : 새 비밀번호.
         * @param  {Function} callback 
         * @param  {Object}   options  
         * @return {ajax}
        ###
        updatePassword: (oldPasswd, newPasswd, callback, options) ->
            if oldPasswd
                oldPasswdObj = { 'passwd': oldPasswd }
                nonce = 'nonce': { 'isPasswdEdit': 1 }
            else 
                oldPasswdObj = {}
                nonce = {}

            options = {} if not options

            userObj = _.assign(
                'new_passwd': newPassWd
                , oldPasswdObj)

            tag = server.TAG.user.aUser.replace ':us_no', _user.us_no
            server.request tag, _.aasign(
                'type': 'PUT'
                'data': _.assign({'user': userObj}, nonce, options)
                , _callbackObj)


        ###
         * 회원탈퇴.
         * @param  {Function} callback
         * @return {ajax}            
        ###
        deleteUser: (callback) ->
            if not _user
                console.log 'deleteUser] user object is empty.'
                return

            tag = server.TAG.user.aUser.replace ':us_no', _user.us_no

            server.request tag, _.assign(
                    'type': 'DELETE'
                , _callbackObj)


        ###
         * login provider 삭제.
         * @param  {String}   sns      : 삭제할 sns 종류.
         * @param  {Function} callback 
         * @return {ajax}            
        ###
        deleteProvider: (sns, callback) ->
            tag = server.TAG.user.provider.replace(':us_no', _user.us_no).replace ':provider', sns
            server.request tag, _.assign(
                    'type': 'DELETE'
                , _callbackObj)


        ###
         * 프로필 이미지 삭제.
         * @param  {Function} callback 
         * @return {ajax}            
        ###
        deletePicture: (callback) ->
            tag = server.TAG.user.profile.replace ':us_no',_user.us_no
            server.request tag, _.assign(
                    'type': 'DELETE'
                , _callbackObj)


        ###
         * 인증 메일 발송.
         * @param  {Function} callback 
         * @return {ajax}            
        ###
        sendEmail: (callback) ->
            tag = server.TAG.user.emailPost
            server.request tag, _callbackObj


        ###
         * email 중복 및 유효성 검사.
         * @param  {String}   email    
         * @param  {Function} callback
         * @return {ajax}            
        ###
        validateEmail: (email, callback) ->
            # null check.
            if not callback or not email
                console.error 'validateEmail] email or callback is not defined.'
                return

            # 유효성 검사.
            if not email.match(/^(([a-zA-Z]|[0-9])|([-]|[_]|[.]))+[@](([a-zA-Z0-9])|([-])){2,63}[.](([a-zA-Z0-9]){2,63})+$/gi)
                callback 'ERROR', _ERROR_CODE.INVALID

            # 중복 여부 검사.
            xhr && xhr.abort()
            filter = 
                'filter':
                    'email': email

            xhr = @loadUser filter, 
                success: (res) =>
                    callback 'ERROR', _ERROR_CODE.DUPLICATED
                error: (er) =>
                    if er.code is 404
                        callback 'SUCCESS'
                    else
                        callback 'ERROR', _ERROR_CODE.UN_KNOWN
                complete: =>
                    xhr = null
