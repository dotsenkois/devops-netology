	local namespace = "prod";
	#frontend
	local frontend_name = "frontend";
	local frontend_replicas = 1;
	local frontend_image = "dotsenkois/kuber_frontend";
	local frontend_image_tag = "latest";

	local frontend_service_type = "NodePort";
	local frontend_service_port = 80;
	local frontend_service_targetPort = 80;

	#backend
	local backend_name = "backend";
	local backend_replicas = 1;
	local backend_image = "dotsenkois/kuber_backend";
	local backend_image_tag = "latest";

	local backend_service_type = "ClusterIP";
	local backend_service_port = 9000;
	local backend_service_targetPort = 9000;

	#database
	local db_name = "db";
	local db_replicas = 1;
	local db_image = "postgres";
	local db_image_tag = "13-alpine";

	local db_service_type = "ClusterIP";
	local db_service_port = 5432;
	local db_service_targetPort = 5432;


[
{
	"apiVersion": "v1",
	"kind": "Service",
	"metadata": {
		"namespace": namespace,
		"name": backend_name,
		"labels": {
			"helm.sh/chart": "chart-0.1.0",
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name",
			"app.kubernetes.io/version": "1.16.0",
			"app.kubernetes.io/managed-by": "Helm"
		}
	},
	"spec": {
		"type": backend_service_type,
		"ports": [
			{
				"port": backend_service_port,
				"targetPort": backend_service_targetPort,
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
		"name": frontend_name,
		"labels": {
			"helm.sh/chart": "chart-0.1.0",
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name",
			"app.kubernetes.io/version": "1.16.0",
			"app.kubernetes.io/managed-by": "Helm"
		}
	},
	"spec": {
		"type": frontend_service_type,
		"ports": [
			{
				"port": frontend_service_port,
				"targetPort": frontend_service_targetPort,
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
		"name": db_name,
		"labels": {
			"helm.sh/chart": "chart-0.1.0",
			"app.kubernetes.io/name": "chart",
			"app.kubernetes.io/instance": "release-name",
			"app.kubernetes.io/version": "1.16.0",
			"app.kubernetes.io/managed-by": "Helm"
		}
	},
	"spec": {
		"type": db_service_type,
		"ports": [
			{
				"port": db_service_port,
				"targetPort": db_service_targetPort,
				"protocol": "TCP",
				"name": db_name
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
		"name": backend_name,
		"labels": {
			"app": backend_name
		}
	},
	"spec": {
		"replicas": backend_replicas,
		"selector": {
			"matchLabels": {
				"app": backend_name
			}
		},
		"template": {
			"metadata": {
				"labels": {
					"app": backend_name
				}
			},
			"spec": {
				"containers": [
					{
						"name": backend_name,
						"image": backend_image + ":" + backend_image_tag,
						"ports": [
							{
								"containerPort": backend_service_port,
								"protocol": "TCP"
							}
						],
						"env": [
							{
								"name": "DATABASE_URL",
								"value": "postgres://postgres:postgres@" + db_name +":" + db_service_port + "/news"
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
		"name": frontend_name,
		"labels": {
			"app": frontend_name
		}
	},
	"spec": {
		"replicas": 1,
		"selector": {
			"matchLabels": {
				"app": frontend_name
			}
		},
		"template": {
			"metadata": {
				"labels": {
					"app": frontend_name
				}
			},
			"spec": {
				"containers": [
					{
						"name": frontend_name,
						"image": frontend_image,
						"ports": [
							{
								"containerPort": frontend_service_port,
								"protocol": "TCP"
							}
						],
						"env": [
							{
								"name": "BASE_URL",
								"value": "http://" + backend_name + ":" + backend_service_targetPort
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
		"name": db_name
	},
	"spec": {
		"selector": {
			"matchLabels": {
				"app": db_name
			}
		},
		"serviceName": db_name,
		"replicas": db_replicas,
		"template": {
			"metadata": {
				"labels": {
					"app": db_name
				}
			},
			"spec": {
				"terminationGracePeriodSeconds": 10,
				"containers": [
					{
						"name": db_name,
						"image": db_image + ":" + db_image_tag ,
						"ports": [
							{
								"containerPort": db_service_port
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