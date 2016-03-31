class nginx::params {

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
            $docRoot   = '/var/www'
        }
        'Debian' : {
            $fileOwner = 'root'
            $fileGroup = 'root'
            $fileMode  = '0644'
            $pkgName   = 'nginx'
            $cfgDir    = '/etc/nginx'
            $docRoot   = '/var/www'
        }
        'Windows' : {
            $fileOwner = 'Administrator'
            $fileGroup = 'Administrators'
            $fileMode  = undef
            $pkgName   = 'nginx-service'
            $cfgDir    = 'C:/ProgramData/nginx'
            $docRoot   = "${cfgDir}/html"
        }
        default : {
            fail { "Unsupported OS family \"${::osfamily}\" for nginx module.": }
        }
    }
    
    #  The server block dir is always based on the config dir in our examples.  If not, move it into the case.
    $blockDir  = "${cfgDir}/conf.d"
}
