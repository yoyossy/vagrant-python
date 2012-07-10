Exec{path=>"/usr/bin:/usr/sbin"}
stage { "update": before => Stage["pre"] }
stage { "pre": before => Stage["main"] }

class aptupdate {
      group { "puppet": ensure => "present"; }
      exec { "/usr/bin/apt-get update":}
}

class python {
    package {
        "build-essential": ensure => latest;
        "python": ensure => "2.6.5-0ubuntu1";
        "python-dev": ensure => "2.6.5-0ubuntu1";
        "python-setuptools": ensure => installed;
       "libreadline5-dev": ensure => present;
	  "libssl-dev": ensure => present;
	  "python-openssl": ensure => installed;
	  "sqlite3": ensure => present;
        "postgresql": ensure => present;
        "libpq-dev": ensure => present;
          "pgadmin3": ensure => present;

	   "libsqlite3-dev": ensure => present;
    }
    exec { "easy_install pip":
        path => "/usr/local/bin:/usr/bin:/bin",
        refreshonly => true,
        require => Package["python-setuptools"],
        subscribe => Package["python-setuptools"],
    }
}

class pildeps {
  package { 
  "libbz2-dev": ensure => present;
  "zlib1g-dev": ensure => present;
  "libfreetype6-dev": ensure => present;
  "libjpeg62-dev": ensure => present;
  "liblcms1-dev": ensure => present;
  }
}
class python-openerp {
  package { 
  "python-lxml": ensure => installed;
  "python-mako": ensure => installed;
  "python-dateutil": ensure => installed;
  "python-psycopg2": ensure => installed;
  "python-pychart": ensure => installed;
  "python-pydot": ensure => installed;
  "python-tz": ensure => installed;
  "python-reportlab": ensure => installed;
  "python-yaml": ensure => installed;
  "python-vobject": ensure => installed;
  "python-gtk2": ensure => installed; 
  "python-glade2": ensure => installed; 
       "python-matplotlib": ensure => installed; 
     "python-egenix-mxdatetime": ensure => installed; 
  "python-pybabel": ensure => installed;
   "python-pyparsing": ensure => installed;
   "python-cherrypy": ensure => installed;
    "python-formencode": ensure => installed;
    "python-simplejson": ensure => installed;
    "python-feedparser": ensure => installed;
    "python-gdata": ensure => installed;
    "python-ldap": ensure => installed;
    "python-libxslt1": ensure => installed;
     "python-openid": ensure => installed;
      "python-vatnumber": ensure => installed;
     "python-webdav": ensure => installed;
      "python-werkzeug": ensure => installed;
        "python-xlwt": ensure => installed;
          "python-zsi": ensure => installed;      
  
     }
}
class vcs {
  package { "git-core":    ensure => present,
  }

}
class checkoutbuildout {
  subversion::working-copy {
    "buildout":
      path => "/opt/python",
      branch => "bda-naked-python/",
      owner => "root",
      group => "root",
      repo_base => "svn.plone.org/svn/collective",
      require => Package["python-setuptools"];
  }
}

class buildpythons {
  include checkoutbuildout
  exec { "/usr/bin/python2.6 /opt/python/bootstrap.py --distribute  && /opt/python/bin/buildout -c all.cfg":
      user => "root",
      cwd => "/opt/python",
      path => "/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin",
      timeout => 7200,
      require => [Class["checkoutbuildout"],Class["python"],Class["pildeps"]],
      creates => "/opt/python/bin/buildout",
      logoutput => on_failure,
  }
#  exec { "/usr/bin/python2.6 /vagrant/kalymero-OpenERP-Buildout-56b09d7/bootstrap.py --distribute  && /vagrant/kalymero-OpenERP-Buildout-56b09d7/bin/buildout -c buildout.cfg":
#      user => "root",
#      path => "/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin",
#      timeout => 7200,
#      require => [Class["python"],Class["pildeps"]],
#      creates => "/vagrant/kalymero-OpenERP-Buildout-56b09d7/bin/buildout",
#      logoutput => on_failure,
#  }



}
class { "aptupdate": stage => "update"}
class { "python": stage => "pre" }
class { "pildeps": stage => "pre" }
class { "vcs": stage => "pre" }

class lucid32 {
  include aptupdate
  include python
  include pildeps
  include vcs
  include buildpythons
  include python-openerp 

}

include lucid32
