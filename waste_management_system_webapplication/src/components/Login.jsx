// Login component for user authentication and role-based navigation
import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { signInWithEmailAndPassword } from 'firebase/auth';
import { doc, getDoc } from 'firebase/firestore';
import { auth, db } from '../config/firebase-config.js';
import './Login.css';
import logo from '../assets/logo.png';

const Login = () => {
  // Hook for programmatic navigation
  const navigate = useNavigate();

  //form data
  const [formData, setFormData] = useState({
    email: '',
    password: '',
  });
  //error messages
  const [error, setError] = useState('');
  //loading status during authentication
  const [loading, setLoading] = useState(false);

  //form input changes
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  // Form validation function
  const validateForm = () => {
    const { email, password } = formData;
    if (!email) return 'Email is required';
    if (!/\S+@\S+\.\S+/.test(email)) return 'Invalid email format';
    if (!password) return 'Password is required';
    return '';
  };

  //submission and authentication
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    // Validate form inputs
    const validationError = validateForm();
    if (validationError) {
      setError(validationError);
      setLoading(false);
      return;
    }

    try {
      // Attempt to sign in with Firebase Auth
      const { email, password } = formData;
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;

      // Fetch user role from Firestore
      const userDoc = await getDoc(doc(db, 'users', user.uid));
      if (!userDoc.exists()) {
        throw new Error('User data not found in Firestore');
      }
      const userData = userDoc.data();
      const role = userData.role;

      // Navigate based on user role
      if (role === 'recycling-center') {
        navigate('/recycling-center');
      } else if (role === 'waste-collection') {
        navigate('/waste-collection');
      } else {
        throw new Error('Invalid user role');
      }
    } catch (error) {
      console.error('Login error:', error);
      // Handle different authentication errors
      switch (error.code) {
        case 'auth/user-not-found':
          setError('No account found with this email.');
          break;
        case 'auth/wrong-password':
          setError('Incorrect password. Please try again.');
          break;
        case 'auth/invalid-email':
          setError('Invalid email address.');
          break;
        case 'auth/too-many-requests':
          setError('Too many attempts. Please try again later.');
          break;
        default:
          setError(error.message || 'Failed to log in. Please try again.');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-container">
      <div className="login-card">
        {/* Login header with logo */}
        <div className="login-header">
          <img src={logo} alt="Waste Management System Logo" className="login-logo" />
          <p>Please login to your account</p>
        </div>

        {/* Error message display */}
        {error && <div className="error-message">{error}</div>}

        {/* Login form */}
        <form onSubmit={handleSubmit} className="login-form">
          {/* Email input field */}
          <div className="form-group">
            <label htmlFor="email">Email</label>
            <input
              type="email"
              id="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              placeholder="Enter your email"
              disabled={loading}
              required
            />
          </div>

          {/* Password input field */}
          <div className="form-group">
            <label htmlFor="password">Password</label>
            <input
              type="password"
              id="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              placeholder="Enter your password"
              disabled={loading}
              required
            />
          </div>

          {/* Form options (Remember me and Forgot password) */}
          <div className="form-options">
            <label className="remember-me">
              <input type="checkbox" disabled={loading} /> Remember me
            </label>
            <Link to="/forgot-password" className="forgot-password">
              Forgot Password?
            </Link>
          </div>

          {/* Submit button */}
          <button type="submit" className="login-button" disabled={loading}>
            {loading ? 'Logging in...' : 'Login'}
          </button>
        </form>

        {/* Registration link */}
        <div className="login-footer">
          <p>
            Don't have an account? <Link to="/register">Sign up</Link>
          </p>
        </div>
      </div>
    </div>
  );
};

export default Login;