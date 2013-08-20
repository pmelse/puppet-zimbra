class zimbra::user {
  create_resources(zimbra_user, hiera_hash('zimbra_users', []))
}
