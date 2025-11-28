# 개발 진행 이슈 해결 노트

---
##  1. admin 계정 삭제 문제

문제 상황: 프로젝트 개발 테스트 중 유일한 admin 계정을 삭제하여 admin 패널에 접속이 불가능한 상황이 발생하였다. 
해결 방법: 


### 가. 실행중인 컨테이너 목록에서 이름과 ID 확인
```
docker ps
```
### 나. 기존 keycloak db 백업

```bash
docker-compose exec keycloak-db pg_dump -U keycloak keycloak > keycloak_backup.sql
```
백업 후 백업 파일은 기본적으로 UTF-16 LE이기에 UTF-8로 선택 후 저장해야한다. (notepad 또는 vsc 우측하단에서 변환)

### 다. 백업 파일 DB 컨테이너 내부 임시 폴더로 복사
인코딩이 변환된 백업 파일을 DB 컨테이너 내부의 임시 폴더로 복사합니다.
```bash
docker cp .\keycloak_backup.sql <DB컨테이너명>:/tmp/backup.sql
```

### 라. 
Keycloak이 실행되면서 DB 테이블을 자동으로 생성하면 복구 시 충돌이 발생합니다. Keycloak만 잠시 끕니다.
```bash
docker stop <Keycloak컨테이너명>
```

### 마. 기본 생성 데이터 초기화(DB 초기화)
Keycloak이 이미 만들어둔 테이블과 데이터를 강제로 초기화하여 "빈 DB" 상태로 만듭니다.
```bash
docker exec -it <DB컨테이너명> psql -U keycloak -d keycloak -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
```

### 바. 백업 파일 빈 DB에 밀어 넣기 
준비된 백업 파일을 빈 DB에 밀어 넣습니다.
```bash
docker exec -it <DB컨테이너명> psql -U keycloak -d keycloak -f /tmp/backup.sql
```
### 사. admin 재설정 유도를 위해 admin 삭제
Master Realm 유저 삭제 (Admin 재설정)
복구된 데이터에 옛날 Admin 정보가 남아있을 수 있습니다. Master Realm의 유저를 비워서 Keycloak이 docker-compose.yml의 환경변수를 읽어 Admin을 새로 생성하도록 유도
```bash
docker exec -it <DB컨테이너명> psql -U keycloak -d keycloak -c "DELETE FROM user_entity WHERE realm_id = 'master';"
```
---