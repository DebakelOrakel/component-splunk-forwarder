// main template for nfs-subdir-external-provisioner
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.splunk_forwarder;

local issuer() = {
    apiVersion: 'cert-manager.io/v1',
    kind: 'Issuer',
    metadata:{
        labels: {
            'app.kubernetes.io/name': 'splunk-forwarder-selfsign',
            'name': 'splunk-forwarder-selfsign',
        },
        name: 'splunk-forwarder-selfsign',
        namespace: params.namespace,
    },
    spec: {
        selfSigned: {},
    },
};

local ca_cert() = {
    apiVersion: 'cert-manager.io/v1',
    kind: 'Certificate',
    metadata:{
        labels: {
            'app.kubernetes.io/name': 'splunk-forwarder-ca',
            'name': 'splunk-forwarder-ca',
        },
        name: 'splunk-forwarder-ca',
        namespace: params.namespace,
    },
    spec:{
        commonName: 'ca.splunk-forwarder',
        duration: '87600h0m0s',
        isCA: true,
        issuerRef: {
            name: 'splunk-forwarder-selfsign',
        },
        secretName: 'splunk-forwarder-ca',
        usages: [
            'digital signature',
            'key encipherment',
            'cert sign',
        ],
    },
};

// Define outputs below
{
  '00_namespace': kube.Namespace(params.namespace),
  '01_issuer': issuer(),
  '02_ca_cert': ca_cert(),
}
