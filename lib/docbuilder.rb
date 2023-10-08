require 'dotenv/load'

require 'bundler/setup'
require 'commander'
require_relative 'commands/generate'
require_relative 'commands/serve'

# CLI for the docbuilder
class DocBuilder
  include Commander::Methods

  include Commands

  # TODO: rename generate to build or opposite
  def generate_cmd(cmd)
    cmd.syntax = 'builder build'
    cmd.description = 'builds the doc'
    cmd.option '--data STRING', String, 'path to data file (default "history.json")'
    cmd.option '--output STRING', String, 'path to output file (default "doc.pdf")'
    cmd.option '--template STRING', String, 'path to template file (default "index.erb")'

    cmd.action do |_args, options|
      options.default \
        data: 'history.json',
        email: ENV.fetch('EMAIL'),
        output: 'doc.pdf',
        phone: ENV.fetch('PHONE'),
        template: 'lib/views/index.erb'

      generate(options)
    end
  end

  def serve_cmd(cmd)
    cmd.syntax = 'builder serve'
    cmd.description = 'serves the doc'
    cmd.option '--data STRING', String, 'path to data file (default "history.json")'

    cmd.action do |_args, options|
      options.default \
        data: 'history.json',
        email: ENV.fetch('EMAIL'),
        output: 'doc.pdf',
        phone: ENV.fetch('PHONE'),
        template: 'index.erb'

      serve(options)
    end
  end

  def run
    program :name, 'Doc Builder'
    program :version, '0.0.1'
    program :description, 'Build a doc'

    command :build do |cmd|
      generate_cmd(cmd)
    end

    command :serve do |cmd|
      serve_cmd(cmd)
    end

    run!
  end
end

DocBuilder.new.run if $PROGRAM_NAME == __FILE__
