FactoryGirl.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email(name) }
    password "foobar"
    password_confirmation "foobar"
  end

  factory :home do
    user
    name { Faker::Lorem.word }
    location { Faker::Lorem.word }
    ip_address { Faker::Internet.ip_v4_address }
    tunnel { Faker::Internet.url }

    after(:create) do |home|
      home.delayed_job = home.delay(cron: HOME_TOKEN_UPDATE_CRON).fetch_token
      home.save
    end
  end

  factory :thing do
    home
    type { Thing.types.sample }
    name { Faker::Lorem.word }
    subtype { Faker::Lorem.word }
    connection_info { { address: "192.168.1.150" } }

    factory :light, class: Things::Light do
      type { "Things::Light" }
    end
    factory :lock, class: Things::Lock do
      type { "Things::Lock" }
    end
    factory :thermostat, class: Things::Thermostat do
      type { "Things::Thermostat" }
    end
    factory :weather, class: Things::Weather do
      type { "Things::Weather" }
    end
    factory :motion_sensor, class: Things::MotionSensor do
      type { "Things::MotionSensor" }
    end
  end

  factory :scenario_thing do
    scenario
    thing { create(:light, home: scenario.home) }
    status { { on: Faker::Boolean.boolean.to_s } }
  end

  factory :scenario do
    home
    name { Faker::Lorem.word }
  end

  factory :timed_task, class: Tasks::TimedTask do
    home

    after(:create) do |timed_task|
      timed_task.delayed_job = timed_task.delay(cron: POLLING_RATE_CRON).apply
      timed_task.save
    end

    trait :scenario do
      scenario {create(:scenario, home: home)      }
    end

    trait :thing do
      status { { on: Faker::Boolean.boolean.to_s } }

      thing {create(:light, home: home)}
    end
  end

  factory :triggered_task, class: Tasks::TriggeredTask do
    home    
    status_to_compare { { movement: Faker::Boolean.boolean.to_s } }
    comparator { "==" }

    before(:create) do |triggered_task|
      triggered_task.thing_to_compare = FactoryGirl.create(:motion_sensor, home: triggered_task.home)
      triggered_task.save
    end

    after(:create) do |triggered_task|
      triggered_task.delayed_job = triggered_task.delay(cron: POLLING_RATE_CRON).apply_if
      triggered_task.save
    end

    trait :scenario do
      before(:create) do |triggered_task|
        triggered_task.scenario = FactoryGirl.create(:scenario, home: triggered_task.home)
        triggered_task.save
      end
    end

    trait :thing do
      status_to_apply { { on: Faker::Boolean.boolean.to_s } }
      
      before(:create) do |triggered_task|
        triggered_task.thing = FactoryGirl.create(:light, home: triggered_task.home)
        triggered_task.save
      end
    end
  end
end
