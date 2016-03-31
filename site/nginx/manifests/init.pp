class nginx ( $fileOwner = $nginx::params::fileOwner,
              $fileGroup = $nginx::params::fileGroup,
              $fileMode  = $nginx::params::fileMode,
              $pkgName   = $nginx::params::pkgName,
              $cfgDir    = $nginx::params::cfgDir,
              $docRoot   = $nginx::params::docRoot,
              $svcName   = $nginx::params::svcName,
              $blockDir  = $nginx::params::blockDir
            ) inherits nginx::params {

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
