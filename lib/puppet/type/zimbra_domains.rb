Puppet::Type.newtype(:zimbra_domains) do

    desc "Type to manage Zimbra domains"

    ensurable

    newparam(:domains, :namevar => true) do
        desc "Zimbra domain id"
    end
end
