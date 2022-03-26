FactoryBot.define do
  factory :result do
    score { rand(100) }
    calm { rand(50) }
    anger { rand(50) }
    joy { rand(50) }
    sorrow { rand(50) }
    energy { rand(50) }
    user
    greeting
    voice { Rack::Test::UploadedFile.new('spec/fixtures/test.wav', 'audio/wav') }
  end
end
