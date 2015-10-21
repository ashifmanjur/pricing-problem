class PriceCalculator
  attr_accessor :base_price, :mark_ups

  RATES = { flat_rate: 5, person_rate: 1.2,
            material_rates: {
                pharmaceutical: { names: ['drugs'], rate: 7.5 },
                food: { names: ['food'], rate: 13.0 },
                electronics: { names: ['television', 'laptop'], rate: 2.0 },
            }
  }

  def initialize(base_price = 0, mark_ups = [])
    self.base_price = base_price || 0
    self.mark_ups = mark_ups || []
  end

  def self.flat_markup
    self::RATES[:flat_rate]
  end

  def self.person_rate
    self::RATES[:person_rate]
  end

  def self.material_rate(material_name = nil)
    return 0.0 unless material_name

    self::RATES[:material_rates].each do |_key, value|
      return value[:rate] if value[:names].include?(material_name)
    end

    0.0
  end

  private

  def number_of_people
    people_counts = self.mark_ups.select { |item| item.match /person|people/ }.map(&:to_i).delete_if { |item| item < 0 }
    people_counts.empty? ? 0 : people_counts.inject(:+)
  end
end