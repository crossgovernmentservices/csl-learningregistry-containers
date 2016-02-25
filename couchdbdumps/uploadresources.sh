for f in ./testresources/*.json; do
  cat ./testresources/start $f ./testresources/end | curl --trace - -X POST -d @- http://admin:password@192.168.99.100:8002/publish --header "Content-Type:application/json" 
done
