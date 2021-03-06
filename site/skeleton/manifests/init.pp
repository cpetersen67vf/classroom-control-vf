class skeleton {
    file { '/etc/skel':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => '0644',
    }
    file { '/etc/skel/.bashrc':
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '0755',
        source => 'puppet:///modules/skeleton/bashrc',
    }
}
