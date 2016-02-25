curl -X PUT http://admin:password@couchdb:5984/incoming && ./couchdb-backup.sh -r -H couchdb -d incoming -f incoming -u admin -p password
curl -X PUT http://admin:password@couchdb:5984/node && ./couchdb-backup.sh -r -H couchdb -d node -f node -u admin -p password
curl -X PUT http://admin:password@couchdb:5984/network && ./couchdb-backup.sh -r -H couchdb -d network -f network -u admin -p password
curl -X PUT http://admin:password@couchdb:5984/community && ./couchdb-backup.sh -r -H couchdb -d community -f community -u admin -p password
curl -X PUT http://admin:password@couchdb:5984/resource_data && ./couchdb-backup.sh -r -H couchdb -d resource_data -f resource_data -u admin -p password
curl -X PUT http://admin:password@couchdb:5984/apps && ./couchdb-backup.sh -r -H couchdb -d apps -f apps -u admin -p password
