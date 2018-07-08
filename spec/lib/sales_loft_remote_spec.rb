require 'rails_helper'

describe SalesLoftRemote do
  let(:body) do
    {
      'metadata' => {
        'filtering' => {},
        'paging' => {
          'per_page' => 25,
          'current_page' => 1,
          'next_page' => 2,
          'prev_page' => nil
        },
        'sorting' => {
          'sort_by' => 'updated_at',
          'sort_direction' => 'DESC NULLS LAST'
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

  let(:remote) { described_class.new }

  describe '#people' do
    before do
      allow(HTTParty).to receive(:get).and_return(body)
    end

    context 'when auth is working' do
      it 'returns api response' do
        expect(remote.people).to eq body
      end
    end

    context 'when auth is not working' do
      let(:body) { { 'error' => 'Invalid Bearer token' } }

      it 'logs an error' do
        expect(Rails.logger).to receive(:error).with(/SalesLoftRemote#people failed with the following error: Invalid Bearer token/)
        remote.people
      end

      it 'returns the api response' do
        expect(remote.people).to eq body
      end
    end
  end

  describe '#query' do
    let(:query) { remote.send(:query) }

    context 'default values' do
      it 'uses default values when none are specified' do
        expect(query['page']).to eq(1)
        expect(query['per_page']).to eq(100)
        expect(query['updated_at[gt]']).to be_within(1.minute).of(DateTime.current - 10.years)
      end
    end

    context 'custom values' do
      let(:remote) { described_class.new(page: 2, per_page: 10, last_cached_at: DateTime.current) }

      it 'uses custom values when provided' do
        expect(query['page']).to eq(2)
        expect(query['per_page']).to eq(10)
        expect(query['updated_at[gt]']).to be_within(1.minute).of(DateTime.current)
      end
    end
  end
end
