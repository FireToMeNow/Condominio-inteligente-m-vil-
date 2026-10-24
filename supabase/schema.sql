create extension if not exists pgcrypto;

create type public.user_role as enum ('resident', 'guard', 'administrator');
create type public.report_status as enum ('pending', 'in_review', 'resolved');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  role public.user_role not null default 'resident',
  residence text
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references public.profiles(id) on delete cascade,
  category text not null,
  details text not null,
  evidence_path text,
  evidence_name text,
  evidence_type text,
  status public.report_status not null default 'pending',
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.reports enable row level security;

create policy "Users read their profile"
  on public.profiles for select
  to authenticated
  using (id = auth.uid());

create policy "Users update their profile"
  on public.profiles for update
  to authenticated
  using (id = auth.uid());

create policy "Residents create reports"
  on public.reports for insert
  to authenticated
  with check (
    created_by = auth.uid()
    and exists (
      select 1 from public.profiles
      where id = auth.uid() and role in ('resident', 'guard', 'administrator')
    )
  );

create policy "Users read relevant reports"
  on public.reports for select
  to authenticated
  using (
    created_by = auth.uid()
    or exists (
      select 1 from public.profiles
      where id = auth.uid() and role in ('guard', 'administrator')
    )
  );

create policy "Guards and administrators update reports"
  on public.reports for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles
      where id = auth.uid() and role in ('guard', 'administrator')
    )
  )
  with check (
    exists (
      select 1 from public.profiles
      where id = auth.uid() and role in ('guard', 'administrator')
    )
  );

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.email));
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

insert into storage.buckets (id, name, public)
values ('report-evidence', 'report-evidence', false)
on conflict (id) do nothing;

create policy "Authenticated users upload report evidence"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'report-evidence'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users read their report evidence"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'report-evidence'
    and (
      (storage.foldername(name))[1] = auth.uid()::text
      or exists (
        select 1 from public.profiles
        where id = auth.uid() and role in ('guard', 'administrator')
      )
    )
  );
