export default {
  apiVersion: 'k8s.cni.cncf.io/v1',
  kind: 'NetworkAttachmentDefinition',
  metadata: {
    name: 'bridge-network',
    namespace: 'default',
    annotations: {
      'k8s.v1.cni.cncf.io/resourceName': 'bridge.network.kubevirt.io/br0',
    },
  },
  spec: {
    config:
      '{\n    "cniVersion": "0.3.1",\n    "name": "br0-l2",\n    "plugins": [{\n        "type": "bridge",\n        "bridge": "br0",\n        "ipam": {}\n    }]\n}\n',
  },
};
