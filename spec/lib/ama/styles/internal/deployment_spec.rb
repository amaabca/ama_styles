# frozen_string_literal: true

describe AMA::Styles::Internal::Deployment do
  subject { described_class.new(log_output: false, bucket: bucket) }

  describe '#run' do
    let(:client_stub) { Aws::S3::Client.new(stub_responses: true) }

    let(:resourse) do
      Aws::S3::Resource.new(client: client_stub)
    end
    let(:pattern) do
      Rails.root.join(
        'public',
        'assets',
        'application*.css'
      ).to_s
    end
    let(:manifest_file_body) do
      read_fixture(
        'api',
        'v1',
        'assets',
        'manifest.json'
      )
    end

    let(:bucket) { resourse.bucket(Rails.configuration.assets_bucket_name) }
    let(:prefix) { AMA::Styles::Globals::ASSET_PREFIX }

    before(:each) do
      client_stub.stub_responses(:get_object, body: manifest_file_body)
      client_stub.stub_responses(:list_objects, bucket_data)
      Rails.application.load_tasks
      subject.silence_stderr { Rake::Task['assets:clobber'].invoke }
    end

    after(:each) do
      subject.silence_stderr { Rake::Task['assets:clobber'].invoke }
    end

    context 'successful api deployment' do
      let(:bucket_data) do
        client_stub.stub_data(:list_objects, contents: [
                                { key: 'assets/shared-1ac6f096e883eb0c27e2cfdb3c09be9237c762b4737acd2879bebd5c5d0cefc7.css' },
                                { key: 'assets/font-awesome/fontawesome-webfont-7bfcab6d585432cc5fa41bbd7ad0f009033b2979.eot' },
                                { key: 'assets/manifest.json' },
                                { key: 'assets/latest.css' },
                                { key: 'assets/fallback.css' }
                              ])
      end

      it 'precompiles assets and uploads them to S3' do
        expect(bucket).to receive(:object).at_least(1).times.and_call_original
        subject.silence_stderr { subject.run }
        expect(Dir.glob(pattern).size).to eq(1)
      end

      it 'uploads a fallback stylesheet to S3 (if Redis is unavailable)' do
        # bucket.object is called many times (once for each asset file)
        # therefore, we have to stub with the following strategy to
        # specifically look for the fallback key.
        expect(bucket).to receive(:object).with(
          File.join(prefix, AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE)
        ).and_call_original
        expect(bucket).to receive(:object).at_least(1).times.and_call_original
        subject.silence_stderr { subject.run }
      end
    end

    context 'there is some missing file' do
      let(:bucket_data) do
        client_stub.stub_data(:list_objects, contents: [
                                { key: 'assets/shared-1ac6f096e883eb0c27e2cfdb3c09be9237c762b4737acd2879bebd5c5d0cefc7.css' },
                                { key: 'assets/latest.css' },
                                { key: 'assets/fallback.css' }
                              ])
      end

      it 'raises an StandardErrorexception' do
        run = proc { subject.silence_stderr { subject.run } }
        expect(run).to raise_error(StandardError, 'File missing!')
      end
    end
  end
end
