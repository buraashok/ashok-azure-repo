param location string = resourceGroup().location
param sqlDatabaseName string
param sqlAdministratorLogin string
param sqlAdministratorLoginPassword string

resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: '${sqlDatabaseName}server'
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  properties: {
    edition: 'S0'
    requestedServiceObjectiveName: 'S0'
  }
}

resource sqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2021-05-01-preview' = {
  parent: sqlServer
  name: 'CurrentIP'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}
