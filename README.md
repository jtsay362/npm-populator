NPM Module Populator

This Ruby project creates a Semantic Data Collection Changefile that contains
data about Node Packaged Modules.

To run:

  bundle install
  ruby populate.rb -d

should create the file npm_modules.json.bz2, which can be uploaded to
Solve for All as a Semantic Data Collection Changefile.

For more documentation on Semantic Data Collections see
https://solveforall.com/docs/developer/semantic_data_collection

Thanks to npmjs.org for providing this data!

