require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#signed_in?' do
    it 'returns false if there is no session' do
      session[:user_id] = nil
      expect(signed_in?).to eq false
    end

    it 'returns true if there is a session' do
      session[:user_id] = 1
      expect(signed_in?).to eq true
    end
  end
end
