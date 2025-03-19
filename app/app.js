// Import express.js
const express = require("express");

// Create express app
var app = express();

// Add static files location
app.use(express.static("static"));

// Get the functions in the db.js file to use
const db = require('./services/db');


// Use the Pug templating engine
app.set('view engine', 'pug');
app.set('views', './app/views');



// Create a route for root - /
app.get("/", function(req, res) {
    res.render("home")
});
// Create a route for about us - /
app.get("/about", function(req, res) {
    res.render("about")
});

// Create a route for contact us - /
app.get("/contact", function(req, res) {
    res.render("contact")
});

app.get("/dashboard", function (req, res) {
    let sql = "SELECT * FROM fitness_records";
    
    db.query(sql)
        .then(results => {
            res.render("dashboard", { records: results }); // Pass records to Pug template
        })

});


// Start server on port 3000
app.listen(3000,function(){
    console.log(`Server running at http://127.0.0.1:3000/`);
});