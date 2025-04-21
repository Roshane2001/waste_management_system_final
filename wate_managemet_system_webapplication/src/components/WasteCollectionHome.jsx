/**
 * WasteCollectionHome Component
 * 
 * This component serves as the main dashboard for the waste collection center.
 * It provides a comprehensive interface for managing waste collections, vehicles,
 * residents, and other operational aspects of the waste management system.
 */

import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import Calendar from 'react-calendar';
import 'react-calendar/dist/Calendar.css';
import './WasteCollectionHome.css';

const WasteCollectionHome = () => {
    const navigate = useNavigate();
    // State to track the active tab in the sidebar navigation
    const [activeTab, setActiveTab] = useState('dashboard');
    const [scheduleView, setScheduleView] = useState('calendar');
    const [reportType, setReportType] = useState('collections');
    const [recyclingTab, setRecyclingTab] = useState('overview');
    const [recyclingFilter, setRecyclingFilter] = useState('all');
    const [bulkCollectionTab, setBulkCollectionTab] = useState('requests');
    const [selectedDate, setSelectedDate] = useState(new Date());
    const [selectedMaterial, setSelectedMaterial] = useState(null);
    const [recyclingProcess, setRecyclingProcess] = useState({
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

    /**
     * Settings Data
     * 
     * Mock data for user settings and preferences.
     * In a production environment, this would be fetched from an API.
     */
    const [settingsData, setSettingsData] = useState({
        userProfile: {
            name: 'John Smith',
            email: 'john.smith@wastemanagement.com',
            role: 'Waste Collection Manager',
            phone: '+1 (555) 123-4567',
            profilePicture: 'https://via.placeholder.com/150',
            department: 'Operations',
            joinDate: '2022-01-15'
        },
        systemPreferences: {
            language: 'English',
            timezone: 'UTC-5 (Eastern Time)',
            dateFormat: 'MM/DD/YYYY',
            theme: 'Light',
            dashboardLayout: 'Default',
            tableRowsPerPage: 10
        },
        notificationSettings: {
            emailNotifications: true,
            pushNotifications: true,
            collectionAlerts: true,
            vehicleAlerts: true,
            staffAlerts: true,
            reportAlerts: true,
            alertFrequency: 'Daily'
        },
        securitySettings: {
            twoFactorAuth: false,
            passwordLastChanged: '2023-03-15',
            loginHistory: [
                { date: '2023-04-10', time: '09:15 AM', device: 'Desktop - Chrome', location: 'New York, USA' },
                { date: '2023-04-09', time: '02:30 PM', device: 'Mobile - Safari', location: 'New York, USA' },
                { date: '2023-04-08', time: '11:45 AM', device: 'Desktop - Firefox', location: 'New York, USA' }
            ]
        },
        integrationSettings: {
            gpsTracking: true,
            weatherApi: true,
            trafficApi: true,
            smsGateway: true,
            emailService: true
        }
    });

    // Bulk Collection Data
    const [bulkCollectionRequests, setBulkCollectionRequests] = useState([
        {
            id: 1,
            residentName: 'John Smith',
            address: '123 Main St',
            contact: '555-123-4567',
            wasteType: 'Construction Debris',
            estimatedWeight: '500 kg',
            requestDate: '2024-03-15',
            preferredDate: '2024-03-20',
            status: 'Pending',
            notes: 'Large amount of construction materials from home renovation'
        },
        {
            id: 2,
            residentName: 'Jane Doe',
            address: '456 Oak Ave',
            contact: '555-234-5678',
            wasteType: 'Garden Waste',
            estimatedWeight: '300 kg',
            requestDate: '2024-03-16',
            preferredDate: '2024-03-21',
            status: 'Confirmed',
            assignedVehicle: 'Truck-001',
            assignedDriver: 'John Driver',
            collectionDate: '2024-03-21',
            notes: 'Tree branches and garden clippings'
        },
        {
            id: 3,
            residentName: 'Robert Johnson',
            address: '789 Pine Rd',
            contact: '555-345-6789',
            wasteType: 'Household Items',
            estimatedWeight: '200 kg',
            requestDate: '2024-03-17',
            preferredDate: '2024-03-22',
            status: 'Completed',
            assignedVehicle: 'Van-001',
            assignedDriver: 'Sarah Driver',
            collectionDate: '2024-03-22',
            actualWeight: '180 kg',
            notes: 'Old furniture and appliances'
        }
    ]);

    // Function to handle settings changes
    const handleSettingsChange = (category, field, value) => {
        setSettingsData(prevData => ({
            ...prevData,
            [category]: {
                ...prevData[category],
                [field]: value
            }
        }));
    };

    // Function to handle bulk collection request status changes
    const handleBulkCollectionStatusChange = (requestId, newStatus) => {
        setBulkCollectionRequests(prevRequests =>
            prevRequests.map(request =>
                request.id === requestId
                    ? { ...request, status: newStatus }
                    : request
            )
        );
    };

    // Function to assign vehicle and driver to bulk collection
    const assignBulkCollection = (requestId, vehicle, driver, collectionDate) => {
        setBulkCollectionRequests(prevRequests =>
            prevRequests.map(request =>
                request.id === requestId
                    ? {
                        ...request,
                        status: 'Confirmed',
                        assignedVehicle: vehicle,
                        assignedDriver: driver,
                        collectionDate: collectionDate
                    }
                    : request
            )
        );
    };

    // Function to mark bulk collection as completed
    const completeBulkCollection = (requestId, actualWeight) => {
        setBulkCollectionRequests(prevRequests =>
            prevRequests.map(request =>
                request.id === requestId
                    ? {
                        ...request,
                        status: 'Completed',
                        actualWeight: actualWeight
                    }
                    : request
            )
        );
    };

    /**
     * Collection Statistics
     * 
     * Mock data representing key metrics for waste collection operations.
     * In a production environment, this would be fetched from an API.
     */
    const collectionStats = {
        totalCollections: 156,
        pendingCollections: 23,
        completedCollections: 133,
        inProgressCollections: 22,
        totalWasteCollected: '2,450 kg',
        recyclingRate: '68%'
    };

    /**
     * Recent Collections Data
     * 
     * Mock data for recently completed or pending collections.
     * Each collection record contains essential information about the collection.
     */
    const recentCollections = [
        { id: 1, location: '123 Main St', date: '2023-04-08', status: 'Completed', wasteType: 'Mixed', weight: '45 kg' },
        { id: 2, location: '456 Oak Ave', date: '2023-04-07', status: 'Completed', wasteType: 'Organic', weight: '32 kg' },
        { id: 3, location: '789 Pine Rd', date: '2023-04-07', status: 'Completed', wasteType: 'Recyclable', weight: '28 kg' },
        { id: 4, location: '321 Elm St', date: '2023-04-06', status: 'Pending', wasteType: 'Mixed', weight: 'N/A' },
        { id: 5, location: '654 Maple Dr', date: '2023-04-06', status: 'Pending', wasteType: 'Organic', weight: 'N/A' },
    ];

    /**
     * Upcoming Collections Data
     * 
     * Mock data for scheduled future collections.
     * Contains information about planned collection routes and times.
     */
    const upcomingCollections = [
        { id: 6, location: '987 Cedar Ln', date: '2023-04-09', time: '09:00 AM', wasteType: 'Mixed' },
        { id: 7, location: '147 Birch St', date: '2023-04-09', time: '10:30 AM', wasteType: 'Recyclable' },
        { id: 8, location: '258 Willow Ave', date: '2023-04-10', time: '08:00 AM', wasteType: 'Organic' },
        { id: 9, location: '369 Spruce Rd', date: '2023-04-10', time: '11:00 AM', wasteType: 'Mixed' },
        { id: 10, location: '741 Fir Dr', date: '2023-04-11', time: '09:30 AM', wasteType: 'Recyclable' },
    ];

    /**
     * Residents Data
     * 
     * Mock data for registered residents in the waste collection service.
     * Contains contact information and collection preferences.
     */
    const [residents, setResidents] = useState([
        { id: 1, name: 'John Smith', address: '123 Main St', postalCode: '10001', phone: '555-123-4567', email: 'john.smith@email.com' },
        { id: 2, name: 'Jane Doe', address: '456 Oak Ave', postalCode: '10002', phone: '555-234-5678', email: 'jane.doe@email.com' },
        { id: 3, name: 'Robert Johnson', address: '789 Pine Rd', postalCode: '10003', phone: '555-345-6789', email: 'robert.johnson@email.com' },
        { id: 4, name: 'Emily Davis', address: '321 Elm St', postalCode: '10004', phone: '555-456-7890', email: 'emily.davis@email.com' },
        { id: 5, name: 'Michael Wilson', address: '654 Maple Dr', postalCode: '10005', phone: '555-567-8901', email: 'michael.wilson@email.com' },
    ]);

    /**
     * Vehicles Data
     * 
     * Mock data for the vehicle fleet used in waste collection operations.
     * Contains detailed information about each vehicle's specifications and status.
     */
    const [vehicles, setVehicles] = useState([
        {
            id: 'Truck-001',
            name: 'Truck-001',
            type: 'Garbage Truck',
            capacity: '5 tons',
            licensePlate: 'ABC123',
            status: 'active',
            assignedDriver: 'John Driver',
            wasteType: 'Mixed'
        },
        {
            id: 2,
            name: 'Van-001',
            type: 'Recycling Van',
            capacity: '2 tons',
            licensePlate: 'DEF456',
            status: 'Active',
            lastMaintenance: '2023-03-10',
            nextMaintenance: '2023-06-10',
            fuelLevel: '60%',
            assignedDriver: 'Sarah Driver',
            wasteType: 'Recyclable'
        },
        {
            id: 3,
            name: 'Truck-002',
            type: 'Organic Waste Truck',
            capacity: '4 tons',
            licensePlate: 'GHI789',
            status: 'Maintenance',
            lastMaintenance: '2023-04-01',
            nextMaintenance: '2023-07-01',
            fuelLevel: '30%',
            assignedDriver: 'Mike Driver',
            wasteType: 'Organic'
        },
        {
            id: 4,
            name: 'Van-002',
            type: 'Recycling Van',
            capacity: '2 tons',
            licensePlate: 'JKL012',
            status: 'Active',
            lastMaintenance: '2023-03-20',
            nextMaintenance: '2023-06-20',
            fuelLevel: '85%',
            assignedDriver: 'Lisa Driver',
            wasteType: 'Recyclable'
        },
        {
            id: 5,
            name: 'Truck-003',
            type: 'Garbage Truck',
            capacity: '5 tons',
            licensePlate: 'MNO345',
            status: 'Inactive',
            lastMaintenance: '2023-02-15',
            nextMaintenance: '2023-05-15',
            fuelLevel: '10%',
            assignedDriver: 'Tom Driver',
            wasteType: 'Mixed'
        },
    ]);

    /**
     * Vehicle Statistics
     * 
     * Summary statistics for the vehicle fleet.
     * Provides a quick overview of vehicle operational status.
     */
    const vehicleStats = {
        totalVehicles: 5,
        activeVehicles: 3,
        maintenanceVehicles: 1,
        inactiveVehicles: 1
    };

    /**
     * Collections Data
     * 
     * Detailed mock data for all collections, including those in progress.
     * Contains comprehensive information about each collection operation.
     */
    const [collections, setCollections] = useState([
        {
            id: 1,
            location: '123 Main Street',
            date: '2024-03-15',
            time: '09:00 AM',
            status: 'Completed',
            wasteType: 'Mixed',
            weight: '250 kg',
            assignedVehicle: 'Truck-001',
            assignedDriver: 'John Driver',
            notes: 'Regular collection completed'
        },
        {
            id: 2,
            location: '456 Oak Avenue',
            date: '2024-03-15',
            time: '10:30 AM',
            status: 'Pending',
            wasteType: 'Recyclable',
            weight: 'N/A',
            assignedVehicle: 'Van-001',
            assignedDriver: 'Sarah Driver',
            notes: 'Scheduled collection'
        },
        {
            id: 3,
            location: '789 Pine Road',
            date: '2024-03-15',
            time: '02:00 PM',
            status: 'In Progress',
            wasteType: 'Organic',
            weight: '180 kg',
            assignedVehicle: 'Truck-002',
            assignedDriver: 'Mike Driver',
            notes: 'Collection in progress'
        },
        {
            id: 4,
            location: '321 Elm Street',
            date: '2024-03-16',
            time: '08:00 AM',
            status: 'Scheduled',
            wasteType: 'Mixed',
            weight: 'N/A',
            assignedVehicle: 'Truck-001',
            assignedDriver: 'John Driver',
            notes: 'Upcoming collection'
        },
        {
            id: 5,
            location: '654 Maple Drive',
            date: '2024-03-16',
            time: '11:00 AM',
            status: 'Scheduled',
            wasteType: 'Recyclable',
            weight: 'N/A',
            assignedVehicle: 'Van-002',
            assignedDriver: 'Lisa Driver',
            notes: 'Upcoming collection'
        }
    ]);

    // Add new state for new collection form
    const [showNewCollectionForm, setShowNewCollectionForm] = useState(false);
    const [newCollectionData, setNewCollectionData] = useState({
        location: '',
        date: '',
        time: '',
        status: 'Scheduled',
        wasteType: 'Mixed',
        assignedVehicle: ''
    });

    // Handle new collection form input changes
    const handleNewCollectionChange = (e) => {
        const { name, value } = e.target;
        setNewCollectionData(prevData => ({
            ...prevData,
            [name]: value
        }));
    };

    // Handle new collection form submission
    const handleNewCollectionSubmit = () => {
        if (!newCollectionData.location || !newCollectionData.date || !newCollectionData.time || !newCollectionData.assignedVehicle) {
            alert('Please fill in all required fields');
            return;
        }

        const newCollection = {
            id: collections.length + 1,
            location: newCollectionData.location,
            date: newCollectionData.date,
            time: newCollectionData.time,
            status: 'Scheduled',
            wasteType: newCollectionData.wasteType,
            vehicle: newCollectionData.assignedVehicle,
            type: 'Collection'
        };

        // Update collections state
        setCollections(prevCollections => [...prevCollections, newCollection]);

        // Reset form
        setNewCollectionData({
            location: '',
            date: '',
            time: '',
            status: 'Scheduled',
            wasteType: 'Mixed',
            assignedVehicle: ''
        });
        setShowNewCollectionForm(false);

        // Switch to schedule tab and calendar view
        setActiveTab('schedule');
        setScheduleView('calendar');
        setSelectedDate(new Date(newCollectionData.date));
    };

    // Add state for editing
    const [editingCollection, setEditingCollection] = useState(null);
    const [editFormData, setEditFormData] = useState({
        location: '',
        date: '',
        time: '',
        status: '',
        wasteType: '',
        weight: '',
        assignedVehicle: '',
        assignedDriver: '',
        notes: ''
    });

    // Handle edit button click
    const handleEditClick = (collection) => {
        setEditingCollection(collection.id);
        setEditFormData({
            location: collection.location,
            date: collection.date,
            time: collection.time,
            status: collection.status,
            wasteType: collection.wasteType,
            weight: collection.weight,
            assignedVehicle: collection.assignedVehicle,
            assignedDriver: collection.assignedDriver,
            notes: collection.notes
        });
    };

    // Handle form input changes
    const handleEditFormChange = (e) => {
        const { name, value } = e.target;
        setEditFormData({
            ...editFormData,
            [name]: value
        });
    };

    // Handle form submission
    const handleEditFormSubmit = (e) => {
        e.preventDefault();
        setCollections(collections.map(collection =>
            collection.id === editingCollection
                ? { ...collection, ...editFormData }
                : collection
        ));
        setEditingCollection(null);
    };

    // Handle delete button click
    const handleDeleteClick = (collectionId) => {
        setCollections(collections.filter(collection => collection.id !== collectionId));
    };

    /**
     * Schedule Data
     * 
     * Mock data for the waste collection center's schedule.
     * Includes collections, staff assignments, and vehicle schedules.
     */
    const scheduleData = {
        collections: [
            { id: 1, title: 'Morning Collection Route', date: '2024-03-16', startTime: '08:00 AM', endTime: '12:00 PM', location: 'Downtown Area', assignedTo: 'John Driver', vehicle: 'Truck-001', status: 'Scheduled' },
            { id: 2, title: 'Afternoon Collection Route', date: '2024-03-16', startTime: '01:00 PM', endTime: '05:00 PM', location: 'Suburban Area', assignedTo: 'Sarah Driver', vehicle: 'Van-001', status: 'Scheduled' },
            { id: 3, title: 'Evening Collection Route', date: '2024-03-16', startTime: '06:00 PM', endTime: '10:00 PM', location: 'Industrial Area', assignedTo: 'Mike Driver', vehicle: 'Truck-002', status: 'Scheduled' },
        ],
        staff: [
            { id: 11, title: 'John Driver', date: '2024-03-16', startTime: '08:00 AM', endTime: '05:00 PM', role: 'Collection Driver', location: 'Downtown Area', status: 'Scheduled' },
            { id: 12, title: 'Sarah Driver', date: '2024-03-16', startTime: '01:00 PM', endTime: '10:00 PM', role: 'Collection Driver', location: 'Suburban Area', status: 'Scheduled' },
            { id: 13, title: 'Mike Driver', date: '2024-03-16', startTime: '06:00 PM', endTime: '02:00 AM', role: 'Collection Driver', location: 'Industrial Area', status: 'Scheduled' },
            { id: 14, title: 'Lisa Driver', date: '2024-03-17', startTime: '09:00 AM', endTime: '05:00 PM', role: 'Collection Driver', location: 'Commercial District', status: 'Scheduled' },
            { id: 15, title: 'Tom Driver', date: '2024-03-17', startTime: '02:00 PM', endTime: '10:00 PM', role: 'Collection Driver', location: 'Industrial Park', status: 'Scheduled' },
        ],
        vehicles: [
            { id: 21, title: 'Truck-001', date: '2024-03-16', startTime: '08:00 AM', endTime: '12:00 PM', type: 'Garbage Truck', assignedTo: 'John Driver', route: 'Downtown Area', status: 'Scheduled' },
            { id: 22, title: 'Van-001', date: '2024-03-16', startTime: '01:00 PM', endTime: '05:00 PM', type: 'Recycling Van', assignedTo: 'Sarah Driver', route: 'Suburban Area', status: 'Scheduled' },
            { id: 23, title: 'Truck-002', date: '2024-03-16', startTime: '06:00 PM', endTime: '10:00 PM', type: 'Organic Waste Truck', assignedTo: 'Mike Driver', route: 'Industrial Area', status: 'Scheduled' },
            { id: 24, title: 'Van-002', date: '2024-03-17', startTime: '09:00 AM', endTime: '11:00 AM', type: 'Recycling Van', assignedTo: 'Lisa Driver', route: 'Commercial District', status: 'Scheduled' },
            { id: 25, title: 'Truck-003', date: '2024-03-17', startTime: '02:00 PM', endTime: '04:00 PM', type: 'Garbage Truck', assignedTo: 'Tom Driver', route: 'Industrial Park', status: 'Scheduled' },
        ]
    };

    /**
     * Report Data
     * 
     * Mock data for various reports and analytics.
     * In a production environment, this would be fetched from an API.
     */
    const reportData = {
        collectionTrends: [
            { month: 'Jan', collections: 145, wasteCollected: '2,100 kg', recyclingRate: '65%' },
            { month: 'Feb', collections: 152, wasteCollected: '2,250 kg', recyclingRate: '67%' },
            { month: 'Mar', collections: 148, wasteCollected: '2,180 kg', recyclingRate: '68%' },
            { month: 'Apr', collections: 156, wasteCollected: '2,450 kg', recyclingRate: '68%' },
            { month: 'May', collections: 162, wasteCollected: '2,600 kg', recyclingRate: '70%' },
            { month: 'Jun', collections: 158, wasteCollected: '2,500 kg', recyclingRate: '71%' },
        ],
        wasteTypeDistribution: [
            { type: 'Mixed', percentage: 40, weight: '980 kg' },
            { type: 'Organic', percentage: 25, weight: '612 kg' },
            { type: 'Recyclable', percentage: 35, weight: '858 kg' },
        ],
        areaPerformance: [
            { area: 'Downtown', collections: 45, completionRate: '98%', recyclingRate: '72%' },
            { area: 'Suburban', collections: 38, completionRate: '95%', recyclingRate: '68%' },
            { area: 'Industrial', collections: 42, completionRate: '92%', recyclingRate: '65%' },
            { area: 'Residential', collections: 31, completionRate: '97%', recyclingRate: '70%' },
            { area: 'Commercial', collections: 28, completionRate: '96%', recyclingRate: '69%' },
        ],
        vehicleEfficiency: [
            { vehicle: 'Truck-001', trips: 85, distance: '1,250 km', fuelUsed: '450 L', efficiency: '2.8 km/L' },
            { vehicle: 'Van-001', trips: 92, distance: '980 km', fuelUsed: '320 L', efficiency: '3.1 km/L' },
            { vehicle: 'Truck-002', trips: 78, distance: '1,180 km', fuelUsed: '420 L', efficiency: '2.8 km/L' },
            { vehicle: 'Van-002', trips: 88, distance: '950 km', fuelUsed: '310 L', efficiency: '3.1 km/L' },
            { vehicle: 'Truck-003', trips: 82, distance: '1,220 km', fuelUsed: '440 L', efficiency: '2.8 km/L' },
        ],
        staffPerformance: [
            { staff: 'John Driver', collections: 42, completionRate: '98%', customerRating: '4.8/5' },
            { staff: 'Sarah Driver', collections: 38, completionRate: '97%', customerRating: '4.7/5' },
            { staff: 'Mike Driver', collections: 40, completionRate: '96%', customerRating: '4.6/5' },
            { staff: 'Lisa Driver', collections: 36, completionRate: '98%', customerRating: '4.9/5' },
            { staff: 'Tom Driver', collections: 39, completionRate: '95%', customerRating: '4.5/5' },
        ],
        costAnalysis: [
            { category: 'Fuel', amount: '$2,450', percentage: 35 },
            { category: 'Maintenance', amount: '$1,800', percentage: 25 },
            { category: 'Staff', amount: '$1,500', percentage: 20 },
            { category: 'Equipment', amount: '$1,000', percentage: 15 },
            { category: 'Other', amount: '$500', percentage: 5 },
        ]
    };

    // Add shop data after other mock data
    const shopData = {
        categories: [
            "Bins & Containers",
            "Safety Equipment",
            "Recycling Equipment",
            "Waste Processing",
            "Educational Materials",
            "Organic Products",
            "Plastic Recycling"
        ],
        products: [
            {
                id: 1,
                name: "Large Recycling Bin",
                category: "Bins & Containers",
                description: "120L capacity recycling bin with color-coded compartments",
                price: 89.99,
                stock: 15,
                rating: 4.5,
                image: "https://via.placeholder.com/300x200?text=Recycling+Bin"
            },
            {
                id: 2,
                name: "Safety Gloves",
                category: "Safety Equipment",
                description: "Heavy-duty gloves for waste handling",
                price: 24.99,
                stock: 50,
                rating: 4.2,
                image: "https://via.placeholder.com/300x200?text=Safety+Gloves"
            },
            {
                id: 3,
                name: "Plastic Shredder",
                category: "Recycling Equipment",
                description: "Industrial-grade plastic waste shredder",
                price: 2499.99,
                stock: 3,
                rating: 4.8,
                image: "https://via.placeholder.com/300x200?text=Plastic+Shredder"
            },
            {
                id: 4,
                name: "Paper Baler",
                category: "Recycling Equipment",
                description: "Compact paper and cardboard baler",
                price: 1899.99,
                stock: 2,
                rating: 4.7,
                image: "https://via.placeholder.com/300x200?text=Paper+Baler"
            },
            {
                id: 5,
                name: "Glass Crusher",
                category: "Recycling Equipment",
                description: "Commercial glass crushing machine",
                price: 2999.99,
                stock: 1,
                rating: 4.9,
                image: "https://via.placeholder.com/300x200?text=Glass+Crusher"
            },
            {
                id: 6,
                name: "Composting Unit",
                category: "Waste Processing",
                description: "Large-scale organic waste composting system",
                price: 3499.99,
                stock: 2,
                rating: 4.6,
                image: "https://via.placeholder.com/300x200?text=Composting+Unit"
            },
            {
                id: 7,
                name: "Recycling Education Kit",
                category: "Educational Materials",
                description: "Complete educational kit for teaching recycling",
                price: 149.99,
                stock: 20,
                rating: 4.4,
                image: "https://via.placeholder.com/300x200?text=Education+Kit"
            },
            {
                id: 8,
                name: "Electronic Waste Bin",
                category: "Bins & Containers",
                description: "Secure container for e-waste collection",
                price: 199.99,
                stock: 8,
                rating: 4.3,
                image: "https://via.placeholder.com/300x200?text=E-Waste+Bin"
            },
            {
                id: 9,
                name: "Hazardous Waste Container",
                category: "Bins & Containers",
                description: "Specialized container for hazardous materials",
                price: 299.99,
                stock: 5,
                rating: 4.7,
                image: "https://via.placeholder.com/300x200?text=Hazardous+Waste+Container"
            },
            {
                id: 10,
                name: "Recycling Sorting Station",
                category: "Recycling Equipment",
                description: "Multi-compartment sorting station",
                price: 599.99,
                stock: 4,
                rating: 4.5,
                image: "https://via.placeholder.com/300x200?text=Sorting+Station"
            },
            {
                id: 11,
                name: "Premium Organic Compost",
                category: "Organic Products",
                description: "High-quality organic compost made from recycled food waste, perfect for gardening",
                price: 29.99,
                stock: 50,
                rating: 4.8,
                image: "https://via.placeholder.com/300x200?text=Organic+Compost"
            },
            {
                id: 12,
                name: "Home Composting Kit",
                category: "Organic Products",
                description: "Complete kit for home composting including bin, starter mix, and guide",
                price: 79.99,
                stock: 25,
                rating: 4.6,
                image: "https://via.placeholder.com/300x200?text=Composting+Kit"
            },
            {
                id: 13,
                name: "Herb Garden Starter Kit",
                category: "Organic Products",
                description: "Everything needed to start your own organic herb garden",
                price: 49.99,
                stock: 30,
                rating: 4.7,
                image: "https://via.placeholder.com/300x200?text=Herb+Garden+Kit"
            },
            {
                id: 14,
                name: "Vegetable Grow Kit",
                category: "Organic Products",
                description: "Complete kit for growing organic vegetables at home",
                price: 59.99,
                stock: 20,
                rating: 4.5,
                image: "https://via.placeholder.com/300x200?text=Vegetable+Grow+Kit"
            },
            {
                id: 15,
                name: "Recycled Plastic Pellets (5kg)",
                category: "Plastic Recycling",
                description: "High-quality recycled plastic pellets for manufacturing",
                price: 89.99,
                stock: 15,
                rating: 4.4,
                image: "https://via.placeholder.com/300x200?text=Plastic+Pellets"
            },
            {
                id: 16,
                name: "Plastic Recycling Bundle (10kg)",
                category: "Plastic Recycling",
                description: "Mixed recycled plastic materials for industrial use",
                price: 149.99,
                stock: 10,
                rating: 4.3,
                image: "https://via.placeholder.com/300x200?text=Plastic+Bundle"
            },
            {
                id: 17,
                name: "Organic Fertilizer Mix",
                category: "Organic Products",
                description: "Natural fertilizer made from composted organic waste",
                price: 39.99,
                stock: 40,
                rating: 4.7,
                image: "https://via.placeholder.com/300x200?text=Organic+Fertilizer"
            },
            {
                id: 18,
                name: "Indoor Plant Grow Kit",
                category: "Organic Products",
                description: "Complete kit for growing plants indoors with recycled materials",
                price: 69.99,
                stock: 15,
                rating: 4.6,
                image: "https://via.placeholder.com/300x200?text=Indoor+Grow+Kit"
            }
        ]
    };

    // Add shop state after other state declarations
    const [shopCategory, setShopCategory] = useState('all');
    const [cart, setCart] = useState([]);
    const [searchQuery, setSearchQuery] = useState('');

    // Add shop functions after other functions
    const addToCart = (product) => {
        setCart(prevCart => {
            const existingItem = prevCart.find(item => item.id === product.id);
            if (existingItem) {
                return prevCart.map(item =>
                    item.id === product.id
                        ? { ...item, quantity: item.quantity + 1 }
                        : item
                );
            }
            return [...prevCart, { ...product, quantity: 1 }];
        });
    };

    const removeFromCart = (productId) => {
        setCart(prevCart => prevCart.filter(item => item.id !== productId));
    };

    const updateQuantity = (productId, quantity) => {
        if (quantity < 1) return;
        setCart(prevCart =>
            prevCart.map(item =>
                item.id === productId
                    ? { ...item, quantity }
                    : item
            )
        );
    };

    // Add daily transactions data after other mock data
    const dailyTransactions = [
        {
            id: 1,
            date: '2024-03-15',
            time: '09:15 AM',
            type: 'Collection',
            amount: 250.00,
            status: 'Completed',
            description: 'Regular waste collection - Downtown area',
            paymentMethod: 'Cash',
            reference: 'COL-2024-001'
        },
        {
            id: 2,
            date: '2024-03-15',
            time: '10:30 AM',
            type: 'Shop',
            amount: 89.99,
            status: 'Completed',
            description: 'Large Recycling Bin purchase',
            paymentMethod: 'Credit Card',
            reference: 'SHOP-2024-001'
        },
        {
            id: 3,
            date: '2024-03-15',
            time: '11:45 AM',
            type: 'Collection',
            amount: 180.00,
            status: 'Completed',
            description: 'Bulk waste collection - Industrial area',
            paymentMethod: 'Bank Transfer',
            reference: 'COL-2024-002'
        },
        {
            id: 4,
            date: '2024-03-15',
            time: '02:15 PM',
            type: 'Shop',
            amount: 149.99,
            status: 'Completed',
            description: 'Plastic Recycling Bundle purchase',
            paymentMethod: 'Credit Card',
            reference: 'SHOP-2024-002'
        },
        {
            id: 5,
            date: '2024-03-15',
            time: '03:30 PM',
            type: 'Collection',
            amount: 320.00,
            status: 'Pending',
            description: 'Hazardous waste collection - Commercial area',
            paymentMethod: 'Bank Transfer',
            reference: 'COL-2024-003'
        },
        {
            id: 6,
            date: '2024-03-15',
            time: '04:45 PM',
            type: 'Shop',
            amount: 29.99,
            status: 'Completed',
            description: 'Premium Organic Compost purchase',
            paymentMethod: 'Credit Card',
            reference: 'SHOP-2024-003'
        }
    ];

    // Add transaction statistics
    const transactionStats = {
        totalTransactions: dailyTransactions.length,
        totalAmount: dailyTransactions.reduce((sum, t) => sum + t.amount, 0),
        completedTransactions: dailyTransactions.filter(t => t.status === 'Completed').length,
        pendingTransactions: dailyTransactions.filter(t => t.status === 'Pending').length,
        collectionRevenue: dailyTransactions.filter(t => t.type === 'Collection').reduce((sum, t) => sum + t.amount, 0),
        shopRevenue: dailyTransactions.filter(t => t.type === 'Shop').reduce((sum, t) => sum + t.amount, 0)
    };

    // Add shop transaction data after other mock data
    const shopTransactions = [
        {
            id: 1,
            date: '2024-03-15',
            time: '10:30 AM',
            customer: 'John Smith',
            items: [
                { name: 'Large Recycling Bin', quantity: 1, price: 89.99 },
                { name: 'Safety Gloves', quantity: 2, price: 24.99 }
            ],
            total: 139.97,
            paymentMethod: 'Credit Card',
            status: 'Completed',
            reference: 'SHOP-2024-001'
        },
        {
            id: 2,
            date: '2024-03-15',
            time: '02:15 PM',
            customer: 'Jane Doe',
            items: [
                { name: 'Plastic Recycling Bundle', quantity: 1, price: 149.99 },
                { name: 'Recycling Education Kit', quantity: 1, price: 149.99 }
            ],
            total: 299.98,
            paymentMethod: 'Credit Card',
            status: 'Completed',
            reference: 'SHOP-2024-002'
        },
        {
            id: 3,
            date: '2024-03-15',
            time: '04:45 PM',
            customer: 'Robert Johnson',
            items: [
                { name: 'Premium Organic Compost', quantity: 3, price: 29.99 },
                { name: 'Home Composting Kit', quantity: 1, price: 79.99 }
            ],
            total: 169.96,
            paymentMethod: 'Cash',
            status: 'Completed',
            reference: 'SHOP-2024-003'
        },
        {
            id: 4,
            date: '2024-03-15',
            time: '05:30 PM',
            customer: 'Emily Davis',
            items: [
                { name: 'Herb Garden Starter Kit', quantity: 2, price: 49.99 },
                { name: 'Organic Fertilizer Mix', quantity: 1, price: 39.99 }
            ],
            total: 139.97,
            paymentMethod: 'Bank Transfer',
            status: 'Pending',
            reference: 'SHOP-2024-004'
        }
    ];

    // Add shop transaction statistics
    const shopTransactionStats = {
        totalTransactions: shopTransactions.length,
        totalRevenue: shopTransactions.reduce((sum, t) => sum + t.total, 0),
        completedTransactions: shopTransactions.filter(t => t.status === 'Completed').length,
        pendingTransactions: shopTransactions.filter(t => t.status === 'Pending').length,
        averageTransactionValue: shopTransactions.reduce((sum, t) => sum + t.total, 0) / shopTransactions.length,
        topSellingItems: [
            { name: 'Premium Organic Compost', quantity: 3 },
            { name: 'Herb Garden Starter Kit', quantity: 2 },
            { name: 'Safety Gloves', quantity: 2 }
        ]
    };

    // Add logout function
    const handleLogout = () => {
        // Clear all stored user data
        localStorage.clear();

        // Redirect to login page
        navigate('/login', { replace: true });
    };

    // Add new state for new vehicle form
    const [showNewVehicleForm, setShowNewVehicleForm] = useState(false);
    const [newVehicleData, setNewVehicleData] = useState({
        id: '',
        vehicleNumber: '',
        type: '',
        capacity: '',
        fuelLevel: '',
        status: 'Active',
        lastMaintenance: '',
        nextMaintenance: '',
        assignedDriver: '',
        notes: ''
    });

    // Handle new vehicle form input changes
    const handleNewVehicleChange = (e) => {
        const { name, value } = e.target;
        setNewVehicleData({
            ...newVehicleData,
            [name]: value
        });
    };

    // Handle new vehicle form submission
    const handleNewVehicleSubmit = () => {
        const newVehicle = {
            ...newVehicleData,
            id: vehicles.length + 1
        };
        setVehicles([...vehicles, newVehicle]);
        setShowNewVehicleForm(false);
        setNewVehicleData({
            id: '',
            vehicleNumber: '',
            type: '',
            capacity: '',
            fuelLevel: '',
            status: 'Active',
            lastMaintenance: '',
            nextMaintenance: '',
            assignedDriver: '',
            notes: ''
        });
    };

    // Add state for editing vehicles
    const [editingVehicle, setEditingVehicle] = useState(null);
    const [editVehicleForm, setEditVehicleForm] = useState({
        name: '',
        type: '',
        capacity: '',
        licensePlate: '',
        status: '',
        assignedDriver: '',
        wasteType: ''
    });

    // Handle edit vehicle button click
    const handleEditVehicleClick = (vehicle) => {
        setEditingVehicle(vehicle);
        setEditVehicleForm({
            name: vehicle.name,
            type: vehicle.type,
            capacity: vehicle.capacity,
            licensePlate: vehicle.licensePlate,
            status: vehicle.status,
            assignedDriver: vehicle.assignedDriver,
            wasteType: vehicle.wasteType
        });
    };

    // Handle form changes in edit mode
    const handleEditVehicleChange = (e) => {
        const { name, value } = e.target;
        setEditVehicleForm(prevForm => ({
            ...prevForm,
            [name]: value
        }));
    };

    // Handle edit form submission
    const handleEditVehicleSubmit = (vehicleId) => {
        setVehicles(vehicles.map(vehicle =>
            vehicle.id === vehicleId
                ? { ...vehicle, ...editVehicleForm }
                : vehicle
        ));
        setEditingVehicle(null);
        setEditVehicleForm({
            name: '',
            type: '',
            capacity: '',
            licensePlate: '',
            status: '',
            assignedDriver: '',
            wasteType: ''
        });
    };

    // Handle delete vehicle
    const handleDeleteVehicle = (vehicleId) => {
        if (window.confirm('Are you sure you want to delete this vehicle?')) {
            setVehicles(vehicles.filter(vehicle => vehicle.id !== vehicleId));
        }
    };

    // Handle maintenance status toggle
    const handleMaintenanceClick = (vehicleId) => {
        setVehicles(vehicles.map(vehicle =>
            vehicle.id === vehicleId
                ? { ...vehicle, status: vehicle.status === 'maintenance' ? 'active' : 'maintenance' }
                : vehicle
        ));
    };

    // Add state for residents
    const [editingResident, setEditingResident] = useState(null);
    const [editResidentForm, setEditResidentForm] = useState({
        name: '',
        address: '',
        postalCode: '',
        phone: '',
        email: ''
    });

    // Handle edit resident button click
    const handleEditResidentClick = (resident) => {
        setEditingResident(resident);
        setEditResidentForm({
            name: resident.name,
            address: resident.address,
            postalCode: resident.postalCode,
            phone: resident.phone,
            email: resident.email
        });
    };

    // Handle resident form changes
    const handleEditResidentChange = (e) => {
        const { name, value } = e.target;
        setEditResidentForm(prevForm => ({
            ...prevForm,
            [name]: value
        }));
    };

    // Handle edit form submission
    const handleEditResidentSubmit = (residentId) => {
        setResidents(residents.map(resident =>
            resident.id === residentId
                ? { ...resident, ...editResidentForm }
                : resident
        ));
        setEditingResident(null);
        setEditResidentForm({
            name: '',
            address: '',
            postalCode: '',
            phone: '',
            email: ''
        });
    };

    // Handle delete resident
    const handleDeleteResident = (residentId) => {
        if (window.confirm('Are you sure you want to delete this resident?')) {
            setResidents(residents.filter(resident => resident.id !== residentId));
        }
    };

    // Add state for new resident form
    const [showNewResidentForm, setShowNewResidentForm] = useState(false);
    const [newResidentData, setNewResidentData] = useState({
        name: '',
        address: '',
        postalCode: '',
        phone: '',
        email: ''
    });

    // Handle new resident form changes
    const handleNewResidentChange = (e) => {
        const { name, value } = e.target;
        setNewResidentData(prevData => ({
            ...prevData,
            [name]: value
        }));
    };

    // Handle new resident form submission
    const handleNewResidentSubmit = () => {
        const newResident = {
            ...newResidentData,
            id: residents.length + 1
        };
        setResidents([...residents, newResident]);
        setShowNewResidentForm(false);
        setNewResidentData({
            name: '',
            address: '',
            postalCode: '',
            phone: '',
            email: ''
        });
    };

    // Add this function to handle date selection
    const handleDateSelect = (date) => {
        setSelectedDate(date);
    };

    // Add this function to get events for a specific date
    const getEventsForDate = (date) => {
        const dateString = date.toISOString().split('T')[0];
        return collections.filter(collection => collection.date === dateString);
    };

    const [complaints, setComplaints] = useState([
        {
            id: 1,
            residentName: 'John Smith',
            category: 'Collection Service',
            title: 'Missed Collection',
            description: 'The waste collection was not done on the scheduled date. This is the second time this month.',
            location: '123 Main St',
            status: 'Pending',
            date: '2024-03-15',
            reply: '',
            updatedAt: '2024-03-15'
        },
        {
            id: 2,
            residentName: 'Jane Doe',
            category: 'Vehicle Issue',
            title: 'Noisy Collection Vehicle',
            description: 'The collection vehicle is making excessive noise during early morning collections.',
            location: '456 Oak Ave',
            status: 'In Progress',
            date: '2024-03-14',
            reply: 'We have noted your complaint and will inspect the vehicle for noise issues.',
            updatedAt: '2024-03-14'
        },
        {
            id: 3,
            residentName: 'Robert Johnson',
            category: 'Staff Behavior',
            title: 'Rude Collection Staff',
            description: 'The collection staff was rude and unprofessional during the collection.',
            location: '789 Pine Rd',
            status: 'Resolved',
            date: '2024-03-13',
            reply: 'We apologize for the behavior. The staff member has been counseled and appropriate action has been taken.',
            updatedAt: '2024-03-13'
        }
    ]);

    const [editingComplaint, setEditingComplaint] = useState(null);
    const [editComplaintData, setEditComplaintData] = useState({
        status: '',
        reply: ''
    });

    // Handle complaint status and reply update
    const handleComplaintUpdate = (complaintId) => {
        setComplaints(prevComplaints =>
            prevComplaints.map(complaint =>
                complaint.id === complaintId
                    ? {
                        ...complaint,
                        status: editComplaintData.status,
                        reply: editComplaintData.reply,
                        updatedAt: new Date().toISOString().split('T')[0]
                    }
                    : complaint
            )
        );
        setEditingComplaint(null);
        setEditComplaintData({ status: '', reply: '' });
    };

    // Add these state variables near the top of the component
    const [complaintFilters, setComplaintFilters] = useState({
        category: 'all',
        status: 'all',
        date: ''
    });

    // Add this function to filter complaints
    const getFilteredComplaints = () => {
        return complaints.filter(complaint => {
            const matchesCategory = complaintFilters.category === 'all' || complaint.category === complaintFilters.category;
            const matchesStatus = complaintFilters.status === 'all' || complaint.status === complaintFilters.status;
            const matchesDate = !complaintFilters.date || complaint.date === complaintFilters.date;

            return matchesCategory && matchesStatus && matchesDate;
        });
    };

    // Add this function to handle filter changes
    const handleFilterChange = (e) => {
        const { name, value } = e.target;
        setComplaintFilters(prev => ({
            ...prev,
            [name]: value
        }));
    };

    // Add this function to handle filter button click
    const handleFilterButtonClick = () => {
        // The filtered complaints will be automatically updated through the getFilteredComplaints function
        // This function is here in case you want to add any additional logic when applying filters
        console.log('Filters applied:', complaintFilters);
    };

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

    const handleProcessUpdate = (stepId, newStatus) => {
        const updatedMaterials = recyclingMaterials.map(material => {
            if (material.id === selectedMaterial?.id) {
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

    // Add this after the other state declarations
    const [recyclingMaterials, setRecyclingMaterials] = useState([
        {
            id: 1,
            name: 'Plastic Bottles',
            category: 'Plastic',
            quantity: '500 kg',
            status: 'pending',
            description: 'Mixed plastic bottles from residential collection',
            lastUpdated: '2024-03-15 10:30',
            recyclingCenter: 'Central Recycling Facility',
            processingStatus: {
                currentStep: 'Collection',
                steps: [
                    { id: 'Collection', status: 'completed', startTime: '2024-03-15 09:00', endTime: '2024-03-15 10:30' },
                    { id: 'Sorting', status: 'in-progress', startTime: '2024-03-15 10:30', endTime: null },
                    { id: 'Cleaning', status: 'pending', startTime: null, endTime: null },
                    { id: 'Processing', status: 'pending', startTime: null, endTime: null },
                    { id: 'Quality Check', status: 'pending', startTime: null, endTime: null },
                    { id: 'Packaging', status: 'pending', startTime: null, endTime: null }
                ]
            }
        },
        // ... existing materials ...
    ]);

    const [schedules, setSchedules] = useState([
        {
            id: 1,
            date: '2024-03-20',
            time: '09:00',
            location: 'Main Street Area',
            type: 'Regular Collection',
            status: 'Scheduled',
            vehicle: 'Truck-001',
            notes: 'Regular household waste collection'
        },
        {
            id: 2,
            date: '2024-03-21',
            time: '10:30',
            location: 'Downtown Area',
            type: 'Bulk Collection',
            status: 'Scheduled',
            vehicle: 'Truck-002',
            notes: 'Large item collection'
        }
    ]);

    const [showScheduleModal, setShowScheduleModal] = useState(false);
    const [newSchedule, setNewSchedule] = useState({
        date: '',
        time: '',
        location: '',
        type: 'Regular Collection',
        vehicle: '',
        notes: ''
    });

    const handleScheduleSubmit = (e) => {
        e.preventDefault();
        const schedule = {
            id: schedules.length + 1,
            ...newSchedule,
            status: 'Scheduled'
        };
        setSchedules([...schedules, schedule]);
        setShowScheduleModal(false);
        setNewSchedule({
            date: '',
            time: '',
            location: '',
            type: 'Regular Collection',
            vehicle: '',
            notes: ''
        });
    };

    const [showTruckLocation, setShowTruckLocation] = useState(false);
    const [selectedTruck, setSelectedTruck] = useState(null);

    const handleTruckLocationClick = (vehicle) => {
        setSelectedTruck(vehicle);
        setShowTruckLocation(true);
    };

    /**
     * Component Render
     * 
     * The main UI structure with conditional rendering based on the active tab.
     */
    return (
        <div className="waste-collection-home">
            {/* Header Section */}
            <header className="header">
                <div className="logo">
                    <h1>Waste Management System</h1>
                </div>
                <div className="user-info">
                    <span className="user-name">Waste Collection Center</span>
                    <button className="logout-btn" onClick={handleLogout}>Logout</button>
                </div>
            </header>

            <div className="main-content">
                {/* Sidebar Navigation */}
                <nav className="sidebar">
                    <ul className="nav-menu">
                        <li className={activeTab === 'dashboard' ? 'active' : ''} onClick={() => setActiveTab('dashboard')}>
                            <span className="icon">📊</span> Dashboard
                        </li>
                        <li className={activeTab === 'collections' ? 'active' : ''} onClick={() => setActiveTab('collections')}>
                            <span className="icon">🗑️</span> Collections
                        </li>
                        <li className={activeTab === 'schedule' ? 'active' : ''} onClick={() => setActiveTab('schedule')}>
                            <span className="icon">📅</span> Schedule
                        </li>
                        <li className={activeTab === 'vehicles' ? 'active' : ''} onClick={() => setActiveTab('vehicles')}>
                            <span className="icon">🚛</span> Vehicles
                        </li>
                        <li className={activeTab === 'residents' ? 'active' : ''} onClick={() => setActiveTab('residents')}>
                            <span className="icon">👥</span> Residents Details
                        </li>
                        <li className={activeTab === 'reports' ? 'active' : ''} onClick={() => setActiveTab('reports')}>
                            <span className="icon">📈</span> Reports
                        </li>
                        <li className={activeTab === 'bulk-collection' ? 'active' : ''} onClick={() => setActiveTab('bulk-collection')}>
                            <span className="icon">🗑️</span> Bulk Collection
                        </li>
                        <li className={activeTab === 'recycling' ? 'active' : ''} onClick={() => setActiveTab('recycling')}>
                            <span className="icon">♻️</span> Recycling
                        </li>
                        <li className={activeTab === 'shop' ? 'active' : ''} onClick={() => setActiveTab('shop')}>
                            <span className="icon">🛒</span> Shop
                        </li>
                        <li className={activeTab === 'complaints' ? 'active' : ''} onClick={() => setActiveTab('complaints')}>
                            <span className="icon">📝</span> Complaints
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

                            {/* Dashboard Content */}
                            <div className="dashboard-content">
                                {/* Statistics Cards */}
                                <div className="stats-cards">
                                    <div className="stat-card">
                                        <div className="stat-icon">🗑️</div>
                                        <div className="stat-info">
                                            <h3>Total Collections</h3>
                                            <p className="stat-value">{collectionStats.totalCollections}</p>
                                        </div>
                                    </div>

                                    <div className="stat-card">
                                        <div className="stat-icon">⏳</div>
                                        <div className="stat-info">
                                            <h3>Pending Collections</h3>
                                            <p className="stat-value">{collectionStats.pendingCollections}</p>
                                        </div>
                                    </div>

                                    <div className="stat-card">
                                        <div className="stat-icon">✅</div>
                                        <div className="stat-info">
                                            <h3>Completed Collections</h3>
                                            <p className="stat-value">{collectionStats.completedCollections}</p>
                                        </div>
                                    </div>

                                    <div className="stat-card">
                                        <div className="stat-icon">♻️</div>
                                        <div className="stat-info">
                                            <h3>Recycling Rate</h3>
                                            <p className="stat-value">{collectionStats.recyclingRate}</p>
                                        </div>
                                    </div>
                                </div>

                                {/* Dashboard Grid - Recent and Upcoming Collections */}
                                <div className="dashboard-grid">
                                    <div className="dashboard-card">
                                        <h3>Recent Collections</h3>
                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Location</th>
                                                    <th>Date</th>
                                                    <th>Status</th>
                                                    <th>Waste Type</th>
                                                    <th>Weight</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {recentCollections.map(collection => (
                                                    <tr key={collection.id}>
                                                        <td>{collection.location}</td>
                                                        <td>{collection.date}</td>
                                                        <td>
                                                            <span className={`status-badge ${collection.status.toLowerCase()}`}>
                                                                {collection.status}
                                                            </span>
                                                        </td>
                                                        <td>{collection.wasteType}</td>
                                                        <td>{collection.weight}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                        <button className="view-all-btn">View All Collections</button>
                                    </div>

                                    <div className="dashboard-card">
                                        <h3>Upcoming Collections</h3>
                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Location</th>
                                                    <th>Date</th>
                                                    <th>Time</th>
                                                    <th>Waste Type</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {upcomingCollections.map(collection => (
                                                    <tr key={collection.id}>
                                                        <td>{collection.location}</td>
                                                        <td>{collection.date}</td>
                                                        <td>{collection.time}</td>
                                                        <td>{collection.wasteType}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                        <button className="view-all-btn">View Full Schedule</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Collections Tab */}
                    {activeTab === 'collections' && (
                        <div className="collections">
                            <h2>Collections Management</h2>

                            {/* Collection Statistics */}
                            <div className="stats-cards">
                                <div className="stat-card">
                                    <div className="stat-icon">🗑️</div>
                                    <div className="stat-info">
                                        <h3>Total Collections</h3>
                                        <p className="stat-value">{collectionStats.totalCollections}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">✅</div>
                                    <div className="stat-info">
                                        <h3>Completed</h3>
                                        <p className="stat-value">{collectionStats.completedCollections}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">⏳</div>
                                    <div className="stat-info">
                                        <h3>Pending</h3>
                                        <p className="stat-value">{collectionStats.pendingCollections}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">🔄</div>
                                    <div className="stat-info">
                                        <h3>In Progress</h3>
                                        <p className="stat-value">{collectionStats.inProgressCollections}</p>
                                    </div>
                                </div>
                            </div>

                            {/* Action Bar - Search and Add New Collection */}
                            <div className="action-bar">
                                <button className="add-btn" onClick={() => setShowNewCollectionForm(true)}>Schedule New Collection</button>
                                <div className="search-bar">
                                    <input type="text" placeholder="Search collections..." />
                                    <button className="search-btn">Search</button>
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
                                                onChange={handleNewCollectionChange}
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
                                                onChange={handleNewCollectionChange}
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
                                                onChange={handleNewCollectionChange}
                                                className="form-input"
                                                required
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Waste Type:</label>
                                            <select
                                                name="wasteType"
                                                value={newCollectionData.wasteType}
                                                onChange={handleNewCollectionChange}
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
                                                onChange={handleNewCollectionChange}
                                                className="form-input"
                                                required
                                            >
                                                <option value="">Select Vehicle</option>
                                                <option value="Truck-001">Truck-001</option>
                                                <option value="Van-001">Van-001</option>
                                                <option value="Truck-002">Truck-002</option>
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
                                <table className="data-table">
                                    <thead>
                                        <tr>
                                            <th>Area</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Status</th>
                                            <th>Waste Type</th>
                                            <th>Vehicle No.</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {collections.map(collection => (
                                            <tr key={collection.id}>
                                                {editingCollection === collection.id ? (
                                                    <>
                                                        <td className="edit-cell">
                                                            <input
                                                                type="text"
                                                                name="location"
                                                                value={editFormData.location}
                                                                onChange={handleEditFormChange}
                                                                className="edit-input"
                                                            />
                                                        </td>
                                                        <td className="edit-cell">
                                                            <input
                                                                type="date"
                                                                name="date"
                                                                value={editFormData.date}
                                                                onChange={handleEditFormChange}
                                                                className="edit-input"
                                                            />
                                                        </td>
                                                        <td className="edit-cell">
                                                            <input
                                                                type="time"
                                                                name="time"
                                                                value={editFormData.time}
                                                                onChange={handleEditFormChange}
                                                                className="edit-input"
                                                            />
                                                        </td>
                                                        <td className="edit-cell">
                                                            <select
                                                                name="status"
                                                                value={editFormData.status}
                                                                onChange={handleEditFormChange}
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
                                                                onChange={handleEditFormChange}
                                                                className="edit-input"
                                                            >
                                                                <option value="Mixed">Mixed</option>
                                                                <option value="Organic">Organic</option>
                                                                <option value="Recyclable">Recyclable</option>
                                                            </select>
                                                        </td>
                                                        <td className="edit-cell">
                                                            <select
                                                                name="vehicle"
                                                                value={editFormData.vehicle}
                                                                onChange={handleEditFormChange}
                                                                className="edit-input"
                                                            >
                                                                <option value="Truck-001">Truck-001</option>
                                                                <option value="Truck-002">Truck-002</option>
                                                                <option value="Van-001">Van-001</option>
                                                                <option value="Van-002">Van-002</option>
                                                            </select>
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
                                                        <td>{collection.date}</td>
                                                        <td>{collection.time}</td>
                                                        <td>
                                                            <span className={`status-badge ${collection.status.toLowerCase().replace(' ', '-')}`}>
                                                                {collection.status}
                                                            </span>
                                                        </td>
                                                        <td>{collection.wasteType}</td>
                                                        <td>{collection.vehicle}</td>
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
                            </div>
                        </div>
                    )}

                    {/* Schedule Tab */}
                    {activeTab === 'schedule' && (
                        <div className="schedule-section">
                            <div className="section-header">
                                <h2>Collection Schedule</h2>
                                <div className="schedule-controls">
                                    <div className="view-toggle">
                                        <button
                                            className={`toggle-btn ${scheduleView === 'calendar' ? 'active' : ''}`}
                                            onClick={() => setScheduleView('calendar')}
                                        >
                                            Calendar View
                                        </button>
                                        <button
                                            className={`toggle-btn ${scheduleView === 'list' ? 'active' : ''}`}
                                            onClick={() => setScheduleView('list')}
                                        >
                                            List View
                                        </button>
                                    </div>
                                    <button className="add-schedule-btn" onClick={() => setShowScheduleModal(true)}>
                                        Add New Schedule
                                    </button>
                                </div>
                            </div>

                            {scheduleView === 'calendar' ? (
                                <div className="calendar-view">
                                    <Calendar
                                        onChange={setSelectedDate}
                                        value={selectedDate}
                                        className="waste-calendar"
                                    />
                                    <div className="selected-date-schedules">
                                        <h3>Schedules for {selectedDate.toLocaleDateString()}</h3>
                                        <div className="schedule-list">
                                            {schedules
                                                .filter(schedule => schedule.date === selectedDate.toISOString().split('T')[0])
                                                .map(schedule => (
                                                    <div key={schedule.id} className="schedule-card">
                                                        <div className="schedule-time">{schedule.time}</div>
                                                        <div className="schedule-details">
                                                            <h4>{schedule.type}</h4>
                                                            <p><strong>Location:</strong> {schedule.location}</p>
                                                            <p><strong>Vehicle:</strong> {schedule.vehicle}</p>
                                                            <p><strong>Status:</strong> {schedule.status}</p>
                                                            {schedule.notes && <p><strong>Notes:</strong> {schedule.notes}</p>}
                                                        </div>
                                                    </div>
                                                ))}
                                        </div>
                                    </div>
                                </div>
                            ) : (
                                <div className="list-view">
                                    <div className="schedule-filters">
                                        <select
                                            className="filter-select"
                                            onChange={(e) => {
                                                const filtered = e.target.value === 'all'
                                                    ? schedules
                                                    : schedules.filter(s => s.type === e.target.value);
                                                setSchedules(filtered);
                                            }}
                                        >
                                            <option value="all">All Types</option>
                                            <option value="Regular Collection">Regular Collection</option>
                                            <option value="Bulk Collection">Bulk Collection</option>
                                            <option value="Special Collection">Special Collection</option>
                                        </select>
                                        <select
                                            className="filter-select"
                                            onChange={(e) => {
                                                const filtered = e.target.value === 'all'
                                                    ? schedules
                                                    : schedules.filter(s => s.status === e.target.value);
                                                setSchedules(filtered);
                                            }}
                                        >
                                            <option value="all">All Status</option>
                                            <option value="Scheduled">Scheduled</option>
                                            <option value="In Progress">In Progress</option>
                                            <option value="Completed">Completed</option>
                                            <option value="Cancelled">Cancelled</option>
                                        </select>
                                    </div>
                                    <div className="schedule-list">
                                        {schedules.map(schedule => (
                                            <div key={schedule.id} className="schedule-card">
                                                <div className="schedule-header">
                                                    <div className="schedule-date-time">
                                                        <span className="date">{schedule.date}</span>
                                                        <span className="time">{schedule.time}</span>
                                                    </div>
                                                    <span className={`status-badge ${schedule.status.toLowerCase()}`}>
                                                        {schedule.status}
                                                    </span>
                                                </div>
                                                <div className="schedule-details">
                                                    <h4>{schedule.type}</h4>
                                                    <p><strong>Location:</strong> {schedule.location}</p>
                                                    <p><strong>Vehicle:</strong> {schedule.vehicle}</p>
                                                    {schedule.notes && <p><strong>Notes:</strong> {schedule.notes}</p>}
                                                </div>
                                                <div className="schedule-actions">
                                                    <button className="action-btn edit">Edit</button>
                                                    <button className="action-btn delete">Cancel</button>
                                                    <button
                                                        className="action-btn location"
                                                        onClick={() => handleTruckLocationClick(schedule.vehicle)}
                                                    >
                                                        Truck Live Location
                                                    </button>
                                                </div>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            )}

                            {/* Add Schedule Modal */}
                            {showScheduleModal && (
                                <div className="modal-overlay">
                                    <div className="modal-content">
                                        <h3>Add New Schedule</h3>
                                        <form onSubmit={handleScheduleSubmit}>
                                            <div className="form-group">
                                                <label htmlFor="date">Date</label>
                                                <input
                                                    type="date"
                                                    id="date"
                                                    value={newSchedule.date}
                                                    onChange={(e) => setNewSchedule({ ...newSchedule, date: e.target.value })}
                                                    required
                                                />
                                            </div>
                                            <div className="form-group">
                                                <label htmlFor="time">Time</label>
                                                <input
                                                    type="time"
                                                    id="time"
                                                    value={newSchedule.time}
                                                    onChange={(e) => setNewSchedule({ ...newSchedule, time: e.target.value })}
                                                    required
                                                />
                                            </div>
                                            <div className="form-group">
                                                <label htmlFor="location">Location</label>
                                                <input
                                                    type="text"
                                                    id="location"
                                                    value={newSchedule.location}
                                                    onChange={(e) => setNewSchedule({ ...newSchedule, location: e.target.value })}
                                                    required
                                                />
                                            </div>
                                            <div className="form-group">
                                                <label htmlFor="type">Collection Type</label>
                                                <select
                                                    id="type"
                                                    value={newSchedule.type}
                                                    onChange={(e) => setNewSchedule({ ...newSchedule, type: e.target.value })}
                                                    required
                                                >
                                                    <option value="Regular Collection">Regular Collection</option>
                                                    <option value="Bulk Collection">Bulk Collection</option>
                                                    <option value="Special Collection">Special Collection</option>
                                                </select>
                                            </div>
                                            <div className="form-group">
                                                <label htmlFor="vehicle">Vehicle</label>
                                                <input
                                                    type="text"
                                                    id="vehicle"
                                                    value={newSchedule.vehicle}
                                                    onChange={(e) => setNewSchedule({ ...newSchedule, vehicle: e.target.value })}
                                                    required
                                                />
                                            </div>
                                            <div className="form-group">
                                                <label htmlFor="notes">Notes</label>
                                                <textarea
                                                    id="notes"
                                                    value={newSchedule.notes}
                                                    onChange={(e) => setNewSchedule({ ...newSchedule, notes: e.target.value })}
                                                />
                                            </div>
                                            <div className="modal-actions">
                                                <button type="submit" className="btn-primary">Add Schedule</button>
                                                <button
                                                    type="button"
                                                    className="btn-secondary"
                                                    onClick={() => setShowScheduleModal(false)}
                                                >
                                                    Cancel
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            )}
                        </div>
                    )}

                    {/* Vehicles Tab */}
                    {activeTab === 'vehicles' && (
                        <div className="vehicles">
                            <h2>Vehicle Management</h2>

                            {/* Vehicle Statistics */}
                            <div className="stats-cards">
                                <div className="stat-card">
                                    <div className="stat-icon">🚛</div>
                                    <div className="stat-info">
                                        <h3>Total Vehicles</h3>
                                        <p className="stat-value">{vehicleStats.totalVehicles}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">✅</div>
                                    <div className="stat-info">
                                        <h3>Active Vehicles</h3>
                                        <p className="stat-value">{vehicleStats.activeVehicles}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">🔧</div>
                                    <div className="stat-info">
                                        <h3>In Maintenance</h3>
                                        <p className="stat-value">{vehicleStats.maintenanceVehicles}</p>
                                    </div>
                                </div>

                                <div className="stat-card">
                                    <div className="stat-icon">⛔</div>
                                    <div className="stat-info">
                                        <h3>Inactive Vehicles</h3>
                                        <p className="stat-value">{vehicleStats.inactiveVehicles}</p>
                                    </div>
                                </div>
                            </div>

                            {/* Action Bar */}
                            <div className="action-bar">
                                <button className="add-btn" onClick={() => setShowNewVehicleForm(true)}>Add New Vehicle</button>
                                <div className="search-bar">
                                    <input type="text" placeholder="Search vehicles..." />
                                    <button className="search-btn">Search</button>
                                </div>
                            </div>

                            {/* New Vehicle Form */}
                            {showNewVehicleForm && (
                                <div className="new-collection-form">
                                    <h3>Add New Vehicle</h3>
                                    <div className="form-grid">
                                        <div className="form-group">
                                            <label>Vehicle Number:</label>
                                            <input
                                                type="text"
                                                name="vehicleNumber"
                                                value={newVehicleData.vehicleNumber}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                                required
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Type:</label>
                                            <select
                                                name="type"
                                                value={newVehicleData.type}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                                required
                                            >
                                                <option value="">Select Type</option>
                                                <option value="Truck">Truck</option>
                                                <option value="Van">Van</option>
                                                <option value="Compact">Compact</option>
                                            </select>
                                        </div>
                                        <div className="form-group">
                                            <label>Capacity (kg):</label>
                                            <input
                                                type="number"
                                                name="capacity"
                                                value={newVehicleData.capacity}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                                required
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Fuel Level (%):</label>
                                            <input
                                                type="number"
                                                name="fuelLevel"
                                                value={newVehicleData.fuelLevel}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                                min="0"
                                                max="100"
                                                required
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Status:</label>
                                            <select
                                                name="status"
                                                value={newVehicleData.status}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                                required
                                            >
                                                <option value="Active">Active</option>
                                                <option value="Maintenance">Maintenance</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
                                        </div>
                                        <div className="form-group">
                                            <label>Last Maintenance:</label>
                                            <input
                                                type="date"
                                                name="lastMaintenance"
                                                value={newVehicleData.lastMaintenance}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Next Maintenance:</label>
                                            <input
                                                type="date"
                                                name="nextMaintenance"
                                                value={newVehicleData.nextMaintenance}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Assigned Driver:</label>
                                            <select
                                                name="assignedDriver"
                                                value={newVehicleData.assignedDriver}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                            >
                                                <option value="">Select Driver</option>
                                                <option value="John Driver">John Driver</option>
                                                <option value="Sarah Driver">Sarah Driver</option>
                                                <option value="Mike Driver">Mike Driver</option>
                                            </select>
                                        </div>
                                        <div className="form-group">
                                            <label>Notes:</label>
                                            <textarea
                                                name="notes"
                                                value={newVehicleData.notes}
                                                onChange={handleNewVehicleChange}
                                                className="form-input"
                                            ></textarea>
                                        </div>
                                    </div>
                                    <div className="form-actions">
                                        <button className="action-btn save" onClick={handleNewVehicleSubmit}>Save</button>
                                        <button className="action-btn cancel" onClick={() => setShowNewVehicleForm(false)}>Cancel</button>
                                    </div>
                                </div>
                            )}

                            {/* Vehicles Table */}
                            <div className="dashboard-card">
                                <h3>Vehicle List</h3>
                                <div className="table-responsive">
                                    <table className="vehicle-table">
                                        <thead>
                                            <tr>
                                                <th>Vehicle ID</th>
                                                <th>Type</th>
                                                <th>Capacity</th>
                                                <th>License</th>
                                                <th>Status</th>
                                                <th>Driver</th>
                                                <th>Waste Type</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {vehicles.map(vehicle => (
                                                <tr key={vehicle.id}>
                                                    {editingVehicle && editingVehicle.id === vehicle.id ? (
                                                        <>
                                                            <td>
                                                                <input
                                                                    type="text"
                                                                    className="edit-input"
                                                                    name="name"
                                                                    value={editVehicleForm.name}
                                                                    onChange={handleEditVehicleChange}
                                                                />
                                                            </td>
                                                            <td>
                                                                <select
                                                                    className="edit-input"
                                                                    name="type"
                                                                    value={editVehicleForm.type}
                                                                    onChange={handleEditVehicleChange}
                                                                >
                                                                    <option value="Garbage Truck">Garbage Truck</option>
                                                                    <option value="Recycling Van">Recycling Van</option>
                                                                    <option value="Compactor">Compactor</option>
                                                                </select>
                                                            </td>
                                                            <td>
                                                                <input
                                                                    type="text"
                                                                    className="edit-input"
                                                                    name="capacity"
                                                                    value={editVehicleForm.capacity}
                                                                    onChange={handleEditVehicleChange}
                                                                />
                                                            </td>
                                                            <td>
                                                                <input
                                                                    type="text"
                                                                    className="edit-input"
                                                                    name="licensePlate"
                                                                    value={editVehicleForm.licensePlate}
                                                                    onChange={handleEditVehicleChange}
                                                                />
                                                            </td>
                                                            <td>
                                                                <select
                                                                    className="edit-input"
                                                                    name="status"
                                                                    value={editVehicleForm.status}
                                                                    onChange={handleEditVehicleChange}
                                                                >
                                                                    <option value="active">Active</option>
                                                                    <option value="maintenance">Maintenance</option>
                                                                    <option value="inactive">Inactive</option>
                                                                </select>
                                                            </td>
                                                            <td>
                                                                <input
                                                                    type="text"
                                                                    className="edit-input"
                                                                    name="assignedDriver"
                                                                    value={editVehicleForm.assignedDriver}
                                                                    onChange={handleEditVehicleChange}
                                                                />
                                                            </td>
                                                            <td>
                                                                <select
                                                                    className="edit-input"
                                                                    name="wasteType"
                                                                    value={editVehicleForm.wasteType}
                                                                    onChange={handleEditVehicleChange}
                                                                >
                                                                    <option value="Mixed">Mixed</option>
                                                                    <option value="Recyclable">Recyclable</option>
                                                                    <option value="Organic">Organic</option>
                                                                </select>
                                                            </td>
                                                            <td>
                                                                <button
                                                                    className="action-btn save"
                                                                    onClick={() => handleEditVehicleSubmit(vehicle.id)}
                                                                >
                                                                    Save
                                                                </button>
                                                                <button
                                                                    className="action-btn cancel"
                                                                    onClick={() => setEditingVehicle(null)}
                                                                >
                                                                    Cancel
                                                                </button>
                                                            </td>
                                                        </>
                                                    ) : (
                                                        <>
                                                            <td>{vehicle.name}</td>
                                                            <td>{vehicle.type}</td>
                                                            <td>{vehicle.capacity}</td>
                                                            <td>{vehicle.licensePlate}</td>
                                                            <td>
                                                                <span className={`status-badge ${vehicle.status}`}>
                                                                    {vehicle.status}
                                                                </span>
                                                            </td>
                                                            <td>{vehicle.assignedDriver}</td>
                                                            <td>{vehicle.wasteType}</td>
                                                            <td>
                                                                <button
                                                                    className="action-btn edit"
                                                                    onClick={() => handleEditVehicleClick(vehicle)}
                                                                >
                                                                    Edit
                                                                </button>
                                                                <button
                                                                    className="action-btn delete"
                                                                    onClick={() => handleDeleteVehicle(vehicle.id)}
                                                                >
                                                                    Delete
                                                                </button>
                                                                <button
                                                                    className={`action-btn maintenance ${vehicle.status === 'maintenance' ? 'active' : ''}`}
                                                                    onClick={() => handleMaintenanceClick(vehicle.id)}
                                                                >
                                                                    Maintenance
                                                                </button>
                                                            </td>
                                                        </>
                                                    )}
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Residents Tab */}
                    {activeTab === 'residents' && (
                        <div className="residents">
                            <h2>Residents Details</h2>
                            <div className="action-bar">
                                <button
                                    className="add-btn"
                                    onClick={() => setShowNewResidentForm(true)}
                                >
                                    Add New Resident
                                </button>
                                <div className="search-bar">
                                    <input type="text" placeholder="Search residents..." />
                                    <button className="search-btn">Search</button>
                                </div>
                            </div>

                            {/* New Resident Form */}
                            {showNewResidentForm && (
                                <div className="form-overlay">
                                    <div className="form-container">
                                        <h3>Add New Resident</h3>
                                        <div className="form-group">
                                            <label>Name:</label>
                                            <input
                                                type="text"
                                                name="name"
                                                value={newResidentData.name}
                                                onChange={handleNewResidentChange}
                                                required
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Address:</label>
                                            <input
                                                type="text"
                                                name="address"
                                                value={newResidentData.address}
                                                onChange={handleNewResidentChange}
                                                required
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Postal Code:</label>
                                            <input
                                                type="text"
                                                name="postalCode"
                                                value={newResidentData.postalCode}
                                                onChange={handleNewResidentChange}
                                                required
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Phone:</label>
                                            <input
                                                type="tel"
                                                name="phone"
                                                value={newResidentData.phone}
                                                onChange={handleNewResidentChange}
                                                required
                                            />
                                        </div>
                                        <div className="form-group">
                                            <label>Email:</label>
                                            <input
                                                type="email"
                                                name="email"
                                                value={newResidentData.email}
                                                onChange={handleNewResidentChange}
                                                required
                                            />
                                        </div>
                                        <div className="form-actions">
                                            <button
                                                className="submit-btn"
                                                onClick={handleNewResidentSubmit}
                                            >
                                                Add Resident
                                            </button>
                                            <button
                                                className="cancel-btn"
                                                onClick={() => setShowNewResidentForm(false)}
                                            >
                                                Cancel
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            )}

                            <table className="data-table">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Address</th>
                                        <th>Postal Code</th>
                                        <th>Phone</th>
                                        <th>Email</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {residents.map(resident => (
                                        <tr key={resident.id}>
                                            {editingResident?.id === resident.id ? (
                                                <>
                                                    <td>
                                                        <input
                                                            type="text"
                                                            className="edit-input"
                                                            name="name"
                                                            value={editResidentForm.name}
                                                            onChange={handleEditResidentChange}
                                                        />
                                                    </td>
                                                    <td>
                                                        <input
                                                            type="text"
                                                            className="edit-input"
                                                            name="address"
                                                            value={editResidentForm.address}
                                                            onChange={handleEditResidentChange}
                                                        />
                                                    </td>
                                                    <td>
                                                        <input
                                                            type="text"
                                                            className="edit-input"
                                                            name="postalCode"
                                                            value={editResidentForm.postalCode}
                                                            onChange={handleEditResidentChange}
                                                        />
                                                    </td>
                                                    <td>
                                                        <input
                                                            type="text"
                                                            className="edit-input"
                                                            name="phone"
                                                            value={editResidentForm.phone}
                                                            onChange={handleEditResidentChange}
                                                        />
                                                    </td>
                                                    <td>
                                                        <input
                                                            type="email"
                                                            className="edit-input"
                                                            name="email"
                                                            value={editResidentForm.email}
                                                            onChange={handleEditResidentChange}
                                                        />
                                                    </td>
                                                    <td>
                                                        <button
                                                            className="action-btn save"
                                                            onClick={() => handleEditResidentSubmit(resident.id)}
                                                        >
                                                            Save
                                                        </button>
                                                        <button
                                                            className="action-btn cancel"
                                                            onClick={() => setEditingResident(null)}
                                                        >
                                                            Cancel
                                                        </button>
                                                    </td>
                                                </>
                                            ) : (
                                                <>
                                                    <td>{resident.name}</td>
                                                    <td>{resident.address}</td>
                                                    <td>{resident.postalCode}</td>
                                                    <td>{resident.phone}</td>
                                                    <td>{resident.email}</td>
                                                    <td>
                                                        <button
                                                            className="action-btn edit"
                                                            onClick={() => handleEditResidentClick(resident)}
                                                        >
                                                            Edit
                                                        </button>
                                                        <button
                                                            className="action-btn delete"
                                                            onClick={() => handleDeleteResident(resident.id)}
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
                        </div>
                    )}

                    {/* Reports Tab */}
                    {activeTab === 'reports' && (
                        <div className="reports">
                            <h2>Reports & Analytics</h2>

                            {/* Report Controls */}
                            <div className="report-controls">
                                <div className="report-type-selector">
                                    <button
                                        className={`report-type-btn ${reportType === 'collections' ? 'active' : ''}`}
                                        onClick={() => setReportType('collections')}
                                    >
                                        Collections
                                    </button>
                                    <button
                                        className={`report-type-btn ${reportType === 'waste' ? 'active' : ''}`}
                                        onClick={() => setReportType('waste')}
                                    >
                                        Waste Analysis
                                    </button>
                                    <button
                                        className={`report-type-btn ${reportType === 'areas' ? 'active' : ''}`}
                                        onClick={() => setReportType('areas')}
                                    >
                                        Area Performance
                                    </button>
                                    <button
                                        className={`report-type-btn ${reportType === 'vehicles' ? 'active' : ''}`}
                                        onClick={() => setReportType('vehicles')}
                                    >
                                        Vehicle Efficiency
                                    </button>
                                    <button
                                        className={`report-type-btn ${reportType === 'staff' ? 'active' : ''}`}
                                        onClick={() => setReportType('staff')}
                                    >
                                        Staff Performance
                                    </button>
                                    <button
                                        className={`report-type-btn ${reportType === 'costs' ? 'active' : ''}`}
                                        onClick={() => setReportType('costs')}
                                    >
                                        Cost Analysis
                                    </button>
                                </div>

                                <div className="report-filters">
                                    <select className="filter-select">
                                        <option value="last-month">Last Month</option>
                                        <option value="last-3-months">Last 3 Months</option>
                                        <option value="last-6-months">Last 6 Months</option>
                                        <option value="last-year">Last Year</option>
                                        <option value="custom">Custom Range</option>
                                    </select>
                                    <button className="export-btn">Export Report</button>
                                </div>
                            </div>

                            {/* Collections Report */}
                            {reportType === 'collections' && (
                                <div className="report-content">
                                    <div className="report-summary">
                                        <div className="summary-card">
                                            <h3>Total Collections</h3>
                                            <p className="summary-value">156</p>
                                            <p className="summary-change positive">+5% from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Completion Rate</h3>
                                            <p className="summary-value">96%</p>
                                            <p className="summary-change positive">+2% from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Average Collection Time</h3>
                                            <p className="summary-value">45 min</p>
                                            <p className="summary-change negative">+5 min from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Customer Satisfaction</h3>
                                            <p className="summary-value">4.7/5</p>
                                            <p className="summary-change positive">+0.2 from last month</p>
                                        </div>
                                    </div>

                                    <div className="report-chart">
                                        <h3>Collection Trends</h3>
                                        <div className="chart-container">
                                            <div className="mock-chart">
                                                <div className="chart-bars">
                                                    {reportData.collectionTrends.map((item, index) => (
                                                        <div key={index} className="chart-bar" style={{ height: `${(item.collections / 200) * 100}%` }}>
                                                            <span className="bar-value">{item.collections}</span>
                                                        </div>
                                                    ))}
                                                </div>
                                                <div className="chart-labels">
                                                    {reportData.collectionTrends.map((item, index) => (
                                                        <div key={index} className="chart-label">{item.month}</div>
                                                    ))}
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="report-table">
                                        <h3>Monthly Collection Details</h3>
                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Month</th>
                                                    <th>Collections</th>
                                                    <th>Waste Collected</th>
                                                    <th>Recycling Rate</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {reportData.collectionTrends.map((item, index) => (
                                                    <tr key={index}>
                                                        <td>{item.month}</td>
                                                        <td>{item.collections}</td>
                                                        <td>{item.wasteCollected}</td>
                                                        <td>{item.recyclingRate}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            )}

                            {/* Waste Analysis Report */}
                            {reportType === 'waste' && (
                                <div className="report-content">
                                    <div className="report-summary">
                                        <div className="summary-card">
                                            <h3>Total Waste Collected</h3>
                                            <p className="summary-value">2,450 kg</p>
                                            <p className="summary-change positive">+8% from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Recycling Rate</h3>
                                            <p className="summary-value">68%</p>
                                            <p className="summary-change positive">+3% from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Landfill Reduction</h3>
                                            <p className="summary-value">1,666 kg</p>
                                            <p className="summary-change positive">+10% from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Carbon Footprint Reduction</h3>
                                            <p className="summary-value">1.2 tons CO2</p>
                                            <p className="summary-change positive">+15% from last month</p>
                                        </div>
                                    </div>

                                    <div className="report-chart">
                                        <h3>Waste Type Distribution</h3>
                                        <div className="chart-container">
                                            <div className="mock-pie-chart">
                                                <div className="pie-segment" style={{ width: '40%', backgroundColor: '#4CAF50' }}>
                                                    <span>Mixed (40%)</span>
                                                </div>
                                                <div className="pie-segment" style={{ width: '25%', backgroundColor: '#FFEB3B' }}>
                                                    <span>Organic (25%)</span>
                                                </div>
                                                <div className="pie-segment" style={{ width: '35%', backgroundColor: '#03A9F4' }}>
                                                    <span>Recyclable (35%)</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="report-table">
                                        <h3>Waste Type Details</h3>
                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Waste Type</th>
                                                    <th>Percentage</th>
                                                    <th>Weight</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {reportData.wasteTypeDistribution.map((item, index) => (
                                                    <tr key={index}>
                                                        <td>{item.type}</td>
                                                        <td>{item.percentage}%</td>
                                                        <td>{item.weight}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            )}

                            {/* Area Performance Report */}
                            {reportType === 'areas' && (
                                <div className="report-content">
                                    <div className="report-summary">
                                        <div className="summary-card">
                                            <h3>Total Areas Covered</h3>
                                            <p className="summary-value">5</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Average Completion Rate</h3>
                                            <p className="summary-value">96%</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Average Recycling Rate</h3>
                                            <p className="summary-value">69%</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Best Performing Area</h3>
                                            <p className="summary-value">Downtown</p>
                                        </div>
                                    </div>

                                    <div className="report-chart">
                                        <h3>Area Performance Comparison</h3>
                                        <div className="chart-container">
                                            <div className="mock-chart">
                                                <div className="chart-bars">
                                                    {reportData.areaPerformance.map((item, index) => (
                                                        <div key={index} className="chart-bar" style={{ height: `${parseInt(item.completionRate)}%` }}>
                                                            <span className="bar-value">{item.completionRate}</span>
                                                        </div>
                                                    ))}
                                                </div>
                                                <div className="chart-labels">
                                                    {reportData.areaPerformance.map((item, index) => (
                                                        <div key={index} className="chart-label">{item.area}</div>
                                                    ))}
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="report-table">
                                        <h3>Area Performance Details</h3>
                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Area</th>
                                                    <th>Collections</th>
                                                    <th>Completion Rate</th>
                                                    <th>Recycling Rate</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {reportData.areaPerformance.map((item, index) => (
                                                    <tr key={index}>
                                                        <td>{item.area}</td>
                                                        <td>{item.collections}</td>
                                                        <td>{item.completionRate}</td>
                                                        <td>{item.recyclingRate}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            )}

                            {/* Vehicle Efficiency Report */}
                            {reportType === 'vehicles' && (
                                <div className="report-content">
                                    <div className="report-summary">
                                        <div className="summary-card">
                                            <h3>Total Vehicles</h3>
                                            <p className="summary-value">5</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Average Efficiency</h3>
                                            <p className="summary-value">2.9 km/L</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Total Distance</h3>
                                            <p className="summary-value">5,580 km</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Total Fuel Used</h3>
                                            <p className="summary-value">1,850 L</p>
                                        </div>
                                    </div>

                                    <div className="report-chart">
                                        <h3>Vehicle Efficiency Comparison</h3>
                                        <div className="chart-container">
                                            <div className="mock-chart">
                                                <div className="chart-bars">
                                                    {reportData.vehicleEfficiency.map((item, index) => (
                                                        <div key={index} className="chart-bar" style={{ height: `${(parseFloat(item.efficiency) / 4) * 100}%` }}>
                                                            <span className="bar-value">{item.efficiency}</span>
                                                        </div>
                                                    ))}
                                                </div>
                                                <div className="chart-labels">
                                                    {reportData.vehicleEfficiency.map((item, index) => (
                                                        <div key={index} className="chart-label">{item.vehicle}</div>
                                                    ))}
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="report-table">
                                        <h3>Vehicle Efficiency Details</h3>
                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Vehicle</th>
                                                    <th>Trips</th>
                                                    <th>Distance</th>
                                                    <th>Fuel Used</th>
                                                    <th>Efficiency</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {reportData.vehicleEfficiency.map((item, index) => (
                                                    <tr key={index}>
                                                        <td>{item.vehicle}</td>
                                                        <td>{item.trips}</td>
                                                        <td>{item.distance}</td>
                                                        <td>{item.fuelUsed}</td>
                                                        <td>{item.efficiency}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            )}

                            {/* Staff Performance Report */}
                            {reportType === 'staff' && (
                                <div className="report-content">
                                    <div className="report-summary">
                                        <div className="summary-card">
                                            <h3>Total Staff</h3>
                                            <p className="summary-value">5</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Average Completion Rate</h3>
                                            <p className="summary-value">97%</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Average Customer Rating</h3>
                                            <p className="summary-value">4.7/5</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Best Performing Staff</h3>
                                            <p className="summary-value">Lisa Driver</p>
                                        </div>
                                    </div>

                                    <div className="report-chart">
                                        <h3>Staff Performance Comparison</h3>
                                        <div className="chart-container">
                                            <div className="mock-chart">
                                                <div className="chart-bars">
                                                    {reportData.staffPerformance.map((item, index) => (
                                                        <div key={index} className="chart-bar" style={{ height: `${(parseFloat(item.customerRating) / 5) * 100}%` }}>
                                                            <span className="bar-value">{item.customerRating}</span>
                                                        </div>
                                                    ))}
                                                </div>
                                                <div className="chart-labels">
                                                    {reportData.staffPerformance.map((item, index) => (
                                                        <div key={index} className="chart-label">{item.staff}</div>
                                                    ))}
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="report-table">
                                        <h3>Staff Performance Details</h3>
                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Staff</th>
                                                    <th>Collections</th>
                                                    <th>Completion Rate</th>
                                                    <th>Customer Rating</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {reportData.staffPerformance.map((item, index) => (
                                                    <tr key={index}>
                                                        <td>{item.staff}</td>
                                                        <td>{item.collections}</td>
                                                        <td>{item.completionRate}</td>
                                                        <td>{item.customerRating}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            )}

                            {/* Cost Analysis Report */}
                            {reportType === 'costs' && (
                                <div className="report-content">
                                    <div className="report-summary">
                                        <div className="summary-card">
                                            <h3>Total Costs</h3>
                                            <p className="summary-value">$8,250</p>
                                            <p className="summary-change negative">+5% from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Cost per Collection</h3>
                                            <p className="summary-value">$52.88</p>
                                            <p className="summary-change negative">+3% from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Cost per kg</h3>
                                            <p className="summary-value">$3.37</p>
                                            <p className="summary-change negative">+2% from last month</p>
                                        </div>
                                        <div className="summary-card">
                                            <h3>Largest Expense</h3>
                                            <p className="summary-value">Fuel (35%)</p>
                                        </div>
                                    </div>

                                    <div className="report-chart">
                                        <h3>Cost Distribution</h3>
                                        <div className="chart-container">
                                            <div className="mock-pie-chart">
                                                <div className="pie-segment" style={{ width: '35%', backgroundColor: '#4CAF50' }}>
                                                    <span>Fuel (35%)</span>
                                                </div>
                                                <div className="pie-segment" style={{ width: '25%', backgroundColor: '#FFEB3B' }}>
                                                    <span>Maintenance (25%)</span>
                                                </div>
                                                <div className="pie-segment" style={{ width: '20%', backgroundColor: '#03A9F4' }}>
                                                    <span>Staff (20%)</span>
                                                </div>
                                                <div className="pie-segment" style={{ width: '15%', backgroundColor: '#9C27B0' }}>
                                                    <span>Equipment (15%)</span>
                                                </div>
                                                <div className="pie-segment" style={{ width: '5%', backgroundColor: '#F44336' }}>
                                                    <span>Other (5%)</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="report-table">
                                        <h3>Cost Breakdown</h3>
                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Category</th>
                                                    <th>Amount</th>
                                                    <th>Percentage</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {reportData.costAnalysis.map((item, index) => (
                                                    <tr key={index}>
                                                        <td>{item.category}</td>
                                                        <td>{item.amount}</td>
                                                        <td>{item.percentage}%</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            )}
                        </div>
                    )}

                    {/* Bulk Collection Tab */}
                    {activeTab === 'bulk-collection' && (
                        <div className="bulk-collection">
                            <h2>Bulk Waste Collection Management</h2>

                            {/* Bulk Collection Tabs */}
                            <div className="bulk-collection-tabs">
                                <button
                                    className={`bulk-collection-tab ${bulkCollectionTab === 'requests' ? 'active' : ''}`}
                                    onClick={() => setBulkCollectionTab('requests')}
                                >
                                    Requests
                                </button>
                                <button
                                    className={`bulk-collection-tab ${bulkCollectionTab === 'schedule' ? 'active' : ''}`}
                                    onClick={() => setBulkCollectionTab('schedule')}
                                >
                                    Schedule
                                </button>
                                <button
                                    className={`bulk-collection-tab ${bulkCollectionTab === 'history' ? 'active' : ''}`}
                                    onClick={() => setBulkCollectionTab('history')}
                                >
                                    History
                                </button>
                            </div>

                            {/* Bulk Collection Content */}
                            <div className="bulk-collection-content">
                                {/* Requests Tab */}
                                {bulkCollectionTab === 'requests' && (
                                    <div className="requests-section">
                                        <div className="action-bar">
                                            <div className="search-bar">
                                                <input type="text" placeholder="Search requests..." />
                                                <button className="search-btn">Search</button>
                                            </div>
                                        </div>

                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Request ID</th>
                                                    <th>Resident</th>
                                                    <th>Address</th>
                                                    <th>Waste Type</th>
                                                    <th>Request Date</th>
                                                    <th>Preferred Date</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {bulkCollectionRequests.map(request => (
                                                    <tr key={request.id}>
                                                        <td>{request.id}</td>
                                                        <td>{request.residentName}</td>
                                                        <td>{request.address}</td>
                                                        <td>{request.wasteType}</td>
                                                        <td>{request.requestDate}</td>
                                                        <td>{request.preferredDate}</td>
                                                        <td>
                                                            <span className={`status-badge ${request.status.toLowerCase()}`}>
                                                                {request.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <button className="action-btn view">View</button>
                                                            {request.status === 'Pending' && (
                                                                <>
                                                                    <button className="action-btn confirm">Confirm</button>
                                                                    <button className="action-btn reject">Reject</button>
                                                                </>
                                                            )}
                                                            {request.status === 'Confirmed' && (
                                                                <button className="action-btn complete">Complete</button>
                                                            )}
                                                        </td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                )}

                                {/* Schedule Tab */}
                                {bulkCollectionTab === 'schedule' && (
                                    <div className="schedule-section">
                                        <div className="schedule-controls">
                                            <div className="date-range">
                                                <input type="date" />
                                                <span>to</span>
                                                <input type="date" />
                                            </div>
                                            <button className="filter-btn">Filter</button>
                                        </div>

                                        <div className="schedule-grid">
                                            {bulkCollectionRequests
                                                .filter(request => request.status === 'Confirmed')
                                                .map(request => (
                                                    <div key={request.id} className="schedule-card">
                                                        <div className="schedule-header">
                                                            <h3>Request #{request.id}</h3>
                                                            <span className={`status-badge ${request.status.toLowerCase()}`}>
                                                                {request.status}
                                                            </span>
                                                        </div>
                                                        <div className="schedule-details">
                                                            <p><strong>Resident:</strong> {request.residentName}</p>
                                                            <p><strong>Address:</strong> {request.address}</p>
                                                            <p><strong>Collection Date:</strong> {request.collectionDate}</p>
                                                            <p><strong>Assigned Vehicle:</strong> {request.assignedVehicle}</p>
                                                            <p><strong>Assigned Driver:</strong> {request.assignedDriver}</p>
                                                        </div>
                                                        <div className="schedule-actions">
                                                            <button className="action-btn view">View Details</button>
                                                            <button className="action-btn edit">Edit Schedule</button>
                                                        </div>
                                                    </div>
                                                ))}
                                        </div>
                                    </div>
                                )}

                                {/* History Tab */}
                                {bulkCollectionTab === 'history' && (
                                    <div className="history-section">
                                        <div className="history-filters">
                                            <select>
                                                <option value="all">All Status</option>
                                                <option value="completed">Completed</option>
                                                <option value="rejected">Rejected</option>
                                            </select>
                                            <input type="date" placeholder="From Date" />
                                            <input type="date" placeholder="To Date" />
                                            <button className="filter-btn">Filter</button>
                                        </div>

                                        <table className="data-table">
                                            <thead>
                                                <tr>
                                                    <th>Request ID</th>
                                                    <th>Resident</th>
                                                    <th>Address</th>
                                                    <th>Waste Type</th>
                                                    <th>Estimated Weight</th>
                                                    <th>Actual Weight</th>
                                                    <th>Collection Date</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {bulkCollectionRequests
                                                    .filter(request => request.status === 'Completed' || request.status === 'Rejected')
                                                    .map(request => (
                                                        <tr key={request.id}>
                                                            <td>{request.id}</td>
                                                            <td>{request.residentName}</td>
                                                            <td>{request.address}</td>
                                                            <td>{request.wasteType}</td>
                                                            <td>{request.estimatedWeight}</td>
                                                            <td>{request.actualWeight || '-'}</td>
                                                            <td>{request.collectionDate || '-'}</td>
                                                            <td>
                                                                <span className={`status-badge ${request.status.toLowerCase()}`}>
                                                                    {request.status}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <button className="action-btn view">View Details</button>
                                                                <button className="action-btn print">Print Report</button>
                                                            </td>
                                                        </tr>
                                                    ))}
                                            </tbody>
                                        </table>
                                    </div>
                                )}
                            </div>
                        </div>
                    )}

                    {/* Recycling Tab */}
                    {activeTab === 'recycling' && (
                        <div className="recycling-section">
                            <div className="recycling-controls">
                                <h2>Recycling Management</h2>
                                <div className="recycling-filters">
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
                                                        <strong>Recycling Center:</strong> {material.recyclingCenter}
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
                                                            {calculateDuration(step.startTime, step.endTime)}
                                                        </span>
                                                    </div>
                                                )}
                                            </div>
                                            <p className="step-description">
                                                {getStepDescription(step.id)}
                                            </p>
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

                            {recyclingTab === 'centers' && (
                                <div className="recycling-centers">
                                    <div className="centers-grid">
                                        {Array.from(new Set(recyclingMaterials.map(m => m.recyclingCenter))).map(center => (
                                            <div key={center} className="center-card">
                                                <h3>{center}</h3>
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
                    )}

                    {/* Shop Tab */}
                    {activeTab === 'shop' && (
                        <div className="shop">
                            <h2>Shop</h2>

                            {/* Shop Navigation */}
                            <div className="shop-nav">
                                <button className="shop-nav-btn active">Products</button>
                                <Link to="/shop-transactions" className="shop-nav-btn">
                                    Transaction History
                                </Link>
                            </div>

                            {/* Shop Content */}
                            <div className="shop-content">
                                <div className="shop-controls">
                                    <div className="search-bar">
                                        <input
                                            type="text"
                                            placeholder="Search recycling products..."
                                            value={searchQuery}
                                            onChange={(e) => setSearchQuery(e.target.value)}
                                        />
                                    </div>
                                    <div className="category-filter">
                                        <select
                                            value={shopCategory}
                                            onChange={(e) => setShopCategory(e.target.value)}
                                        >
                                            <option value="">All Categories</option>
                                            {shopData.categories.map((category) => (
                                                <option key={category} value={category}>
                                                    {category}
                                                </option>
                                            ))}
                                        </select>
                                    </div>
                                </div>
                                <div className="shop-content">
                                    <div className="products-grid">
                                        {shopData.products
                                            .filter((product) => {
                                                const matchesCategory = !shopCategory || product.category === shopCategory;
                                                const matchesSearch = !searchQuery ||
                                                    product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                                                    product.description.toLowerCase().includes(searchQuery.toLowerCase());
                                                return matchesCategory && matchesSearch;
                                            })
                                            .map((product) => (
                                                <div key={product.id} className="product-card">
                                                    <img src={product.image} alt={product.name} />
                                                    <div className="product-info">
                                                        <h3>{product.name}</h3>
                                                        <p className="product-category">{product.category}</p>
                                                        <p className="product-description">{product.description}</p>
                                                        <div className="product-rating">
                                                            {'★'.repeat(Math.floor(product.rating))}
                                                            {'☆'.repeat(5 - Math.floor(product.rating))}
                                                        </div>
                                                        <p className="product-price">${product.price.toFixed(2)}</p>
                                                        <p className="product-stock">
                                                            {product.stock > 0
                                                                ? `${product.stock} in stock`
                                                                : 'Out of stock'}
                                                        </p>
                                                        <button
                                                            className="add-to-cart-btn"
                                                            onClick={() => addToCart(product)}
                                                            disabled={product.stock === 0}
                                                        >
                                                            Add to Cart
                                                        </button>
                                                    </div>
                                                </div>
                                            ))}
                                    </div>
                                    <div className="shopping-cart">
                                        <h3>Shopping Cart</h3>
                                        {cart.length === 0 ? (
                                            <p className="empty-cart">Your cart is empty</p>
                                        ) : (
                                            <>
                                                <div className="cart-items">
                                                    {cart.map((item) => (
                                                        <div key={item.id} className="cart-item">
                                                            <img src={item.image} alt={item.name} />
                                                            <div className="cart-item-info">
                                                                <h4>{item.name}</h4>
                                                                <p>${item.price.toFixed(2)}</p>
                                                            </div>
                                                            <div className="cart-item-actions">
                                                                <input
                                                                    type="number"
                                                                    min="1"
                                                                    value={item.quantity}
                                                                    onChange={(e) => updateQuantity(item.id, parseInt(e.target.value))}
                                                                />
                                                                <button
                                                                    className="remove-btn"
                                                                    onClick={() => removeFromCart(item.id)}
                                                                >
                                                                    Remove
                                                                </button>
                                                            </div>
                                                        </div>
                                                    ))}
                                                </div>
                                                <div className="cart-summary">
                                                    <p>
                                                        Total: $
                                                        {cart
                                                            .reduce((total, item) => total + item.price * item.quantity, 0)
                                                            .toFixed(2)}
                                                    </p>
                                                    <button className="checkout-btn">Proceed to Checkout</button>
                                                </div>
                                            </>
                                        )}
                                    </div>
                                </div>

                                {/* Add Shop Transaction Statistics */}
                                <div className="shop-stats">
                                    <div className="stat-card">
                                        <div className="stat-icon">💰</div>
                                        <div className="stat-info">
                                            <h3>Total Revenue</h3>
                                            <p className="stat-value">${shopTransactionStats.totalRevenue.toFixed(2)}</p>
                                        </div>
                                    </div>

                                    <div className="stat-card">
                                        <div className="stat-icon">🛒</div>
                                        <div className="stat-info">
                                            <h3>Total Transactions</h3>
                                            <p className="stat-value">{shopTransactionStats.totalTransactions}</p>
                                        </div>
                                    </div>

                                    <div className="stat-card">
                                        <div className="stat-icon">✅</div>
                                        <div className="stat-info">
                                            <h3>Completed</h3>
                                            <p className="stat-value">{shopTransactionStats.completedTransactions}</p>
                                        </div>
                                    </div>

                                    <div className="stat-card">
                                        <div className="stat-icon">⏳</div>
                                        <div className="stat-info">
                                            <h3>Pending</h3>
                                            <p className="stat-value">{shopTransactionStats.pendingTransactions}</p>
                                        </div>
                                    </div>
                                </div>

                                {/* Add Shop Transaction History */}
                                <div className="shop-transactions">
                                    <h3>Transaction History</h3>
                                    <table className="data-table">
                                        <thead>
                                            <tr>
                                                <th>Date & Time</th>
                                                <th>Customer</th>
                                                <th>Items</th>
                                                <th>Total</th>
                                                <th>Payment Method</th>
                                                <th>Status</th>
                                                <th>Reference</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {shopTransactions.map(transaction => (
                                                <tr key={transaction.id}>
                                                    <td>{transaction.date} {transaction.time}</td>
                                                    <td>{transaction.customer}</td>
                                                    <td>
                                                        <ul className="transaction-items">
                                                            {transaction.items.map((item, index) => (
                                                                <li key={index}>
                                                                    {item.quantity}x {item.name} (${item.price.toFixed(2)})
                                                                </li>
                                                            ))}
                                                        </ul>
                                                    </td>
                                                    <td>${transaction.total.toFixed(2)}</td>
                                                    <td>{transaction.paymentMethod}</td>
                                                    <td>
                                                        <span className={`status-badge ${transaction.status.toLowerCase()}`}>
                                                            {transaction.status}
                                                        </span>
                                                    </td>
                                                    <td>{transaction.reference}</td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                </div>

                                {/* Add Top Selling Items */}
                                <div className="top-selling-items">
                                    <h3>Top Selling Items</h3>
                                    <div className="items-grid">
                                        {shopTransactionStats.topSellingItems.map((item, index) => (
                                            <div key={index} className="item-card">
                                                <h4>{item.name}</h4>
                                                <p>Quantity Sold: {item.quantity}</p>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Complaints Tab */}
                    {activeTab === 'complaints' && (
                        <div className="complaints">
                            <h2>Complaints Management</h2>

                            {/* Complaints Filters */}
                            <div className="complaints-filters">
                                <select
                                    className="filter-select"
                                    name="category"
                                    value={complaintFilters.category}
                                    onChange={handleFilterChange}
                                >
                                    <option value="all">All Categories</option>
                                    <option value="Collection Service">Collection Service</option>
                                    <option value="Vehicle Issue">Vehicle Issue</option>
                                    <option value="Staff Behavior">Staff Behavior</option>
                                    <option value="Other">Other</option>
                                </select>
                                <select
                                    className="filter-select"
                                    name="status"
                                    value={complaintFilters.status}
                                    onChange={handleFilterChange}
                                >
                                    <option value="all">All Status</option>
                                    <option value="Pending">Pending</option>
                                    <option value="In Progress">In Progress</option>
                                    <option value="Resolved">Resolved</option>
                                </select>
                                <input
                                    type="date"
                                    className="date-filter"
                                    name="date"
                                    value={complaintFilters.date}
                                    onChange={handleFilterChange}
                                />
                                <button
                                    className="filter-btn"
                                    onClick={handleFilterButtonClick}
                                >
                                    Filter
                                </button>
                            </div>

                            {/* Complaints Table */}
                            <div className="complaints-table">
                                <table className="data-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Resident</th>
                                            <th>Category</th>
                                            <th>Title</th>
                                            <th>Location</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {getFilteredComplaints().map(complaint => (
                                            <tr key={complaint.id}>
                                                <td>{complaint.id}</td>
                                                <td>{complaint.residentName}</td>
                                                <td>{complaint.category}</td>
                                                <td>{complaint.title}</td>
                                                <td>{complaint.location}</td>
                                                <td>{complaint.date}</td>
                                                <td>
                                                    <span className={`status-badge ${complaint.status.toLowerCase().replace(' ', '-')}`}>
                                                        {complaint.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <button
                                                        className="action-btn view"
                                                        onClick={() => {
                                                            setEditingComplaint(complaint.id);
                                                            setEditComplaintData({
                                                                status: complaint.status,
                                                                reply: complaint.reply
                                                            });
                                                        }}
                                                    >
                                                        View/Update
                                                    </button>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>

                            {/* Complaint Details Modal */}
                            {editingComplaint && (
                                <div className="complaint-modal">
                                    <div className="modal-content">
                                        <h3>Complaint Details</h3>
                                        <div className="complaint-details">
                                            <div className="detail-row">
                                                <span className="detail-label">Resident:</span>
                                                <span className="detail-value">
                                                    {complaints.find(c => c.id === editingComplaint)?.residentName}
                                                </span>
                                            </div>
                                            <div className="detail-row">
                                                <span className="detail-label">Category:</span>
                                                <span className="detail-value">
                                                    {complaints.find(c => c.id === editingComplaint)?.category}
                                                </span>
                                            </div>
                                            <div className="detail-row">
                                                <span className="detail-label">Title:</span>
                                                <span className="detail-value">
                                                    {complaints.find(c => c.id === editingComplaint)?.title}
                                                </span>
                                            </div>
                                            <div className="detail-row">
                                                <span className="detail-label">Description:</span>
                                                <p className="detail-value">
                                                    {complaints.find(c => c.id === editingComplaint)?.description}
                                                </p>
                                            </div>
                                            <div className="detail-row">
                                                <span className="detail-label">Location:</span>
                                                <span className="detail-value">
                                                    {complaints.find(c => c.id === editingComplaint)?.location}
                                                </span>
                                            </div>
                                        </div>

                                        <div className="complaint-update">
                                            <div className="form-group">
                                                <label>Status:</label>
                                                <select
                                                    value={editComplaintData.status}
                                                    onChange={(e) => setEditComplaintData({
                                                        ...editComplaintData,
                                                        status: e.target.value
                                                    })}
                                                    className="form-input"
                                                >
                                                    <option value="Pending">Pending</option>
                                                    <option value="In Progress">In Progress</option>
                                                    <option value="Resolved">Resolved</option>
                                                </select>
                                            </div>
                                            <div className="form-group">
                                                <label>Reply:</label>
                                                <textarea
                                                    value={editComplaintData.reply}
                                                    onChange={(e) => setEditComplaintData({
                                                        ...editComplaintData,
                                                        reply: e.target.value
                                                    })}
                                                    className="form-input"
                                                    rows="4"
                                                    placeholder="Enter your reply to the resident..."
                                                ></textarea>
                                            </div>
                                        </div>

                                        <div className="modal-actions">
                                            <button
                                                className="action-btn save"
                                                onClick={() => handleComplaintUpdate(editingComplaint)}
                                            >
                                                Update
                                            </button>
                                            <button
                                                className="action-btn cancel"
                                                onClick={() => {
                                                    setEditingComplaint(null);
                                                    setEditComplaintData({ status: '', reply: '' });
                                                }}
                                            >
                                                Cancel
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            )}
                        </div>
                    )}
                </main>
            </div>

            {/* Truck Location Modal */}
            {showTruckLocation && (
                <div className="modal-overlay">
                    <div className="modal-content truck-location-modal">
                        <div className="modal-header">
                            <h3>Live Truck Location</h3>
                            <button
                                className="close-btn"
                                onClick={() => setShowTruckLocation(false)}
                            >
                                ×
                            </button>
                        </div>
                        <div className="truck-location-content">
                            <div className="truck-info">
                                <h4>Vehicle: {selectedTruck}</h4>
                                <p>Current Status: Active</p>
                            </div>
                            <div className="map-container">
                                {/* This would be replaced with an actual map component */}
                                <div className="map-placeholder">
                                    <p>Map showing truck location would be displayed here</p>
                                    <p>Current Location: 123 Main St, City</p>
                                    <p>Last Updated: {new Date().toLocaleTimeString()}</p>
                                </div>
                            </div>
                            <div className="truck-actions">
                                <button className="btn-primary">Refresh Location</button>
                                <button className="btn-secondary">Contact Driver</button>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default WasteCollectionHome; 