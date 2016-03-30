define users::managed_user ( $home = "/home/${title}", $group, $shell = '/bin/bash', $authkey, ) {
    
    $name = $title
    
    File {
        owner => $name,
        group => $group,
        mode => '0700',
    }
    user { $name:
        ensure => present,
        gid => $group,
        home => $home,
        shell => $shell,
    }
    file { $home:
        ensure => directory,
    }
    file { "${home}/.ssh":
        ensure => directory,
    }
    if $authkey {
        ssh_authorized_key { "${name} default key":
            user => $name,
            type => 'ssh-rsa',
            key => $authkey,
        }
    }
}
