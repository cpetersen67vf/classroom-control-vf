class users::admins {

    users::managed_user { 'jose':
        group => 'users',
    }
    
    users::managed_user { 'alice':
        group => 'users',
    }
    
    users::managed_user { 'chen':
        group => 'users',
    }

}
