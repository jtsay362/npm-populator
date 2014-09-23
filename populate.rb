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
    "mapping" : {
      "_all" : {
        "enabled" : false
      },
      "properties" : {
        "name" : {
          "type" : "multi_field",
          "path" : "just_name",
          "fields" : {
             "rawName" : { "type" : "string", "index" : "not_analyzed" },
             "name" : { "type" : "string", "index" : "analyzed" }
          }
        },
        "description" : {
          "type" : "string",
          "index" : "analyzed"
        },
        "author" : {
          "type" : "object",
          "properties" : {
            "name" : {
              "type" : "string",
              "index" : "no"
            },
            "email" : {
              "type" : "string",
              "index" : "no"
            }
          }
        },
        "contributors" : {
          "type" : "object",
          "properties" : {
            "name" : {
              "type" : "string",
              "index" : "no"
            },
            "email" : {
              "type" : "string",
              "index" : "no"
            },
            "github" : {
              "type" : "string",
              "index" : "no"
            },
            "url" : {
              "type" : "string",
              "index" : "no"
            },
            "web" : {
              "type" : "string",
              "index" : "no"
            }
          }
        },
        "dist-tags" : {
          "type" : "object",
          "properties" : {
            "name" : {
              "type" : "string",
              "index" : "no"
            },
            "version" : {
              "type" : "string",
              "index" : "no"
            }
          }
        },
        "versions" : {
          "type" : "object",
          "properties" : {
            "name" : {
              "type" : "string",
              "index" : "no"
            },
            "tag" : {
              "type" : "string",
              "index" : "no"
            },
            "version" : {
              "type" : "string",
              "index" : "no"
            }
          }
        },
        "main" : {
          "type" : "string",
          "index" : "no"
        },
        "maintainers" : {
          "type" : "object",
          "properties" : {
            "name" : {
              "type" : "string",
              "index" : "no"
            },
            "email" : {
              "type" : "string",
              "index" : "no"
            },
            "website" : {
              "type" : "string",
              "index" : "no"
            }
          }
        },
        "readmeFilename" : {
          "type" : "string",
          "index" : "no"
        },
        "repository" : {
          "type" : "object",
          "properties" : {
            "author" : {
              "type" : "string",
              "index" : "no"
            },

            "commit_date" : {
              "type" : "date",
              "index" : "no"
            },
            "dist" : {
              "type" : "string",
              "index" : "no"
            },
            "email" : {
              "type" : "string",
              "index" : "no"
            },
            "git" : {
              "type" : "string",
              "index" : "no"
            },
            "github" : {
              "type" : "string",
              "index" : "no"
            },
            "handle" : {
              "type" : "string",
              "index" : "no"
            },
            "id_string" : {
              "type" : "string",
              "index" : "no"
            },
            "job" : {
              "type" : "string",
              "index" : "no"
            },
            "main" : {
              "type" : "string",
              "index" : "no"
            },
            "name" : {
              "type" : "string",
              "index" : "no"
            },
            "repository" : {
              "type" : "string",
              "index" : "no"
            },
            "revision" : {
              "type" : "string",
              "index" : "no"
            },
            "private" : {
              "type" : "string",
              "index" : "no"
            },
            "static" : {
              "type" : "string",
              "index" : "no"
            },
            "title" : {
              "type" : "string",
              "index" : "no"
            },
            "type" : {
              "type" : "string",
              "index" : "no"
            },
            "update" : {
              "type" : "string",
              "index" : "no"
            },
            "url" : {
              "type" : "string",
              "index" : "no"
            },
            "version" : {
              "type" : "string",
              "index" : "no"
            },
            "versions" : {
              "type" : "object",
              "properties" : {
                "tag" : {
                  "type" : "string",
                  "index" : "no"
                },
                "version" : {
                  "type" : "string",
                  "index" : "no"
                }
              }
            },
            "web" :  {
              "type" : "string",
              "index" : "no"
            }
          }
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
          "properties" : {
            "fingerprint" : {
              "type" : "string",
              "index" : "no"
            },
            "signature" : {
              "type" : "string",
              "index" : "no"
            }
          }
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
          "properties" : {
            "bugs" : {
              "type" : "string",
              "index" : "no"
            },
            "email" : {
              "type" : "string",
              "index" : "no"
            },
            "license" : {
              "type" : "string",
              "index" : "no"
            },
            "mail" : {
              "type" : "string",
              "index" : "no"
            },
            "name" : {
              "type" : "string",
              "index" : "no"
            },
            "readmeFilename" : {
              "type" : "string",
              "index" : "no"
            },
            "tags" : {
              "type" : "object",
              "properties" : {
                "tag" : {
                  "type" : "string",
                  "index" : "no"
                },
                "version" : {
                  "type" : "string",
                  "index" : "no"
                }
              }
            },
            "versions" : {
              "type" : "object",
              "properties" : {
                "tag" : {
                  "type" : "string",
                  "index" : "no"
                },
                "version" : {
                  "type" : "string",
                  "index" : "no"
                }
              }
            },
            "time" : {
              "type" : "object",
              "properties" : {
                "modified" : {
                  "type" : "date",
                  "index" : "no"
                }
              }
            },
            "url" : {
              "type" : "string",
              "index" : "no"
            },
            "web" : {
              "type" : "string",
              "index" : "no"
            }
          }
        },
        "time" : {
          "type" : "object",
          "properties" : {
            "modified" : {
              "type" : "date",
              "index" : "no"
            }
          }
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