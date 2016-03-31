class nginx ( $root ) {

    #  Service name is always the same for our examples.  If it can change, move it into the case.
    $svcName = 'nginx'
    
    #  Case to set the variables we care about in Puppet code.  Some ERB-only stuff is left in the ERB for now.
    case $::osfamily {
        'RedHat' : {
            $fileOwner = 'root'
            $fileGroup = 'root'
            $fileMode  = '0644'
            $pkgName   = 'nginx'
            $cfgDir    = '/etc/nginx'
            $docRoot   = pick ($root, '/var/www')
        }
        'Debian' : {
            $fileOwner = 'root'
            $fileGroup = 'root'
            $fileMode  = '0644'
            $pkgName   = 'nginx'
            $cfgDir    = '/etc/nginx'
            $docRoot   = pick ($root, '/var/www')
        }
        'Windows' : {
            $fileOwner = 'Administrator'
            $fileGroup = 'Administrators'
            $fileMode  = undef
            $pkgName   = 'nginx-service'
            $cfgDir    = 'C:/ProgramData/nginx'
            $docRoot   = pick ($root, "${cfgDir}/html")
        }
        default : {
            fail { "Unsupported OS family \"${::osfamily}\" for nginx module.": }
        }
    }
    
    #  The server block dir is always based on the config dir in our examples.  If not, move it into the case.
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
