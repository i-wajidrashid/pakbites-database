
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
Order to StatusHistory 1:M<br><br>
Identifying the normalization problems
Explain why the "Items" column violates 1NF.<br>
1. The "items" column violates 1NF because it has mulitple values in a single field like Biryani,naan,raita in a single field. To make this 1NF we should remove having
multiple values in a single field.
2. Decompose this table into 2NF and 3NF. Show the resulting tables.
This table is already in a 2NF because all the attributes are dependent on the Primary key. To compose this table into 3NF we need to make 2 different tables named 
Customers and Orders and joining them using a foreign key.
3. What is a transitive dependency? Give an example from the PakBites system.
Transitive dependency is that 2 or more non key attributes can not be dependent on each other for example from the restaurants table in pakbites_database , 2 non key attributes that are email and address could not be dependent on each other.
4. What would happen if we stored the restaurant name directly in the Orders table instead of using a foreign key? Explain the problems.
If we stored the restaurant name directly in the Orders table instead of using a foreign key. The Orders table would contain duplicate values as their are many orders from 
1 restaurant.<br><br>

•	Define entity integrity and give an example from your design.
   Entity integrity is that there must be a Primary Key in a table and the Primary key should not be NULL. From the Table Restaurants , "RestaurantID" is a primary key
   and it does not contain any NULL value.
•	Define referential integrity and explain what happens if a restaurant is deleted but it has orders.
   Referential integrity is associated with the foreign key . It creates consistency in the database for example a foreign key in a child table cannot be updated
   if the primary key in the parent table is not updated. If a restaurant is deleted but it has orders the orders would also be deleted.
•	Define domain integrity and give 3 examples of domain constraints in your PakBites schema.
   Domain integrity assures the allowed and not allowed values in a column for example the "cityname" in the table "cities" cannot be NULL and "email" in the table
   restaurants cannot have duplicate values as it has a UNIQUE constraint and "rating" from the table restaurants should be between 1 and 5 because it has a check
   constraint.
•	What is a composite key? Does your design use any? If not, give a hypothetical example.
    A composite key is a primary key that consists of more than 1 column. All the columns that make up the composite key must be unique and NOT NULL. NO , my desgin does
   not have ant composite keys. Example Their is a students table containing course_id and student_id both of them can become a composite key because a student a have
   many different courses and a course can be studied by many students. Both of these tables must be UNIQUE when combined.
•	Explain the difference between CASCADE, SET NULL, and RESTRICT for ON DELETE foreign key actions. Which would you use for order items when an order is deleted, and why?
CASCADE means that If a row is deleted from the parent table, the database automatically deletes all associated rows in the child table.
SET NULL means that When the parent row is deleted, the foreign key column in the child table is set to NULL. The child record stays working, but its connection to the parent is removed.
RESTRICT prevents the deletion of the parent row if any child records are referencing it. The database will show an error and stop the operation.
when an order is deleted i should use CASCADE because order items are dependent on the order, if the parent order no longer exists, the individual line items become "orphaned" data with no context.

