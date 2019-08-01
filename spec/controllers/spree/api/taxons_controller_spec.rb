require 'spec_helper'

module Spree
  describe Api::TaxonsController do
    render_views

    let(:taxonomy) { create(:taxonomy) }
    let(:taxon) { create(:taxon, name: "Ruby", taxonomy: taxonomy) }
    let(:taxon2) { create(:taxon, name: "Rails", taxonomy: taxonomy) }
    let(:attributes) {
      ["id", "name", "pretty_name", "permalink", "position", "parent_id", "taxonomy_id"]
    }

    before do
      allow(controller).to receive(:spree_current_user) { current_api_user }

      taxon2.children << create(:taxon, name: "3.2.2", taxonomy: taxonomy)
      taxon.children << taxon2
      taxonomy.root.children << taxon
    end

    context "as a normal user" do
      let(:current_api_user) { build(:user) }

      it "gets all taxons for a taxonomy" do
        api_get :index, taxonomy_id: taxonomy.id

        expect(json_response.first['name']).to eq taxon.name
        children = json_response.first['taxons']
        expect(children.count).to eq 1
        expect(children.first['name']).to eq taxon2.name
        expect(children.first['taxons'].count).to eq 1
      end

      it "gets all taxons" do
        api_get :index

        expect(json_response.first['name']).to eq taxonomy.root.name
        children = json_response.first['taxons']
        expect(children.count).to eq 1
        expect(children.first['name']).to eq taxon.name
        expect(children.first['taxons'].count).to eq 1
      end

      it "can search for a single taxon" do
        api_get :index, q: { name_cont: "Ruby" }

        expect(json_response.count).to eq(1)
        expect(json_response.first['name']).to eq "Ruby"
      end
    end
  end
end
