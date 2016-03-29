class nginx {
    package { 'nginx':
        ensure => present,
    }
    
    file { '/etc/nginx/nginx.conf':
        ensure => present,
        source => 'puppet:///modules/nginx/nginx.conf',
        require => Package['nginx'],
    }
    
    file { '/etc/nginx/conf.d/default.conf':
        ensure => present,
        source => 'puppet:///modules/nginx/default.conf',
        require => Package['nginx'],
    }
    
    file { '/var/www':
        ensure => directory,
        require => Package['nginx'],
    }
    
    file { '/var/www/index.html':
        ensure => present,
        require => File['/var/www'],
        source => 'puppet:///modules/nginx/index.html',
    }
    
    service { 'nginx':
        ensure => running,
        enable => true,
        subscribe => [ File['/var/www/index.html'], File['/etc/nginx/nginx.conf'], File['/etc/nginx/conf.d/default.conf'] ],
    }
}
