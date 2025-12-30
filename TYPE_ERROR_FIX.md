# ✅ Delete Event Type Error - FIXED!

## Problem

```
TypeError: "d806c0b8-89fc-4330-8502-e9f93ea31fc7": type 'String' is not a subtype of type 'int'
```

## Root Cause

The `ticket_events` table in Supabase uses **UUID (String)** for the `id` column, but the `deleteEvent` function was expecting an **integer** parameter.

## Solution Applied

Changed the `deleteEvent` function parameter type from `int` to `dynamic`:

### Before:

```dart
Future<void> deleteEvent(int eventId, String eventName) async {
```

### After:

```dart
Future<void> deleteEvent(dynamic eventId, String eventName) async {
```

## Why `dynamic`?

- Handles both String UUIDs and integer IDs
- More flexible for different database schemas
- The `.eq('id', eventId)` query works with any type

## File Changed

- `lib/admin/delete_event.dart` - Line 44

## Status

✅ **FIXED** - The delete function will now accept UUID strings from your Supabase database

## Next Steps

1. **Hot restart** your Flutter app (press `R` in the terminal)
2. Navigate to **Delete Events** page
3. Try deleting an event
4. If you still get permission errors, follow the **DELETE_FIX_GUIDE.md** to add Supabase RLS policies

## Note

The signup.dart errors are unrelated to the delete functionality and were pre-existing issues.
