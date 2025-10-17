# 🧭 Router Setup Documentation

## Current Router Configuration (Option A)

**Last Updated:** October 17, 2025

---

## 📋 Route Structure

```
App Routes:
/                → Root (Auth Check & Redirect)
├── /login       → LoginScreen
├── /register    → RegisterScreen
├── /home        → HomePage
└── /main-screen → HomePage (alias)
```

---

## 🔄 How It Works

### **1. Root Route `/` with Auth Check**

```dart
GoRoute(
  path: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      return '/home';    // User logged in → Go to home
    }
    return '/login';     // User logged out → Go to login
  },
)
```

**Logic Flow:**
```
User opens app (/)
      ↓
Check Firebase Auth
      ↓
User exists?
├─ YES → Redirect to /home
└─ NO  → Redirect to /login
```

---

## 📱 User Experience Flow

### **Scenario 1: New User (Not Logged In)**
```
1. Opens app
2. App checks auth at "/"
3. No user found
4. Redirects to "/login" ✅
5. User sees login screen
```

### **Scenario 2: Returning User (Logged In)**
```
1. Opens app
2. App checks auth at "/"
3. User found in Firebase Auth
4. Redirects to "/home" ✅
5. User sees home page (skips login!)
```

### **Scenario 3: User Logs In**
```
1. On login screen
2. Enters email/password
3. Firebase Auth successful
4. Code: context.go('/main-screen')
5. Shows HomePage ✅
```

### **Scenario 4: User Logs Out**
```
1. On home page
2. Clicks logout button
3. FirebaseAuth.instance.signOut()
4. User manually navigates to login ⚠️
   (Option B would auto-redirect)
```

---

## 🎯 Route Details

| Route | Purpose | Screen | Auth Required |
|-------|---------|--------|---------------|
| `/` | Entry point | None (redirects) | No |
| `/login` | Sign in | LoginScreen | No |
| `/register` | Sign up | RegisterScreen | No |
| `/home` | Main app | HomePage | Yes (recommended) |
| `/main-screen` | Alias for home | HomePage | Yes (recommended) |

---

## ⚙️ Configuration

### **Initial Location**
```dart
initialLocation: "/"
```
- App always starts at root route
- Root route checks auth and redirects

### **Error Handling**
```dart
errorBuilder: (context, state) {
  return Scaffold(
    body: Center(
      child: Text("Page Not Found: ${state.uri}"),
    ),
  );
}
```
- Catches invalid routes
- Shows error page with "Go to Login" button

---

## 📝 Code Snippets

### **Navigate to Login**
```dart
context.go('/login');
// or
GoRouter.of(context).go('/login');
```

### **Navigate to Home**
```dart
context.go('/home');
// or
context.go('/main-screen');  // Same destination
```

### **Navigate to Register**
```dart
context.go('/register');
```

### **Check Current Route**
```dart
final currentRoute = GoRouter.of(context).location;
print('Current route: $currentRoute');
```

---

## 🔐 Authentication Integration

### **How Auth Check Works**

**Firebase Auth State:**
```dart
FirebaseAuth.instance.currentUser
├─ Returns User object if logged in
└─ Returns null if logged out
```

**Router uses this to decide:**
```dart
final user = FirebaseAuth.instance.currentUser;

if (user != null) {
  // User logged in
  return '/home';
} else {
  // User logged out
  return '/login';
}
```

---

## ⚠️ Current Limitations

### **What Works:**
✅ Auto-redirect on app start based on auth
✅ Navigate to home after login
✅ Navigate to register from login
✅ Error page for invalid routes

### **What Needs Improvement:**
⚠️ **No auto-redirect after logout** - User stays on home page
⚠️ **No real-time auth updates** - Only checks on app start
⚠️ **Manual navigation required** after auth changes

### **Why These Limitations?**

Option A uses **static redirect** which:
- Only runs when navigating to "/"
- Doesn't listen to auth state changes
- Requires manual navigation after login/logout

**Solution:** Upgrade to **Option B (Auth Gate with Streaming)** for:
- ✅ Real-time auth state monitoring
- ✅ Auto-redirect on login/logout
- ✅ Better user experience

---

## 🚀 Future Improvements (Option B)

```dart
// Auth Gate with StreamBuilder
GoRoute(
  path: '/',
  builder: (context, state) => StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return HomePage();     // Logged in
      }
      return LoginScreen();    // Logged out
    },
  ),
),
```

**Benefits over Option A:**
- ✅ Real-time updates
- ✅ Automatic logout redirect
- ✅ No manual navigation needed
- ✅ Better security

---

## 🧪 Testing Your Routes

### **Test 1: App Start (Logged Out)**
```
1. Sign out if logged in
2. Close and reopen app
3. Should show login screen ✅
```

### **Test 2: App Start (Logged In)**
```
1. Log in first
2. Close and reopen app
3. Should show home page ✅
```

### **Test 3: Invalid Route**
```
1. Type invalid URL: /fake-page
2. Should show error page ✅
```

### **Test 4: Login Flow**
```
1. On login screen
2. Enter credentials
3. Should navigate to home ✅
```

### **Test 5: Register Flow**
```
1. Click "Sign up" on login
2. Should navigate to register ✅
3. Complete registration
4. Should navigate to home ✅
```

---

## 📊 Comparison: Before vs After

| Feature | Before | After (Option A) |
|---------|--------|------------------|
| **Initial route** | `/login` | `/` (checks auth) |
| **Logged in user** | Still sees login | Goes to home ✅ |
| **Logged out user** | Sees login ✅ | Sees login ✅ |
| **After logout** | Stays on home ⚠️ | Stays on home ⚠️ |
| **Auto-redirect** | No | On app start only |

---

## 💡 Best Practices

1. **Always use root route `/` as entry point**
2. **Check auth state for protected routes**
3. **Provide manual navigation fallbacks**
4. **Show loading state during auth check**
5. **Handle error routes gracefully**

---

## 🐛 Troubleshooting

### **Problem: Stuck on login even though logged in**
**Solution:** 
- Clear app data
- Check FirebaseAuth.instance.currentUser
- Verify initialLocation is "/"

### **Problem: Error page shows for valid routes**
**Solution:**
- Check route path spelling
- Verify import statements
- Ensure widget exists

### **Problem: After logout, still on home page**
**Solution:**
- Manually navigate: `context.go('/login')`
- Or upgrade to Option B for auto-redirect

---

## 📚 Resources

- GoRouter Documentation: https://pub.dev/packages/go_router
- Firebase Auth: https://firebase.google.com/docs/auth
- Flutter Navigation: https://docs.flutter.dev/ui/navigation

---

**Implementation:** Option A - Root Route with Redirect
**Status:** ✅ Implemented and Working
**Next Upgrade:** Option B - Auth Gate with Streaming (for real-time updates)
