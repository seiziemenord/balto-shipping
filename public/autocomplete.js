function initAutocomplete() {
  const input = document.getElementById('address');
  const options = {
    types: ['address'],
  };

  const autocomplete = new google.maps.places.Autocomplete(input, options);
  autocomplete.addListener('place_changed', () => {
    const place = autocomplete.getPlace();
    const addressComponents = place.address_components;

    let newAddress = [];
    let city = '';
    let country = '';
    let zipcode = '';

    for (const component of addressComponents) {
      const types = component.types;
    
      if (types.includes('postal_code')) {
        zipcode = component.long_name;
        document.getElementById('zipcode').value = zipcode;
      } else if (types.includes('locality')) {
        city = component.long_name;
        document.getElementById('city').value = city;
      } else if (types.includes('country')) {
        country = component.long_name;
        document.getElementById('country').value = country;
      } else if (types.includes('street_number') || types.includes('route')) {
        newAddress.push(component.long_name);
      }
    }
    

    // Update the address field with the new address
    input.value = newAddress.join(', ');
  });
}

google.maps.event.addDomListener(window, 'load', initAutocomplete);