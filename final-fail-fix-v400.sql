-- Final fail button fix v400
-- Stores fail count directly on weekly_assignments, which already updates successfully.

alter table public.weekly_assignments
add column if not exists fail_count int not null default 0;

-- Backfill from old fail_counts table if any values exist.
with totals as (
  select assignment_id, coalesce(sum(fail_count), 0)::int as total_fail
  from public.fail_counts
  group by assignment_id
)
update public.weekly_assignments wa
set fail_count = totals.total_fail
from totals
where wa.id = totals.assignment_id;

-- Optional safety: never allow negative fail counts.
alter table public.weekly_assignments
drop constraint if exists weekly_assignments_fail_count_nonnegative;

alter table public.weekly_assignments
add constraint weekly_assignments_fail_count_nonnegative
check (fail_count >= 0);

notify pgrst, 'reload schema';

select 'final fail button fix v400 installed' as status;
