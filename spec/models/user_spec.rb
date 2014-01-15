require 'spec_helper'

describe User do

  context "devise" do
    before(:each) do
      @attr = {
        :name => "ExampleUser",
        :email => "user@example.com",
        :password => "changeme",
        :password_confirmation => "changeme"
      }
    end

    it "should create a new instance given a valid attribute" do
      User.create!(@attr)
    end

    it "should require an email address" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end

    it "should reject duplicate email addresses" do
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

    describe "passwords" do

      before(:each) do
        @user = User.new(@attr)
      end

      it "should have a password attribute" do
        @user.should respond_to(:password)
      end

      it "should have a password confirmation attribute" do
        @user.should respond_to(:password_confirmation)
      end
    end

    describe "password validations" do

      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
      end

      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
      end

      it "should reject short passwords" do
        short = "a" * 5
        hash = @attr.merge(:password => short, :password_confirmation => short)
        User.new(hash).should_not be_valid
      end

    end

    describe "password encryption" do

      before(:each) do
        @user = User.create!(@attr)
      end

      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end

      it "should set the encrypted password attribute" do
        @user.encrypted_password.should_not be_blank
      end
    end
  end

  context 'login names' do
    context 'same :name' do
      it "should not allow two users with the same name" do
        FactoryGirl.create(:user, :name => "bob")
        user = FactoryGirl.build(:user, :name => "bob")
        user.should_not be_valid
        user.errors[:name].should include("has already been taken")
      end

      it "tests uniqueness case-insensitively" do
        FactoryGirl.create(:user, :name => "bob")
        user = FactoryGirl.build(:user, :name => "BoB")
        user.should_not be_valid
        user.errors[:name].should include("has already been taken")
      end
    end

    context 'case sensitivity' do
      it 'preserves case of login name' do
        user = FactoryGirl.create(:user, :name => "BOB")
        User.last.name.should eq 'BOB'
      end
    end

    context 'invalid login names' do
      it "doesn't allow short names" do
        user = FactoryGirl.build(:invalid_user_shortname)
        user.should_not be_valid
        user.errors[:name].should include("should be between 2 and 25 characters long")
      end
      it "doesn't allow really long names" do
        user = FactoryGirl.build(:invalid_user_longname)
        user.should_not be_valid
        user.errors[:name].should include("should be between 2 and 25 characters long")
      end
      it "doesn't allow spaces in names" do
        user = FactoryGirl.build(:invalid_user_spaces)
        user.should_not be_valid
        user.errors[:name].should include("may only include letters, numbers, or underscores")
      end
      it "doesn't allow other chars in names" do
        user = FactoryGirl.build(:invalid_user_badchars)
        user.should_not be_valid
        user.errors[:name].should include("may only include letters, numbers, or underscores")
      end
      it "doesn't allow reserved names" do
        user = FactoryGirl.build(:invalid_user_badname)
        user.should_not be_valid
        user.errors[:name].should include("name is reserved")
      end
    end

    context 'valid login names' do
      it "allows plain alphanumeric chars in names" do
        user = FactoryGirl.build(:valid_user_alphanumeric)
        user.should be_valid
      end
      it "allows uppercase chars in names" do
        user = FactoryGirl.build(:valid_user_uppercase)
        user.should be_valid
      end
      it "allows underscores in names" do
        user = FactoryGirl.build(:valid_user_underscore)
        user.should be_valid
      end
    end
  end

  context 'watches' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "can watch a site" do
      @user.watches.count.should == 0
      @watch = FactoryGirl.create(:watch, :user => @user)
      @user.watches << @watch
      @user.watches.count.should == 1
    end
  end

end
