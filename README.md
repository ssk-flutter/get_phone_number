# get_phone_number

Get Phone Number from Android Native

#### Warning: This library works in only android.

## Usage

#### Simple function
```
    String phoneNumber = await GetPhoneNumber().get();

    print('getPhoneNumber result: $phoneNumber');
```

#### Detailed function with android permissions
```
    final module = GetPhoneNumber();

    if (!module.isSupport()) {
        print('Not supported platform');
    }

    if (!await module.hasPermission()) {
      if (!await module.requestPermission()) {
        throw 'Failed to get permission phone number';
      }
    }

    String phoneNumber = await module.getPhoneNumber();
    print('getPhoneNumber result: $phoneNumber');
```