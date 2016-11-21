# My wildfly configuration
default['wildfly']['version']='10.1.0'
default['wildfly']['download_url']='http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz'
default['wildfly']['checksum_file']='wildfly_checksum.txt'

# wildfly home directory
default['wildfly']['home']='/opt/wildfly'

# wildfly user and group
default['wildfly']['user']='wildfly'
default['wildfly']['group']='wildfly'

# wildfly service
default['wildfly']['service']='wildfly'

default['wildfly']['enforce_config'] = false

# wildfly mode
default['wildfly']['mode']='standalone'
default['wildfly']['sa']['conf'] = 'standalone-full.xml'

# port binding offset
default['wildfly']['int']['port_binding_offset'] = '0'

# interface settings
default['wildfly']['int']['mgmt']['bind']='0.0.0.0'
default['wildfly']['int']['mgmt']['http_port']='9990'
default['wildfly']['int']['mgmt']['https_port']='9993'
default['wildfly']['int']['pub']['bind']='0.0.0.0'
default['wildfly']['int']['pub']['http_port']='8080'
default['wildfly']['int']['pub']['https_port']='8443'
default['wildfly']['int']['wsdl']['bind']='0.0.0.0'
default['wildfly']['int']['ajp']['port']='8009'

# wait times
default['wildfly']['initd']['startup_wait']='30'
default['wildfly']['initd']['shutdown_wait']='30'

# Console log settings
default['wildfly']['log']['console_log']='/var/log/wildfly/console.log'
