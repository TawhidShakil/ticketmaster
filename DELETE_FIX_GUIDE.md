# Delete Event Fix - Supabase RLS Policy

## Problem

The delete function is not working because Supabase Row Level Security (RLS) policies are blocking the DELETE operation.

## Solution

You need to add a DELETE policy in your Supabase dashboard for the `ticket_events` table.

### Steps to Fix:

1. **Go to Supabase Dashboard**

   - Open your project at https://supabase.com
   - Navigate to: **Authentication** → **Policies**
   - Select the `ticket_events` table

2. **Create a new DELETE policy**

   - Click "New Policy"
   - Choose "Create a policy from scratch"
   - Policy name: `Allow authenticated users to delete events`
   - Operation: **DELETE**
   - Target roles: `authenticated`

3. **Add the policy SQL**

   ```sql
   -- Option 1: Allow all authenticated users to delete
   CREATE POLICY "Allow authenticated delete" ON "public"."ticket_events"
   FOR DELETE
   TO authenticated
   USING (true);
   ```

   **OR** (More secure - only for admins)

   ```sql
   -- Option 2: Only allow specific admin users to delete
   CREATE POLICY "Allow admin delete" ON "public"."ticket_events"
   FOR DELETE
   TO authenticated
   USING (
     auth.jwt() ->> 'email' IN (
       'admin@example.com',  -- Replace with your admin email
       'youradmin@email.com'
     )
   );
   ```

4. **Verify existing policies**
   Make sure you also have these policies enabled:
   - ✅ SELECT policy (for viewing events)
   - ✅ INSERT policy (for uploading events)
   - ✅ UPDATE policy (for editing events)
   - ✅ DELETE policy (for deleting events) ← **This is what's missing!**

### Quick SQL to run in Supabase SQL Editor:

```sql
-- Enable RLS if not already enabled
ALTER TABLE "public"."ticket_events" ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to delete
CREATE POLICY "Allow authenticated delete"
ON "public"."ticket_events"
FOR DELETE
TO authenticated
USING (true);
```

### Testing:

After adding the policy:

1. Hot reload your Flutter app (press 'r' in terminal)
2. Navigate to Delete Events page
3. Try deleting an event
4. Check the debug console for logs showing the delete operation

### Debug Logs:

The updated delete function now shows detailed error messages:

- ✅ "deleted successfully" - Delete worked!
- ❌ "Permission denied. Please check Supabase RLS policies" - RLS policy issue
- ❌ "Authentication error" - User not logged in
- ❌ Other errors will show the specific error message

## Alternative: Disable RLS (NOT RECOMMENDED for production)

```sql
ALTER TABLE "public"."ticket_events" DISABLE ROW LEVEL SECURITY;
```

⚠️ **Warning**: This removes all security and allows anyone to delete data!
