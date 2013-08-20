class zimbra::list {
  create_resources(zimbra_list, hiera_hash('zimbra_lists', []))
}
