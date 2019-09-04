# frozen_string_literal: true

describe 'assets:copy_raw_assets' do
  include_context 'rake'
  let(:valid_file) { File.join(Rails.root, 'public', 'assets', 'raw', 'assets', 'header.png') }
  let(:invalid_file) { File.join(Rails.root, 'public', 'assets', 'raw', 'assets', 'header.jpg') }

  before(:each) do
    subject.invoke
  end

  it 'creates a header.png raw image' do
    expect(File.file?(valid_file)).to eq true
  end

  it 'does not create a header.jpg raw image' do
    expect(File.file?(invalid_file)).to eq false
  end
end
