class nginx {

    $svcName = 'nginx'
    if $::osfamily == 'RedHat' {
        $fileOwner = 'root'
        $fileGroup = 'root'
        $fileMode  = '0644'
        $pkgName   = 'nginx'
        $cfgDir    = '/etc/nginx'
        $docRoot   = '/var/www'
    }
    elsif $::osfamily == 'Debian' {
        $fileOwner = 'root'
        $fileGroup = 'root'
        $fileMode  = '0644'
        $pkgName   = 'nginx'
        $cfgDir    = '/etc/nginx'
        $docRoot   = '/var/www'
    }
    elsif $::osfamily == 'Windows' {
        $fileOwner = 'Administrator'
        $fileGroup = 'Administrators'
        $fileMode  = undef
        $pkgName   = 'nginx-service'
        $cfgDir    = 'C:/ProgramData/nginx'
        $docRoot   = "${cfgDir}/html"
    }
    $blockDir  = "${cfgDir}/conf.d"
    
    File {
        ensure => file,
        owner => $fileOwner,
        group => $fileGroup,
        mode => $fileMode,
    }
    
    package { $pkgName:
        ensure => present,
    }
    
    file { "${cfgDir}/nginx.conf":
        content => template('nginx/nginx.conf.erb'),
        require => Package[$pkgName],
    }
    
    file { "${blockDir}/default.conf":
        content => template('nginx/default.conf.erb'),
        require => Package[$pkgName],
    }
    
    file { $docRoot:
        ensure => directory,
        require => Package[$pkgName],
    }
    
    file { "${docRoot}/index.html":
        require => File[$docRoot],
        source => 'puppet:///modules/nginx/index.html',
    }
    
    service { $svcName:
        ensure => running,
        enable => true,
        subscribe => [ File["${docRoot}/index.html"], File["${cfgDir}/nginx.conf"], File["${blockDir}/default.conf"] ],
    }
}
