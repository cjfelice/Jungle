require 'rails_helper'


RSpec.describe User, type: :model do
  
  describe 'Validations' do

    before(:each) do
      @user = User.new
    end

    it 'saves when all fields are filled' do
      full_user = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
      full_user.save
      expect(full_user).to be_valid
    end

    it 'is not valid without a first_name' do
      expect(@user).to_not be_valid
      expect(@user.errors.messages[:first_name]).to include('can\'t be blank')
    end
    
    it 'is not valid without a last_name' do
      expect(@user).to_not be_valid
      expect(@user.errors.messages[:last_name]).to include('can\'t be blank')
    end

    it 'is not valid without a password' do
      expect(@user).to_not be_valid
      expect(@user.errors.messages[:password]).to include('can\'t be blank')
    end

    it 'is not valid if password and password confirmation do not match' do
      full_user = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
      full_user2 = User.new(first_name: 'Tar', last_name: 'Mack', email: 'a@e.com', password: 'password', password_confirmation: 'passw000rd')
      full_user.save
      full_user2.save
      expect(full_user.password).to eq(full_user.password_confirmation)
      expect(full_user2.password).to_not eq(full_user2.password_confirmation)
    end

    it 'is not valid if password is too short' do
      full_user = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
      full_user2 = User.new(first_name: 'Mike', last_name: 'Mike', email: 'mike@gmail.com', password: '1', password_confirmation: '1')
      full_user.save
      full_user2.save
      expect(full_user).to be_valid
      expect(full_user2).to_not be_valid
      expect(full_user2.errors.messages[:password]).to include("is too short (minimum is 6 characters)")
      expect(full_user2.errors.messages[:password_confirmation]).to include("is too short (minimum is 6 characters)")
    end

    it 'is not valid without an email' do
      expect(@user).to_not be_valid
      expect(@user.errors.messages[:email]).to include('can\'t be blank')
    end

    it 'requires a unique email' do
      full_user1 = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
      full_user2 = User.new(first_name: 'Margerine', last_name: 'Slice', email: 'CHIMPTIME@gmail.com', password: 'chicken', password_confirmation: 'chicken')
      full_user1.save
      full_user2.save
      expect(full_user1).to be_valid
      expect(full_user2).to_not be_valid
      expect(full_user2.errors.messages[:email]).to include('has already been taken')
    end

    context 'on an existing user' do
      let(:user) do
        full_user1 = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
        full_user1.save
        User.find full_user1.id
      end

      it "should be valid with no changes" do
        expect(user).to_not be_valid
      end

      it "should not be valid with an empty password" do
        user.password = user.password_confirmation = ""
        expect(user).to_not be_valid
      end

      it "should be valid with a new password" do
        user.password = user.password_confirmation = "new password"
        expect(user).to be_valid
      end
    end

  end

  describe ".authenticate_with_credentials" do
    
    it 'should authenticate if password and email are valid' do
    user = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
    user.save
    valid_user = User.authenticate_with_credentials('chimptime@gmail.com', 'blimpos')

    expect(valid_user).to eq(user)
    end

    it 'should not authenticate if password and email are not valid' do
      user = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
      user.save
      invalid_user = User.authenticate_with_credentials('frog@frog.com', 'blimpos')
  
      expect(invalid_user).to_not eq(user)
    end

    it 'should authenticate if user adds uppercase letters to their email' do
      user = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
      user.save
      valid_user = User.authenticate_with_credentials('chimpTIME@gmail.com', 'blimpos')
      expect(valid_user).to eq(user)
    end

    it 'should authenticate if user adds spaces to beginning or end of email' do
      user = User.new(first_name: 'Chimpy', last_name: 'McG', email: 'chimptime@gmail.com', password: 'blimpos', password_confirmation: 'blimpos')
      user.save
      valid_user = User.authenticate_with_credentials(' chimptime@gmail.com ', 'blimpos')
      expect(valid_user).to eq(user)
    end
  end
end