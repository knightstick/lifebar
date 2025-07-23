FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task #{n}" }
    interval_type { "weekly" }

    trait :daily do
      interval_type { "daily" }
    end

    trait :weekly do
      interval_type { "weekly" }
    end

    trait :monthly do
      interval_type { "monthly" }
    end

    trait :custom do
      interval_type { "custom" }
      interval_value { 5 }
    end

    trait :completed do
      transient do
        completed_at { Time.current }
      end

      after(:create) do |task, evaluator|
        task.mark_completed!(evaluator.completed_at)
      end
    end
  end
end
