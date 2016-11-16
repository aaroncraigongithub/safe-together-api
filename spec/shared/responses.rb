# frozen_string_literal: true
%w(200 201 401 403 404 422 502).each do |code|
  RSpec.shared_examples_for "a #{code} response" do
    it "returns #{code}" do
      expect(response.code).to eq code.to_s
    end
  end
end

RSpec.shared_context 'a JSON payload' do
  let(:payload) { JSON.parse(response.body) }
end
