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
      expect(subject.number_of_people).to eq(7)
    end

    it 'returns 0 if no related mark ups are given' do
      subject.mark_ups = ['3 polution', 'foo', '4 dums']
      expect(subject.number_of_people).to eq(0)
    end

    it 'discards if negative values are given' do
      subject.mark_ups = ['-3 people', 'foo', '4 people']
      expect(subject.number_of_people).to eq(4)
    end
  end
end