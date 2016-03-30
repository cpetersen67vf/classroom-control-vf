define users::managed_user ( $home = "/home/${title}", $group, $shell = '/bin/bash', $authkey = undef, ) {
    
    File {
        owner => $title,
        group => $group,
        mode => '0700',
    }
    user { $title:
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
        ssh_authorized_key { "${title} default key":
            user => $title,
            type => 'ssh-rsa',
            key => $authkey,
        }
    }
}
