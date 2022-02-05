# cellphone-locator

A Flutter project made for locating a cellphone with a cellphone.

# System Requirements

- flutter sdk: ">=2.11.0 <3.0.0"

## Istallation instructions

### Receiver side

- rename receiver/env.example.dart to receiver/env.dart
- change the value of senderNumber from env.dart to the number of the phone you're using as sender.
- cd into receiver
- run 'flutter pub dev'
- run 'flutter run'

### Sender side

- rename sender/env.example.dart to sender/env.dart
- change the value of receiverNumber from env.dart to the number of the phone you're using as receiver.
- cd into sender
- run 'flutter pub dev'
- run 'flutter run'


## how it works

The app is separated in two parts. Sender and Receiver.

Receiver stays in the cellphone that is going to be located.
Sender stays in the cellphone that is going to locate.

The main idea behind the app is that first the sender send a SMS with a especific code to the receiver.
Who evaluates if the code is correct and if the number who sent the SMS is the right one.
If both conditions are validated. The receiver sends back a SMS to the sender with the current location of itself.
After the location is received by the sender. It shows the location on map with the usage of the google maps package.