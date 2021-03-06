# frozen_string_literal: true

describe AMA::Styles::Internal::Deployment do
  subject { described_class.new(log_output: false, bucket: bucket) }

  describe '#run' do
    let(:client) do
      Aws::S3::Resource.new(
        region: 'us-west-2',
        stub_responses: true
      )
    end
    let(:pattern) do
      Rails.root.join(
        'public',
        'assets',
        '**',
        'shared*.css'
      ).to_s
    end
    let(:bucket) { client.bucket(Rails.configuration.assets_bucket_name) }
    let(:prefix) { AMA::Styles::Globals::ASSET_PREFIX }

    before(:each) do
      Rails.application.load_tasks
      subject.silence_stderr { Rake::Task['assets:clobber'].invoke }
    end

    context 'successful api deployment' do
      let(:deployment_response) do
        read_fixture(
          'api',
          'v1',
          'assets',
          'deployments.json'
        )
      end

      before(:each) do
        stub_api_deployment(body: deployment_response)
      end

      after(:each) do
        subject.silence_stderr { Rake::Task['assets:clobber'].invoke }
      end

      it 'precompiles assets and uploads them to S3' do
        expect(bucket).to receive(:object).at_least(1).times.and_call_original
        subject.silence_stderr { subject.run }
        expect(Dir.glob(pattern).size).to eq(2)
      end

      it 'uploads a fallback stylesheet to S3 (if Redis is unavailable)' do
        # bucket.object is called many times (once for each asset file)
        # therefore, we have to stub with the following strategy to
        # specifically look for the fallback key.
        expect(bucket).to receive(:object).with(
          File.join("#{prefix}v2", AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE)
        ).and_call_original
        expect(bucket).to receive(:object).with(
          File.join("#{prefix}v3", AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE)
        ).and_call_original
        expect(bucket).to receive(:object).at_least(1).times.and_call_original
        subject.silence_stderr { subject.run }
      end
    end

    context 'api deployment failure' do
      let(:deployment_response) do
        read_fixture(
          'api',
          'v1',
          'assets',
          'deployment_failure.json'
        )
      end

      before(:each) do
        stub_api_deployment(body: deployment_response, status: 422)
      end

      it 'raises a RestClient::UnprocessableEntity exception' do
        run = proc { subject.silence_stderr { subject.run } }
        expect(run).to raise_error(RestClient::UnprocessableEntity)
      end
    end
  end
end
