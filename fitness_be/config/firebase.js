const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "fitness-tracking-ccf2a.firebasestorage.app"  // Sử dụng tên bucket chính xác từ Firebase Console
});

const bucket = admin.storage().bucket();

// Thêm hàm helper để kiểm tra kết nối
const checkStorageConnection = async () => {
  try {
    console.log('Attempting to connect to bucket:', admin.storage().bucket().name);
    const [files] = await bucket.getFiles({ maxResults: 1 });
    console.log('Firebase Storage connected successfully');
    return true;
  } catch (error) {
    console.error('Firebase Storage connection error:', error);
    console.error('Bucket name being used:', bucket.name);
    return false;
  }
};

module.exports = { admin, bucket, checkStorageConnection }; 