require 'spec_helper'

describe Graph do
  context "path_identifier" do
    let(:short_path) { "http://www.facebook.com/Fooacres" }
    let(:long_path) { "http://www.facebook.com/pages/Fooacres/12345678" }
    let(:short_path_photo) { "http://www.facebook.com/Fooacres/photos_stream?ref=page_internal" }
    let(:long_path_photo) { "http://www.facebook.com/pages/Fooacres/12345678/?sk=photo_stream" }

    it 'handles and empty url' do
      expect(Graph.get_path_identifier("")).to eq ""
    end
    it 'returns the last argument of a /pages/Pagename/id path' do
      expect(Graph.get_path_identifier(short_path)).to eq "Fooacres"
    end
    it 'returns the first argument of a /Pagename path' do
      expect(Graph.get_path_identifier(long_path)).to eq "12345678"
    end
    it 'returns the last argument of a /pages/Pagename/id path with a query' do
      expect(Graph.get_path_identifier(short_path_photo)).to eq "Fooacres"
    end
    it 'returns the first argument of a /Pagename path with a sub-page' do
      expect(Graph.get_path_identifier(long_path_photo)).to eq "12345678"
    end
  end
end
