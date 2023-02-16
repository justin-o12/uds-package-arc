const express = require ("express");
const app = express();
const cors = require("cors");
const pool = require("./db")

app.use(cors())
app.use(express.json())

app.get("/url",(req,res,next) => {
    res.json({"message":"Automate everything!","timestamp":Math.floor(Date.now() / 1000)});
});

app.post("/newGreeting", async (req,res) =>{
    try {
        const greeting = req.body.greeting;
        const greetingsInsert = 'insert into greetings (greeting) values ($1) returning *';
        const newGreeting = await pool.query(greetingsInsert, [greeting]);
        res.json(newGreeting.rows);
    } catch (error) {        
        console.log("heres an error", error);
    }
});

app.get("/getGreeting", async (req,res) =>{
    try {
        const greetingsInsert = 'select * from greetings ORDER BY RANDOM() limit 1 ';
        const newGreeting = await pool.query(greetingsInsert);
        res.json(newGreeting.rows[0].greeting);
    } catch (error) {
        res.json("DB Issue")
        console.log("heres an error", error);
    }
});


module.exports = app;
