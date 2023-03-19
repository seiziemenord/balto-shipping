function initAutocomplete() {
    const input = document.getElementById('address');
    const options = {
      types: ['address'],
    };
  
    const autocomplete = new google.maps.places.Autocomplete(input, options);
    autocomplete.addListener('place_changed', () => {
      const place = autocomplete.getPlace();
      const addressComponents = place.address_components;
  
      for (const component of addressComponents) {
        const types = component.types;
  
        if (types.includes('postal_code')) {
            document.getElementById('zipcode').value = component.long_name;
        } else if (types.includes('locality')) {
          document.getElementById('city').value = component.long_name;
        } else if (types.includes('country')) {
          document.getElementById('country').value = component.long_name;
        }
      }
    });
  }
  
  google.maps.event.addDomListener(window, 'load', initAutocomplete);
  