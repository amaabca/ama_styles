# frozen_string_literal: true

describe AMA::Styles::Cache do
  describe 'delegations' do
    AMA::Styles::Cache::DELEGATIONS.each do |method|
      describe method do
        it 'responds to the delegated method' do
          expect(AMA::Styles::Cache).to respond_to(method)
        end
      end
    end
  end

  describe '.store' do
    before(:each) do
      store = ActiveSupport::Cache::NullStore.new
      Rails.configuration.cloudfront_cache_store = store
    end

    after(:each) do
      Rails.configuration.cloudfront_cache_store = described_class.build_store(
        :redis_store,
        db: 3,
        namespace: 'assets',
        host: Rails.configuration.redis_endpoint,
        raw: true
      )
    end

    it 'returns the cache store that is configured' do
      expect(described_class.store).to be_an(ActiveSupport::Cache::NullStore)
    end
  end

  describe '.build_store' do
    it 'returns a cache store instance with the options specified' do
      store = described_class.build_store(:redis_store, raw: true)
      expect(store).to be_an(ActiveSupport::Cache::RedisStore)
      expect(store.options[:raw]).to be true
    end
  end

  describe '.transaction' do
    let(:redis_key) { 'foo/bar' }

    before(:each) do
      described_class.clear
    end

    it 'yields the underlying cache class to the block' do
      described_class.transaction do |store|
        expect(store).to eq(AMA::Styles::Cache)
      end
    end

    it 'rolls back on a failure' do
      begin
        described_class.transaction do |store|
          store.write(redis_key, true)
          raise StandardError, 'explicit raise!'
        end
      rescue StandardError
        expect(described_class.read(redis_key)).to be nil
      end
    end

    it 'writes multiple values atomically' do
      described_class.transaction do |store|
        store.write(1, 'true')
        store.write(2, 'true')
      end
      expect(described_class.read(1)).to eq('true')
      expect(described_class.read(2)).to eq('true')
    end
  end
end
