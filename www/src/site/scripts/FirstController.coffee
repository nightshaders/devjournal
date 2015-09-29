angular.module("App")
.controller("FirstController", ($scope, Login, GetUsers, CreateUser) ->
  $scope.first = new class FirstController
    constructor: (Login) ->
      @data = {
        name:"Bruce Wayne"
        id:"Batman"
      }
      @users = []

    submit: ->
      Login.submit()

    getUsers: ->
      GetUsers.submit((res) =>
        @users = res
        $scope.$digest()
      )

    createUser: ->
      CreateUser.submit({
        id : "1"
        username : "Clark Kent"
        password : "Superman"
      })
)
.service("CreateUser", ($http) ->
  submit: (user) ->
    $http.post("http://localhost:9100/user", user)
    .success((res) ->
      console.log('success', res)
    )
    .error((err) ->
      console.log('error', err)
    )

)
.service("GetUsers", ($http) ->
  submit: (cb) ->
    $http.get("http://localhost:9100/users")
      .success((res) ->
        console.log('success', res)
      )
      .error((err) ->
        console.log('error', err)
      )
)
.service("Login", ($http) ->
  submit = (cb) ->
      $http.get("http://localhost:9100/hello/bub")
      .success((res) ->
        console.log('success', res)
      )
      .error((err) ->
        console.log('error', err)
      )


  { submit }
)