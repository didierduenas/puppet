#TEST ONLYFILE
 
#définir une classe "dokuwiki" pour les instruction liées à l'installation de dokuwiki
#définir un node pour server0
#utiliser la classe "dokuwiki"

class dokuwiki {
    package {
        'apache2':
            ensure => present
    }
    package {
        'php7.3':
            ensure => present
    }
    file {
        'download dokuwiki':
            path => '/usr/src/dokuwiki.tgz',
            ensure => present,
            source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz'
    }
    exec {
        'extract dokuwiki':
            command => 'tar xavf dokuwiki.tgz',
            cwd => '/usr/src',
            path => ['/usr/bin'],
            require => File['download dokuwiki'],
            unless => 'test -d /usr/src/dokuwiki-2020-07-29/'
    }
    file {
        'rename dokuwiki':
            path => '/usr/src/dokuwiki',
            ensure => present,
            source => '/usr/src/dokuwiki-2020-07-29',
            require => Exec['extract dokuwiki']
    }
    file {
        'delete extracted dokuwiki':
            path => '/usr/src/dokuwiki-2020-07-29',
            ensure => absent,
            require => File['rename dokuwiki']
    }
    #file {
    #    'delete archive':
    #        path => '/usr/src/dokuwiki.tgz',
    #        ensure => absent
    #}
}

node server0 {
    include dokuwiki
}

# file {
#     'create recettes.wiki directory':
#         ensure  => directory,
#         path    => '/var/www/recettes.wiki',
#         source  => '/usr/src/dokuwiki',
#         recurse => true,
#         owner   => 'www-data',
#         group   => 'www-data',
#         require => File['rename dokuwiki']
# }
# file {
#     'create politique.wiki directory':
#         ensure  => directory,
#         path    => '/var/www/politique.wiki',
#         source  => '/usr/src/dokuwiki',
#         recurse => true,
#         owner   => 'www-data',
#         group   => 'www-data',
#         require => File['rename dokuwiki']
# }