
•   What are the ACID properties? Explain each with a PakBites example.
ACID stands for Atomicity Consistency Isolation Durability.
Atomicity ensures a transaction is all or nothing if a payment succeeds but the order record fails, the whole transaction reverts.

Consistency Keeps data valid according to rules, an order cannot be created for a restaurant_id that doesn't exist in the database.

Isolation ensures that multiple transactions happen independently without bumping into each other. It prevents errors like selling the same item
twice by making sure one person's order finishes before the next one starts.

Durability guarantees that once an order is marked 'delivered,' that data survives even if the Pakbites server crashes immediately after.

•   What is the default isolation level in MySQL? What problems can it prevent?
Default isolation level is repeatable read. It prevents dirty reads (seeing uncommitted changes) and non-repeatable 
reads (data changing while you are still reading it),ensuring a restaurant owner sees consistent sales figures during a report.

•   What is a deadlock? How could it theoretically occur in the PakBites system?
A Deadlock occurs when two transactions are stuck waiting for each other to release locks on specific rows.

For Example 
transaction A locks a customer row to update points and 
waits for an order row, while transaction B has 
locked that same order and is waiting for the customer row to update a profile.


