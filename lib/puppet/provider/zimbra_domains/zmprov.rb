Puppet::Type.type(:zimbra_domains).provide(:zmprov) do

    desc "Manages mailing lists for Zimbra Collaboration Suite"

    confine :operatingsystem => [:Ubuntu,:Debian]
    confine :true => begin
        File.exists?('/opt/zimbra/bin/zmprov') && File.exists?('/opt/zimbra/bin/ldapsearch')
    end
    defaultfor :operatingsystem => [:Ubuntu]

    commands :zmprov => '/opt/zimbra/bin/zmprov',
             :zmmailbox => '/opt/zimbra/bin/zmmailbox',
             :ldapsearch => '/opt/zimbra/bin/ldapsearch',
             :zmlocalconfig => '/opt/zimbra/bin/zmlocalconfig'


    mk_resource_methods

    require 'socket' 
    
    def self.instances
        host_name=Socket.gethostbyname(Socket.gethostname.to_s)[0]
        # Getting ldap password
        ldap_pass = zmlocalconfig('-s','zimbra_ldap_password').gsub('zimbra_ldap_password = ','').chomp("\n")

        # Configuring ldap filter for users
        lfilter = 'objectClass=zimbraDomain'

        # here we get all users
        raw = ldapsearch('-LLL','-H',"ldap://#{host_name}:389",'-D','uid=zimbra,cn=admins,cn=zimbra','-x','-w',ldap_pass,lfilter)

        raw_lists=raw.split("\n\n")
        raw_lists.compact.map  { |i| 
            # getting uid
            name = i.grep(/zimbraDomainName: /)[0].gsub('zimbraDomainName: ','').chomp

            new(:name => name, 
                :ensure => :present)
        }
    end

    def self.prefetch(resources)
        lists = instances
        resources.keys.each do |name|
            if provider = lists.find{ |usr| usr.name == name }
                resources[name].provider = provider
            end
        end
    end

    def exists?
        @property_hash[:ensure] == :present
    end

    def create
        # Create list
#        options = Array.new
#        (options << 'displayName' << resource[:display_name]) if resource[:display_name]

        zmprov('cd',resource[:name])
    end

    def destroy
        zmprov('dd',resource[:name])
    end

end
