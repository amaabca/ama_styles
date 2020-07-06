# frozen_string_literal: true

describe AMA::Styles::Resolver do
  describe '#asset_path' do
    before(:each) do
      subject.remote = remote
      subject.version = version
    end

    context 'with remote: true' do
      let(:remote) { true }
      let(:version) {}

      context 'when asset digest is found' do
        let(:asset_name) { 'foo-123.css' }

        before(:each) do
          AMA::Styles::Cache.write(
            AMA::Styles::Globals::CURRENT_STYLESHEET_DIGEST_KEY,
            asset_name
          )
        end

        after(:each) do
          AMA::Styles::Cache.clear
        end

        it 'returns the cloudfront asset url' do
          cloudfront_url = URI.join(
            Rails.configuration.cloudfront_url,
            AMA::Styles::Globals::ASSET_PREFIX,
            asset_name
          ).to_s
          expect(subject.asset_path).to eq(cloudfront_url)
        end

        context 'with version specified' do
          let(:version) { 'v1' }

          it 'returns the primary stylesheet name with a version prefix' do
            cloudfront_url = URI.join(
              Rails.configuration.cloudfront_url,
              "#{version}/",
              AMA::Styles::Globals::ASSET_PREFIX,
              asset_name
            ).to_s
            expect(subject.asset_path).to eq(cloudfront_url)
          end
        end
      end

      context 'when asset fallback is used' do
        before(:each) do
          AMA::Styles::Cache.clear
        end

        it 'returns the cloudfront fallback url' do
          cloudfront_url = URI.join(
            Rails.configuration.cloudfront_url,
            AMA::Styles::Globals::ASSET_PREFIX,
            AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE
          ).to_s
          expect(subject.asset_path).to eq(cloudfront_url)
        end

        context 'with version specified' do
          let(:version) { 'v1' }

          it 'returns the primary stylesheet name with a version prefix' do
            cloudfront_url = URI.join(
              Rails.configuration.cloudfront_url,
              "#{version}/",
              AMA::Styles::Globals::ASSET_PREFIX,
              AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE
            ).to_s
            expect(subject.asset_path).to eq(cloudfront_url)
          end
        end
      end

      context 'with version specified' do
        let(:version) { 'v1' }

        it 'returns the primary stylesheet name with a version prefix' do
          cloudfront_url = URI.join(
            Rails.configuration.cloudfront_url,
            "#{version}/",
            AMA::Styles::Globals::ASSET_PREFIX,
            AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE
          ).to_s
          expect(subject.asset_path).to eq(cloudfront_url)
        end
      end
    end

    context 'with remote: false' do
      let(:remote) { false }
      let(:version) {}

      it 'returns the primary stylesheet name' do
        name = AMA::Styles::Globals::PRIMARY_STYLESHEET_NAME
        expect(subject.asset_path).to eq(name)
      end
    end
  end
end
