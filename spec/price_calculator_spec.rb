require 'price_calculator'

describe PriceCalculator do
  describe 'attributes' do
    it 'allows reading and writing of base price' do
      subject.base_price = 3200
      expect(subject.base_price).to eq(3200)
    end

    it 'allows reading and writing of mark_ups array of strings' do
      subject.mark_ups = ['3 People', 'goods', 'bars']
      expect(subject.mark_ups).to contain_exactly('3 People', 'goods', 'bars')
    end

    context 'initialized without any arg' do
      it 'should have 0 as base price' do
        expect(subject.base_price).to be_zero
      end

      it 'should have an empty array as mark_ups' do
        expect(subject.mark_ups).to be_empty
      end
    end

    context 'initialized with args' do
      it 'should have the base price as given' do
        price_calculator = PriceCalculator.new(3200)
        expect(price_calculator.base_price).to eq(3200)
      end

      it 'should have the mark up list as given' do
        price_calculator = PriceCalculator.new(3200, ['foo', 'bar'])
        expect(price_calculator.mark_ups).to contain_exactly('bar', 'foo')
      end
    end
  end

  describe '.flat_markup' do
    it 'returns the flat markup rate of 5%' do
      expect(PriceCalculator.flat_markup).to eq(5)
    end
  end

  describe '.person_rate' do
    it 'returns the each person rate of 1.2%' do
      expect(PriceCalculator.person_rate).to eq(1.2)
    end
  end

  describe '.material_rate' do
    it 'returns rate of 0% if called with empty material name' do
      expect(PriceCalculator.material_rate).to eq(0)
    end

    it 'returns rate of 7.5% if called with material name associated with pharmaceutical' do
      expect(PriceCalculator.material_rate('drugs')).to eq(7.5)
    end

    it 'returns rate of 13% if called with material name associated with food' do
      expect(PriceCalculator.material_rate('food')).to eq(13)
    end

    it 'returns rate of 2% if called with material name associated with electronics' do
      expect(PriceCalculator.material_rate('television')).to eq(2)
    end

    it 'returns rate of 0.0% if called with material name not associated with any type' do
      expect(PriceCalculator.material_rate('foo')).to eq(0.0)
    end
  end

  describe '#number_of_people' do
    it 'returns the total by adding up all the markups related to number of people working' do
      subject.mark_ups = ['3 people', 'foo', '4 people']
      expect(subject.send(:number_of_people)).to eq(7)
    end

    it 'returns 0 if no related mark ups are given' do
      subject.mark_ups = ['3 polution', 'foo', '4 dums']
      expect(subject.send(:number_of_people)).to eq(0)
    end

    it 'discards ss if negative values are given' do
      subject.mark_ups = ['-3 people', 'foo', '4 people']
      expect(subject.send(:number_of_people)).to eq(4)
    end
  end

  describe '#people_cost' do
    it 'returns the total cost by people working on the job' do
      price_calculator = PriceCalculator.new(12456.95, ['4 people', 'books'])
      expect(price_calculator.send(:people_cost)).to eq(627.830280)
    end

    it 'returns 0 as total cost by people working on the job if no valid mark up is given' do
      price_calculator = PriceCalculator.new(12456.95, ['-2 people', 'books'])
      expect(price_calculator.send(:people_cost)).to eq(0)
    end
  end

  describe '#flat_markup_cost' do
    it 'returns the total flat mark up cost' do
      price_calculator = PriceCalculator.new(12456.95, ['4 people', 'books'])
      expect(price_calculator.send(:flat_markup_cost)).to eq(622.847500)
    end

    it 'returns o as the total flat mark up cost if no base price is given' do
      expect(subject.send(:flat_markup_cost)).to eq(0)
    end
  end

  describe '#materials_cost' do
    it 'returns the total materials mark up cost' do
      price_calculator = PriceCalculator.new(12456.95, ['4 people', 'drugs'])
      expect(price_calculator.send(:materials_cost)).to eq(980.984813)
    end

    it 'returns o as the total materials mark up cost if no chargeable material is given' do
      price_calculator = PriceCalculator.new(12456.95, ['4 people', 'books'])
      expect(price_calculator.send(:materials_cost)).to eq(0)
    end
  end

  describe '#calculated_base_price' do
    it 'returns the total materials mark up cost' do
      subject.base_price = 12456.95
      expect(subject.send(:calculated_base_price)).to eq(13079.797500)
    end
  end

  describe '#calculate' do
    it 'responds to calculate method' do
      expect(subject).to respond_to(:calculate)
    end

    it 'returns the base price with flat markup if no other markups are assigned' do
      subject.base_price = 2300.00
      expect(subject.calculate).to eq(2415.00)
    end

    it 'adds up people charges of 1.2% on top of base price with flat charges' do
      price_calculator = PriceCalculator.new(1000.00, ['2 people'])
      expect(price_calculator.calculate).to eq(1075.20)
    end

    it 'adds up people charges of 1.2% on top of base price with flat charges plus pharmaceutical material rate' do
      price_calculator = PriceCalculator.new(5432.00, ['1 person', 'drugs'])
      expect(price_calculator.calculate).to eq(6199.81)
    end

    it 'adds up people charges of 13% on top of base price with flat charges plus food material rate' do
      price_calculator = PriceCalculator.new(1299.99, ['3 person', 'food'])
      expect(price_calculator.calculate).to eq(1591.58)
    end

    it 'adds up people charges of 1.2% on top of base price with flat charges and no rate if unknown material is used' do
      price_calculator = PriceCalculator.new(12456.95, ['4 people', 'books'])
      expect(price_calculator.calculate).to eq(13707.63)
    end
  end
end