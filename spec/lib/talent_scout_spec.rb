require 'spec_helper'

describe TalentScout do
  describe '.search' do
    let!(:music) { create(:music) }
    let!(:video) { create(:video, title: "Adventure Adventure Adventure") }
    let!(:book) { create(:book) }

    before do
      Elasticsearch::Model.client.indices.refresh
    end

    it 'returns records from multiple models' do
      response = TalentScout.search [Video.where("id IS NOT NULL"), Music, Book], { query: { query_string: { query: "Adventure", default_operator: 'AND' } } }
      expect(response.records).to include book
      expect(response.records).to include video
      expect(response.records).to_not include music
    end

    it 'returns records that are in correct order' do
      response = TalentScout.search [Video, Music, Book], { query: { query_string: { query: "Adventure", default_operator: 'AND' } } }
      # first, ensure we are not crazy, and ES returned the hits in the right order
      expect(response.response["hits"]["hits"].map { |hit| [hit['_type'].titleize, hit['_source']['id']] }).to eq [[video.class.name.to_s, video.id], [book.class.name, book.id]]
      # ensure the records are in the same order
      expect(response.records).to eq [video, book]
    end
  end
end
