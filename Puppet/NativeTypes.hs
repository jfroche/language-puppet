module Puppet.NativeTypes where

import Puppet.NativeTypes.Helpers
--import Puppet.Interpreter.Types.Files (typefile)
import qualified Data.Map as Map

fakeTypes = map faketype ["class", "ssh_authorized_key_secure"]

defaultTypes = map defaulttype ["augeas","computer","cron","exec","file","filebucket","group","host","interface","k5login","macauthorization","mailalias","maillist","mcx","mount","nagios_command","nagios_contact","nagios_contactgroup","nagios_host","nagios_hostdependency","nagios_hostescalation","nagios_hostextinfo","nagios_hostgroup","nagios_service","nagios_servicedependency","nagios_serviceescalation","nagios_serviceextinfo","nagios_servicegroup","nagios_timeperiod","notify","package","resources","router","schedule","scheduledtask","selboolean","selmodule","service","sshauthorizedkey","sshkey","stage","tidy","user","vlan","yumrepo","zfs","zone","zpool"]

nativeTypes :: Map.Map PuppetTypeName (PuppetTypeValidate)
nativeTypes = Map.fromList (fakeTypes ++ defaultTypes)
