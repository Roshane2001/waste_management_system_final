import {initializeApp} from "firebase/app";
import {getAuth} from "firebase/auth";
import {getFirestore} from 'firebase/firestore';

const firebaseConfig = {
    apiKey: "AIzaSyAmGgQwDGk5gwq0fUcva6MLtvosfc8HIQo",
    authDomain: "waste-management-platform-on.firebaseapp.com",
    projectId: "waste-management-platform-on",
    storageBucket: "waste-management-platform-on.firebasestorage.app",
    messagingSenderId: "907041039473",
    appId: "1:907041039473:web:1f5f4092622f6724f627d0"
};


export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
// const analytics = getAnalytics(app);