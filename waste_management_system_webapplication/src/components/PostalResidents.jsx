// PostalResidents component for managing and viewing residents by postal code
import React, { useEffect, useState } from 'react';
import './PostalResidents.css';
import { collection, getDocs, query, where } from "firebase/firestore";
import { db } from "../config/firebase-config.js";

const PostalResidents = () => {
    // Reference to the residents collection in Firestore
    const residentsCollectionRef = collection(db, 'residents');

    const [postalCodes, setPostalCodes] = useState([]);
    const [selectedPostalCode, setSelectedPostalCode] = useState('');
    const [postalCodeMessage, setPostalCodeMessage] = useState('');
    const [showMessageModal, setShowMessageModal] = useState(false);
    const [filteredResidents, setFilteredResidents] = useState([]);

    // Effect to fetch all unique postal codes when component
    useEffect(() => {
        const fetchPostalCodes = async () => {
            const snapshot = await getDocs(residentsCollectionRef);
            const codesSet = new Set();
            snapshot.forEach(doc => {
                const data = doc.data();
                if (data.postalCode) {
                    codesSet.add(data.postalCode);
                }
            });
            setPostalCodes(Array.from(codesSet));
        };

        fetchPostalCodes();
    }, []);

    // Function to fetch residents by postal code
    const getResidentsByPostalCode = async (postalCode) => {
        if (!postalCode) return;
        const q = query(residentsCollectionRef, where("postalCode", "==", postalCode));
        const snapshot = await getDocs(q);
        const residents = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        setFilteredResidents(residents);
    };

    // Effect to update filtered residents when postal code changes
    useEffect(() => {
        if (selectedPostalCode) {
            getResidentsByPostalCode(selectedPostalCode);
        } else {
            setFilteredResidents([]);
        }
    }, [getResidentsByPostalCode, selectedPostalCode]);

    // Handler for sending messages to residents
    const handleSendMessage = () => {
        alert(`Message sent to residents in postal code ${selectedPostalCode}`);
        setShowMessageModal(false);
        setPostalCodeMessage('');
    };

    return (
        <div className="postal-residents">
            <h2>Postal Code Residents List</h2>

            {/* Postal Code Selection Section */}
            <div className="postal-code-selection">
                <select
                    value={selectedPostalCode}
                    onChange={(e) => setSelectedPostalCode(e.target.value)}
                    className="postal-code-select"
                >
                    <option value="">Select Postal Code</option>
                    {postalCodes.map(code => (
                        <option key={code} value={code}>{code}</option>
                    ))}
                </select>

                {/* Message Button - Only shown when a postal code is selected */}
                {selectedPostalCode && (
                    <button
                        className="send-message-btn"
                        onClick={() => setShowMessageModal(true)}
                    >
                        Send Message to Residents
                    </button>
                )}
            </div>

            {/* Residents List Section - Only shown when a postal code is selected */}
            {selectedPostalCode && (
                <div className="residents-list">
                    <h3>Residents in {selectedPostalCode}</h3>
                    <table className="data-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Address</th>
                                <th>Phone</th>
                                <th>Email</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredResidents.map(resident => (
                                <tr key={resident.id}>
                                    <td>{resident.name}</td>
                                    <td>{resident.address}</td>
                                    <td>{resident.phone}</td>
                                    <td>{resident.email}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}

            {/* Message Modal - For sending messages to residents */}
            {showMessageModal && (
                <div className="modal-overlay">
                    <div className="modal-content">
                        <h3>Send Message to Residents in {selectedPostalCode}</h3>
                        <div className="message-form">
                            <textarea
                                value={postalCodeMessage}
                                onChange={(e) => setPostalCodeMessage(e.target.value)}
                                placeholder="Enter your message here..."
                                rows="6"
                                className="message-input"
                            />
                            <div className="modal-actions">
                                <button
                                    className="action-btn save"
                                    onClick={handleSendMessage}
                                    disabled={!postalCodeMessage.trim()}
                                >
                                    Send Message
                                </button>
                                <button
                                    className="action-btn cancel"
                                    onClick={() => {
                                        setShowMessageModal(false);
                                        setPostalCodeMessage('');
                                    }}
                                >
                                    Cancel
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default PostalResidents; 