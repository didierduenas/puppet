#TEST3 

package { 'apache2':
  ensure   => present,
  name     => 'apache2',
  provider => apt
}

#PHP 

package { 'php7.3':
  ensure   => present,
  name     => 'php7.3',
  provider => apt
}

#ETAPE 3 TELECHARGEMENT DU DOKUWIKI.TGZ

file { 'download-dokuwiki':
  ensure => present,
  source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
  path   => '/usr/src/dokuwiki.tgz'
}

#ETAPE 4 EXTRACTION DE L'ARCHIVE DOKUWIKI.TGZ

exec { 'extract-dokuwiki':
  command => 'tar xavf dokuwiki.tgz',
  cwd     => '/usr/src',
  path    => ['/usr/bin'],
  require => file['download-dokuwiki'],
  require  => file['rename-dokuwiki-2020-07-29']
}

file { 'rename-dokuwiki-2020-07-29':
  ensure => present,
  source => '/usr/src/dokuwiki-2020-07-29',
  path   => '/usr/src/dokuwiki'
}

file { 'create new directory for recettes.wiki in /var/www and allow apache to write in':
  ensure  => directory,
  path    => '/var/www/recettes.wiki',
  recurse => true,
  owner   => 'www-data',
  group   => 'www-data',
  require  => file['Copy-dokuwiki-directory-contents-in-recettes-wiki']
}

file { 'create new directory for politique.wiki in /var/www and allow apache to write in':
  ensure  => directory,
  path    => '/var/www/politique.wiki',
  recurse => true,
  owner   => 'www-data',
  group   => 'www-data',
  require  => file['Copy-dokuwiki-directory-contents-in-politique-wiki']
}

file { 'Copy-dokuwiki-directory-contents-in-recettes-wiki':
  ensure => present,
  source => '/usr/src/dokuwiki',
  path   => '/var/www/recettes.wiki'
}

file { 'Copy-dokuwiki-directory-contents-in-politique-wiki':
  ensure => present,
  source => '/usr/src/dokuwiki',
  path   => '/var/www/politique.wiki'
}