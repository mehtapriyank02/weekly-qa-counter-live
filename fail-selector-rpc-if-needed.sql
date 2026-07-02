-- Only run this if fail buttons show an RPC error.
-- This creates the RPC used by the inline fail selector in app.js.

create or replace function public.set_fail_count_exact(
  p_assignment_id uuid,
  p_fail_count int
)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  clean_fail int := 0;
begin
  if p_assignment_id is null then
    raise exception 'Assignment ID is required';
  end if;

  if not exists (
    select 1
    from public.weekly_assignments
    where id = p_assignment_id
  ) then
    raise exception 'Assignment not found';
  end if;

  clean_fail := greatest(coalesce(p_fail_count, 0), 0);

  delete from public.fail_counts
  where assignment_id = p_assignment_id;

  if clean_fail > 0 then
    insert into public.fail_counts (
      assignment_id,
      fail_count,
      created_at,
      updated_at
    )
    values (
      p_assignment_id,
      clean_fail,
      now(),
      now()
    );
  end if;

  return clean_fail;
end;
$$;

grant execute on function public.set_fail_count_exact(uuid, int) to authenticated;

select 'fail selector RPC installed' as status;
