# ☁️ Cloudinary Setup Guide

## Your Cloudinary Credentials
- **Cloud Name:** `dcdjqjcvm`
- **API Key:** `414983313753661`
- **API Secret:** `FJqbKTkvw7yhaK3XJf8nUtiTrns`
- **Dashboard:** https://console.cloudinary.com/

## ✅ Free Tier Benefits
- 🎁 **25 GB Storage** (5x more than Firebase free tier!)
- 🎁 **25 GB Bandwidth/month**
- 🎁 **No credit card required**
- 🎁 **Free forever**

## 🔧 Setup Steps

### Step 1: Create Unsigned Upload Preset (REQUIRED)

**Important:** You MUST create this preset for uploads to work!

1. Go to: https://console.cloudinary.com/settings/upload
2. Scroll to **"Upload presets"** section
3. Click **"Add upload preset"**
4. Configure:
   - **Preset name:** `socially_unsigned`
   - **Signing Mode:** ⚠️ Select **"Unsigned"** (very important!)
   - **Folder:** Leave empty (we'll set dynamically in code)
   - **Access Mode:** Upload
   - Click **Save**

### Step 2: Verify Integration

The following files have been configured:

✅ **pubspec.yaml** - Added `cloudinary_public: ^0.21.0`
✅ **lib/services/cloudinary_service.dart** - Created with your credentials
✅ **lib/views/auth_view/register.dart** - Updated to use Cloudinary

### Step 3: Test Upload

1. Run the app: `flutter run`
2. Go to Register screen
3. Select a profile image
4. Fill the registration form
5. Click "Sign Up"
6. Check Cloudinary Dashboard → Media Library → `profile-images` folder

## 📁 Folder Structure in Cloudinary

```
Media Library/
├── profile-images/     ← User profile pictures
├── post-images/        ← Post/feed images (future)
└── reels/              ← Video reels (future)
```

## 🔒 Security

✅ **Unsigned uploads** - No API secret exposed in client code
✅ **Folder-based organization** - Easy to manage
✅ **Secure HTTPS URLs** - All uploads use https://

## 📊 Monitor Usage

### Check Current Usage
1. Go to: https://console.cloudinary.com/
2. View dashboard to see:
   - Storage used (out of 25GB)
   - Bandwidth used this month (out of 25GB)
   - Number of transformations

### Set Up Alerts
1. Go to **Settings → Usage**
2. Set email alerts at:
   - 80% of storage (20GB)
   - 80% of bandwidth (20GB)

## 💻 Code Usage

### Upload Profile Image
```dart
final imageUrl = await CloudinaryService().uploadImage(
  imageFile,
  'profile-images',
);
```

### Upload Post Image
```dart
final imageUrl = await CloudinaryService().uploadImage(
  imageFile,
  'post-images',
);
```

### Upload Reel/Video
```dart
final videoUrl = await CloudinaryService().uploadVideo(
  videoFile,
  'reels',
);
```

## 🎯 Optimization Tips

1. **Compress images before upload**
   - Reduces storage & bandwidth
   - Faster uploads for users

2. **Use Cloudinary transformations**
   - Resize images on-the-fly
   - Create thumbnails automatically
   - Optimize for different devices

3. **Implement caching**
   - Cache downloaded images
   - Reduce repeated downloads

## 🆚 Comparison: Cloudinary vs Firebase Storage

| Feature | Cloudinary (FREE) | Firebase (Spark Plan) |
|---------|-------------------|----------------------|
| **Storage** | 25 GB | 5 GB |
| **Bandwidth** | 25 GB/month | 1 GB/day (30GB/month) |
| **Credit Card** | ❌ Not required | ✅ Required (Blaze plan) |
| **Image Transformations** | ✅ Included | ❌ Not included |
| **Setup Complexity** | ⚠️ Medium | ✅ Easy |
| **Cost After Free Tier** | Paid plans available | $0.026/GB storage |

## ⚠️ Important Notes

1. **Upload Preset is REQUIRED**
   - Create `socially_unsigned` preset before testing
   - Set signing mode to "Unsigned"

2. **API Secret Security**
   - ⚠️ Never commit API secret to public repos
   - ✅ Using unsigned preset (no secret in client code)

3. **Folder Names**
   - Use lowercase with hyphens: `profile-images`, `post-images`
   - Avoid spaces and special characters

## 🐛 Troubleshooting

### Error: "Invalid upload preset"
**Fix:** Create the unsigned upload preset in Cloudinary dashboard

### Error: "Upload failed"
**Fix:** Check internet connection and Cloudinary dashboard status

### Images not appearing
**Fix:** Verify the returned URL is saved to Firestore correctly

## 📞 Support

- Cloudinary Dashboard: https://console.cloudinary.com/
- Documentation: https://cloudinary.com/documentation
- Status Page: https://status.cloudinary.com/

---

**Last Updated:** October 16, 2025
**Status:** ✅ Configured and Ready (after creating upload preset)
