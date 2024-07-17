# Madcamp Week03: 넙죽아 죽이 짜다

맛있는 메뉴 좀 알려줘봐

## 프로젝트 소개

넙죽아 죽이 짜다는 카이스트에서 먹는 학식 정보를 각각의 메뉴의 별점과 함께 표시해 주는 앱입니다.

선택한 날의 학식을 자신이 좋아하는 음식 정보와 알레르기 정보를 통해 자동으로 추천해줍니다.

매일 반복되는 식사 시간, 더 이상 메뉴로 고민하지 마세요!

## 개발환경

### FrontEnd

Tool: Flutter

IDE: Android Studio

### BackEnd

Tool: Node.js

Server: AWS EC2

DB: MySQL, EC2 인스턴스 내부 설치

## 팀원 소개

- 김원중(카이스트 전산학부 20): https://github.com/wjhjkim
- 김진환(카이스트 전기및전자공학부 20):   https://github.com/kimjinhwan0

## 프로젝트 구조: 프론트엔드

### 1. 로그인 페이지

- 아이디와 비밀번호를 통해 로그인할 수 있습니다.
    - 로그인 이후 서버에서 jwt 토큰을 생성해 앱을 다시 실행할 때 자동으로 로그인됩니다.
- 회원가입을 통해 아이디와 비밀번호를 생성할 수 있습니다.
    
https://github.com/user-attachments/assets/b11d1d2e-b478-4a89-bea9-8876219444e1
    

### 2. 메인 메뉴 페이지

- 지금 시간대에 먹을 수 있는 학식 메뉴를 확인할 수 있습니다.
- 사용자의 좋아하는 메뉴와 알레르기 정보에 기인하여 학식 메뉴를 추천해줍니다.
    - 학식 메뉴는  1. 알레르기 정보, 2. 좋아하는 메뉴 순으로 정렬됩니다.
    
https://github.com/user-attachments/assets/30d5b347-c82e-4b89-b614-1c1633c42d8c
    

### 3. 메뉴 상세 페이지

- 선택한 메뉴 안의 반찬들의 별점과 하트 정보를 보여줍니다.
- 각 메뉴를 눌러 상세 페이지로 이동할 수 있습니다.
- 사용자가 설정한 알레르기 이름이 빨간색으로 표시됩니다.
    
https://github.com/user-attachments/assets/9fa6a330-24ee-4a06-ab51-cc3601b683af
    

### 4. 음식 상세 페이지

- 선택한 음식의 별점과 하트 정보를 보여줍니다.
- 음식의 리뷰를 확인할 수 있습니다.
- 사용자가 설정한 알레르기의 번호가 빨간색으로 표시됩니다.

https://github.com/user-attachments/assets/1a9799cf-4b1a-4439-8860-2533e138f16c

### 5. 마이 페이지

- 아래의 세 메뉴로 이동할 수 있는 화면을 보여줍니다.
    
https://github.com/user-attachments/assets/74006e59-98af-46b6-a757-b8a08a7cd237
    

### 6. 좋아하는 메뉴 확인 페이지

- 자신이 하트를 누른 음식들을 확인할 수 있는 페이지입니다.
- 카드를 누르면 음식 상세 페이지로 이동합니다.
    
https://github.com/user-attachments/assets/beaca0c0-a298-45d6-891b-bf2e2efb3290
    

### 7. 알레르기 설정 페이지

- 사용자의 알레르기 정보를 설정할 수 있습니다.
- SharedReference 패키지를 통해 앱을 종료해도 데이터를 저장합니다.
    
https://github.com/user-attachments/assets/523338da-883b-486a-bee5-b52eaf3840b3
    

### 8. 자신의 리뷰 확인 페이지

- 사용자가 쓴 리뷰를 확인할 수 있습니다.
    
https://github.com/user-attachments/assets/66ccbb13-a8aa-4f5c-965d-be0fdb7fff4c
    

### 9. 그날의 메뉴 확인 페이지

- 선택된 날의 여러 시간대와 장소의 메뉴들을 한눈에 보여줍니다.
    
https://github.com/user-attachments/assets/64341076-0eb4-48df-b054-c6c4aa2b4f37
    

### 10. 월별 식단표 확인 페이지

- 원하는 날짜와 장소를 골라 그날의 식단을 한눈에 확인할 수 있습니다.
    
https://github.com/user-attachments/assets/e4e5c272-266e-4b1f-8c31-c875696a2a26

    

### 11. 리뷰 작성 페이지

- 원하는 날짜와 장소, 시간대의 원하는 메뉴를 골라 별점과 리뷰를 남길 수 있습니다.
    
https://github.com/user-attachments/assets/057a582f-2fe8-4c2d-afa4-034686ce82db

## APK 파일 링크

https://drive.google.com/file/d/1r7fUuopOJ_jinPeOGySVRLw_fwiMB331/view?usp=sharing
