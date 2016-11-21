class zimbra::domain {
  notify { "hiera_hash('zimbra_domains')":
    withpath => true }
  create_resources(zimbra_domains, hiera_hash('zimbra_domains', []))
}
