require 'rails_helper'

describe CachePeopleWorker do
  let(:resp_1) do
    {
      'metadata' => {
        'paging' => {
          'current_page' => 1,
          'next_page' => 2
        }
      },
      'data' => [
        {
          'id' => 1234,
          'display_name' => 'Beatrix Kiddo',
          'title' => 'Former Assassin',
          'email_address' => 'black.mamba@gmail.com'
        }
      ]
    }
  end
  let(:resp_2) do
    {
      'metadata' => {
        'paging' => {
          'current_page' => 2,
          'next_page' => nil
        }
      },
      'data' => [
        {
          'id' => 1234,
          'display_name' => 'Budd',
          'title' => 'Bouncer',
          'email_address' => 'sidewinder@gmail.com'
        }
      ]
    }
  end
  let(:job) { described_class.new }

  before do
    allow_any_instance_of(SalesLoftRemote).to receive(:people).and_return(resp_1)
  end

  describe '#perform' do
    it 'queries people from the SalesLoftRemote' do
      expect_any_instance_of(SalesLoftRemote).to receive(:people).once
      job.perform
    end

    it 'creates person objects' do
      expect { job.perform }
        .to change { Person.where(email: 'black.mamba@gmail.com').count }
        .by(1)
    end

    context 'when there are paginated results' do
      it 'queues additional jobs' do
        expect(described_class).to receive(:perform_async)
        job.perform
      end

      it 'does not update last_cached_at' do
        expect_any_instance_of(PersonMetaData).not_to receive(:update)
        job.perform
      end
    end

    context 'when there are no more paginated results' do
      before do
        allow_any_instance_of(SalesLoftRemote).to receive(:people).and_return(resp_2)
      end

      it 'does not queue additional jobs' do
        expect(described_class).not_to receive(:perform_async)
        job.perform
      end

      it 'updates last_cached_at' do
        expect_any_instance_of(PersonMetaData).to receive(:update)
        job.perform
      end
    end
  end
end
