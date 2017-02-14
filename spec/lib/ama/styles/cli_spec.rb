# frozen_string_literal: true
describe AMA::Styles::CLI do
  let(:argv) { %w(staging deploy) }
  let(:branch) { 'my_branch' }
  let(:invalid_argument) { AMA::Styles::CLI::InvalidArgument }
  subject do
    described_class.new(argv: argv, branch: branch, dry_run: true)
  end

  describe '#parse_and_execute' do
    context 'invalid command' do
      let(:argv) { %w(staging push) }

      it 'raise invalid argument' do
        expect { subject.parse_and_execute }.to raise_error invalid_argument
      end
    end

    context 'missing command' do
      let(:argv) { %w(staging) }

      it 'raise invalid argument' do
        expect { subject.parse_and_execute }.to raise_error invalid_argument
      end
    end

    context 'invalid environment' do
      let(:argv) { %w(test deploy) }

      it 'raise invalid argument' do
        expect { subject.parse_and_execute }.to raise_error invalid_argument
      end
    end

    context 'missing environment' do
      let(:argv) { [] }

      it 'raise invalid argument' do
        expect { subject.parse_and_execute }.to raise_error invalid_argument
      end
    end

    context 'valid params' do
      it 'returns a AMA::Styles::Commands::Deploy instance' do
        expect(subject.parse_and_execute).to be true
      end
    end
  end
end
