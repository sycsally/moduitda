-- 연락처 폼 메시지를 저장하는 테이블
-- Supabase 대시보드 > SQL Editor에 붙여넣고 Run 하세요. (한 번만 실행)

create table if not exists public.messages (
  id         uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name       text not null check (char_length(name) between 1 and 50),
  email      text check (email is null or char_length(email) <= 200),
  message    text not null check (char_length(message) between 1 and 2000)
);

-- RLS: 방문자는 메시지를 "보내기"만 할 수 있고, 남이 쓴 메시지는 읽을 수 없습니다.
-- 받은 메시지는 대시보드 Table Editor에서 확인하세요.
alter table public.messages enable row level security;

drop policy if exists "Anyone can send a message" on public.messages;
create policy "Anyone can send a message"
  on public.messages
  for insert
  to anon, authenticated
  with check (true);

grant insert on public.messages to anon, authenticated;
