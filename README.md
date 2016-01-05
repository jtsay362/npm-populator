# NPM Module Populator

This Ruby project creates a Semantic Data Collection Changefile that contains
data about Node Packaged Modules.

## Usage

To run:

  bundle install
  
  ruby populate.rb -d

should create the file npm_modules.json.bz2, which can be uploaded to
Solve for All as a Semantic Data Collection Changefile.

See the [documentation on Semantic Data Collections](https://solveforall.com/docs/developer/semantic_data_collection) 
for more information.

Thanks to npmjs.org for providing this data!

## License

This project is licensed with the Apache License, Version 2.0. See LICENSE.
