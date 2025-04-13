/**
 * RecyclingCenterHome Component
 * 
 * This component serves as the main dashboard for the recycling center.
 * It provides a comprehensive interface for managing recycling operations,
 * tracking recycled materials, and monitoring recycling statistics.
 */

import { useState } from 'react';
import { Link } from 'react-router-dom';
import './RecyclingCenterHome.css';

/**
 * RecyclingCenterHome Component
 * 
 * @returns {JSX.Element} The rendered recycling center dashboard
 */
const RecyclingCenterHome = () => {
    // State to track the active tab in the sidebar navigation
    const [activeTab, setActiveTab] = useState('dashboard');
    // State to track the selected view in the schedule tab
    const [scheduleView, setScheduleView] = useState('calendar');

    /**
     * Recycling Statistics
     * 
     * Mock data representing key metrics for recycling operations.
     * In a production environment, this would be fetched from an API.
     */
    const recyclingStats = {
        totalRecycled: '1,250 kg',
        plasticRecycled: '450 kg',
        paperRecycled: '350 kg',
        metalRecycled: '250 kg',
        glassRecycled: '200 kg',
        recyclingRate: '75%'
    };

    /**
     * Recent Recycling Data
     * 
     * Mock data for recently processed recycling materials.
     * Each record contains essential information about the recycling operation.
     */
    const recentRecycling = [
        { id: 1, material: 'Plastic', date: '2024-03-15', weight: '45 kg', status: 'Processed' },
        { id: 2, material: 'Paper', date: '2024-03-15', weight: '32 kg', status: 'Processed' },
        { id: 3, material: 'Metal', date: '2024-03-14', weight: '28 kg', status: 'Processed' },
        { id: 4, material: 'Glass', date: '2024-03-14', weight: '15 kg', status: 'Processing' },
        { id: 5, material: 'Plastic', date: '2024-03-14', weight: '38 kg', status: 'Processing' },
    ];

    /**
     * Upcoming Collections Data
     * 
     * Mock data for scheduled recycling material collections.
     * Contains information about planned collection routes and times.
     */
    const upcomingCollections = [
        { id: 6, location: '987 Cedar Ln', date: '2024-03-16', time: '09:00 AM', material: 'Mixed' },
        { id: 7, location: '147 Birch St', date: '2024-03-16', time: '10:30 AM', material: 'Plastic' },
        { id: 8, location: '258 Willow Ave', date: '2024-03-17', time: '08:00 AM', material: 'Paper' },
        { id: 9, location: '369 Spruce Rd', date: '2024-03-17', time: '11:00 AM', material: 'Metal' },
        { id: 10, location: '741 Fir Dr', date: '2024-03-18', time: '09:30 AM', material: 'Glass' },
    ];

    /**
     * Recycling Process Data
     * 
     * Mock data for the recycling process steps and current status.
     * Each process has multiple stages with tracking information.
     */
    const recyclingProcesses = [
        {
            id: 1,
            material: 'Plastic',
            batchId: 'PL-2024-001',
            startDate: '2024-03-10',
            currentStage: 'Sorting',
            stages: [
                { name: 'Collection', status: 'Completed', date: '2024-03-10', notes: 'Collected from 5 locations' },
                { name: 'Sorting', status: 'In Progress', date: '2024-03-11', notes: 'Separating by type and color' },
                { name: 'Cleaning', status: 'Pending', date: null, notes: null },
                { name: 'Shredding', status: 'Pending', date: null, notes: null },
                { name: 'Pelletization', status: 'Pending', date: null, notes: null },
                { name: 'Quality Check', status: 'Pending', date: null, notes: null },
                { name: 'Packaging', status: 'Pending', date: null, notes: null }
            ],
            estimatedCompletion: '2024-03-18',
            assignedStaff: 'John Smith, Maria Garcia',
            equipment: 'Sorting Line A, Conveyor Belt 2'
        },
        {
            id: 2,
            material: 'Paper',
            batchId: 'PP-2024-003',
            startDate: '2024-03-12',
            currentStage: 'Pulping',
            stages: [
                { name: 'Collection', status: 'Completed', date: '2024-03-12', notes: 'Collected from 3 locations' },
                { name: 'Sorting', status: 'Completed', date: '2024-03-13', notes: 'Separated by grade' },
                { name: 'Pulping', status: 'In Progress', date: '2024-03-14', notes: 'Using chemical pulping method' },
                { name: 'Screening', status: 'Pending', date: null, notes: null },
                { name: 'Deinking', status: 'Pending', date: null, notes: null },
                { name: 'Refining', status: 'Pending', date: null, notes: null },
                { name: 'Paper Making', status: 'Pending', date: null, notes: null },
                { name: 'Drying', status: 'Pending', date: null, notes: null },
                { name: 'Rolling', status: 'Pending', date: null, notes: null }
            ],
            estimatedCompletion: '2024-03-20',
            assignedStaff: 'David Chen, Sarah Johnson',
            equipment: 'Pulper 1, Paper Machine B'
        },
        {
            id: 3,
            material: 'Glass',
            batchId: 'GL-2024-002',
            startDate: '2024-03-11',
            currentStage: 'Cleaning',
            stages: [
                { name: 'Collection', status: 'Completed', date: '2024-03-11', notes: 'Collected from 4 locations' },
                { name: 'Sorting', status: 'Completed', date: '2024-03-12', notes: 'Separated by color' },
                { name: 'Cleaning', status: 'In Progress', date: '2024-03-13', notes: 'Removing labels and contaminants' },
                { name: 'Crushing', status: 'Pending', date: null, notes: null },
                { name: 'Melting', status: 'Pending', date: null, notes: null },
                { name: 'Molding', status: 'Pending', date: null, notes: null },
                { name: 'Annealing', status: 'Pending', date: null, notes: null },
                { name: 'Quality Inspection', status: 'Pending', date: null, notes: null }
            ],
            estimatedCompletion: '2024-03-19',
            assignedStaff: 'Michael Brown, Lisa Wong',
            equipment: 'Glass Crusher, Furnace 3'
        },
        {
            id: 4,
            material: 'Metal',
            batchId: 'MT-2024-004',
            startDate: '2024-03-13',
            currentStage: 'Collection',
            stages: [
                { name: 'Collection', status: 'In Progress', date: '2024-03-13', notes: 'Collecting from 6 locations' },
                { name: 'Sorting', status: 'Pending', date: null, notes: null },
                { name: 'Shredding', status: 'Pending', date: null, notes: null },
                { name: 'Magnetic Separation', status: 'Pending', date: null, notes: null },
                { name: 'Melting', status: 'Pending', date: null, notes: null },
                { name: 'Purification', status: 'Pending', date: null, notes: null },
                { name: 'Solidification', status: 'Pending', date: null, notes: null },
                { name: 'Quality Testing', status: 'Pending', date: null, notes: null }
            ],
            estimatedCompletion: '2024-03-22',
            assignedStaff: 'Robert Wilson, Emily Davis',
            equipment: 'Metal Shredder, Furnace 1'
        }
    ];

    /**
     * Schedule Data
     * 
     * Mock data for the recycling center's schedule.
     * Includes collection schedules, processing schedules, and staff assignments.
     */
    const scheduleData = {
        // Collection schedules
        collections: [
            { id: 1, type: 'Collection', title: 'Plastic Collection - Route A', date: '2024-03-16', startTime: '08:00 AM', endTime: '12:00 PM', location: 'Downtown Area', assignedTo: 'John Smith, Maria Garcia', vehicle: 'Truck A-123', status: 'Scheduled' },
            { id: 2, type: 'Collection', title: 'Paper Collection - Route B', date: '2024-03-16', startTime: '09:00 AM', endTime: '01:00 PM', location: 'Suburban Area', assignedTo: 'David Chen, Sarah Johnson', vehicle: 'Truck B-456', status: 'Scheduled' },
            { id: 3, type: 'Collection', title: 'Glass Collection - Route C', date: '2024-03-17', startTime: '08:30 AM', endTime: '11:30 AM', location: 'Industrial Area', assignedTo: 'Michael Brown, Lisa Wong', vehicle: 'Truck C-789', status: 'Scheduled' },
            { id: 4, type: 'Collection', title: 'Metal Collection - Route D', date: '2024-03-17', startTime: '10:00 AM', endTime: '02:00 PM', location: 'Commercial Area', assignedTo: 'Robert Wilson, Emily Davis', vehicle: 'Truck D-012', status: 'Scheduled' },
            { id: 5, type: 'Collection', title: 'Mixed Recycling - Route E', date: '2024-03-18', startTime: '09:30 AM', endTime: '01:30 PM', location: 'Residential Area', assignedTo: 'John Smith, Maria Garcia', vehicle: 'Truck E-345', status: 'Scheduled' },
        ],

        // Processing schedules
        processing: [
            { id: 6, type: 'Processing', title: 'Plastic Sorting - Batch PL-2024-001', date: '2024-03-16', startTime: '01:00 PM', endTime: '05:00 PM', location: 'Sorting Facility', assignedTo: 'John Smith, Maria Garcia', equipment: 'Sorting Line A', status: 'Scheduled' },
            { id: 7, type: 'Processing', title: 'Paper Pulping - Batch PP-2024-003', date: '2024-03-16', startTime: '02:00 PM', endTime: '06:00 PM', location: 'Processing Plant', assignedTo: 'David Chen, Sarah Johnson', equipment: 'Pulper 1', status: 'Scheduled' },
            { id: 8, type: 'Processing', title: 'Glass Cleaning - Batch GL-2024-002', date: '2024-03-17', startTime: '01:30 PM', endTime: '04:30 PM', location: 'Cleaning Station', assignedTo: 'Michael Brown, Lisa Wong', equipment: 'Cleaning Unit 2', status: 'Scheduled' },
            { id: 9, type: 'Processing', title: 'Metal Shredding - Batch MT-2024-004', date: '2024-03-18', startTime: '09:00 AM', endTime: '12:00 PM', location: 'Shredding Facility', assignedTo: 'Robert Wilson, Emily Davis', equipment: 'Metal Shredder', status: 'Scheduled' },
            { id: 10, type: 'Processing', title: 'Quality Inspection - All Materials', date: '2024-03-19', startTime: '10:00 AM', endTime: '03:00 PM', location: 'Quality Lab', assignedTo: 'Quality Team', equipment: 'Testing Equipment', status: 'Scheduled' },
        ],

        // Staff schedules
        staff: [
            { id: 11, type: 'Staff', title: 'John Smith', date: '2024-03-16', startTime: '08:00 AM', endTime: '05:00 PM', role: 'Collection Driver', location: 'Various Locations', status: 'Scheduled' },
            { id: 12, type: 'Staff', title: 'Maria Garcia', date: '2024-03-16', startTime: '08:00 AM', endTime: '05:00 PM', role: 'Collection Assistant', location: 'Various Locations', status: 'Scheduled' },
            { id: 13, type: 'Staff', title: 'David Chen', date: '2024-03-16', startTime: '09:00 AM', endTime: '06:00 PM', role: 'Processing Operator', location: 'Processing Plant', status: 'Scheduled' },
            { id: 14, type: 'Staff', title: 'Sarah Johnson', date: '2024-03-16', startTime: '09:00 AM', endTime: '06:00 PM', role: 'Processing Assistant', location: 'Processing Plant', status: 'Scheduled' },
            { id: 15, type: 'Staff', title: 'Michael Brown', date: '2024-03-17', startTime: '08:30 AM', endTime: '04:30 PM', role: 'Glass Processing Specialist', location: 'Glass Processing Area', status: 'Scheduled' },
            { id: 16, type: 'Staff', title: 'Lisa Wong', date: '2024-03-17', startTime: '08:30 AM', endTime: '04:30 PM', role: 'Glass Processing Assistant', location: 'Glass Processing Area', status: 'Scheduled' },
            { id: 17, type: 'Staff', title: 'Robert Wilson', date: '2024-03-18', startTime: '09:00 AM', endTime: '05:00 PM', role: 'Metal Processing Specialist', location: 'Metal Processing Area', status: 'Scheduled' },
            { id: 18, type: 'Staff', title: 'Emily Davis', date: '2024-03-18', startTime: '09:00 AM', endTime: '05:00 PM', role: 'Metal Processing Assistant', location: 'Metal Processing Area', status: 'Scheduled' },
            { id: 19, type: 'Staff', title: 'Quality Team', date: '2024-03-19', startTime: '10:00 AM', endTime: '03:00 PM', role: 'Quality Inspectors', location: 'Quality Lab', status: 'Scheduled' },
        ],

        // Equipment schedules
        equipment: [
            { id: 20, type: 'Equipment', title: 'Truck A-123', date: '2024-03-16', startTime: '08:00 AM', endTime: '12:00 PM', purpose: 'Plastic Collection', assignedTo: 'John Smith, Maria Garcia', status: 'Scheduled' },
            { id: 21, type: 'Equipment', title: 'Truck B-456', date: '2024-03-16', startTime: '09:00 AM', endTime: '01:00 PM', purpose: 'Paper Collection', assignedTo: 'David Chen, Sarah Johnson', status: 'Scheduled' },
            { id: 22, type: 'Equipment', title: 'Truck C-789', date: '2024-03-17', startTime: '08:30 AM', endTime: '11:30 AM', purpose: 'Glass Collection', assignedTo: 'Michael Brown, Lisa Wong', status: 'Scheduled' },
            { id: 23, type: 'Equipment', title: 'Truck D-012', date: '2024-03-17', startTime: '10:00 AM', endTime: '02:00 PM', purpose: 'Metal Collection', assignedTo: 'Robert Wilson, Emily Davis', status: 'Scheduled' },
            { id: 24, type: 'Equipment', title: 'Truck E-345', date: '2024-03-18', startTime: '09:30 AM', endTime: '01:30 PM', purpose: 'Mixed Recycling Collection', assignedTo: 'John Smith, Maria Garcia', status: 'Scheduled' },
            { id: 25, type: 'Equipment', title: 'Sorting Line A', date: '2024-03-16', startTime: '01:00 PM', endTime: '05:00 PM', purpose: 'Plastic Sorting', assignedTo: 'John Smith, Maria Garcia', status: 'Scheduled' },
            { id: 26, type: 'Equipment', title: 'Pulper 1', date: '2024-03-16', startTime: '02:00 PM', endTime: '06:00 PM', purpose: 'Paper Pulping', assignedTo: 'David Chen, Sarah Johnson', status: 'Scheduled' },
            { id: 27, type: 'Equipment', title: 'Cleaning Unit 2', date: '2024-03-17', startTime: '01:30 PM', endTime: '04:30 PM', purpose: 'Glass Cleaning', assignedTo: 'Michael Brown, Lisa Wong', status: 'Scheduled' },
            { id: 28, type: 'Equipment', title: 'Metal Shredder', date: '2024-03-18', startTime: '09:00 AM', endTime: '12:00 PM', purpose: 'Metal Shredding', assignedTo: 'Robert Wilson, Emily Davis', status: 'Scheduled' },
            { id: 29, type: 'Equipment', title: 'Testing Equipment', date: '2024-03-19', startTime: '10:00 AM', endTime: '03:00 PM', purpose: 'Quality Inspection', assignedTo: 'Quality Team', status: 'Scheduled' },
        ]
    };

    /**
     * Component Render
     * 
     * The main UI structure with conditional rendering based on the active tab.
     */
    return (
        <div className="recycling-center-home">
            {/* Header Section */}
            <header className="header">
                <div className="logo">
                    <h1>Waste Management System</h1>
                </div>
                <div className="user-info">
                    <span className="user-name">Recycling Center</span>
                    <button className="logout-btn">Logout</button>
                </div>
            </header>

            <div className="main-content">
                {/* Sidebar Navigation */}
                <nav className="sidebar">
                    <ul className="nav-menu">
                        <li className={activeTab === 'dashboard' ? 'active' : ''} onClick={() => setActiveTab('dashboard')}>
                            <span className="icon">📊</span> Dashboard
                        </li>
                        <li className={activeTab === 'materials' ? 'active' : ''} onClick={() => setActiveTab('materials')}>
                            <span className="icon">♻️</span> Materials
                        </li>
                        <li className={activeTab === 'schedule' ? 'active' : ''} onClick={() => setActiveTab('schedule')}>
                            <span className="icon">📅</span> Schedule
                        </li>
                        <li className={activeTab === 'processes' ? 'active' : ''} onClick={() => setActiveTab('processes')}>
                            <span className="icon">⚙️</span> Processes
                        </li>
                        <li className={activeTab === 'reports' ? 'active' : ''} onClick={() => setActiveTab('reports')}>
                            <span className="icon">📈</span> Reports
                        </li>
                        <li className={activeTab === 'settings' ? 'active' : ''} onClick={() => setActiveTab('settings')}>
                            <span className="icon">⚙️</span> Settings
                        </li>
                    </ul>
                </nav>

                {/* Main Content Area - Conditionally Rendered Based on Active Tab */}
                <main className="content">
                    {/* Dashboard Tab */}
                    {activeTab === 'dashboard' && (
                        <div className="dashboard">
                            <h2>Dashboard</h2>

                            {/* Statistics Cards */}
                            <div className="stats-cards">
                                <div className="stat-card">
                                    <div className="stat-icon">♻️</div>
                                    <div className="stat-info">
                                        <h3>Total Recycled</h3>
                                        <p className="stat-value">{recyclingStats.totalRecycled}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">🥤</div>
                                    <div className="stat-info">
                                        <h3>Plastic Recycled</h3>
                                        <p className="stat-value">{recyclingStats.plasticRecycled}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">📄</div>
                                    <div className="stat-info">
                                        <h3>Paper Recycled</h3>
                                        <p className="stat-value">{recyclingStats.paperRecycled}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">🔧</div>
                                    <div className="stat-info">
                                        <h3>Metal Recycled</h3>
                                        <p className="stat-value">{recyclingStats.metalRecycled}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">🥂</div>
                                    <div className="stat-info">
                                        <h3>Glass Recycled</h3>
                                        <p className="stat-value">{recyclingStats.glassRecycled}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">📈</div>
                                    <div className="stat-info">
                                        <h3>Recycling Rate</h3>
                                        <p className="stat-value">{recyclingStats.recyclingRate}</p>
                                    </div>
                                </div>
                            </div>

                            {/* Dashboard Grid - Recent and Upcoming Collections */}
                            <div className="dashboard-grid">
                                <div className="dashboard-card">
                                    <h3>Recent Recycling</h3>
                                    <table className="data-table">
                                        <thead>
                                            <tr>
                                                <th>Material</th>
                                                <th>Date</th>
                                                <th>Weight</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {recentRecycling.map(item => (
                                                <tr key={item.id}>
                                                    <td>{item.material}</td>
                                                    <td>{item.date}</td>
                                                    <td>{item.weight}</td>
                                                    <td>
                                                        <span className={`status-badge ${item.status.toLowerCase()}`}>
                                                            {item.status}
                                                        </span>
                                                    </td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                    <button className="view-all-btn">View All Recycling</button>
                                </div>

                                <div className="dashboard-card">
                                    <h3>Upcoming Collections</h3>
                                    <table className="data-table">
                                        <thead>
                                            <tr>
                                                <th>Location</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Material</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {upcomingCollections.map(collection => (
                                                <tr key={collection.id}>
                                                    <td>{collection.location}</td>
                                                    <td>{collection.date}</td>
                                                    <td>{collection.time}</td>
                                                    <td>{collection.material}</td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                    <button className="view-all-btn">View Full Schedule</button>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Materials Tab */}
                    {activeTab === 'materials' && (
                        <div className="materials">
                            <h2>Materials Management</h2>
                            <p>Materials management content will go here.</p>
                        </div>
                    )}

                    {/* Schedule Tab */}
                    {activeTab === 'schedule' && (
                        <div className="schedule">
                            <h2>Schedule Management</h2>

                            <div className="schedule-controls">
                                <div className="schedule-view-options">
                                    <button
                                        className={`view-option-btn ${scheduleView === 'calendar' ? 'active' : ''}`}
                                        onClick={() => setScheduleView('calendar')}
                                    >
                                        <span className="icon">📅</span> Calendar View
                                    </button>
                                    <button
                                        className={`view-option-btn ${scheduleView === 'list' ? 'active' : ''}`}
                                        onClick={() => setScheduleView('list')}
                                    >
                                        <span className="icon">📋</span> List View
                                    </button>
                                </div>

                                <div className="schedule-filters">
                                    <select className="filter-select">
                                        <option value="all">All Types</option>
                                        <option value="collection">Collections</option>
                                        <option value="processing">Processing</option>
                                        <option value="staff">Staff</option>
                                        <option value="equipment">Equipment</option>
                                    </select>
                                    <select className="filter-select">
                                        <option value="all">All Status</option>
                                        <option value="scheduled">Scheduled</option>
                                        <option value="in-progress">In Progress</option>
                                        <option value="completed">Completed</option>
                                        <option value="cancelled">Cancelled</option>
                                    </select>
                                    <input type="date" className="date-filter" />
                                </div>

                                <button className="add-schedule-btn">Add New Schedule</button>
                            </div>

                            {/* Calendar View */}
                            {scheduleView === 'calendar' && (
                                <div className="calendar-view">
                                    <div className="calendar-header">
                                        <button className="calendar-nav-btn">Previous</button>
                                        <h3>March 2024</h3>
                                        <button className="calendar-nav-btn">Next</button>
                                    </div>

                                    <div className="calendar-grid">
                                        <div className="calendar-day-header">Sun</div>
                                        <div className="calendar-day-header">Mon</div>
                                        <div className="calendar-day-header">Tue</div>
                                        <div className="calendar-day-header">Wed</div>
                                        <div className="calendar-day-header">Thu</div>
                                        <div className="calendar-day-header">Fri</div>
                                        <div className="calendar-day-header">Sat</div>

                                        {/* Calendar days would be dynamically generated here */}
                                        {/* For demo purposes, we'll show a few days with events */}
                                        <div className="calendar-day empty"></div>
                                        <div className="calendar-day empty"></div>
                                        <div className="calendar-day empty"></div>
                                        <div className="calendar-day empty"></div>
                                        <div className="calendar-day empty"></div>
                                        <div className="calendar-day">
                                            <div className="day-number">1</div>
                                            <div className="day-events">
                                                <div className="calendar-event collection">Collection Route A</div>
                                            </div>
                                        </div>
                                        <div className="calendar-day">
                                            <div className="day-number">2</div>
                                            <div className="day-events">
                                                <div className="calendar-event processing">Processing Batch A</div>
                                            </div>
                                        </div>

                                        {/* More days would be here */}

                                        <div className="calendar-day">
                                            <div className="day-number">15</div>
                                            <div className="day-events">
                                                <div className="calendar-event collection">Plastic Collection</div>
                                                <div className="calendar-event processing">Paper Processing</div>
                                            </div>
                                        </div>

                                        <div className="calendar-day">
                                            <div className="day-number">16</div>
                                            <div className="day-events">
                                                <div className="calendar-event collection">Plastic Collection - Route A</div>
                                                <div className="calendar-event processing">Plastic Sorting - Batch PL-2024-001</div>
                                                <div className="calendar-event staff">John Smith, Maria Garcia</div>
                                                <div className="calendar-event equipment">Truck A-123</div>
                                            </div>
                                        </div>

                                        <div className="calendar-day">
                                            <div className="day-number">17</div>
                                            <div className="day-events">
                                                <div className="calendar-event collection">Glass Collection - Route C</div>
                                                <div className="calendar-event staff">Michael Brown, Lisa Wong</div>
                                                <div className="calendar-event equipment">Truck C-789</div>
                                            </div>
                                        </div>

                                        {/* More days would be here */}
                                    </div>
                                </div>
                            )}

                            {/* List View */}
                            {scheduleView === 'list' && (
                                <div className="list-view">
                                    <div className="schedule-tabs">
                                        <button className="schedule-tab active">Collections</button>
                                        <button className="schedule-tab">Processing</button>
                                        <button className="schedule-tab">Staff</button>
                                        <button className="schedule-tab">Equipment</button>
                                    </div>

                                    <div className="schedule-list">
                                        {scheduleData.collections.map(item => (
                                            <div className="schedule-item" key={item.id}>
                                                <div className="schedule-item-header">
                                                    <h3>{item.title}</h3>
                                                    <span className={`status-badge ${item.status.toLowerCase()}`}>
                                                        {item.status}
                                                    </span>
                                                </div>

                                                <div className="schedule-item-details">
                                                    <div className="detail-row">
                                                        <span className="detail-label">Date:</span>
                                                        <span className="detail-value">{item.date}</span>
                                                    </div>
                                                    <div className="detail-row">
                                                        <span className="detail-label">Time:</span>
                                                        <span className="detail-value">{item.startTime} - {item.endTime}</span>
                                                    </div>
                                                    <div className="detail-row">
                                                        <span className="detail-label">Location:</span>
                                                        <span className="detail-value">{item.location}</span>
                                                    </div>
                                                    <div className="detail-row">
                                                        <span className="detail-label">Assigned To:</span>
                                                        <span className="detail-value">{item.assignedTo}</span>
                                                    </div>
                                                    <div className="detail-row">
                                                        <span className="detail-label">Vehicle:</span>
                                                        <span className="detail-value">{item.vehicle}</span>
                                                    </div>
                                                </div>

                                                <div className="schedule-item-actions">
                                                    <button className="action-btn edit">Edit</button>
                                                    <button className="action-btn view">View Details</button>
                                                    <button className="action-btn delete">Cancel</button>
                                                </div>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            )}
                        </div>
                    )}

                    {/* Processes Tab */}
                    {activeTab === 'processes' && (
                        <div className="processes">
                            <h2>Recycling Processes</h2>

                            <div className="process-controls">
                                <div className="search-filter">
                                    <input type="text" placeholder="Search processes..." className="search-input" />
                                    <select className="filter-select">
                                        <option value="all">All Materials</option>
                                        <option value="plastic">Plastic</option>
                                        <option value="paper">Paper</option>
                                        <option value="glass">Glass</option>
                                        <option value="metal">Metal</option>
                                    </select>
                                    <select className="filter-select">
                                        <option value="all">All Stages</option>
                                        <option value="collection">Collection</option>
                                        <option value="sorting">Sorting</option>
                                        <option value="processing">Processing</option>
                                        <option value="completed">Completed</option>
                                    </select>
                                </div>
                                <button className="add-process-btn">Add New Process</button>
                            </div>

                            <div className="process-list">
                                {recyclingProcesses.map(process => (
                                    <div className="process-card" key={process.id}>
                                        <div className="process-header">
                                            <div className="process-title">
                                                <h3>{process.material} Recycling</h3>
                                                <span className="batch-id">Batch: {process.batchId}</span>
                                            </div>
                                            <div className="process-status">
                                                <span className={`status-badge ${process.currentStage.toLowerCase()}`}>
                                                    {process.currentStage}
                                                </span>
                                                <span className="completion-date">
                                                    Est. Completion: {process.estimatedCompletion}
                                                </span>
                                            </div>
                                        </div>

                                        <div className="process-timeline">
                                            {process.stages.map((stage, index) => (
                                                <div className={`timeline-stage ${stage.status.toLowerCase().replace(' ', '-')}`} key={index}>
                                                    <div className="stage-dot"></div>
                                                    <div className="stage-line"></div>
                                                    <div className="stage-content">
                                                        <h4>{stage.name}</h4>
                                                        {stage.date && <p className="stage-date">{stage.date}</p>}
                                                        {stage.notes && <p className="stage-notes">{stage.notes}</p>}
                                                    </div>
                                                </div>
                                            ))}
                                        </div>

                                        <div className="process-details">
                                            <div className="detail-item">
                                                <span className="detail-label">Start Date:</span>
                                                <span className="detail-value">{process.startDate}</span>
                                            </div>
                                            <div className="detail-item">
                                                <span className="detail-label">Assigned Staff:</span>
                                                <span className="detail-value">{process.assignedStaff}</span>
                                            </div>
                                            <div className="detail-item">
                                                <span className="detail-label">Equipment:</span>
                                                <span className="detail-value">{process.equipment}</span>
                                            </div>
                                        </div>

                                        <div className="process-actions">
                                            <button className="action-btn update">Update Status</button>
                                            <button className="action-btn edit">Edit Process</button>
                                            <button className="action-btn view">View Details</button>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}

                    {/* Reports Tab */}
                    {activeTab === 'reports' && (
                        <div className="reports">
                            <h2>Reports & Analytics</h2>
                            <p>Reports and analytics content will go here.</p>
                        </div>
                    )}

                    {/* Settings Tab */}
                    {activeTab === 'settings' && (
                        <div className="settings">
                            <h2>Settings</h2>
                            <p>Settings content will go here.</p>
                        </div>
                    )}
                </main>
            </div>
        </div>
    );
};

export default RecyclingCenterHome; 