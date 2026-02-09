
CREATE DATABASE IF NOT EXISTS pakbites_database;
USE pakbites_database;

CREATE TABLE Cities (
    CityID INT AUTO_INCREMENT PRIMARY KEY,
    CityName VARCHAR(100) NOT NULL,
    Province VARCHAR(100) NOT NULL
);

CREATE TABLE Restaurants (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantName VARCHAR(150) NOT NULL,
    Address TEXT NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    CuisineType VARCHAR(50),
    Rating DECIMAL(2, 1) DEFAULT 0.0 CHECK (Rating >= 1 AND Rating <= 5),
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

CREATE TABLE MenuItems (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    ItemName VARCHAR(150) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    Category ENUM('appetizer', 'main', 'dessert', 'drink', 'side') NOT NULL,
    IsAvailable BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(150) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Address TEXT NOT NULL,
    RegistrationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

CREATE TABLE Riders (
    RiderID INT AUTO_INCREMENT PRIMARY KEY,
    RiderName VARCHAR(150) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    VehicleType ENUM('bike', 'car', 'bicycle') NOT NULL,
    CityID INT,
    AvailabilityStatus ENUM('available', 'busy', 'offline') DEFAULT 'offline',
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    RiderID INT,
    OrderDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    DeliveryAddress TEXT NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    DeliveryFee DECIMAL(10, 2) NOT NULL,
    Status ENUM('pending', 'confirmed', 'preparing', 'on_the_way', 'delivered', 'cancelled') DEFAULT 'pending',
    PaymentMethod ENUM('cash', 'card', 'jazzcash', 'easypaisa') NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (RiderID) REFERENCES Riders(RiderID)
);

CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    LineTotal DECIMAL(10, 2) NOT NULL, -- (Quantity * Price at time of order)
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    ReviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY UniqueReview (CustomerID, RestaurantID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE OrderStatusHistory (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    OldStatus VARCHAR(50),
    NewStatus VARCHAR(50) NOT NULL,
    ChangedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
    This design satisifies 3NF.
    By creating a CityID foreign key, we ensure that all columns in the Restaurant, Customer, and Rider tables depend only on their respective Primary Keys.
);
Relationship and Cardinality
City to Restaurant 1:M
City to Customer/Rider 1:M
Restaurant to MenuItem 1:M
Customer to Order 1:M
Restaurant to Order 1:M
Rider to Order 1:M
Order to OrderItem 1:M
MenuItem to OrderItem 1:M
Customer to Review 1:M
Order to StatusHistory 1:M
