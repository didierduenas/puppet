#TEST 
 
#Déclarer deux nodes : server0 et server1
#faire en sorte que dokuwiki soit installé sur les deux nodes
#déployer politique.wiki uniquement sur node0
#déployer recettes.wiki uniquement sur node1
#essayer d'adapter ce que vous venez de faire en utilisant des variables https://puppet.com/docs/puppet/6/lang_variables.html

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
            unless => 'test -d /usr/src/dokuwiki-stable/'
    }
    file {
        'rename dokuwiki':
            path => '/usr/src/dokuwiki',
            ensure => present,
            source => '/usr/src/dokuwiki-stable',
            require => Exec['extract dokuwiki']
    }
    file {
        'delete extracted dokuwiki':
            path => '/usr/src/dokuwiki-stable',
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