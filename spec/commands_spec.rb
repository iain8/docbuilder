require 'commander'
require 'docbuilder'
require 'validate'

describe Commands do
  before :each do
    @fake_html = '<html>result</html>'
    @fake_erb = '<%= hello =>'
  end

  describe 'Commands#make_html' do
    it 'generates html using ERB and JSON' do
      mock_erb = instance_spy(ERB)

      allow(mock_erb).to receive(:result_with_hash).and_return(@fake_html)

      allow(ERB).to receive(:new).and_return(mock_erb)
      allow(File).to receive(:read).and_return(@fake_erb)

      instance = DocBuilder.new

      expect(instance.make_html('path.erb', '{ "data": "yes" }')).to eq(@fake_html)
    end
  end

  describe('Commands#generate') do
    it 'makes a delicious PDF' do
      allow_any_instance_of(Commander::UI::ProgressBar).to receive(:show)

      mock_grover = instance_spy(Grover)
      allow(mock_grover).to receive(:to_pdf).and_return('data.pdf')
      allow(Grover).to receive(:new).and_return(mock_grover)

      allow(File).to receive(:read).and_return('p { color: green }')
      allow(File).to receive(:write)

      options = Commander::Command::Options.new
      options.template = 'path.erb'
      
      instance = DocBuilder.new
      allow(instance).to receive(:make_html).and_return(@fake_html)
      allow(instance).to receive(:load_and_validate_history).and_return('{ "json": true }')

      expect(instance.generate(options)).to eq(nil)
      expect(instance).to have_received(:load_and_validate_history).with(options)
      expect(instance).to have_received(:make_html).with('path.erb', '{ "json": true }')
     
      expect(Grover).to have_received(:new).with(
        @fake_html,
        {
          style_tag_options: [ { content: "p { color: green }"}]
        }
      )
      expect(mock_grover).to have_received(:to_pdf).with(no_args)
    end
  end
end

