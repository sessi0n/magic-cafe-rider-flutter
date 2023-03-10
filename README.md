# rider_adventure

Rider Adventure

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## DB 모양
user > profile data > 바이크 데이터는 하나 table 로 퉁
user background img > 따로 table. 많이 호출됨
quest picture img > json list table > 따로 할 필욘없을듯? > 클릭 했을때와 분리하려면 해야함
user > quest > 수락, 완료, 발주 한 퀘스트에 대해서는 따로 해야함 > 따로 많이 호출됨
quest table 엔 isDeleted 가 있어야함. 삭제 가능하므로
퀘스트는 수락한 사람이 1있다면 삭제 불가
퀘스트 난이도는 완료하는 시점에 쉬움/중간/어려움 선택
