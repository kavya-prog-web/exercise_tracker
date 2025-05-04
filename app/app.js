// Import express.js
const express = require("express");
const bodyParser = require('body-parser');
const { User } = require("./models/user");
// Create express app
var app = express();
const cookieParser = require("cookie-parser");
const session = require('express-session');
// Add static files location

const bcrypt = require('bcryptjs');
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());
app.use(express.static(__dirname));
const oneDay = 1000 * 60 * 60 * 24;
const sessionMiddleware = session({
    secret: "thisismysecrctekeyfhrgfgrfrty84fwir767",
    saveUninitialized: true,
    cookie: { maxAge: oneDay },
    resave: false
});
app.use(sessionMiddleware);

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

app.get("/login", function(req, res) {
    res.render('login');
});
app.get("/register", function(req, res) {
    res.render('register');
});
// Create a route for about us - /
app.get("/about", function(req, res) {
    res.render("about")
});

// Create a route for contact us - /
app.get("/contact", function(req, res) {
    res.render("contact")
});

// Check submitted email and password pair
app.post('/authenticate', async function (req, res) {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).send('Email and password are required.');
        }

        var user = new User(email);
        const uId = await user.getIdFromEmail();
        if (!uId) {
            return res.render('login',{ errorMessage: 'Invalid Email' });
        }

        const match = await user.authenticate(password);
        if (!match) {
            return res.render('login',{ errorMessage: 'Invalid Email' })
        }

        req.session.uid = uId;
        req.session.loggedIn = true;
        console.log(req.session.id);
        res.redirect('/dashboard');
    } catch (err) {
        console.error(`Error while authenticating user:`, err.message);
        res.status(500).send('Internal Server Error');
    }
});

app.get("/login", function (req, res) {
    try {
        if (req.session.uid) {
            res.redirect('/dashboard');
        } else {
            res.render('login');
        }
        res.end();
    } catch (err) {
        console.error("Error accessing root route:", err);
        res.status(500).send('Internal Server Error');
    }
});

app.get('/logout', function (req, res) {
    try {
        req.session.destroy();
        res.redirect('/login');
    } catch (err) {
        console.error("Error logging out:", err);
        res.status(500).send('Internal Server Error');
    }
});

app.post('/set-password', async function (req, res) {
    params = req.body;
    var user = new User(params.email);
    try {
        uId = await user.getIdFromEmail();
        if (uId) {
            // If a valid, existing user is found, set the password and redirect to the users single-student page
            await user.setUserPassword(params.password);
            console.log(req.session.id);
            res.render('forgot-password', { successMessage: 'Password set successfully' });
            // res.send('Password set successfully');
        }
        else {
            // If no existing user is found, add a new one
            // newId = await user.addUser(params.email);
            res.render('forgot-password', { errorMessage: 'Email is not exists,Please check your Email' });
            // res.send('Email is not exists,Please check your Email');
        }
    } catch (err) {
        console.error(`Error while adding password `, err.message);
    }
});

app.get("/dashboard", function (req, res) {
    if (!req.session.uid) return res.redirect("/login");

    const { activity_type, min_duration, max_duration, search } = req.query;
    let sql = "SELECT * FROM fitness_records WHERE user_id = ?";
    const values = [req.session.uid];

    if (activity_type) {
        sql += " AND activity_type = ?";
        values.push(activity_type);
    }
    if (min_duration) {
        sql += " AND duration >= ?";
        values.push(min_duration);
    }
    if (max_duration) {
        sql += " AND duration <= ?";
        values.push(max_duration);
    }
    if (search) {
        sql += " AND activity_type LIKE ?";
        values.push(`%${search}%`);
    }

    db.query(sql, values)
        .then(results => {
            res.render("dashboard", {
                records: results,
                search,
                activity_type,
                min_duration,
                max_duration
            });
        })
        .catch(err => {
            console.error("Database error:", err);
            res.status(500).send("Internal Server Error");
        });
});

app.post("/fitness/add", async (req, res) => {
    if (!req.session.uid) return res.redirect("/login");

    const { activity_type, duration, distance, calories_burned, heart_rate, steps } = req.body;
    const sql = `
        INSERT INTO fitness_records 
        (user_id, activity_type, duration, distance, calories_burned, heart_rate, steps) 
        VALUES (?, ?, ?, ?, ?, ?, ?)`;

    try {
        await db.query(sql, [
            req.session.uid,
            activity_type,
            duration,
            distance || null,
            calories_burned || null,
            heart_rate || null,
            steps || null
        ]);
        res.redirect("/dashboard");
    } catch (err) {
        console.error("Error inserting fitness record:", err);
        res.status(500).send("Failed to add record");
    }
});


// create User api
app.post('/userregistration', async (req, res) => {
    const { email, password} = req.body;

    try {
        // Hash the password using bcrypt
        const hashedPassword = await bcrypt.hash(password, 10);
        
        // Prepare SQL query
        const sql = 'INSERT INTO Users(email, password) VALUES (?, ?)';
        const values = [email, hashedPassword];
        // Execute SQL query
        await db.query(sql, values);

        res.render('register', { successMessage: 'User created successfully' });
    } catch (error) {
        console.log(error)
        res.render('register', { errorMessage: 'Error inserting data into the database' });
    }
});


// Route to display detailed fitness record
app.get("/fitness/:id", function(req, res) {
    const recordId = req.params.id;
    let sql = "SELECT * FROM fitness_records WHERE record_id = ?";
    
    db.query(sql, [recordId])
        .then(results => {
            if (results.length > 0) {
                res.render("fitness_details", { record: results[0] });
            } else {
                res.status(404).send("Record not found");
            }
        })
        .catch(err => {
            console.error("Database error:", err);
            res.status(500).send("Internal Server Error");
        });
});

// contact us route
app.post("/contact", async function (req, res) {
    const { name, email, message } = req.body;

    if (!name || !email || !message) {
        return res.render("contact", { errorMessage: "All fields are required." });
    }

    const sql = "INSERT INTO contact_us (name, email, message) VALUES (?, ?, ?)";

    try {
        await db.query(sql, [name, email, message]);
        res.render("contact", { successMessage: "Message sent successfully!" });
    } catch (err) {
        console.error("Error inserting contact message:", err);
        res.render("contact", { errorMessage: "There was a problem sending your message." });
    }
});



// Start server on port 3000
app.listen(3000,function(){
    console.log(`Server running at http://127.0.0.1:3000/`);
});