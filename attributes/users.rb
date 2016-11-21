# Wildfly user configuration
# Access Control Provider (acp)
default['wildfly']['acp']='simple'

# mgmt users
default['wildfly']['users']['mgmt'] = [
  { id: 'wildfly', passhash: '2c6368f4996288fcc621c5355d3e39b7' }
]

# app users
default['wildfly']['users']['app'] = [
  { id: 'wildfly', passhash: '2c6368f4996288fcc621c5355d3e39b7' }
]

# application roles
default['wildfly']['roles']['app'] = [
  { id: 'wildfly', roles: 'role1,role2' }
]
