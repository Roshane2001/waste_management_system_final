// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDwZSR1zh35S24z5LtLpou6ADdgwTIXrgY",
  authDomain: "wastemanagementsystem-17ac5.firebaseapp.com",
  projectId: "wastemanagementsystem-17ac5",
  storageBucket: "wastemanagementsystem-17ac5.firebasestorage.app",
  messagingSenderId: "432788925979",
  appId: "1:432788925979:web:9df3c2a94fbcc6cfe212be"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase services
const auth = getAuth(app);
const db = getFirestore(app);
const storage = getStorage(app);

// Export the initialized Firebase services
export { auth, db, storage };
export default app; 