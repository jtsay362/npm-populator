require 'json'
require 'uri'
require 'net/http'
require 'fileutils'

NPM_PACKAGES_URL = 'https://registry.npmjs.org/-/all'
DOWNLOAD_DIR = './downloaded'
DOWNLOAD_FILENAME = "#{DOWNLOAD_DIR}/all.json"

class NpmPackagePopulator
  def initialize(output_path)
    @output_path = output_path
  end

  def download
    puts "Starting download ..."

    FileUtils.mkpath(DOWNLOAD_DIR)
    uri = URI.parse(NPM_PACKAGES_URL)
    response = Net::HTTP.get_response(uri)
    File.write(DOWNLOAD_FILENAME, response.body)

    puts "Done downloading!"
  end

  def populate
    File.open(@output_path, 'w:UTF-8') do |out|
      out.write <<-eos
{
  "metadata" : {
    "settings" : {
      "analysis": {
        "char_filter" : {
          "no_special" : {
            "type" : "mapping",
            "mappings" : ["-=>", "_=>", ".=>"]
          }
        },
        "analyzer" : {
          "lower_whitespace" : {
            "type" : "custom",
            "tokenizer": "whitespace",
            "filter" : ["lowercase"],
            "char_filter" : ["no_special"]
          }
        }
      }
    },
    "mapping" : {
      "_all" : {
        "enabled" : false
      },
      "properties" : {
        "name" : {
          "type" : "string",
          "analyzer" : "lower_whitespace"
        },
        "description" : {
          "type" : "string",
          "analyzer" : "english"
        },
        "author" : {
          "type" : "object",
          "enabled" : false
        },
        "contributors" : {
          "type" : "object",
          "enabled" : false
        },
        "dist-tags" : {
          "type" : "object",
          "enabled" : false
        },
        "versions" : {
          "type" : "object",
          "enabled" : false
        },
        "main" : {
          "type" : "string",
          "index" : "no"
        },
        "maintainers" : {
          "type" : "object",
          "enabled" : false
        },
        "readmeFilename" : {
          "type" : "string",
          "index" : "no"
        },
        "repository" : {
          "type" : "object",
          "enabled" : false
        },
        "dist" : {
          "type" : "string",
          "index" : "no"
        },
        "email" : {
          "type" : "string",
          "index" : "no"
        },
        "gpg" : {
          "type" : "object",
          "enabled" : false
        },
        "homepage" : {
          "type" : "string",
          "index" : "no"
        },
        "license" : {
          "type" : "string",
          "index" : "no"
        },
        "org" : {
          "type" : "string",
          "index" : "no"
        },
        "path" : {
          "type" : "string",
          "index" : "no"
        },
        "signature" : {
          "type" : "string",
          "index" : "no"
        },
        "bugs" : {
          "type" : "object",
          "enabled" : false
        },
        "time" : {
          "type" : "object",
          "enabled" : false
        },
        "keywords" : {
          "type" : "string",
          "index" : "not_analyzed"
        },
        "stars" : {
          "type" : "integer",
          "store" : true
        },
        "update" : {
          "type" : "string",
          "index" : "no"
        },
        "created" : {
          "type" : "date",
          "store" : true
        },
        "updated" : {
          "type" : "date",
          "store" : true
        },
        "suggest" : {
          "type" : "completion",
          "analyzer" : "lower_whitespace"
        }
      }
    }
  },
  "updates" :
    eos

      out.write(parse_packages().to_json)
      out.write("\n}")
    end
  end

  def parse_packages()
    packages = JSON.parse(File.read(DOWNLOAD_FILENAME))
    rv = []

    packages.each do |key, value|
      unless key.to_s == '_updated'
        p = value

        ['NOW_KLUDGE', 'asdf', 'foo', 'users'].each do |prop|
          p.delete(prop)
        end

        author = p['author']

        if author
          if author.is_a?(Hash)
            author.keep_if do |k, v|
              (k == 'name') || (k == 'email')
            end
          elsif author.is_a?(String)
            p['author'] = {
              name: author
              # TODO: extract email
            }
          else
            p.delete('author')
          end
        end

        repo = p['repository']

        if repo
          # FIXME: not all getting deleted
          ['contributors', 'time', 'typ', 'tyep', 'type:', 'users', 'web '].each do |prop|
            repo.delete(prop)
          end
        end

        cs = p['contributors']

        if cs.is_a?(Array)
          cs.each do |c|
            c.keep_if do |k, v|
              # FIXME: not all getting deleted
              ['email', 'github', 'name', 'url', 'web'].include?(k)
            end
          end
        end

        versions = p['versions']
        distTags = p['dist-tags']

        if versions
          p['versions'] = versions.keys.map { |version| {version: version.to_s, tag: versions[version] } }
        end

        if distTags
          p['tags'] = distTags.keys.map { |tag| {tag: tag.to_s, version: distTags[tag] } }
          p.delete('dist-tags')
        end

        p['suggest'] = p['name']

        rv << p
      end
    end

    rv
  end
end

output_filename = 'npm_modules.json'

download = false

ARGV.each do |arg|
  if arg == '-d'
    download = true
  else
    output_filename = arg
  end
end

populator = NpmPackagePopulator.new(output_filename)

if download
  populator.download()
end

populator.populate()
system("bzip2 -kf #{output_filename}")