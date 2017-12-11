FactoryGirl.define do
    test_password = "testpw"
    
    factory :user do
        sequence(:email){|n| "user#{n}@factory_generated.ex"}
        password test_password
        password_confirmation test_password
    end
end