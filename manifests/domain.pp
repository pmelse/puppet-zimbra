class zimbra::domain {
  create_resources(zimbra_domains, hiera_hash('zimbra_domains', []))
}
