# kotrain

A new Flutter project.

## Getting Started

flutter run

flutter devices

flutter emulators --launch {emulator_id}

flutter build apk --release

install dependencies in pubspe.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  http: ^0.13.4
```


flutter run 할때
devices가 잘 안잡힌다면
adb환경변수를 잘 잡아줄것 : platfoms-tool