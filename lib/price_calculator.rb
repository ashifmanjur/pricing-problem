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
    return 0.0 if material_name.nil? || material_name.empty?

    self::RATES[:material_rates].each do |_key, value|
      return value[:rate] if value[:names].include?(material_name)
    end

    0.0
  end

  def calculate
    return calculated_base_price if mark_ups.empty?

    (calculated_base_price + people_cost + materials_cost).round(2)
  end

  private

  def calculated_base_price
    (base_price + flat_markup_cost).round(6)
  end

  def people_cost
    (number_of_people.to_f * ((self.class.person_rate.to_f * calculated_base_price.to_f) / 100.0)).round(6)
  end

  def flat_markup_cost
    ((self.class.flat_markup.to_f * self.base_price.to_f) / 100.0).round(6)
  end

  def materials_cost
    sum = 0.0

    (self.mark_ups - self.mark_ups.select { |item| item.match /person|people/ }).each do |mark_up|
      sum += (self.class.material_rate(mark_up.to_s).to_f * calculated_base_price.to_f) / 100.0
    end

    sum.round(6)
  end

  def number_of_people
    people_counts = self.mark_ups.select { |item| item.match /person|people/ }.map(&:to_i).delete_if { |item| item < 0 }
    people_counts.empty? ? 0 : people_counts.inject(:+)
  end
end