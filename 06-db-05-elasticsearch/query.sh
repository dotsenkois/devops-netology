curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}'
curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 2,  
      "number_of_replicas": 1 
    }
  }
}'



curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 4,  
      "number_of_replicas": 2 
    }
  }
}'


curl -X GET "localhost:9200/_cat/indices?v&pretty"
curl -X GET "localhost:9200/_cluster/health?pretty"

curl -X DELETE "localhost:9200/ind-1?pretty"
curl -X DELETE "localhost:9200/ind-2?pretty"
curl -X DELETE "localhost:9200/ind-3?pretty"

curl -X PUT "localhost:9200/_snapshot/elastic_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/var/lib/elasticsearch/snapsots"
  }
}
'
curl -X POST "localhost:9200/_snapshot/elastic_backup/_verify?pretty"


curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}'

curl -X DELETE "localhost:9200/test-2?pretty"

curl -X PUT "localhost:9200/_snapshot/elastic_backup/test?pretty"

curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}'


curl -X DELETE "localhost:9200/test?pretty"

curl -X GET "localhost:9200/_snapshot/elastic_backup/*?verbose=false&pretty"

curl -X POST 'localhost:9200/_snapshot/elastic_backup/test/_restore?pretty' -H 'Content-Type: application/json' -d'{"include_global_state":true}'

curl -XDELETE https://localhost:9200/api/v1/platform/configuration/snapshots/repositories/my_repository \
-H "Authorization: ApiKey $ECE_API_KEY"

# Delete an index
curl -X DELETE "localhost:9200/test?pretty"
# Delete a data stream
curl -X DELETE "localhost:9200/_data_stream/logs-my_app-default?pretty"

curl -X POST 'localhost:9200/test/_close'

curl -X POST 'localhost:9200/_snapshot/elastic_backup/test/_restore?pretty' -H 'Content-Type: application/json' -d'
{
  "indices": "test",
  "ignore_unavailable": true,
  "include_global_state": false,              
  "rename_pattern": "(.+)",
  "rename_replacement": "$1_restored",
  "include_aliases": false
}'
