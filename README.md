# get_phone_number

Get Phone Number from Android Native

#### Warning: This library works in only android.

## Usage

#### Simple function
```
    String phoneNumber = await GetPhoneNumber().get();

    print('getPhoneNumber result: $phoneNumber');
```

#### List of phone number
```
    List<String> list = await GetPhoneNumber().getListPhoneNumber();

    print('getListPhoneNumber result: list');
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

---

<a href="https://www.buymeacoffee.com/sscoach" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
