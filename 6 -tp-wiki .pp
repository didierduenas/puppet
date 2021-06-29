#TEST 
 
# on décide d'ajouter un site "tajineworld.com" et de l'héberger sur server0 
# http://igm.univ-mlv.fr/~dr/XPOSE2010/puppet/puppetcommandes.html
# https://puppet.com/docs/puppet/6/lang_defined_types.html 

class dokuwiki {
    $source_path = '/usr/src'
    $binary_path = '/usr/bin'
    $web_path = '/var/www'

    package { 'apache2':
            ensure => present
    }

    package { 'php7.3':
            ensure => present
    }

#etape 3 téléchargement du dokuwiki.tgz

    file { 'download-dokuwiki':
            ensure => present,
            source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
            path   => "${source_path}/dokuwiki.tgz"
    }

#etape 4 extraire l'archive dokuwiki.tgz

    exec { 'extract-dokuwiki':
            command => 'tar xavf dokuwiki.tgz',
            cwd     => "${source_path}",
            path    => ["${binary_path}"],
            require => File['download-dokuwiki'],
            unless  => "test -d ${source_path}/dokuwiki-2020-07-29"
    }

    file { 'rename-dokuwiki-2020-07-29':
            ensure  => present,
            source  => "${source_path}/dokuwiki-2020-07-29",
            path    => "${source_path}/dokuwiki",
            require => Exec['extract-dokuwiki']
    }
}

    #etape 5 création des VM

##  Créer un dossier pour les données du site XXX

#class dokuwiki_deploy {
#   $source_path = '/usr/src'
#    $web_path = '/var/www'    
#
#    file { "create new directory for ${env}.wiki in ${web_path} and allow apache to write in":            
#            ensure  => directory,
#            source  => "${source_path}/dokuwiki",
#            path    => "${web_path}/${env}.wiki",
#            recurse => true,
#            owner   => 'www-data',
#            group   => 'www-data',
#            require => File['rename-dokuwiki-2020-07-29']
#    }
#}
$source_path = '/usr/src'
$web_path = '/var/www'

define deploy_dokuwiki ($env="") {
    file { "$env":
            ensure  => directory,
            source  => "${source_path}/dokuwiki",
            path    => "${web_path}/${env}",
            recurse => true,
            owner   => 'www-data',
            group   => 'www-data',
            require => File['rename-dokuwiki-2020-07-29']
    }
}

node 'server0' {
    #$env = 'recettes'
    include dokuwiki
    #include dokuwiki_deploy
    
    deploy_dokuwiki { "recettes.wiki":
        env => "recettes.wiki",
    }

    deploy_dokuwiki { "tajineworld.com":
        env => "tajineworld.com",
    }
}

node 'server1' {
    #$env = 'politique'
    include dokuwiki
    #include dokuwiki_deploy
    deploy_dokuwiki { "politique.wiki":
        env => "politique.wiki",
    }
}