// RecycleTab component for managing recycling materials and their processing status

import React, { useState } from 'react'

const RecycleTab = () => {
    // State for managing the active tab (overview, process-updates, or centers)
    const [recyclingTab, setRecyclingTab] = useState('overview');
    const [recyclingFilter, setRecyclingFilter] = useState('all');
    const [recyclingMaterials, setRecyclingMaterials] = useState([]);
    const [selectedMaterial, setSelectedMaterial] = useState(null);

    // State for tracking recycling process steps and their status
    //recycling process 6 steps in sequence
    const [, setRecyclingProcess] = useState({
        currentStep: 0,
        steps: [
            { id: 1, name: 'Collection', status: 'pending', completedAt: null },
            { id: 2, name: 'Sorting', status: 'pending', completedAt: null },
            { id: 3, name: 'Cleaning', status: 'pending', completedAt: null },
            { id: 4, name: 'Processing', status: 'pending', completedAt: null },
            { id: 5, name: 'Quality Check', status: 'pending', completedAt: null },
            { id: 6, name: 'Packaging', status: 'pending', completedAt: null }
        ]
    });

    // Handler for when a material is clicked in the overview
    // Resets the process steps when selecting a new material
    const handleMaterialClick = (material) => {
        setSelectedMaterial(material);
        // Reset process steps when selecting a new material
        setRecyclingProcess(prev => ({
            ...prev,
            currentStep: 0,
            steps: prev.steps.map(step => ({
                ...step,
                status: 'pending',
                completedAt: null
            }))
        }));
    };

    // Handler for updating the status of a process step
    const handleProcessUpdate = (stepId, newStatus) => {
        const updatedMaterials = recyclingMaterials.map(material => {
            if (material.id === selectedMaterial?.id) {
                // Update the steps array with new status and timing
                const updatedSteps = material.processingStatus.steps.map(step => {
                    if (step.id === stepId) {
                        const now = new Date().toISOString().slice(0, 16);
                        return {
                            ...step,
                            status: newStatus,
                            startTime: newStatus === 'in-progress' ? now : step.startTime,
                            endTime: newStatus === 'completed' ? now : step.endTime
                        };
                    }
                    return step;
                });

                // Update the material's processing status
                return {
                    ...material,
                    processingStatus: {
                        ...material.processingStatus,
                        currentStep: newStatus === 'completed' ?
                            material.processingStatus.steps.find(s => s.id === stepId).id :
                            material.processingStatus.currentStep,
                        steps: updatedSteps
                    }
                };
            }
            return material;
        });

        setRecyclingMaterials(updatedMaterials);
    };

    return (
        <div className="recycling-section">
            {/* Header section with filters and view options */}
            <div className="recycling-controls">
                <h2>Recycling Management</h2>
                <div className="recycling-filters">
                    {/* Filter dropdown for material status */}
                    <select
                        value={recyclingFilter}
                        onChange={(e) => setRecyclingFilter(e.target.value)}
                        className="filter-select"
                    >
                        <option value="all">All Materials</option>
                        <option value="pending">Pending</option>
                        <option value="in-progress">In Progress</option>
                        <option value="completed">Completed</option>
                    </select>
                    {/* View selection dropdown */}
                    <select
                        value={recyclingTab}
                        onChange={(e) => setRecyclingTab(e.target.value)}
                        className="view-select"
                    >
                        <option value="overview">Overview</option>
                        <option value="process-updates">Process Updates</option>
                        <option value="centers">Recycling Centers</option>
                    </select>
                </div>
            </div>

            {/* Overview tab - displays list of recycling materials with their basic information */}
            {recyclingTab === 'overview' && (
                <div className="materials-list">
                    {recyclingMaterials
                        .filter(material =>
                            recyclingFilter === 'all' ||
                            material.status.toLowerCase() === recyclingFilter
                        )
                        .map(material => (
                            <div
                                key={material.id}
                                className={`material-card ${selectedMaterial?.id === material.id ? 'selected' : ''}`}
                                onClick={() => handleMaterialClick(material)}
                            >
                                <div className="material-header">
                                    <h3>{material.name}</h3>
                                    <span className="material-category">{material.category}</span>
                                </div>
                                <div className="material-details">
                                    <div>
                                        <strong>Quantity:</strong> {material.quantity}
                                    </div>
                                    <div>
                                        <strong>Status:</strong>
                                        <span className={`status-badge ${material.status.toLowerCase()}`}>
                                            {material.status}
                                        </span>
                                    </div>
                                    <div>
                                        <strong>Current Step:</strong> {material.processingStatus.currentStep}
                                    </div>
                                    <div>
                                        <strong>Last Updated:</strong> {material.lastUpdated}
                                    </div>
                                </div>
                                <p className="material-description">{material.description}</p>
                            </div>
                        ))}
                </div>
            )}

            {/* Process Updates tab - shows detailed process steps for selected material */}
            {recyclingTab === 'process-updates' && selectedMaterial && (
                <div className="process-steps">
                    {selectedMaterial.processingStatus.steps.map((step) => (
                        <div key={step.id} className={`process-step ${step.status === 'in-progress' ? 'current' : ''}`}>
                            <div className="step-header">
                                <h3>{step.id}</h3>
                                <span className={`status-badge ${step.status}`}>
                                    {step.status.charAt(0).toUpperCase() + step.status.slice(1)}
                                </span>
                            </div>
                            {/* Timing information for each step */}
                            <div className="step-timing">
                                {step.startTime && (
                                    <div className="time-info">
                                        <span className="time-label">Start:</span>
                                        <span className="time-value">{new Date(step.startTime).toLocaleString()}</span>
                                    </div>
                                )}
                                {step.endTime && (
                                    <div className="time-info">
                                        <span className="time-label">End:</span>
                                        <span className="time-value">{new Date(step.endTime).toLocaleString()}</span>
                                    </div>
                                )}
                                {step.startTime && step.endTime && (
                                    <div className="time-info">
                                        <span className="time-label">Duration:</span>
                                        <span className="time-value">
                                            { }
                                        </span>
                                    </div>
                                )}
                            </div>
                            <p className="step-description">
                                { }
                            </p>
                            {/* Action buttons for updating step status */}
                            <div className="step-actions">
                                {step.status === 'pending' && (
                                    <button
                                        className="btn-primary"
                                        onClick={() => handleProcessUpdate(step.id, 'in-progress')}
                                    >
                                        Start Process
                                    </button>
                                )}
                                {step.status === 'in-progress' && (
                                    <button
                                        className="btn-success"
                                        onClick={() => handleProcessUpdate(step.id, 'completed')}
                                    >
                                        Complete Step
                                    </button>
                                )}
                                {step.status === 'completed' && (
                                    <button
                                        className="btn-warning"
                                        onClick={() => handleProcessUpdate(step.id, 'in-progress')}
                                    >
                                        Reopen Step
                                    </button>
                                )}
                            </div>
                        </div>
                    ))}
                </div>
            )}

            {/* Recycling Centers tab - displays information about recycling centers */}
            {/* Shows statistics and current materials for each center */}
            {recyclingTab === 'centers' && (
                <div className="recycling-centers">
                    <div className="centers-grid">
                        {Array.from(new Set(recyclingMaterials.map(m => m.recyclingCenter))).map(center => (
                            <div key={center} className="center-card">
                                <h3>{center}</h3>
                                {/* Center statistics */}
                                <div className="center-stats">
                                    <div className="stat">
                                        <span className="stat-label">Active Materials</span>
                                        <span className="stat-value">
                                            {recyclingMaterials.filter(m => m.recyclingCenter === center).length}
                                        </span>
                                    </div>
                                    <div className="stat">
                                        <span className="stat-label">Total Quantity</span>
                                        <span className="stat-value">
                                            {recyclingMaterials
                                                .filter(m => m.recyclingCenter === center)
                                                .reduce((sum, m) => sum + parseInt(m.quantity), 0)} kg
                                        </span>
                                    </div>
                                </div>
                                {/* List of current materials at this center */}
                                <div className="center-materials">
                                    <h4>Current Materials</h4>
                                    <ul>
                                        {recyclingMaterials
                                            .filter(m => m.recyclingCenter === center)
                                            .map(material => (
                                                <li key={material.id}>
                                                    <span className="material-name">{material.name}</span>
                                                    <span className={`status-badge ${material.status.toLowerCase()}`}>
                                                        {material.status}
                                                    </span>
                                                </li>
                                            ))}
                                    </ul>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            )}
        </div>
    )
}
export default RecycleTab
