require 'commander/user_interaction'
require 'erb'
require 'grover'
require 'pathname'
require_relative '../validate'

# Generate document command
module Commands
  include Validator

  def generate(options)
    progress = Commander::UI::ProgressBar.new(3, title: 'Building doc...')

    progress.show

    json = load_and_validate_history(options)

    progress.increment

    html = make_html(options.template, json)

    progress.increment

    # include local css for PDF
    grover = Grover.new(
      html,
      style_tag_options: [{ content: File.read(Pathname.new("#{Dir.pwd}/public/style.css")) }]
    )

    File.write("#{Dir.pwd}/#{options.output}", grover.to_pdf)

    progress.increment
  end

  # create html out of thin air/ERB and JSON
  def make_html(template, data)
    erb = ERB.new(File.read("#{Dir.pwd}/#{template}"))

    erb.result_with_hash(data)
  end
end
