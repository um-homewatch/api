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
  end

  factory :thing do
    home
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

    factory :scenario_light do
      before(:create) do |scenario_thing|
        scenario_thing.thing = FactoryGirl.create(:light, home: scenario_thing.home)
      end
      status { { on: Faker::Boolean.boolean.to_s } }
    end

    factory :scenario_lock do
      before(:create) do |scenario_thing|
        scenario_thing.thing = FactoryGirl.create(:lock, home: scenario_thing.home)
      end
      status { { locked: Faker::Boolean.boolean.to_s } }
    end

    factory :scenario_thermostat do
      before(:create) do |scenario_thing|
        scenario_thing.thing = FactoryGirl.create(:thermostat, home: scenario_thing.home)
      end
      status { { targetTemperature: Faker::Number.between(15, 25).to_s } }
    end
  end

  factory :scenario do
    home
    name { Faker::Lorem.word }
  end

  factory :timed_task, class: Tasks::TimedTask do
    home

    before(:create) do |timed_task|
      timed_task.thing = FactoryGirl.create(:light, home: timed_task.home)
    end

    after(:create) do |timed_task|
      timed_task.delayed_job = timed_task.delay(cron: "*/5 * * * *").apply
      timed_task.save
    end

    factory :timed_task_light do
      before(:create) do |timed_task|
        timed_task.thing = FactoryGirl.create(:light, home: timed_task.home)
      end
      status { { on: Faker::Boolean.boolean.to_s } }
    end
  end

  factory :triggered_task, class: Tasks::TriggeredTask do
    home

    before(:create) do |triggered_task|
      triggered_task.thing = FactoryGirl.create(:light, home: triggered_task.home)
    end

    after(:create) do |triggered_task|
      triggered_task.delayed_job = triggered_task.delay(cron: "*/5 * * * * *").apply
      triggered_task.save
    end

    factory :triggered_task_light do
      before(:create) do |triggered_task|
        triggered_task.thing = FactoryGirl.create(:light, home: triggered_task.home)
      end
      status_to_apply { { on: Faker::Boolean.boolean.to_s } }
      status_to_compare { { on: Faker::Boolean.boolean.to_s } }
      keys_to_compare { [:on] }
      comparator_type { "equals" }
    end
  end
end
