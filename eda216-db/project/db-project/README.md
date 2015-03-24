Database cookie production project
=================================

## Requirements

### Modeling
Produce a complete database description with an E/R diagram and a relational model. You may,
if you wish, hand in this description for comments (see the cover sheet)

### Database
Implement the database. Document and justify any deviations from the model.

### User interface
Implement a graphical user interface to the database (only “program 2” of the programs mentioned
in section 4).
 * The user interface must be self-explanatory and easy to use.
 * The implementation must be stable. The system should produce reasonable results for arbitrary input.
 * All requirements must be addressed. 
   * One program that handles everything that concerns production, blocking and searching of pallets. The test version of this program will incorporate the screen where pallet production is simulated.
   * Production includes updating the raw materials storage when a pallet is produced. 
   * An order to block a pallet will always come before the pallet has been delivered.
   * We must be able to trace/search each pallet, and show the contents of the pallet, the location of the pallet, if the pallet is delivered and in that case to whom, etc.:
     * Id 
     * cookietype 
     * blocked/not 
     * prodTime
     * delivered to customerID, show date of deliv
     
### Report
1. The report should be written in English.
2. A cover sheet with the name of the project, your names, education programs, and e-mail addresses. You must check mail to these addresses regularly. Also give the date of submission and complete instructions for running your program.
3. An introduction (what the project is about, etc.).
4. Something about requirements that you fulfill or don’t fulfill.
5. An outline of your system (which database manager you use, which programs you havewritten, how the programs communicate with the database, etc.).
6. An E/R diagram which describes the system.
7. Relations. Indicate primary keys, possibly secondary keys, and foreign keys. You must show that the relations are normalized according to your chosen normal form (if a relation “obviously” is in BCNF you may say so, provided that you justify your statement). If a relation is in a lower normal form than BCNF, you must justify this choice.
8. SQL statements to create all tables, views, stored procedures, and other database elements. (Don’t include statements to create the initial contents of the database.)
9. A user’s manual (not necessary if everything in the program is self-explanatory).
