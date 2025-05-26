// Collections component for managing waste collection schedules and operations
import React, { useEffect, useState, useMemo } from 'react'
import { addSchedule, deleteSchedule, fetchSchedules, updateSchedule } from "../../utils/collections.js";
import { collection, getDocs, query, where } from "firebase/firestore";
import { db } from "../../config/firebase-config.js";
import { getVehicles } from "../../utils/vehicles.js";

const Collections = () => {
    // Reference to the vehicles collection in Firestore
    const vehiclesCollectionRef = collection(db, 'vehicles');

    // State of storing all collection schedules
    const [collections, setCollections] = useState([]);
    // State of storing available vehicles for assignment
    const [availableVehicles, setAvailableVehicles] = useState([]);
    // State of controlling new collection form visibility
    const [showNewCollectionForm, setShowNewCollectionForm] = useState(false);
    // State of new collection form data
    const [newCollectionData, setNewCollectionData] = useState({
        location: '',
        date: '',
        time: '',
        status: 'Scheduled',
        wasteType: 'Mixed',
        assignedVehicle: '',
    });
    // State for tracking which collection is being edited
    const [editingCollection, setEditingCollection] = useState(null);
    // State for edit form data
    const [editFormData, setEditFormData] = useState({
        location: '',
        date: '',
        time: '',
        status: '',
        wasteType: '',
        vehicleNumber: '',
        notes: ''
    });
    const [searchQuery, setSearchQuery] = useState('');
    const [loading, setLoading] = useState(false);

    // Load collection schedules when component mounts
    useEffect(() => {
        const loadData = async () => {
            const data = await fetchSchedules();
            setCollections(data);
        };
        loadData();
    }, []);

    // Function to fetch active vehicles from the database
    const fetchActiveVehicles = async () => {
        try {
            const vehicles = await getVehicles();
            const activeVehicles = vehicles.filter(vehicle =>
                vehicle.status && vehicle.status.toLowerCase() === 'active'
            );
            setAvailableVehicles(activeVehicles);
        } catch (error) {
            console.error("Error fetching vehicles:", error);
        }
    };

    // Fetch available vehicles when editing starts or new form opens
    useEffect(() => {
        fetchActiveVehicles();
    }, [editingCollection, showNewCollectionForm]);

    // Handler for submitting new collection schedule
    const handleNewCollectionSubmit = async () => {
        if (!newCollectionData.location || !newCollectionData.date || !newCollectionData.time || !newCollectionData.assignedVehicle) {
            alert('Please fill in all required fields');
            return;
        }

        const newItem = await addSchedule(newCollectionData);
        setCollections(prev => [...prev, newItem]);
        setShowNewCollectionForm(false);
        // Reset form data after successful submission
        setNewCollectionData({ location: '', date: '', time: '', status: 'Scheduled', wasteType: 'Mixed', assignedVehicle: '' });
    };

    // Handler for initiating collection edit
    const handleEditClick = (collection) => {
        setEditingCollection(collection.id);
        setEditFormData({ ...collection });
    };

    // Handler for submitting collection edits
    const handleEditFormSubmit = async (id) => {
        await updateSchedule(id, editFormData);
        setCollections(prev =>
            prev.map(c => (c.id === id ? { ...c, ...editFormData } : c))
        );
        setEditingCollection(null);
    };

    // Handler for deleting a collection schedule
    const handleDeleteClick = async (id) => {
        await deleteSchedule(id);
        setCollections(prev => prev.filter(c => c.id !== id));
    };

    //filtered collections based on search query
    const filteredCollections = useMemo(() => {
        return collections.filter(collection =>
            collection.location?.toLowerCase().includes(searchQuery.toLowerCase()) ||
            collection.vehicleNumber?.toLowerCase().includes(searchQuery.toLowerCase()) ||
            collection.status?.toLowerCase().includes(searchQuery.toLowerCase()) ||
            collection.wasteType?.toLowerCase().includes(searchQuery.toLowerCase()) ||
            (collection.notes && collection.notes.toLowerCase().includes(searchQuery.toLowerCase()))
        );
    }, [collections, searchQuery]);

    return (
        <div className="collections">
            <h2>Collections Management</h2>

            {/* Collection Statistics */}
            <div className="stats-cards">
                <div className="stat-card">
                    <div className="stat-icon">🗑️</div>
                    <div className="stat-info">
                        <h3>Total Collections</h3>
                        <p className="stat-value">{collections.length}</p>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon">✅</div>
                    <div className="stat-info">
                        <h3>Completed</h3>
                        <p className="stat-value">{collections.filter(c => c.status === 'Completed').length}</p>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon">⏳</div>
                    <div className="stat-info">
                        <h3>Pending</h3>
                        <p className="stat-value">{collections.filter(c => c.status === 'Scheduled').length}</p>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon">🔄</div>
                    <div className="stat-info">
                        <h3>In Progress</h3>
                        <p className="stat-value">{collections.filter(c => c.status === 'In Progress').length}</p>
                    </div>
                </div>
            </div>


            {/* Action Bar - Search and Add New Collection */}
            <div className="action-bar">
                <button className="add-btn" onClick={() => setShowNewCollectionForm(true)}>Schedule New Collection</button>
                <div className="search-bar">
                    <input
                        type="text"
                        placeholder="Search collections..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                    />
                </div>
            </div>

            {/* New Collection Form */}
            {showNewCollectionForm && (
                <div className="new-collection-form">
                    <h3>Schedule New Collection</h3>
                    <div className="form-grid">
                        <div className="form-group">
                            <label>Location:</label>
                            <input
                                type="text"
                                name="location"
                                value={newCollectionData.location}
                                onChange={e => setNewCollectionData({ ...newCollectionData, location: e.target.value })}
                                className="form-input"
                                required
                            />
                        </div>
                        <div className="form-group">
                            <label>Date:</label>
                            <input
                                type="date"
                                name="date"
                                value={newCollectionData.date}
                                onChange={e => setNewCollectionData({ ...newCollectionData, date: e.target.value })}
                                className="form-input"
                                required
                            />
                        </div>
                        <div className="form-group">
                            <label>Time:</label>
                            <input
                                type="time"
                                name="time"
                                value={newCollectionData.time}
                                onChange={e => setNewCollectionData({ ...newCollectionData, time: e.target.value })}
                                className="form-input"
                                required
                            />
                        </div>
                        <div className="form-group">
                            <label>Waste Type:</label>
                            <select
                                name="wasteType"
                                value={newCollectionData.wasteType}
                                onChange={e => setNewCollectionData({ ...newCollectionData, wasteType: e.target.value })}
                                className="form-input"
                            >
                                <option value="Mixed">Mixed</option>
                                <option value="Organic">Organic</option>
                                <option value="Recyclable">Recyclable</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Assigned Vehicle:</label>
                            <select
                                name="assignedVehicle"
                                value={newCollectionData.assignedVehicle}
                                onChange={e => setNewCollectionData({ ...newCollectionData, assignedVehicle: e.target.value })}
                                className="form-input"
                                required
                            >
                                <option value="">Select Vehicle</option>
                                {availableVehicles.map(vehicle => (
                                    <option key={vehicle.id} value={vehicle.vehicleNumber}>
                                        {vehicle.vehicleNumber}
                                    </option>
                                ))}
                            </select>
                        </div>
                    </div>
                    <div className="form-actions">
                        <button className="action-btn save" onClick={handleNewCollectionSubmit}>Save</button>
                        <button className="action-btn cancel" onClick={() => setShowNewCollectionForm(false)}>Cancel</button>
                    </div>
                </div>
            )}

            {/* Collection Schedule Table */}
            <div className="dashboard-card">
                <h3>Collection Schedule</h3>
                {loading ? (
                    <p>Loading...</p>
                ) : (
                    <table className="data-table">
                        <thead>
                            <tr>
                                <th>Location</th>
                                <th>Vehicle Number</th>
                                <th>Status</th>
                                <th>Waste Type</th>
                                <th>Notes</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredCollections.map((collection) => (
                                <tr key={collection.id}>
                                    {editingCollection === collection.id ? (
                                        <>
                                            <td className="edit-cell">
                                                <input
                                                    type="text"
                                                    name="location"
                                                    value={editFormData.location}
                                                    onChange={e => setEditFormData({ ...editFormData, location: e.target.value })}
                                                    className="edit-input"
                                                />
                                            </td>
                                            <td className="edit-cell">
                                                <select
                                                    name="vehicleNumber"
                                                    value={editFormData.vehicleNumber || ''}
                                                    onChange={e => setEditFormData({ ...editFormData, vehicleNumber: e.target.value })}
                                                    className="edit-input"
                                                >
                                                    <option value="">Select Vehicle</option>
                                                    {availableVehicles.map(vehicle => (
                                                        <option key={vehicle.id} value={vehicle.vehicleNumber}>
                                                            {vehicle.vehicleNumber}
                                                        </option>
                                                    ))}
                                                </select>
                                            </td>
                                            <td className="edit-cell">
                                                <select
                                                    name="status"
                                                    value={editFormData.status}
                                                    onChange={e => setEditFormData({ ...editFormData, status: e.target.value })}
                                                    className="edit-input"
                                                >
                                                    <option value="Scheduled">Scheduled</option>
                                                    <option value="In Progress">In Progress</option>
                                                    <option value="Completed">Completed</option>
                                                    <option value="Cancelled">Cancelled</option>
                                                </select>
                                            </td>
                                            <td className="edit-cell">
                                                <select
                                                    name="wasteType"
                                                    value={editFormData.wasteType}
                                                    onChange={e => setEditFormData({ ...editFormData, wasteType: e.target.value })}
                                                    className="edit-input"
                                                >
                                                    <option value="Mixed">Mixed</option>
                                                    <option value="Organic">Organic</option>
                                                    <option value="Recyclable">Recyclable</option>
                                                </select>
                                            </td>
                                            <td className="edit-cell">
                                                <input
                                                    type="text"
                                                    name="notes"
                                                    value={editFormData.notes || ''}
                                                    onChange={e => setEditFormData({ ...editFormData, notes: e.target.value })}
                                                    className="edit-input"
                                                />
                                            </td>
                                            <td>
                                                <button
                                                    className="action-btn save"
                                                    onClick={() => handleEditFormSubmit(collection.id)}
                                                >
                                                    Save
                                                </button>
                                                <button
                                                    className="action-btn cancel"
                                                    onClick={() => setEditingCollection(null)}
                                                >
                                                    Cancel
                                                </button>
                                            </td>
                                        </>
                                    ) : (
                                        <>
                                            <td>{collection.location}</td>
                                            <td>{collection.assignedVehicle}</td>
                                            <td>
                                                <span className={`status-badge ${collection.status.toLowerCase().replace(' ', '-')}`}>
                                                    {collection.status}
                                                </span>
                                            </td>
                                            <td>{collection.wasteType}</td>
                                            <td>{collection.notes}</td>
                                            <td>
                                                <button
                                                    className="action-btn edit"
                                                    onClick={() => handleEditClick(collection)}
                                                >
                                                    Edit
                                                </button>
                                                <button
                                                    className="action-btn delete"
                                                    onClick={() => handleDeleteClick(collection.id)}
                                                >
                                                    Delete
                                                </button>
                                            </td>
                                        </>
                                    )}
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
            </div>
        </div>
    )
}
export default Collections;
