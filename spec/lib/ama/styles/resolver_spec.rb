# frozen_string_literal: true

describe AMA::Styles::Resolver do
  let(:default_version) { AMA::Styles::Globals.ama_styles_default_version }

  describe '#asset_path' do
    before(:each) do
      subject.remote = remote
      subject.version = version
    end

    context 'with remote: true' do
      let(:remote) { true }

      context 'when asset digest is found' do
        let(:asset_name) { 'foo-123.css' }

        before(:each) do
          AMA::Styles::Cache.write(
            "#{AMA::Styles::Globals::CURRENT_STYLESHEET_DIGEST_KEY}/#{subject.version}",
            "#{subject.version}/#{asset_name}"
          )
        end

        after(:each) do
          AMA::Styles::Cache.clear
        end

        context 'when version is nil' do
          let(:version) {}

          it 'returns the ama_styles_default_version cloudfront asset url' do
            cloudfront_url = URI.join(
              Rails.configuration.cloudfront_url,
              AMA::Styles::Globals::ASSET_PREFIX,
              "#{AMA::Styles::Globals.ama_styles_default_version}/",
              asset_name
            ).to_s
            expect(subject.asset_path).to eq(cloudfront_url)
          end

          context 'but there is a cache entry for ama_styles_version' do
            before(:each) do
              AMA::Styles::Cache.write(
                "#{AMA::Styles::Globals::CURRENT_STYLESHEET_DIGEST_KEY}/v3",
                "v3/#{asset_name}"
              )
              AMA::Styles::Cache.write(AMA::Styles::Globals::AMA_STYLES_VERSION_KEY, 'v3')
            end

            it 'returns the v3 cloudfront asset url' do
              cloudfront_url = URI.join(
                Rails.configuration.cloudfront_url,
                AMA::Styles::Globals::ASSET_PREFIX,
                'v3/',
                asset_name
              ).to_s
              expect(subject.asset_path).to eq(cloudfront_url)
            end

            context 'but that version is invalid' do
              before(:each) do
                AMA::Styles::Cache.write(
                  "#{AMA::Styles::Globals::CURRENT_STYLESHEET_DIGEST_KEY}/#{default_version}",
                  "v3/#{asset_name}"
                )
                AMA::Styles::Cache.write(AMA::Styles::Globals::AMA_STYLES_VERSION_KEY, 'v5')
              end

              it 'returns the default version cloudfront asset url' do
                cloudfront_url = URI.join(
                  Rails.configuration.cloudfront_url,
                  AMA::Styles::Globals::ASSET_PREFIX,
                  "#{default_version}/",
                  asset_name
                ).to_s
                expect(subject.asset_path).to eq(cloudfront_url)
              end
            end
          end
        end

        context 'when version is v2' do
          let(:version) { 'v2' }

          it 'returns the v2 cloudfront asset url' do
            cloudfront_url = URI.join(
              Rails.configuration.cloudfront_url,
              AMA::Styles::Globals::ASSET_PREFIX,
              "#{version}/",
              asset_name
            ).to_s
            expect(subject.asset_path).to eq(cloudfront_url)
          end
        end

        context 'when version is v3' do
          let(:version) { 'v3' }

          context 'when version v2 is passed' do
            before(:each) do
              AMA::Styles::Cache.write(
                "#{AMA::Styles::Globals::CURRENT_STYLESHEET_DIGEST_KEY}/v2",
                "v2/#{asset_name}"
              )
            end

            it 'returns the v2 cloudfront asset url' do
              cloudfront_url = URI.join(
                Rails.configuration.cloudfront_url,
                AMA::Styles::Globals::ASSET_PREFIX,
                'v2/',
                asset_name
              ).to_s
              expect(subject.asset_path('v2')).to eq(cloudfront_url)
            end
          end

          it 'returns the v3 cloudfront asset url' do
            cloudfront_url = URI.join(
              Rails.configuration.cloudfront_url,
              AMA::Styles::Globals::ASSET_PREFIX,
              "#{version}/",
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

        context 'when version is nil' do
          let(:version) {}

          it 'returns the ama_styles_default_version cloudfront fallback url' do
            cloudfront_url = URI.join(
              Rails.configuration.cloudfront_url,
              AMA::Styles::Globals::ASSET_PREFIX,
              "#{AMA::Styles::Globals.ama_styles_default_version}/",
              AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE
            ).to_s
            expect(subject.asset_path).to eq(cloudfront_url)
          end
        end

        context 'when version is v2' do
          let(:version) { 'v2' }

          it 'returns the v2 cloudfront fallback url' do
            cloudfront_url = URI.join(
              Rails.configuration.cloudfront_url,
              AMA::Styles::Globals::ASSET_PREFIX,
              "#{version}/",
              AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE
            ).to_s
            expect(subject.asset_path).to eq(cloudfront_url)
          end
        end

        context 'when version is v3' do
          let(:version) { 'v3' }

          it 'returns the v3 cloudfront fallback url' do
            cloudfront_url = URI.join(
              Rails.configuration.cloudfront_url,
              AMA::Styles::Globals::ASSET_PREFIX,
              "#{version}/",
              AMA::Styles::Globals::FALLBACK_STYLESHEET_FILE
            ).to_s
            expect(subject.asset_path).to eq(cloudfront_url)
          end
        end
      end
    end

    context 'with remote: false' do
      let(:remote) { false }
      let(:name) { "#{subject.version}/#{AMA::Styles::Globals::PRIMARY_STYLESHEET_NAME}" }

      context 'when version is nil' do
        let(:version) {}

        it 'returns the ama_styles_default_version stylesheet name' do
          expect(subject.asset_path).to eq(name)
        end
      end

      context 'when version is v2' do
        let(:version) { 'v2' }

        it 'returns the v2 stylesheet name' do
          expect(subject.asset_path).to eq(name)
        end
      end

      context 'when version is v3' do
        let(:version) { 'v3' }

        it 'returns the v3 stylesheet name' do
          expect(subject.asset_path).to eq(name)
        end
      end
    end
  end
end
