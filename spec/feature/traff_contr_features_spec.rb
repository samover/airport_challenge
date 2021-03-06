describe 'Traffic controller features' do
  let(:plane) { Plane.new }
  let(:airport) { Airport.new }
  before { allow(airport.weather).to receive(:stormy?).and_return(false) }

  feature 'a traffic controller can instruct a plane' do
    scenario 'to land' do
      expect(plane).to respond_to(:land)
    end
    scenario 'to take off' do
      expect(plane).to respond_to(:take_off)
    end
  end

  feature 'a traffic controller can prevent planes from' do
    scenario 'landing when airport is full' do
      msg = 'Airport is full'
      Airport::DEFAULT_CAPACITY.times { airport.clear_for_landing Plane.new }
      expect { airport.clear_for_landing plane }.to raise_error(msg)
    end

    scenario 'landing when weather is stormy' do
      msg = 'Weather is stormy'
      allow(airport.weather).to receive(:stormy?).and_return(true)
      expect { airport.clear_for_landing plane }.to raise_error(msg)
    end

    scenario 'taking off when weather is stormy' do
      msg = 'Weather is stormy'
      allow(airport.weather).to receive(:stormy?).and_return(true)
      expect { airport.clear_for_takeoff plane }.to raise_error(msg)
    end

    scenario 'taking off when not registered at airport' do
      msg = 'Plane not registered at this airport'
      expect { airport.clear_for_takeoff plane }.to raise_error(msg)
    end
  end
end
