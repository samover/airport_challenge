require 'airport'

describe Airport do
  subject(:airport) { described_class.new(Airport::DEFAULT_CAPACITY, weather) }
  let(:plane) { double(:plane, land: true, take_off: true) }
  let(:weather) { double(:weather, stormy?: false) }

  context 'when initializing' do
    it 'has a default capacity' do
      expect(airport.capacity).to eq Airport::DEFAULT_CAPACITY
    end
    it 'which can be overridden' do
      airport = Airport.new(50)
      expect(airport.capacity).to eq 50
    end
  end

  context '#full?' do
    it 'prevent planes from landing' do
      msg = 'Airport is full'
      Airport::DEFAULT_CAPACITY.times { airport.clear_for_landing plane }
      expect{ airport.clear_for_landing plane }.to raise_error(msg)
    end
  end

  context '#stormy?' do
    let(:weather) { double(:weather, stormy?: true) }

    it 'prevent planes from landing' do
      msg = 'Weather is stormy'
      expect { airport.clear_for_landing plane }.to raise_error(msg)
    end

    it 'prevent planes from taking off' do
      msg = 'Weather is stormy'
      expect { airport.clear_for_landing plane }.to raise_error(msg)
    end
  end

  context 'not #registered?' do
    it 'plane cannot take off' do
      msg = 'Plane not registered at this airport'
      expect { airport.clear_for_takeoff plane }.to raise_error(msg)
    end
  end

  context 'registers and unregisters planes' do
    it 'after landing' do
      airport.clear_for_landing plane
      expect(airport.planes).to include plane
    end
    it 'after takeoff' do
      airport.clear_for_landing plane
      airport.clear_for_takeoff plane
      expect(airport.planes).not_to include plane
    end
  end
end
