package {
'apache2':
  ensure   => present,
  name     => 'apache2',
  provider => apt
}

package {
'php7.3':
  ensure   => present
}

file {
'get Dokuwiki':
  ensure => present,
  path   => '/usr/src/dokuwiki.tgz',
  source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
}

exec {
'dezip dokuwiki':
  command => 'tar xavf dokuwiki.tgz',
  path    => ['/usr/bin'],
  cwd     => '/usr/src'
}

file {
'mv dokuwiki':
  ensure => present,
  path   => '/usr/src/dokuwiki',
  source => '/usr/src/dokuwiki-2020-07-29',
}

file {
'create directory for recettes.wiki':
  ensure => directory,
  path   => '/var/www/recettes.wiki'
}

file {
'create directory for politique.wiki':
  ensure => directory,
  path   => '/var/www/politique.wiki'
}

file {
'copy dokuwiki for recettes':
  ensure => present,
  path   => '/var/www/recettes.wiki',
  source => '/usr/src/dokuwiki'
}

file {
'copy dokuwiki for politique':
  ensure => present,
  path   => '/var/www/politique.wiki',
  source => '/usr/src/dokuwiki'
}