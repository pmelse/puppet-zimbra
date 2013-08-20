#Adding some dependenties to be sure that the domain is created before de mailbox.
class zimbra (
  $zimbra_param = $zimbra::params::param,
) inherits zimbra::params {

  #Adding some dependenties to be sure that the domain is created before de mailbox.

  class { 'zimbra::domain': } ->
  class { 'zimbra::user': } ->
  class { 'zimbra::list': } ->
  Class [ 'zimbra' ]
}
