# get_phone_number

Get Phone Number from Android Native

#### Warning: This library works in only android.

## Usage

#### Simple function
```
    String phoneNumber = await GetPhoneNumber().getWithGetPermission();
```

#### Detailed function with android permission
```
    if (!await GetPhoneNumber().hasPermission()) {
      if (!await GetPhoneNumber().requestPermission()) {
        throw 'Failed to get permission phone number';
      }
    }

    String phoneNumber = await GetPhoneNumber().get();
    print('getPhoneNumber result: $phoneNumber');
```