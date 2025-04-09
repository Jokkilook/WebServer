import pandas as pd

# 엑셀 파일 경로
file_path = 'schools.xlsx'

# 엑셀 파일 읽기
df = pd.read_excel(file_path)

# 테이블명 예시
table_name = 'school'

# 중복 방지를 위한 집합
seen_schools = set()

# INSERT 문 생성
insert_statements = []
for index, row in df.iterrows():
    school_name = row['name']
    url = row['url']

    # 이미 본 학교면 건너뛰기
    if school_name in seen_schools:
        continue

    seen_schools.add(school_name)

    # URL이 www로 시작하면 https:// 붙이기
    if isinstance(url, str) and url.startswith('www.'):
        url = 'https://' + url

    insert_sql = f"INSERT INTO {table_name} (name, url) VALUES ('{school_name}', '{url}');"
    insert_statements.append(insert_sql)

# 결과 출력
for stmt in insert_statements:
    print(stmt)