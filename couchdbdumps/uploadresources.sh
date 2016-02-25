for f in ./testresources/*.json; do
  cat ./testresources/start $f ./testresources/end | curl --trace - -X POST -d @- http://admin:password@learningregistry/publish --header "Content-Type:application/json" 
done
