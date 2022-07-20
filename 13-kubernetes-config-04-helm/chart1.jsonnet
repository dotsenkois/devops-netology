local namespace = "prod";

local frontend = {
    name: "frontend",
    replicas: 1,
    image: "dotsenkois/kuber_frontend",
    image_tag: "latest",
    service: {
        type: "NodePort",
        port: 80,
        targetPort: 80
    }
};

local backend = {
    name: "backend",
    replicas: 1,
    image: "dotsenkois/kuber_backend",
    image_tag: "latest",
    service: {
        type: "ClusterIP",
        port: 9000,
        targetPort: 9000
    }
};

local db = {
    name: "db",
    replicas: 1,
    image: "postgres",
    image_tag: "13-alpine",
    service: {
        type: "ClusterIP",
        port: 5432,
        targetPort: 5432
    }
};

[
{
	"apiVersion": "v1",
	"kind": "Service",
	"metadata": {
		"namespace": namespace,
		"name": backend.name,
		"labels": {
			"helm.sh/chart": "chart-0.1.0",
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name",
			"app.kubernetes.io/version": "1.16.0",
			"app.kubernetes.io/managed-by": "Helm"
		}
	},
	"spec": {
		"type": backend.service.type,
		"ports": [
			{
				"port": backend.service.port,
				"targetPort": backend.service.targetPort,
				"protocol": "TCP"
			}
		],
		"selector": {
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name"
		}
	}
},

{
	"apiVersion": "v1",
	"kind": "Service",
	"metadata": {
		"namespace": namespace,
		"name": frontend.name,
		"labels": {
			"helm.sh/chart": "chart-0.1.0",
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name",
			"app.kubernetes.io/version": "1.16.0",
			"app.kubernetes.io/managed-by": "Helm"
		}
	},
	"spec": {
		"type": frontend.service.type,
		"ports": [
			{
				"port": frontend.service.port,
				"targetPort": frontend.service.targetPort,
				"protocol": "TCP",
				"name": "http"
			}
		],
		"selector": {
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name"
		}
	}
},

{
	"apiVersion": "v1",
	"kind": "Service",
	"metadata": {
		"namespace": namespace,
		"name": db.name,
		"labels": {
			"helm.sh/chart": "chart-0.1.0",
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name",
			"app.kubernetes.io/version": "1.16.0",
			"app.kubernetes.io/managed-by": "Helm"
		}
	},
	"spec": {
		"type": db.service.type,
		"ports": [
			{
				"port": db.service.port,
				"targetPort": db.service.targetPort,
				"protocol": "TCP",
				"name": db.name
			}
		],
		"selector": {
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name"
		}
	}
},

{
	"apiVersion": "apps/v1",
	"kind": "Deployment",
	"metadata": {
		"namespace": namespace,
		"name": backend.name,
		"labels": {
			"app": backend.name
		}
	},
	"spec": {
		"replicas": backend.replicas,
		"selector": {
			"matchLabels": {
				"app": backend.name
			}
		},
		"template": {
			"metadata": {
				"labels": {
					"app": backend.name
				}
			},
			"spec": {
				"containers": [
					{
						"name": backend.name,
						"image": backend.image + ":" + backend.image_tag,
						"ports": [
							{
								"containerPort": backend.service.port,
								"protocol": "TCP"
							}
						],
						"env": [
							{
								"name": "DATABASE_URL",
								"value": "postgres://postgres:postgres@" + db.name +":" + db.service.port + "/news"
							}
						]
					}
				]
			}
		}
	}
},

{
	"apiVersion": "apps/v1",
	"kind": "Deployment",
	"metadata": {
		"namespace": namespace,
		"name": frontend.name,
		"labels": {
			"app": frontend.name
		}
	},
	"spec": {
		"replicas": 1,
		"selector": {
			"matchLabels": {
				"app": frontend.name
			}
		},
		"template": {
			"metadata": {
				"labels": {
					"app": frontend.name
				}
			},
			"spec": {
				"containers": [
					{
						"name": frontend.name,
						"image": frontend.image,
						"ports": [
							{
								"containerPort": frontend.service.port,
								"protocol": "TCP"
							}
						],
						"env": [
							{
								"name": "BASE_URL",
								"value": "http://" + backend.name + ":" + backend.service.targetPort
							}
						]
					}
				]
			}
		}
	}
},

{
	"apiVersion": "apps/v1",
	"kind": "StatefulSet",
	"metadata": {
		"namespace": namespace,
		"name": db.name
	},
	"spec": {
		"selector": {
			"matchLabels": {
				"app": db.name
			}
		},
		"serviceName": db.name,
		"replicas": db.replicas,
		"template": {
			"metadata": {
				"labels": {
					"app": db.name
				}
			},
			"spec": {
				"terminationGracePeriodSeconds": 10,
				"containers": [
					{
						"name": db.name,
						"image": db.image + ":" + db.image_tag ,
						"ports": [
							{
								"containerPort": db.service.port
							}
						],
						"env": [
							{
								"name": "POSTGRES_PASSWORD",
								"value": "postgres"
							},
							{
								"name": "POSTGRES_USER",
								"value": "postgres"
							},
							{
								"name": "POSTGRES_DB",
								"value": "news"
							}
						]
					}
				]
			}
		}
	}
}

]