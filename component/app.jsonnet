local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.splunk_forwarder;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('splunk-forwarder', params.namespace);

{
  'splunk-forwarder': app,
}
