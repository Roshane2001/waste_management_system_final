/**
 * Register Component
 * 
 * This component handles user registration for the waste management system.
 * It provides a form for new users to create an account and select their role
 * (waste collection center or recycling center).
 */

import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Register.css';

/**
 * Register Component
 * 
 * @returns {JSX.Element} The rendered registration form
 */
const Register = () => {
    // State for form inputs
    const [formData, setFormData] = useState({
        name: '',
        email: '',
        password: '',
        confirmPassword: '',
        role: 'waste-collection', // Default role
    });
    const [error, setError] = useState('');

    // Hook for programmatic navigation
    const navigate = useNavigate();

    /**
     * Handles input changes
     * 
     * @param {Event} e - The input change event
     */
    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prevState => ({
            ...prevState,
            [name]: value
        }));
    };

    /**
     * Handles form submission
     * 
     * @param {Event} e - The form submission event
     */
    const handleSubmit = (e) => {
        e.preventDefault();

        // Basic validation
        if (!formData.name || !formData.email || !formData.password || !formData.confirmPassword) {
            setError('Please fill in all fields');
            return;
        }

        if (formData.password !== formData.confirmPassword) {
            setError('Passwords do not match');
            return;
        }

        // For demo purposes, registration is successful
        // In production, this would send data to a backend
        navigate('/');
    };

    return (
        <div className="register-container">
            <div className="register-box">
                <h1>Waste Management System</h1>
                <h2>Register</h2>

                {error && <div className="error-message">{error}</div>}

                <form onSubmit={handleSubmit}>
                    <div className="form-group">
                        <label htmlFor="name">Full Name</label>
                        <input
                            type="text"
                            id="name"
                            name="name"
                            value={formData.name}
                            onChange={handleChange}
                            placeholder="Enter your full name"
                        />
                    </div>

                    <div className="form-group">
                        <label htmlFor="email">Email</label>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            value={formData.email}
                            onChange={handleChange}
                            placeholder="Enter your email"
                        />
                    </div>

                    <div className="form-group">
                        <label htmlFor="password">Password</label>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            value={formData.password}
                            onChange={handleChange}
                            placeholder="Enter your password"
                        />
                    </div>

                    <div className="form-group">
                        <label htmlFor="confirmPassword">Confirm Password</label>
                        <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            value={formData.confirmPassword}
                            onChange={handleChange}
                            placeholder="Confirm your password"
                        />
                    </div>

                    <div className="form-group">
                        <label htmlFor="role">Role</label>
                        <select
                            id="role"
                            name="role"
                            value={formData.role}
                            onChange={handleChange}
                        >
                            <option value="waste-collection">Waste Collection Center</option>
                            <option value="recycling-center">Recycling Center</option>
                        </select>
                    </div>

                    <button type="submit" className="register-btn">Register</button>
                </form>

                <p className="login-link">
                    Already have an account? <a href="/">Login</a>
                </p>
            </div>
        </div>
    );
};

export default Register; 