# Firestore Composite Indexes Required

To enable server-side filtering by user and date, the following composite indexes must be created in the Firebase Console:

### 1. Expenses Collection
- **Field Path**: `userId` (Ascending)
- **Field Path**: `date` (Descending)
- **Query Scope**: Collection

### 2. Income Collection
- **Field Path**: `userId` (Ascending)
- **Field Path**: `date` (Descending)
- **Query Scope**: Collection

### 3. Expenses by Category (Optional but recommended)
- **Field Path**: `userId` (Ascending)
- **Field Path**: `category` (Ascending)
- **Field Path**: `date` (Descending)
- **Query Scope**: Collection

---
**Note**: If these indexes are not created, Firestore queries using `where('userId', ...)` and `orderBy('date', ...)` will fail with an error providing a direct link to create the index.
