shared_examples "website" do

  it 'validates website' do
    expect(FactoryGirl.build(:site, :website => 'http://example.com')).to be_valid
    expect(FactoryGirl.build(:site, :website => 'example.com')).to be_valid
  end

  it 'allows blank and nil website' do
    expect(FactoryGirl.build(:site, :website => '')).to be_valid
    expect(FactoryGirl.build(:site, :website => nil)).to be_valid
  end

  it 'normalises website if http is missing' do
    @site = FactoryGirl.build(:site, :website => 'example.com')
    expect(@site).to be_valid
    expect(@site.website).to eq 'http://example.com'
  end

  it "doesn't normalise websites starting with http" do
    @site = FactoryGirl.build(:site, :website => 'http://example.com')
    expect(@site).to be_valid
    expect(@site.website).to eq 'http://example.com'
  end

  it "doesn't normalise websites starting with https" do
    @site = FactoryGirl.build(:site, :website => 'https://example.com')
    expect(@site).to be_valid
    expect(@site.website).to eq 'https://example.com'
  end

  it "doesn't normalise blank website" do
    @site = FactoryGirl.build(:site, :website => '')
    expect(@site).to be_valid
    expect(@site.website).to eq ''
  end

  it "doesn't normalise nil website" do
    @site = FactoryGirl.build(:site, :website => nil)
    expect(@site).to be_valid
    expect(@site.website).to eq nil
  end

end

