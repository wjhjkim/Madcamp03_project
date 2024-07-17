# 넙죽아 죽이 짜다

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
    
    [1_로그인화면.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/7e01cbe7-c816-4477-96e4-a1c363906143/1_%EB%A1%9C%EA%B7%B8%EC%9D%B8%ED%99%94%EB%A9%B4.mp4)
    

### 2. 메인 메뉴 페이지

- 지금 시간대에 먹을 수 있는 학식 메뉴를 확인할 수 있습니다.
- 사용자의 좋아하는 메뉴와 알레르기 정보에 기인하여 학식 메뉴를 추천해줍니다.
    - 학식 메뉴는  1. 알레르기 정보, 2. 좋아하는 메뉴 순으로 정렬됩니다.
    
    [2_메인메뉴페이지.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/a9365430-6ebb-4f59-9687-d07e28f6f8a5/2_%EB%A9%94%EC%9D%B8%EB%A9%94%EB%89%B4%ED%8E%98%EC%9D%B4%EC%A7%80.mp4)
    

### 3. 메뉴 상세 페이지

- 선택한 메뉴 안의 반찬들의 별점과 하트 정보를 보여줍니다.
- 각 메뉴를 눌러 상세 페이지로 이동할 수 있습니다.
- 사용자가 설정한 알레르기 이름이 빨간색으로 표시됩니다.
    
    [3_메뉴상세페이지.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/c76c1b3b-8821-4f9a-bd90-4c0b41426e67/3_%EB%A9%94%EB%89%B4%EC%83%81%EC%84%B8%ED%8E%98%EC%9D%B4%EC%A7%80.mp4)
    

### 4. 음식 상세 페이지

- 선택한 음식의 별점과 하트 정보를 보여줍니다.
- 음식의 리뷰를 확인할 수 있습니다.
- 사용자가 설정한 알레르기의 번호가 빨간색으로 표시됩니다.

[]()

### 5. 마이 페이지

- 아래의 세 메뉴로 이동할 수 있는 화면을 보여줍니다.
    
    [5_마이페이지.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/fd83a43f-5e7c-4d62-8667-ccc2aec2bda5/5_%EB%A7%88%EC%9D%B4%ED%8E%98%EC%9D%B4%EC%A7%80.mp4)
    

### 6. 좋아하는 메뉴 확인 페이지

- 자신이 하트를 누른 음식들을 확인할 수 있는 페이지입니다.
- 카드를 누르면 음식 상세 페이지로 이동합니다.
    
    [6_좋아하는거확인.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/dacc852b-6ad7-4266-bb08-b7c4d7200909/6_%EC%A2%8B%EC%95%84%ED%95%98%EB%8A%94%EA%B1%B0%ED%99%95%EC%9D%B8.mp4)
    

### 7. 알레르기 설정 페이지

- 사용자의 알레르기 정보를 설정할 수 있습니다.
- SharedReference 패키지를 통해 앱을 종료해도 데이터를 저장합니다.
    
    [7_알레르기설정.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/c7c4dcf2-218e-42b5-b871-7047ea3fc96d/7_%EC%95%8C%EB%A0%88%EB%A5%B4%EA%B8%B0%EC%84%A4%EC%A0%95.mp4)
    

### 8. 자신의 리뷰 확인 페이지

- 사용자가 쓴 리뷰를 확인할 수 있습니다.
    
    [8_리뷰확인.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/6e6923b1-66d7-489c-809e-c0dbd9a5cd84/8_%EB%A6%AC%EB%B7%B0%ED%99%95%EC%9D%B8.mp4)
    

### 9. 그날의 메뉴 확인 페이지

- 선택된 날의 여러 시간대와 장소의 메뉴들을 한눈에 보여줍니다.
    
    [9_그날의메뉴확인.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/f0f90eaf-4569-4a31-9a25-888af4d7404b/9_%EA%B7%B8%EB%82%A0%EC%9D%98%EB%A9%94%EB%89%B4%ED%99%95%EC%9D%B8.mp4)
    

### 10. 월별 식단표 확인 페이지

- 원하는 날짜와 장소를 골라 그날의 식단을 한눈에 확인할 수 있습니다.
    
    [10_월별식단표.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/c932af33-34e4-41cd-a659-7499de65b8f4/10_%EC%9B%94%EB%B3%84%EC%8B%9D%EB%8B%A8%ED%91%9C.mp4)
    

### 11. 리뷰 작성 페이지

- 원하는 날짜와 장소, 시간대의 원하는 메뉴를 골라 별점과 리뷰를 남길 수 있습니다.
    
    [11_리뷰작성.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/8aaf880b-4b47-4cde-b9dc-42a59efb10bc/11_%EB%A6%AC%EB%B7%B0%EC%9E%91%EC%84%B1.mp4)

## APK 파일 링크
