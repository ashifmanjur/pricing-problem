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
end