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
    let { activity_type, min_duration, max_duration, search } = req.query;
    let sql = "SELECT * FROM fitness_records WHERE 1=1";  // Start with a basic query

    // Filter by activity type if provided
    if (activity_type) {
        sql += ` AND activity_type = '${activity_type}'`;
    }

    // Filter by duration if provided
    if (min_duration) {
        sql += ` AND duration >= ${min_duration}`;
    }
    if (max_duration) {
        sql += ` AND duration <= ${max_duration}`;
    }

    // Search for activities based on user input
    if (search) {
        sql += ` AND activity_type LIKE '%${search}%'`;
    }

    db.query(sql)
        .then(results => {
            res.render("dashboard", { records: results, search, activity_type, min_duration, max_duration });
        })
        .catch(err => {
            console.error("Database error:", err);
            res.status(500).send("Internal Server Error");
        });
});



// Start server on port 3000
app.listen(3000,function(){
    console.log(`Server running at http://127.0.0.1:3000/`);
});