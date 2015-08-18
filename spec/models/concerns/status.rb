shared_examples "status" do

  it 'should have a status' do
    @site = FactoryGirl.create(:site)
    expect(@site.status).to eq 'potential'
  end

  it 'all valid status values should work' do
    ['potential', 'proposed', 'active'].each do |s|
      @site = FactoryGirl.build(:site, :status => s)
      expect(@site).to be_valid
    end
  end

  it 'should refuse invalid status values' do
    @site = FactoryGirl.build(:site, :status => 'not valid')
    expect(@site).not_to be_valid
    expect(@site.errors[:status]).to include("not valid is not a valid status")
  end
end
