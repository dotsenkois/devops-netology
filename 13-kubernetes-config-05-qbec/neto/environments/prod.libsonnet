local production = import './stage.libsonnet';

production {
  components +: {
    backend +: {
      replicas: 3,
    },
    frontend +: {
      replicas: 3,
    },
    db +: {
      replicas: 3,
    },
    endpoint: {
      address: "51.250.45.77"
    }
  }
}