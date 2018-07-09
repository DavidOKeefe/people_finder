require 'rails_helper'

describe Api::PeopleController do
  render_views

  describe '#index' do
    context 'json' do
      it 'responds with a 200' do
        get :index, format: :json

        expect(response.status).to eq(200)
      end
    end
  end

  describe '#letter_frequency' do
    context 'json' do
      it 'responds with a 200' do
        get :letter_frequency, format: :json

        expect(response.status).to eq(200)
      end
    end
  end

  describe '#potential_duplicates' do
    context 'json' do
      it 'responds with a 200' do
        get :potential_duplicates, format: :json

        expect(response.status).to eq(200)
      end
    end
  end
end
